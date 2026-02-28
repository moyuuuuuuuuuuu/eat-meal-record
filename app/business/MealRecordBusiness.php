<?php

namespace app\business;

use app\service\baidu\Ibs;
use support\Db;
use Carbon\Carbon;
use support\Log;
use support\Request;
use app\util\Calculate;
use app\common\enum\BusinessCode;
use app\common\base\{BaseBusiness};
use support\exception\BusinessException;
use app\common\context\NutritionTemplate;
use Webman\Validation\Annotation\Validate;
use app\common\validate\MealRecordValidator;
use app\common\exception\DataNotFoundException;
use app\model\{FoodModel, FoodUnitModel, UserStepsModel, MealRecordModel, MealRecordFoodModel};

class MealRecordBusiness extends BaseBusiness
{
    public function relation(Request $request): array
    {
        $userId = $request->userInfo->id;
        $today  = Carbon::today();
        $dates  = [];
        for ($i = 0; $i < 7; $i++) {
            $dates[] = $today->copy()->subDays($i)->toDateString();
        }

        // 1. 批量获取最近三日的餐食记录
        $mealRecords = MealRecordModel::query()
            ->with(['meals.food', 'meals.unit'])
            ->where('user_id', $userId)
            ->whereIn('meal_date', $dates)
            ->get();

        // 2. 数据聚合
        $groupedRecords = $mealRecords->groupBy(function ($item) {
            return $item->meal_date->toDateString();
        });

        $relation = [];
        foreach ($dates as $date) {
            $dateString = (string)$date;
            $dayMeals   = $groupedRecords->get($dateString, collect());

            if ($dayMeals->isEmpty()) {
                continue;
            }

            $meals = [];
            foreach ($dayMeals as $record) {
                $mealKcal = $record->nutrition['kcal'] ?? 0;

                $items = [];
                foreach ($record->meals as $mealFood) {
                    $items[] = [
                        'name'     => $mealFood->name ?: ($mealFood->food->name ?? '未知食物'),
                        'amount'   => (int)$mealFood->number . ($mealFood->unit->name ?? ''),
                        'calories' => (float)($mealFood->nutrition['kcal'] ?? 0),
                    ];
                }

                $meals[] = [
                    'id'            => $record->id,
                    'mealType'      => $record->type, // Model 中有 type 的 getter 转换
                    'items'         => $items,
                    'totalCalories' => (float)$mealKcal,
                ];
            }

            $dateLabel  = '';
            $carbonDate = Carbon::parse($dateString);
            if ($carbonDate->isToday()) {
                $dateLabel = '今天';
            } elseif ($carbonDate->isYesterday()) {
                $dateLabel = '昨天';
            } else {
                $dateLabel = $carbonDate->format('n月j日');
            }

            $relation[] = [
                'date'      => $dateString,
                'dateLabel' => $dateLabel,
                'meals'     => $meals,
            ];
        }

        return $relation;
    }

    public function history(Request $request): array
    {
        $page     = $request->post('page', 1);
        $pageSize = $request->post('pageSize', 10);
        $userId   = $request->userInfo->id;

        // 1. 获取用户有记录的所有日期并进行分页
        $datesQuery = MealRecordModel::query()
            ->where('user_id', $userId)
            ->select('meal_date')
            ->groupBy('meal_date')
            ->orderByDesc('meal_date');

        $paginator = $datesQuery->paginate($pageSize, ['*'], 'page', $page);
        $dates     = $paginator->getCollection()->pluck('meal_date')->toArray();

        if (empty($dates)) {
            return $paginator->toArray();
        }
        foreach ($dates as &$date) {
            $date = Carbon::parse($date)->toDateString();
        }
        unset($date);
        // 2. 批量获取这些日期的餐食记录
        $mealRecords = MealRecordModel::query()
            ->with(['meals.food', 'meals.unit'])
            ->where('user_id', $userId)
            ->whereIn('meal_date', $dates)
            ->get();

        // 3. 批量获取这些日期的步数记录
        $userSteps = UserStepsModel::query()
            ->where('user_id', $userId)
            ->whereIn('record_date', $dates)
            ->get()
            ->keyBy('record_date');

        // 4. 数据聚合
        $groupedRecords = $mealRecords->groupBy(function ($item) {
            return $item->meal_date->toDateString();
        });

        $history = [];
        foreach ($dates as $date) {
            $dateString = (string)$date;
            $dayMeals   = $groupedRecords->get($dateString, collect());

            $totalCalories = '0.00';
            $meals         = [];

            foreach ($dayMeals as $record) {
                $mealKcal      = $record->nutrition['kcal'] ?? 0;
                $totalCalories = Calculate::add($totalCalories, (string)$mealKcal, 2);

                $items = [];
                foreach ($record->meals as $mealFood) {
                    $items[] = [
                        'name'   => $mealFood->name ?: ($mealFood->food->name ?? '未知食物'),
                        'amount' => (int)$mealFood->number . ($mealFood->unit->name ?? ''),
                    ];
                }

                $meals[] = [
                    'id'            => $record->id,
                    'mealType'      => $record->type, // Model 中有 type 的 getter 转换
                    'totalCalories' => (float)$mealKcal,
                    'items'         => $items,
                ];
            }

            $steps       = $userSteps->get($dateString)->steps ?? 0;
            $totalBurned = (int)($steps * 0.04); // 简单步数消耗估算

            $dateLabel  = '';
            $carbonDate = Carbon::parse($dateString);
            if ($carbonDate->isToday()) {
                $dateLabel = '今天';
            } elseif ($carbonDate->isYesterday()) {
                $dateLabel = '昨天';
            } else {
                $dateLabel = $carbonDate->format('n月j日');
            }

            $history[] = [
                'id'            => $dateString,
                'date'          => $dateString,
                'dateLabel'     => $dateLabel,
                'totalCalories' => (float)$totalCalories,
                'totalBurned'   => $totalBurned,
                'mealCount'     => $dayMeals->count(),
                'meals'         => $meals,
            ];
        }

        $paginator->setCollection(collect($history));

        return $paginator->toArray();
    }


    #[Validate(validator: MealRecordValidator::class, scene: 'create')]
    public function create(Request $request)
    {
        return Db::transaction(function () use ($request) {
            $foods                     = $request->post('foods');
            $type                      = $request->post('type');
            $nutrition                 = $request->post('nutrition');
            $latitude                  = $request->post('latitude');
            $longitude                 = $request->post('longitude');
            $address                   = $request->post('address');
            $today                     = Carbon::today();
            $nutritionTemplateInstance = NutritionTemplate::instance();
            // 检查今日该餐次是否有记录
            $mealRecord = MealRecordModel::query()
                ->where('user_id', $request->userInfo->id)
                ->where('meal_date', $today->toDateString())
                ->where('type', $type)
                ->first();

            if (!$mealRecord) {
                if ($latitude && $longitude && !$address) {
                    $addressData = Ibs::instance()->getAddress($latitude, $longitude);
                    $address     = $addressData['formatted_address'] ?? '';
                }
                $mealRecord = MealRecordModel::create([
                    'user_id'   => $request->userInfo->id,
                    'type'      => $type,
                    //                    'nutrition' => $nutritionTemplateInstance->format($nutrition ?? []),
                    'meal_date' => $today->toDateString(),
                    'latitude'  => $latitude,
                    'longitude' => $longitude,
                    'address'   => $address,
                ]);
            }
            unset($nutrition);

            $mealRecordId = $mealRecord->id;
            $batchInsert  = [];
            $allNutrition = collect();

            foreach ($foods as $item) {
                // 检查当前餐食记录是否存在该食品
                $mealRecordFoodInfo = MealRecordFoodModel::query()
                    ->where('meal_id', $mealRecordId)
                    ->where('food_id', $item['food_id'])
                    ->first();

                if (!$mealRecordFoodInfo) {
                    // 不存在，计算并准备插入
                    $itemNutrition = $nutritionTemplateInstance->calculate(foodId: $item['food_id'], unitId: $item['unit_id'], number: $item['number']);
                    $allNutrition->push($itemNutrition);

                    $foodName = $item['name'] ?? null;
                    if (!$foodName) {
                        $foodName = FoodModel::query()->where('id', $item['food_id'])->value('name');
                    }
                    $batchInsert[] = [
                        'meal_id'   => $mealRecordId,
                        'user_id'   => $request->userInfo->id,
                        'food_id'   => $item['food_id'],
                        'unit_id'   => $item['unit_id'],
                        'nutrition' => json_encode($itemNutrition, JSON_UNESCAPED_UNICODE),
                        'number'    => $item['number'],
                        'name'      => $foodName,
                        'image'     => $item['image'] ?? '',
                    ];
                } else {
                    // 已存在，处理累加逻辑
                    $currentNumber = $item['number'];
                    $currentUnitId = $item['unit_id'];
                    $oldUnitId     = $mealRecordFoodInfo->unit_id;

                    if ($currentUnitId == $oldUnitId) {
                        // 单位相同，直接计算当前增量营养并累加
                        $incrementalNutrition = $nutritionTemplateInstance->calculate(foodId: $item['food_id'], unitId: $currentUnitId, number: $currentNumber);
                        $newNumber            = Calculate::add((string)$mealRecordFoodInfo->number, (string)$currentNumber, 2);
                    } else {
                        // 单位不同，需要将新添加的数量转换成旧单位的数量
                        $foodUnitWeights = FoodUnitModel::query()
                            ->where('food_id', $item['food_id'])
                            ->whereIn('unit_id', [$currentUnitId, $oldUnitId])
                            ->pluck('weight', 'unit_id');
                        if (!isset($foodUnitWeights[$currentUnitId]) || !isset($foodUnitWeights[$oldUnitId])) {
                            throw new DataNotFoundException('单位换算数据缺失');
                        }

                        // 转换率 = 当前单位重量 / 旧单位重量

                        $ratio             = Calculate::div((string)$foodUnitWeights[$currentUnitId], (string)$foodUnitWeights[$oldUnitId], 8);
                        $incrementalNumber = Calculate::mul((string)$currentNumber, $ratio, 2);
                        $newNumber         = Calculate::add((string)$mealRecordFoodInfo->number, $incrementalNumber, 2);
                        // 计算基于旧单位的增量营养
                        $incrementalNutrition = $nutritionTemplateInstance->calculate(foodId: $item['food_id'], unitId: $oldUnitId, number: $incrementalNumber);
                    }

                    // 更新该食物的营养总计（原营养 + 增量）
                    $oldNutrition     = $mealRecordFoodInfo->nutrition ?: $nutritionTemplateInstance->template();
                    $newFoodNutrition = [];
                    foreach ($oldNutrition as $key => $val) {
                        $newFoodNutrition[$key] = Calculate::add((string)$val, (string)($incrementalNutrition[$key] ?? 0), 2);
                    }

                    $mealRecordFoodInfo->number    = $newNumber;
                    $mealRecordFoodInfo->nutrition = $newFoodNutrition;
                    if (!$mealRecordFoodInfo->save()) {
                        throw new BusinessException('更新食物记录失败');
                    }

                    // 记录增量到总体营养中
                    $allNutrition->push($incrementalNutrition);
                }
            }
            // 合并并累加所有食物的营养成分
            $currentNutrition = $mealRecord->nutrition ?: $nutritionTemplateInstance->template();
            $totalNutrition   = $allNutrition->reduce(function ($carry, $item) {
                foreach ($item as $key => $value) {
                    $carry[$key] = Calculate::add((string)($carry[$key] ?? '0'), (string)$value, 2);
                }
                return $carry;
            }, $currentNutrition);

            $mealRecord->nutrition = $totalNutrition;
            $batchInsertResult     = true;
            if ($batchInsert) {
                $batchInsertResult = MealRecordFoodModel::insert($batchInsert);
            }
            if (!$mealRecord->save() || !$batchInsertResult) {
                throw new BusinessException('餐食记录保存失败', BusinessCode::BUSINESS_ERROR->value);
            }
            return $mealRecord->toArray();
        });
    }
}
