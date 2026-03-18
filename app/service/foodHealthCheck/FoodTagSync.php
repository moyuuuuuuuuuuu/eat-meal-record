<?php

namespace app\service\foodHealthCheck;

use app\model\FoodModel;
use app\model\FoodTagModel;
use app\model\TagModel;
use app\service\Alarm;
use app\service\FoodService;
use support\Db;
use support\Log;
use support\Redis;

class FoodTagSync extends BaseHealthCheck
{


    /**
     * @param string[] $foodNameItem
     * @return array
     */
    protected function syncRemote(array $foodNameItem)
    {
        $codeResponseCacheKey = 'coze:response:' . date('Ymd') . ':tag:' . md5(json_encode($foodNameItem));
        $result               = Redis::get($codeResponseCacheKey);

        if ($result) {
            $resultData = json_decode($result, true);
        } else {
            $resultData = FoodService::tag($foodNameItem);
            if ($resultData) {
                Redis::setEx($codeResponseCacheKey, 1800, json_encode($resultData));
            }
        }

        if (empty($resultData)) return [];

        $foodIdList   = FoodModel::query()->whereIn('name', $foodNameItem)->get(['id', 'name'])->keyBy('name');
        $successNames = [];

        foreach ($resultData as $foodInfo) {
            $foodName    = $foodInfo['food'] ?? null;
            $currentFood = $foodIdList->get($foodName);
            if (!$currentFood) continue;

            try {
                $status = Db::transaction(function () use ($foodInfo, $currentFood) {
                    $tags = $foodInfo['tags'] ?? [];
                    foreach ($tags as $tagName => $typeName) {
                        $typeId = $this->typeMapping[$typeName] ?? 3;

                        $tagModel = TagModel::firstOrCreate(
                            ['name' => $tagName, 'type' => $typeId],
                            ['meta_type' => $typeName]
                        );

                        FoodTagModel::firstOrCreate([
                            'food_id' => $currentFood->id,
                            'tag_id'  => $tagModel->id
                        ]);
                    }
                    return true;
                }, 3);

                if ($status) $successNames[] = $foodName;
            } catch (\Exception $e) {
                Alarm::notify($e);
            }
        }

        return $successNames;
    }
}
