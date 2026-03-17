<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\context\TokenLimit;
use app\common\enum\BusinessCode;
use app\common\enum\NormalStatus;
use app\common\enum\NutritionInputType;
use app\common\enum\RedisSubscribeEventName;
use app\common\enum\UserInfoContext;
use app\common\exception\DataNotFoundException;
use app\common\exception\ValidationException;
use app\common\validate\FoodValidator;
use app\format\FoodFormat;
use app\service\baidu\Bos;
use app\model\{CatModel, FoodModel, FoodModel as Food, FoodUnitModel, MealRecordModel, UnitModel};
use app\service\FoodService;
use app\service\Nutrition;
use app\service\recommendation\Recommendation;
use app\util\Calculate;
use app\util\Helper;
use support\Context;
use support\Db;
use app\common\exception\BusinessException;
use support\Log;
use support\Redis;
use support\Request;
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
        if (!$query->exists()) {
            $query = $query->clone();
            Redis::publish(RedisSubscribeEventName::FoodNutritionSync->value, json_encode([$name]));
            // 最多等 6 秒，每 2 秒检查一次
            foreach (range(1, 3) as $attempt) {
                sleep(2);
                if ($query->exists()) {
                    break;
                }
            }
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

        $food = Food::query()->with([
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
        foreach ($foodList as $item) {
            $foodInfo      = Db::transaction(function () use ($item, $foodFormat) {
                // 1. 解析单位与重量 (保持你原有的逻辑)
                $unitStr  = $item['unit'] ?? '1 份';
                $unitArr  = explode(' ', trim($unitStr));
                $unitNum  = (float)($unitArr[0] ?? 1);
                $unitName = $unitArr[1] ?? '份';

                $totalWeightStr = $item['weight'] ?? '100g';
                $totalWeight    = (float)preg_replace('/[^0-9.]/', '', $totalWeightStr);
                if ($totalWeight <= 0) $totalWeight = 100;

                // 2. 换算 100g 营养成分
                $ratio          = Calculate::div('100', (string)$totalWeight, 10);
                $localNutrition = [];

                foreach ($item['nutrition'] as $nut) {
                    $key                  = $nut['name'];
                    $dbKey                = $key; // 转换映射，没有映射则用原名
                    $val                  = (string)$nut['value'];
                    $localNutrition[$key] = (float)Calculate::mul($val, $ratio, 2);
                }
                if (!isset($localNutrition['kcal'])) {
                    $localNutrition['kcal'] = $localNutrition['kal'] ?? 0;
                }
                // 3. 处理单位
                $unit = UnitModel::firstOrCreate(['name' => $unitName], ['type' => 'count']);
                if ($unit->wasRecentlyCreated) $newItems['units'][] = $unitName;

                // 4. 处理食物基础信息
                $catName = $item['cat'] ?? '其他';
                $catId   = CatModel::where('name', $catName)->value('id') ?:
                    CatModel::insertGetId(['name' => $catName, 'pid' => 0, 'sort' => 100]);

                $food = FoodModel::updateOrCreate(
                    ['name' => $item['name']],
                    ['cat_id' => $catId, 'status' => 1, 'is_common' => $item['is_common'] ?? 2, 'is_ingredient' => $item['is_ingredient'] ?? 2]
                );

                // 5. 【核心补充】维护 food_nutrients 营养表
                // 注意：这里需要根据 food_id 更新或创建
                $localNutrition['food_id'] = $food->id;
                \app\model\FoodNutrientModel::updateOrCreate(
                    ['food_id' => $food->id],
                    $localNutrition
                );

                // 6. 维护食物单位换算关系
                $singleUnitWeight = Calculate::div((string)$totalWeight, (string)$unitNum, 2);
                FoodUnitModel::updateOrCreate(
                    ['food_id' => $food->id, 'unit_id' => $unit->id],
                    ['weight' => $singleUnitWeight, 'is_default' => 0]
                );
                return $food;
            });
            $newFoodList[] = $foodFormat->format($foodInfo);
        }
        return $newFoodList;
    }

    #[Validate(validator: FoodValidator::class, scene: 'recognize')]
    public function recognize(Request $request)
    {
        if (!TokenLimit::instance()->hasQuota()) {
            throw new BusinessException('AI识别次数已经用完，请先手动选择食物吧', BusinessCode::NO_AUTH);
        }

        /* $response = json_decode(file_get_contents(public_path() . '/qianfan_response.json'), true);
         return $this->success('ok', FoodBusiness::instance()->syncRemote($response));*/
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
            if ($type == NutritionInputType::IMAGE) {
                $result = (new Nutrition())->request($type, $content);
            } else {
                if ($type == NutritionInputType::AUDIO) {
                    $result = Bos::instance()->putObjFromBase($content, $options);
                    if (!$result) {
                        throw new BusinessException('录音文件上传失败', BusinessCode::THREE_PART_ERROR);
                    }
                    $content = source($result);
                }
                $result = FoodService::nutrition($type, $content);
            }

            if (!isset($result['foods']) || empty($result['foods'])) {
                throw new DataNotFoundException('识别失败');
            }
            return FoodBusiness::instance()->syncRemote($result['foods'] ?? []);
        } catch (\Exception $exception) {
            Log::error($exception->getMessage(), [$exception->getCode(), $exception->getFile(), $exception->getLine(), $exception->getTraceAsString()]);
            throw new BusinessException($exception->getMessage(), $exception->getCode(), $exception);
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
