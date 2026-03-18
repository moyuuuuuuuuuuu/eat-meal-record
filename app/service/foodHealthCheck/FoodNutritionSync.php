<?php

namespace app\service\foodHealthCheck;

use app\model\FoodModel;
use app\service\FoodService;
use app\util\FoodSyncByRemote;
use support\Db;
use support\Log;
use support\Redis;

final class FoodNutritionSync extends BaseHealthCheck
{


    /**
     * @param string[] $foodNameItem
     * @return array
     */
    protected function syncRemote(array $foodNameItem)
    {
        $codeResponseCacheKey = 'coze:response:' . date('Ymd') . ':nutrition:' . md5(json_encode($foodNameItem));
        $foodNutritionList    = Redis::get($codeResponseCacheKey);
        if ($foodNutritionList) {
            $foodNutritionList = json_decode($foodNutritionList, true);
        } else {
            $foodNutritionList = FoodService::nutritionForFood($foodNameItem);
            if ($foodNutritionList) {
                Redis::setEx($codeResponseCacheKey, 1800, json_encode($foodNutritionList));
            }
        }
        if (empty($foodNutritionList)) {
            Redis::del($codeResponseCacheKey);
            Log::warning("AI未返回任何食品信息: " . implode(',', $foodNameItem));
            return [];
        }
        /**
         * [{"cat":"五谷","is_common":1,"is_ingredient":2,"name":"八宝粥","nutrition":[{"name":"kcal","value":68.0},{"name":"pro","value":2.4},{"name":"fat","value":0.3},{"name":"carb","value":14.7},{"name":"fiber","value":1.2},{"name":"vit_c","value":2.0},{"name":"mag","value":17.0},{"name":"folic","value":12.0},{"name":"cal","value":7.0},{"name":"iron","value":0.5},{"name":"vit_e","value":0.12}],"tags":{"口味":"甜","推荐餐次":"早餐、加餐","特性":"易消化、中等热量"},"units":[{"is_default":1,"name":"罐","type":"package","weight":360},{"is_default":0,"name":"碗","type":"service","weight":250}]},{"cat":"五谷","is_common":2,"is_ingredient":2,"name":"壮馍","nutrition":[{"name":"kcal","value":280.0},{"name":"pro","value":8.0},{"name":"fat","value":10.0},{"name":"carb","value":38.0},{"name":"fiber","value":1.5},{"name":"vit_c","value":0.0},{"name":"mag","value":25.0},{"name":"folic","value":15.0},{"name":"cal","value":30.0},{"name":"iron","value":1.2},{"name":"vit_e","value":0.8}],"tags":{"口味":"咸香","推荐餐次":"午餐、晚餐","特性":"高热量、饱腹感强"},"units":[{"is_default":1,"name":"个","type":"count","weight":500}]}]
         */
        $result = [];
        foreach ($foodNutritionList as $key => $item) {
            $currentResult = false;
            try {
                $foodName = $item['name'] ?? null;
                if (!$foodName) {
                    unset($foodNutritionList[$key]);
                    continue;
                }

                $currentResult = Db::transaction(function () use ($item, $foodNutritionList, $key) {
                    // 维护数据关系
                    $catId           = FoodSyncByRemote::cats($item['cat'] ?? '其他');
                    $food            = FoodModel::updateOrCreate(
                        ['name' => $item['name']],
                        ['cat_id' => $catId, 'status' => 1, 'is_common' => $item['is_common'] ?? 2, 'is_ingredient' => $item['is_ingredient'] ?? 2]
                    );
                    $nutritionResult = FoodSyncByRemote::nutrition($food->id, $item['nutrition']);
                    $unitResult      = FoodSyncByRemote::units($food->id, $item['units'] ?? []);
                    $tagResult       = FoodSyncByRemote::tags($food->id, $item['tags'] ?? []);
                    if (!$unitResult || !$nutritionResult || !$tagResult) {
                        unset($foodNutritionList[$key]);
                        return null;
                    }
                    return $unitResult && $nutritionResult && $tagResult;
                });
            } catch (\Exception $e) {
                Log::error("食品 [{$foodName}] 同步失败: " . $e->getMessage());
                continue;
            } finally {
                $result[] = $currentResult ? 1 : 0;
            }
        }
        $result = array_filter($result);
        Redis::del($codeResponseCacheKey);
        return $result;
    }
}
