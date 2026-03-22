<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\context\TokenLimit;
use app\common\enum\BusinessCode;
use app\common\enum\NormalStatus;
use app\common\enum\NutritionInputType;
use app\common\enum\QueueEventName;
use app\common\enum\UserInfoContext;
use app\common\exception\BusinessException;
use app\common\exception\DataNotFoundException;
use app\common\exception\ValidationException;
use app\common\validate\FoodValidator;
use app\format\FoodFormat;
use app\service\Alarm;
use app\model\{FoodModel, FoodUnitModel, MealRecordModel};
use app\service\baidu\Bos;
use app\service\BooHee;
use app\service\FoodService;
use app\service\recommendation\Recommendation;
use app\util\Calculate;
use app\util\FoodSyncByRemote;
use app\util\Helper;
use support\Context;
use support\Db;
use support\Log;
use support\Request;
use Webman\RedisQueue\Client;
use Webman\Validation\Annotation\Validate;

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
            echo '食品' . $name . '未找到已推送至队列查询' . PHP_EOL;
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

    public function syncRemote(array $foodList)
    {
        if (empty($foodList)) return true;
        $newFoodList = [];
        $foodFormat  = new FoodFormat(null);
        foreach ($foodList as $key => $item) {
            $foodInfo = Db::transaction(function () use ($key, $item, $foodList) {
                $catId           = FoodSyncByRemote::cats($item['cat'] ?? '其他');
                $food            = FoodModel::updateOrCreate(
                    ['name' => $item['name']],
                    ['cat_id' => $catId, 'status' => 1, 'is_common' => $item['is_common'] ?? 2, 'is_ingredient' => $item['is_ingredient'] ?? 2]
                );
                $nutritionResult = FoodSyncByRemote::nutrition($food->id, $item['nutrition']);
                $unitResult      = FoodSyncByRemote::units($food->id, $item['units'] ?? []);
                $tagResult       = FoodSyncByRemote::tags($food->id, $item['tags'] ?? []);
                if (!$unitResult || !$nutritionResult || !$tagResult) {
                    unset($foodList[$key]);
                    return null;
                }
                return $food;
            });
            if ($foodInfo) {
                $newFoodList[] = $foodFormat->format($foodInfo);
            }
        }
        return $newFoodList;
    }

    #[Validate(validator: FoodValidator::class, scene: 'recognize')]
    public function recognize(Request $request)
    {
        if (!TokenLimit::instance()->hasQuota()) {
            throw new BusinessException('AI识别次数已经用完，请先手动选择食物吧', BusinessCode::NO_AUTH);
        }
        $content = $request->post('content', null);
        $type    = $request->post('type', null);
        $options = $request->post('options', []);
        if (!$type || !$content) {
            throw new ValidationException('类型', '内容');
        }

        if (!in_array($type, Helper::cases(NutritionInputType::class))) {
            throw new BusinessException('不支持的识别方式', BusinessCode::PARAM_ERROR);
        }
        try {
            $type = NutritionInputType::tryFrom($type);
            if (in_array($type, [NutritionInputType::AUDIO, NutritionInputType::IMAGE])) {
                $result = Bos::instance()->putObjFromBase($content, $options ?? ['format' => 'jpg']);
                if (!$result) {
                    throw new BusinessException('录音文件上传失败', BusinessCode::THREE_PART_ERROR);
                }
                $content = source($result);
            }
            $result = FoodService::nutrition($type, $content);

            if (!$result) {
                throw new DataNotFoundException('识别失败');
            }
            return FoodBusiness::instance()->syncRemote($result ?? []);
        } catch (\Exception $exception) {
            Log::error($exception->getMessage(), [$exception->getCode(), $exception->getFile(), $exception->getLine(), $exception->getTraceAsString()]);
            Alarm::notify($exception);
            throw new BusinessException($exception->getMessage(), $exception->getCode());
        }
    }

    public function recommendation(Request $request)
    {
        $userId       = Context::get(UserInfoContext::UserId->value);
        $sumNutrition = [];

        if ($userId) {
            //检查数据是否满足推荐
            //7天内是否有餐食记录
            $mealRecordList = MealRecordModel::query()
                ->whereBetween('meal_date', [date('Y-m-d', strtotime("-7 day")), date('y-m-d')])
                ->pluck('nutrition')
                ->toArray();
            foreach ($mealRecordList as $mealRecord) {
                foreach ($mealRecord as $nut => $num) {
                    if (!isset($sumNutrition[$nut])) {
                        $sumNutrition[$nut] = $num;
                        continue;
                    }
                    $sumNutrition[$nut] = Calculate::add($sumNutrition[$nut], $num);
                }
            }
        }
        return (new Recommendation())->getSuggestions($sumNutrition);
    }
}
