<?php

namespace app\service\redisSubscribe;

use app\model\CatModel;
use app\model\FoodModel;
use app\model\FoodTagModel;
use app\model\TagModel;
use app\service\FoodService;
use support\Db;
use support\Log;

class FoodTagSync extends BaseRedisSubscribe
{

    public function run($message)
    {
        $foodIds = json_decode($message, true);

        $foodList = FoodModel::query()->whereIn('id', $foodIds)->get(['name', 'id']);
        if ($foodList->isEmpty()) {
            return;
        }
        $result   = null;
        $attempts = 0;
        while ($attempts < 3) {
            try {
                $result = FoodService::tag($foodList->pluck('name')->toArray());
                break;
            } catch (\Exception $e) {
                $attempts++;
                if ($attempts >= 3) {
                    Log::error("FoodTagSync ⚠️ API 彻底失败: " . $e->getMessage());
                    return;
                }
                sleep(2);
            }
        }


        if (empty($result)) return;
        $resultData = is_string($result) ? json_decode($result, true) : $result;

        foreach ($resultData as $foodInfo) {
            $foodName    = $foodInfo['food'] ?? null;
            $currentFood = $foodList->where('name', $foodName)->first() ?? null;
            if (!$currentFood) continue;

            try {
                // 2. 将大事务拆分为“独立的小事务”或“单次写入”，降低死锁概率
                Db::transaction(function () use ($foodInfo, $currentFood) {
                    // 处理分类
                    $cateModel = CatModel::firstOrCreate(['name' => $foodInfo['cate'] ?? '其他']);
                    $currentFood->update([
                        'cat_id'    => $cateModel->id,
                        'is_common' => ($foodInfo['isCommon'] ?? false) ? 1 : 2
                    ]);
                    $tags = $foodInfo['tags'] ?? [];
                    foreach ($tags as $tagName => $typeName) {
                        $typeId = $this->typeMapping[$typeName] ?? 3;

                        try {
                            $tagModel = TagModel::where('name', $tagName)->where('type', $typeId)->first();
                            if (!$tagModel) {
                                $tagModel = TagModel::create([
                                    'name'      => $tagName,
                                    'type'      => $typeId,
                                    'meta_type' => $typeName
                                ]);
                            }

                            FoodTagModel::firstOrCreate([
                                'food_id' => $currentFood->id,
                                'tag_id'  => $tagModel->id
                            ]);
                        } catch (\Illuminate\Database\QueryException $e) {
                            if ($e->getCode() == 23000) {
                                $tagModel = TagModel::where('name', $tagName)->where('type', $typeId)->first();
                                if ($tagModel) {
                                    FoodTagModel::firstOrCreate(['food_id' => $currentFood->id, 'tag_id' => $tagModel->id]);
                                }
                            } else {
                                throw $e;
                            }
                        }
                    }
                }, 3); // 这里的 3 表示事务死锁时自动重试 3 次
            } catch (\Exception $e) {
                Log::error("FoodTagSync❌ 处理 [{$foodName}] 失败: " . $e->getMessage());
            }
        }

    }
}
