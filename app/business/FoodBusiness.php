<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\enum\BusinessCode;
use app\common\enum\NormalStatus;
use app\common\enum\NutritionInputType;
use app\common\enum\QueueEventName;
use app\common\enum\TaskCompleteStatus;
use app\common\enum\TaskRunStatus;
use app\common\enum\UserInfoContext;
use app\common\exception\BusinessException;
use app\common\exception\DataNotFoundException;
use app\common\exception\ValidationException;
use app\common\validate\FoodValidator;
use app\format\FoodFormat;
use app\service\Alarm;
use app\model\{FoodModel, FoodUnitModel, MealRecordModel, TaskModel};
use app\service\baidu\Bos;
use app\service\BooHee;
use app\service\FoodService;
use app\service\FoodSynchronizer;
use app\service\recommendation\NutritionContextBuilder;
use app\service\recommendation\Recommendation;
use app\util\Helper;
use support\Context;
use support\Db;
use support\Log;
use support\Redis;
use support\Request;
use support\Snowflake;
use Webman\RedisQueue\Client;
use Webman\Validation\Annotation\Validate;
use function Illuminate\Support\now;

class FoodBusiness extends BaseBusiness
{

    public function search(Request $request): array
    {
        $name     = $request->get('name');
        $catId    = $request->get('cat_id');
        $page     = (int)$request->get('page', 1);
        $pageSize = (int)$request->get('pageSize', 10);
        $pageSize = max(1, min($pageSize, 50));
        $query    = FoodModel::query()
            ->with([
                'cat' => function ($q) {
                    $q->select('cats.id', 'cats.name');
                },
                'unit',
                'nutrition'
            ])
            ->where('status', NormalStatus::YES->value);

        if ($name) {
            $query->where('name', 'like', "%$name%");
        }

        if ($catId) {
            $query->where('cat_id', $catId);
        }
        $query->whereExists(function ($query) {
            $mainTable = (new FoodModel())->getTable();
            $subTable  = (new FoodUnitModel)->getTable();
            $query->select(Db::raw(1))
                ->from($subTable)
                ->whereColumn($subTable . '.food_id', $mainTable . '.id');
        });
        if (!$query->exists() && BooHee::instance()->canUse()) {
            $query = $query->clone();
            Client::send(QueueEventName::FoodSync->value, ['foodName' => $name]);
            Log::info('本地食品未命中，已推送远端同步队列', ['name' => $name]);
        }
        $paginate   = $query->orderByDesc('id')
            ->paginate($pageSize, ['*'], 'page', $page);
        $foodFormat = new FoodFormat($request);
        $paginate->getCollection()->transform(function ($item) use ($foodFormat) {
            return $foodFormat->format($item);
        });
        return $paginate->toArray();
    }

    public function detail(Request $request)
    {
        $id = $request->get('id');
        if (!$id) {
            throw new ValidationException('ID');
        }

        $food = FoodModel::query()->with([
            'cat' => function ($q) {
                $q->select('id', 'name');
            }, 'tags'
        ])->find($id);

        if (!$food) {
            throw new DataNotFoundException();
        }

        return (new FoodFormat($request))->format($food);
    }

    public function syncRemote(array $foodList): array
    {
        if (empty($foodList)) return [];
        $foodFormat = new FoodFormat(null);
        return collect((new FoodSynchronizer())->sync($foodList))
            ->map(fn(FoodModel $food) => $foodFormat->format($food))
            ->values()
            ->all();
    }

    #[Validate(validator: FoodValidator::class, scene: 'recognize')]
    public function recognize(Request $request): array
    {
        $content = $request->post('content');
        $type    = $request->post('type');
        $options = $request->post('options', []);

        if (!$type || !$content) {
            throw new ValidationException('类型', '内容');
        }

        $inputType = NutritionInputType::tryFrom($type);
        if (!$inputType) {
            throw new BusinessException('不支持的识别方式', BusinessCode::PARAM_ERROR);
        }

        try {
            if (in_array($inputType, [NutritionInputType::AUDIO, NutritionInputType::IMAGE])) {
                if($inputType === NutritionInputType::IMAGE){
                    $options = ['format'=>'jpg'];
                }
                $uploadResult = Bos::instance()->putObjectByBase($content, $options ?? ['format' => 'jpg'], strtolower(__FUNCTION__));
                if (!$uploadResult) {
                    throw new BusinessException($inputType->label() . '上传失败', BusinessCode::THREE_PART_ERROR);
                }
                $content = source($uploadResult);
            }
            $params    = [
                'type'    => $inputType->value,
                'content' => $content,
            ];
            $taskQuery = TaskModel::query()
                ->orderByDesc('created_at')
                ->where('user_id', $request->userInfo->id)
                ->where('created_at', '>=', now()->subDays(7))
                ->where('run_status', TaskRunStatus::Finished->value)
                ->where('complete_status', TaskCompleteStatus::Success->value);

            foreach($params as $key => $value) {
                if (is_array($value)) {
                    $taskQuery->whereJsonContains("params->$key", $value);
                } else {
                    $taskQuery->where("params->$key", $value);
                }
            }
            $taskId = $taskQuery->value('task_id');
            if ($taskId) {
                return [
                    'taskId' => (string)$taskId,
                    'status' => TaskCompleteStatus::Success->labelCode(),
                    'reused' => true,
                ];
            }

            $taskId     = Snowflake::instance()->id();
            $createData = [
                'params'     => [
                    'type'    => $inputType->value,
                    'content' => $content,
                ],
                'additional' => ['userId' => $request->userInfo->id],
                'user_id'    => $request->userInfo->id,
                'task_id'    => $taskId,
                'run_status' => TaskRunStatus::Waiting->value,
            ];

            TaskModel::create($createData);

            // 预设 Redis 状态为正在执行
            Redis::setEx(
                UserInfoContext::userInfoTaskCacheKey($request->userInfo->id, $taskId),
                3600,
                TaskRunStatus::Running->value
            );

            try {
                Client::send(QueueEventName::TaskConsume->value, $taskId);
            } catch (\Throwable $exception) {
                TaskModel::query()->where('task_id', $taskId)->update([
                    'run_status'      => TaskRunStatus::Finished->value,
                    'complete_status' => TaskCompleteStatus::Failed->value,
                    'completed_at'    => date('Y-m-d H:i:s'),
                    'error_msg'       => '任务入队失败',
                ]);
                Redis::del(UserInfoContext::userInfoTaskCacheKey($request->userInfo->id, $taskId));
                throw $exception;
            }

            return [
                'taskId' => (string)$taskId,
                'status' => TaskCompleteStatus::Running->labelCode(),
                'reused' => false,
            ];
        } catch (BusinessException $exception) {
            throw $exception;
        } catch (\Exception $exception) {
            Log::error('AI识别请求异常：' . $exception->getMessage(), [
                'code'  => $exception->getCode(),
                'file'  => $exception->getFile(),
                'line'  => $exception->getLine(),
                'trace' => $exception->getTraceAsString()
            ]);
            throw new BusinessException('服务异常，请稍后再试', BusinessCode::SYSTEM_ERROR);
        }
    }

    public function recommendation(Request $request)
    {
        $userId  = Context::get(UserInfoContext::UserId->value);
        $context = [
            'mode'          => NutritionContextBuilder::MODE_FALLBACK,
            'nutrition'     => [],
            'analysis_days' => 0,
        ];
        $totalRecordDays = 0;

        if ($userId) {
            $totalRecordDays = $this->countUserRecordDays($userId);

            $mealRecordList = MealRecordModel::query()
                ->where('user_id', $userId)
                ->whereBetween('meal_date', [date('Y-m-d', strtotime("-6 day")), date('Y-m-d')])
                ->get(['meal_date', 'nutrition'])
                ->toArray();

            $context = (new NutritionContextBuilder())->build($mealRecordList, date('Y-m-d'));
        }

        $recommendation = (new Recommendation())->getSuggestions($context['nutrition']);
        if (!$recommendation) {
            return null;
        }

        return array_merge($recommendation, [
            'recommendation_mode' => $context['mode'],
            'record_days'         => $totalRecordDays,
            'analysis_days'       => $context['analysis_days'],
        ]);
    }

    private function countUserRecordDays(int|string $userId): int
    {
        if (!$userId) {
            return 0;
        }

        return (int)MealRecordModel::query()
            ->where('user_id', $userId)
            ->whereNotNull('meal_date')
            ->distinct()->count('meal_date');
    }
}
