<?php

namespace app\service\foodHealthCheck;

use app\model\FoodModel;
use app\model\FoodUnitModel;
use app\model\UnitModel;
use app\service\FoodService;
use support\Db;
use support\Log;
use support\Redis;

final class FoodUnitSync extends BaseHealthCheck
{


    /**
     * @param string[] $foodNameItem
     * @return array
     */
    protected function syncRemote(array $foodNameItem)
    {
        $codeResponseCacheKey = 'coze:response:' . date('Ymd') . ':unit:' . md5(json_encode($foodNameItem));
        try {
            $result = Redis::get($codeResponseCacheKey);
            if ($result) {
                $result = json_decode($result, true);
            } else {
                $result = FoodService::unit($foodNameItem);
                if ($result) {
                    Redis::setEx($codeResponseCacheKey, 1800, json_encode($result));
                }
            }
        } catch (\Exception $e) {
            Log::error("FoodUnitSync API 失败: " . $e->getMessage());
            return [];
        }

        if (empty($result)) return [];

        $resultData = is_string($result) ? json_decode($result, true) : $result;
        // 处理嵌套 data 结构
        if (isset($resultData['data'])) $resultData = $resultData['data'];

        $foodsByName  = FoodModel::whereIn('name', $foodNameItem)->get(['id', 'name'])->keyBy('name');
        $successNames = [];

        foreach ($resultData as $item) {
            $foodName    = $item['food'] ?? null;
            $unitItems   = $item['unit'] ?? [];
            $currentFood = $foodsByName->get($foodName);

            if (!$currentFood || empty($unitItems)) continue;

            try {
                $status = Db::transaction(function () use ($unitItems, $currentFood) {
                    foreach ($unitItems as $unitItem) {
                        $unitName  = $unitItem['name'] ?? '克';
                        $weight    = (float)($unitItem['weight'] ?? 100);
                        $isDefault = (int)($unitItem['is_default'] ?? 0);

                        $unit = UnitModel::firstOrCreate(['name' => $unitName]);

                        FoodUnitModel::updateOrCreate(
                            ['food_id' => $currentFood->id, 'unit_id' => $unit->id],
                            ['weight' => $weight, 'is_default' => $isDefault]
                        );
                    }
                    return true;
                }, 3);

                if ($status) $successNames[] = $foodName;
            } catch (\Exception $e) {
                Log::error("FoodUnitSync [{$foodName}] 写入失败: " . $e->getMessage());
            }
        }
        Redis::del($codeResponseCacheKey);
        return $successNames;
    }
}
