<?php

namespace app\util;

use app\common\enum\FoodTag;
use app\model\{CatModel, FoodNutrientModel, FoodTagModel, FoodUnitModel, TagModel, UnitModel};
use \Illuminate\Database\QueryException;
use support\Log;

/**
 * 食品信息同步
 * 数据来源于扣子 使用的豆包1.8
 */
class FoodSyncByRemote
{

    /**
     * @param string $catName
     * @return int|null
     */
    static function cats(string $catName): int|null
    {
        try {
            $catModel = CatModel::query()->where('name', $catName)->first();
            if (!$catModel) {
                $catModel = CatModel::create([
                    'name' => $catName, 'pid' => 0, 'sort' => 100
                ]);
            }
            return $catModel->id ?? 0;
        } catch (QueryException $e) {
            if ($e->getCode() == 23000) {
                return self::cats($catName);
            }
            throw $e;
        }
    }

    /**
     * @param int $foodId
     * @param array $nutrition
     * @return FoodNutrientModel|\Illuminate\Database\Eloquent\Model|null
     */
    static function nutrition(int $foodId, array $nutrition)
    {
        if (!$foodId || !$nutrition) return null;
        $localNutrition = [];
        foreach ($nutrition as $nut) {
            $key                  = $nut['name'];
            $val                  = (string)($nut['value'] ?? 0);
            $localNutrition[$key] = (float)Calculate::mul($val, 1, 2);
        }
        return FoodNutrientModel::updateOrCreate(['food_id' => $foodId], $localNutrition);
    }

    /**
     * @param int $foodId
     * @param array $units
     * @return int[]|null
     */
    static function units(int $foodId, array $units, int $attempt = 0)
    {
        if (!$foodId || !$units) return null;
        $result = [];
        foreach ($units as $unit) {
            try {
                $unitModel     = UnitModel::updateOrCreate([
                    'name' => $unit['name'],
                    'type' => $unit['type'],
                ]);
                $foodUnitModel = FoodUnitModel::updateOrCreate(
                    ['food_id' => $foodId, 'unit_id' => $unitModel->id],
                    ['weight' => $unit['weight'] ?? 0, 'is_default' => $unit['is_default'] ?? 0]
                );
                $result[]      = $foodUnitModel->id;
            } catch (QueryException $e) {
                if ($attempt < 3 && in_array($e->errorInfo[1], [1213, 1062])) {
                    usleep(mt_rand(100, 500) * 1000); // 随机等待 100-500ms
                    self::units($foodId, $units, $attempt + 1);
                } else {
                    throw $e;
                }
            }
        }

        return $result;
    }

    /**
     * @param int $foodId
     * @param array $tags
     * @return array
     */
    static function tags(int $foodId, array $tags, int $attempt = 0)
    {
        $result = [];
        foreach ($tags as $tagName => $typeName) {
            $typeId = FoodTag::fromLabel($typeName);
            try {
                // 1. 尝试获取或创建标签 ID
                $tagId = self::getOrCreateTagId($tagName, $typeId);

                if (!$tagId) continue;

                // 2. 建立关联（使用 firstOrCreate 避免重复写入）
                $foodTagModel = FoodTagModel::firstOrCreate([
                    'food_id' => $foodId,
                    'tag_id'  => $tagId
                ]);
                $result[]     = $foodTagModel->id;
            } catch (QueryException $e) {
                Log::info($e->getCode(), [$e->getMessage()]);
                // 3. 限制重试次数，避免无限递归
                if ($attempt < 3 && in_array($e->errorInfo[1], [1213, 1062])) {
                    usleep(mt_rand(100, 500) * 1000); // 随机等待 100-500ms
                    return self::tags($foodId, $tags, $attempt + 1);
                }
                throw $e;
            }
        }
        return $result;
    }

    /**
     * 内部方法：安全获取标签 ID
     */
    static function getOrCreateTagId($tagName, $typeId)
    {
        try {
            $maxRetries = 3;
            $attempt    = 0;

            while ($attempt < $maxRetries) {
                try {
                    // 用 firstOrCreate 代替 insert，天然避免重复插入冲突
                    $tagModel = \app\model\TagModel::firstOrCreate(
                        ['name' => $tagName, 'type' => $typeId]
                    );
                    break; // 成功则跳出循环
                } catch (\Exception $e) {
                    if (strpos($e->getMessage(), '1213') !== false && $attempt < $maxRetries - 1) {
                        $attempt++;
                        usleep(mt_rand(50000, 200000)); // 随机等 50~200ms 再重试，错开竞争
                        continue;
                    }
                    throw $e; // 重试次数耗尽或其他错误，往上抛
                }
            }
            return $tagModel->id ?? null;
        } catch (QueryException $e) {
            // 如果创建时被别人抢先了 (1062) 或死锁 (1213)
            if (in_array($e->errorInfo[1], [1062, 1213])) {
                // 稍作停顿，直接从数据库读别人刚创建好的
                usleep(10000);
                $tag = TagModel::where('name', $tagName)->first();
                return $tag->id ?? null;
            }
            throw $e;
        }
    }
}
