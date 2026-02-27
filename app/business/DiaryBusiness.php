<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\context\NutritionTemplate;
use app\common\enum\BusinessCode;
use app\common\enum\MealRecordType;
use app\common\exception\DataNotFoundException;
use app\common\exception\ParamException;
use app\common\validate\MealRecordValidator;
use app\format\MealRecordFoodFormat;
use app\format\MealRecordFormat;
use app\model\FoodModel;
use app\model\FoodUnitModel;
use app\model\MealRecordFoodModel;
use app\model\MealRecordModel;
use app\util\Calculate;
use Carbon\Carbon;
use plugin\admin\app\model\MealRecord;
use support\Context;
use support\Db;
use support\exception\BusinessException;
use support\Request;
use function Symfony\Component\Clock\now;
use support\validation\annotation\Validate;

class DiaryBusiness extends BaseBusiness
{
    /**
     * 获取饮食记录列表
     */
    public function meals(Request $request): array
    {
        $date  = $request->get('date', date('Y-m-d'));
        $time  = Carbon::parse($date);
        $query = MealRecordModel::query()
            ->select('id', 'type', 'nutrition')
            ->with(['foods'])
            ->where('meal_date', $time->format('Y-m-d'))
            ->limit(3)
            ->orderBy('type');
        if ($request->userInfo) {
            $query->where('user_id', $request->userInfo->id);
        }
        $list                 = $query->get();
        $mealRecordFoodFormat = new MealRecordFoodFormat($request);
        $newList              = $list
            ->groupBy('type')
            ->map(function ($items) use ($mealRecordFoodFormat) {
                return $items->flatMap(function ($meal) use ($mealRecordFoodFormat) {
                    return $meal->foods->map(function ($foodItem) use ($mealRecordFoodFormat) {
                        return $mealRecordFoodFormat->format($foodItem);
                    });
                })->values();
            });
        return $newList->toArray();
    }

    /**
     * 获取总结
     */
    public function summary(Request $request): array
    {

        //每日卡路里目标
        $target             = $request->userInfo->target ?? 2000;
        $dailyGoal          = $this->calcMacroFromKcal($target);
        $totalNutritionList = MealRecordModel::query()
            ->where('user_id', $request->userInfo->id)
            ->where('meal_date', Carbon::today())
            ->pluck('nutrition')->toArray();
        $totalNutrition     = [];
        foreach ($totalNutritionList as $item) {
            foreach ($item as $k => $v) {
                if (!isset($totalNutrition[$k])) {
                    $totalNutrition[$k] = $v;
                    continue;
                }
                $totalNutrition[$k] = bcadd($totalNutrition[$k], $v);
            }
        }
        return [
            'dailyGoal'      => $dailyGoal,
            'totalIntake'    => [
                'calories' => $totalNutrition['kcal'],
                'protein'  => $totalNutrition['protein'],
                'fat'      => $totalNutrition['fat'],
                'carbs'    => $totalNutrition['carbohydrate'] ?? 00,
            ],
            'burnedCalories' => 0.00
        ];
    }

    #[Validate(validator: MealRecordValidator::class, scene: 'create')]
    public function addMeal(Request $request)
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

    #[Validate(validator: MealRecordValidator::class, scene: 'delete')]
    public function delete(Request $request)
    {
        return Db::transaction(function () use ($request) {
            $mealRecordFoodId = $request->post('meal_record_food_id');

            // 获取要删除的食物项目并锁定
            $mealFood = MealRecordFoodModel::query()
                ->where('id', $mealRecordFoodId)
                ->where('user_id', $request->userInfo->id)
                ->lockForUpdate()
                ->first();

            if (!$mealFood) {
                throw new DataNotFoundException('未找到该饮食记录项');
            }

            $mealRecordId = $mealFood->meal_id;

            // 获取主记录并锁定
            $mealRecord = MealRecordModel::query()
                ->where('id', $mealRecordId)
                ->where('user_id', $request->userInfo->id)
                ->lockForUpdate()
                ->first();

            if (!$mealRecord) {
                throw new DataNotFoundException('未找到相关的饮食记录');
            }

            // 从主记录中减去要删除的食物营养成分
            $currentNutrition = $mealRecord->nutrition ?: NutritionTemplate::instance()->template();
            $foodNutrition    = $mealFood->nutrition ?: [];

            foreach ($foodNutrition as $key => $value) {
                if (isset($currentNutrition[$key])) {
                    $currentNutrition[$key] = bcsub((string)$currentNutrition[$key], (string)$value, 2);
                    // 确保不会出现负数（业务逻辑上营养成分不应为负）
                    if (bccomp($currentNutrition[$key], '0', 2) === -1) {
                        $currentNutrition[$key] = '0.00';
                    }
                }
            }

            // 更新主表营养总和
            $mealRecord->nutrition = $currentNutrition;
            if (!$mealRecord->save()) {
                throw new BusinessException('更新主记录失败', BusinessCode::BUSINESS_ERROR->value);
            }

            // 删除该项
            if (!$mealFood->delete()) {
                throw new BusinessException('删除失败，请稍后重试', BusinessCode::BUSINESS_ERROR->value);
            }

            return $mealFood;
        });
    }

    public function calcMacroFromKcal(int $target, array $ratio = [
        'protein' => 0.2,
        'fat'     => 0.25,
        'carbs'   => 0.55,
    ]): array
    {
        if ($target <= 0) {
            throw new ParamException('target');
        }

        // 各营养素所占热量
        $proteinKcal = bcmul((string)$target, (string)$ratio['protein'], 2);
        $fatKcal     = bcmul((string)$target, (string)$ratio['fat'], 2);
        $carbsKcal   = bcmul((string)$target, (string)$ratio['carbs'], 2);

        return [
            'kcal'    => $target,
            'protein' => bcdiv($proteinKcal, '4', 2), // 4 kcal/g
            'fat'     => bcdiv($fatKcal, '9', 2),     // 9 kcal/g
            'carbs'   => bcdiv($carbsKcal, '4', 2),   // 4 kcal/g
        ];
    }
}
