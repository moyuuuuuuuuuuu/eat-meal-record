<?php

namespace app\service\foodHealthCheck;

use app\model\FoodModel;
use app\service\FoodService;
use app\util\FoodSyncByRemote;
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

        $foodsByName  = FoodModel::whereIn('name', $foodNameItem)->get(['id', 'name'])->keyBy('name');
        $successNames = [];

        foreach ($result as $item) {
            $foodName    = $item['food'] ?? null;
            $unitItems   = $item['unit'] ?? [];
            $currentFood = $foodsByName->get($foodName);

            if (!$currentFood || empty($unitItems)) continue;

            try {
                $foodId = Db::transaction(function () use ($unitItems, $currentFood) {
                    if (!FoodSyncByRemote::units($currentFood->id, $unitItems)) {
                        throw new \RuntimeException('未保存任何有效单位');
                    }
                    return $currentFood->id;
                }, 3);

                $successNames[] = $foodId;
            } catch (\Exception $e) {
                Log::error("FoodUnitSync [{$foodName}] 写入失败: " . $e->getMessage());
            }
        }
        Redis::del($codeResponseCacheKey);
        return $successNames;
    }
}
