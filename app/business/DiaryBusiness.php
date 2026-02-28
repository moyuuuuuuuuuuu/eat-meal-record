<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\context\NutritionTemplate;
use app\common\enum\BusinessCode;
use app\common\enum\MealRecordType;
use app\common\exception\DataNotFoundException;
use app\common\exception\ValidationException;
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
use Webman\Validation\Annotation\Validate;

class DiaryBusiness extends BaseBusiness
{
    /**
     * 获取饮食记录列表
     */
    public function meals(Request $request): array
    {
        if (!$request->userInfo) {
            return [];
        }
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
        $target    = $request->userInfo->target ?? 2000;
        $dailyGoal = $this->calcMacroFromKcal($target);
        if ($request->userInfo) {
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

                    $totalNutrition[$k] = Calculate::add($totalNutrition[$k], $v);
                }
            }
        }
        return [
            'dailyGoal'      => $dailyGoal ?? [
                    'calories' => $target,
                    'protein'  => 0.00,
                    'fat'      => 0.00,
                    'carbs'    => 0.00,
                ],
            'totalIntake'    => [
                'calories' => $totalNutrition['kcal'] ?? 0.00,
                'protein'  => $totalNutrition['protein'] ?? 0.00,
                'fat'      => $totalNutrition['fat'] ?? 0.00,
                'carbs'    => $totalNutrition['carbohydrate'] ?? 00,
            ],
            'burnedCalories' => 0.00
        ];
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
            if (MealRecordFoodModel::query()->where('meal_id', $mealRecordId)->where('id', '<>', $mealRecordFoodId)->count() <= 0) {
                //删除主记录并返回
                $mealRecordDeleteResult = MealRecordModel::query()
                    ->where('id', $mealRecordId)
                    ->where('user_id', $request->userInfo->id)
                    ->lockForUpdate()
                    ->delete();
                return $mealRecordDeleteResult && $mealFood->delete();
            }
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

                    $currentNutrition[$key] = Calculate::sub((string)$currentNutrition[$key], (string)$value, 2);
                    // 确保不会出现负数（业务逻辑上营养成分不应为负）
                    if (Calculate::comp($currentNutrition[$key], '0', 2) === -1) {
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
            throw new ValidationException('target');
        }

        // 各营养素所占热量
        $proteinKcal = bcmul((string)$target, (string)$ratio['protein'], 2);
        $fatKcal     = bcmul((string)$target, (string)$ratio['fat'], 2);
        $carbsKcal   = bcmul((string)$target, (string)$ratio['carbs'], 2);

        return [
            'calories' => $target,
            'protein'  => bcdiv($proteinKcal, '4', 2), // 4 kcal/g
            'fat'      => bcdiv($fatKcal, '9', 2),     // 9 kcal/g
            'carbs'    => bcdiv($carbsKcal, '4', 2),   // 4 kcal/g
        ];
    }
}
