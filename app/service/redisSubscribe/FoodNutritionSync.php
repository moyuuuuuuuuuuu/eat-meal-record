<?php

namespace app\service\redisSubscribe;

use app\common\enum\RedisSubscribe;
use app\format\FoodFormat;
use app\model\CatModel;
use app\model\FoodModel;
use app\model\FoodNutrientModel;
use app\model\FoodUnitModel;
use app\model\UnitModel;
use app\service\FoodService;
use app\util\Calculate;
use support\Db;
use support\Log;
use support\Redis;

final class FoodNutritionSync extends BaseFoodSync
{
    public function run($message)
    {
        $foodNameList = json_decode($message, true);
        if (empty($foodNameList)) return;
        $chunks = array_chunk($foodNameList, 10);

        foreach ($chunks as $index => $batchNames) {
            try {
                // 1. 过滤掉数据库已存在的
                $todoNames = $this->filterExists($batchNames);

                // 记录日志 (使用 Webman 的 Log)
                \support\Log::info("[FoodNutritionSync] 待处理名单: ", $todoNames);
                if (empty($todoNames)) {
                    Log::info("[FoodNutritionSync] 批次 " . ($index + 1) . " 无需更新");
                    continue;
                }

                // 2. 调用服务获取营养信息
                $remoteFoods = FoodService::nutritionForFood(array_values($todoNames));

                \support\Log::info("[FoodNutritionSync] 远程获取数据: ", (array)$remoteFoods);

                if (!empty($remoteFoods)) {
                    // 执行同步入库
                    $foodIdList = $this->syncRemote($remoteFoods);
                    Log::info("[FoodNutritionSync] 同步进度: 批次 " . ($index + 1) . " 成功 +" . count($remoteFoods));
                    Redis::publish(RedisSubscribe::FoodTagSync->value, json_encode($foodIdList));
                    Redis::publish(RedisSubscribe::FoodUnitSync->value, json_encode($foodIdList));
                }
            } catch (\Exception $e) {
                Log::error("[FoodNutritionSync] 批次 " . ($index + 1) . " 发生异常: " . $e->getMessage(), $batchNames);
                \support\Log::error("[FoodNutritionSync] 异常详情: " . $e);
            }
        }
    }

    protected function syncRemote(array $foodList)
    {
        if (empty($foodList)) return [];

        $result = [];
        foreach ($foodList as $item) {
            $foodId   = Db::transaction(function () use ($item) {
                // 单位与重量解析
                $unitStr  = $item['unit'] ?? '1 份';
                $unitArr  = explode(' ', trim($unitStr));
                $unitNum  = (float)($unitArr[0] ?? 1);
                $unitName = $unitArr[1] ?? '份';

                $totalWeightStr = $item['weight'] ?? '100g';
                $totalWeight    = (float)preg_replace('/[^0-9.]/', '', $totalWeightStr);
                if ($totalWeight <= 0) $totalWeight = 100;

                // 100g 比例换算
                $ratio = Calculate::div('100', (string)$totalWeight, 10);

                $localNutrition = [];
                foreach ($item['nutrition'] as $nut) {
                    $key                    = $nut['name'];
                    $dbKey                  = $key;
                    $val                    = (string)($nut['value'] ?? 0);
                    $localNutrition[$dbKey] = (float)Calculate::mul($val, $ratio, 2);
                }

                if (!isset($localNutrition['kcal'])) {
                    $localNutrition['kcal'] = $localNutrition['kal'] ?? 0;
                }

                // 维护数据关系
                $catName = $item['cat'] ?? '其他';
                $catId   = CatModel::where('name', $catName)->value('id') ?:
                    CatModel::insertGetId(['name' => $catName, 'pid' => 0, 'sort' => 100]);

                $food = FoodModel::updateOrCreate(
                    ['name' => $item['name']],
                    ['cat_id' => $catId, 'status' => 1, 'is_common' => $item['is_common'] ?? 2, 'is_ingredient' => $item['is_ingredient'] ?? 2]
                );

                FoodNutrientModel::updateOrCreate(['food_id' => $food->id], $localNutrition);

                $unit             = UnitModel::firstOrCreate(['name' => $unitName], ['type' => 'count']);
                $singleUnitWeight = Calculate::div((string)$totalWeight, (string)$unitNum, 2);

                FoodUnitModel::updateOrCreate(
                    ['food_id' => $food->id, 'unit_id' => $unit->id],
                    ['weight' => $singleUnitWeight, 'is_default' => 0]
                );

                return $food->id;
            });
            $result[] = $foodId;
        }
        return $result;
    }

    /**
     * 辅助方法：过滤已同步的食物
     */
    private function filterExists(array $names): array
    {
        $foodTable          = (new FoodModel())->getTable();
        $foodNutrientsTable = (new FoodNutrientModel())->getTable();
        $exists             = FoodModel::query()
            ->whereIn('name', $names)
            ->whereExists(function ($query) use ($foodNutrientsTable, $foodTable) {
                $query->from($foodNutrientsTable)
                    ->whereColumn($foodNutrientsTable . '.food_id', $foodTable . '.id');
            })
            ->pluck('name')
            ->toArray();

        return array_diff($names, $exists);
    }
}
