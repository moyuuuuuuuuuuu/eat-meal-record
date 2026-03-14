<?php

namespace app\service\recommendation;

use support\Db;

/**
 * 食物仓库 —— 唯一知道 foods / food_nutrients / food_tags 表的类
 *
 * 职责：根据 tag_id 列表查询匹配的食物及其营养数据。
 *       所有 SQL 逻辑集中在此，缓存/分页/排序扩展也在此处理。
 *
 * 相关表结构假设：
 *   foods         : id, name, status(1=上架)
 *   food_nutrients: food_id, kcal, pro, fat, carb, fiber
 *   food_tags     : food_id, tag_id
 */
class FoodRepository
{
    /**
     * 根据标签 ID 列表随机查询食物
     *
     * @param  int[] $tagIds  目标标签 ID
     * @param  int   $limit   返回条数（默认 3）
     * @return array          食物数组，每项包含 id/name/kcal/pro/fat/carb/fiber
     */
    public function findByTagIds(array $tagIds, int $limit = 3): array
    {
        if (empty($tagIds)) {
            return [];
        }

        $rows = Db::table('foods as f')
            ->join('food_nutrients as fn', 'f.id', '=', 'fn.food_id')
            ->whereExists(function ($query) use ($tagIds) {
                $query->select(Db::raw(1))
                    ->from('food_tags as ftr')
                    ->whereRaw('ftr.food_id = f.id')
                    ->whereIn('ftr.tag_id', $tagIds);
            })
            ->where('f.status', 1)
            ->inRandomOrder()
            ->limit($limit)
            ->select('f.id', 'f.name', 'fn.kcal', 'fn.pro', 'fn.fat', 'fn.carb', 'fn.fiber')
            ->get();

        return $rows ? $rows->toArray() : [];
    }

    /**
     * 随机取一条推荐食物（用于单条推荐场景）
     *
     * @param  int[] $tagIds
     * @return array|null  单条食物，未命中返回 null
     */
    public function findOneByTagIds(array $tagIds): ?array
    {
        if (empty($tagIds)) {
            return null;
        }

        $row = Db::table('foods as f')
            ->join('food_nutrients as fn', 'f.id', '=', 'fn.food_id')
            ->whereExists(function ($query) use ($tagIds) {
                $query->select(Db::raw(1))
                    ->from('food_tags as ftr')
                    ->whereRaw('ftr.food_id = f.id')
                    ->whereIn('ftr.tag_id', $tagIds);
            })
            ->where('f.status', 1)
            ->inRandomOrder()
            ->select('f.id', 'f.name', 'fn.kcal', 'fn.pro', 'fn.fat', 'fn.carb', 'fn.fiber')
            ->first();

        return $row ? (array) $row : null;
    }

    /**
     * 扩展点：按热量范围过滤（供未来个性化推荐使用）
     *
     * @param  int[] $tagIds
     * @param  float $minKcal
     * @param  float $maxKcal
     * @param  int   $limit
     */
    public function findByTagIdsWithKcalRange(
        array $tagIds,
        float $minKcal,
        float $maxKcal,
        int   $limit = 3
    ): array {
        if (empty($tagIds)) {
            return [];
        }

        $rows = Db::table('foods as f')
            ->join('food_nutrients as fn', 'f.id', '=', 'fn.food_id')
            ->whereExists(function ($query) use ($tagIds) {
                $query->select(Db::raw(1))
                    ->from('food_tags as ftr')
                    ->whereRaw('ftr.food_id = f.id')
                    ->whereIn('ftr.tag_id', $tagIds);
            })
            ->where('f.status', 1)
            ->whereBetween('fn.kcal', [$minKcal, $maxKcal])
            ->inRandomOrder()
            ->limit($limit)
            ->select('f.id', 'f.name', 'fn.kcal', 'fn.pro', 'fn.fat', 'fn.carb', 'fn.fiber')
            ->get();

        return $rows ? $rows->toArray() : [];
    }
}
