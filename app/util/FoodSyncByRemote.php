<?php

namespace app\util;

use app\common\enum\FoodTag;
use app\model\{CatModel, FoodNutrientModel, FoodTagModel, FoodUnitModel, TagModel, UnitModel};
use \Illuminate\Database\QueryException;

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
    static function units(int $foodId, array $units)
    {
        if (!$foodId || !$units) return null;
        $result = [];
        foreach ($units as $unit) {
            try {
                $unitModel = UnitModel::query()->where('name', $unit['name'])->first();
                if (!$unitModel) {
                    $unitModel = UnitModel::create([
                        'name' => $unit['name'],
                        'type' => $unit['type'],
                    ]);
                }
                $foodUnitModel = FoodUnitModel::updateOrCreate(
                    ['food_id' => $foodId, 'unit_id' => $unitModel->id],
                    ['weight' => $unit['weight'] ?? 0, 'is_default' => $unit['is_default'] ?? 0]
                );
                $result[]      = $foodUnitModel->id;
            } catch (QueryException $e) {
                if ($e->getCode() == 23000) {
                    self::units($foodId, $units);
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
    static function tags(int $foodId, array $tags)
    {
        $result = [];
        foreach ($tags as $tagName => $typeName) {
            $typeId = FoodTag::fromLabel($typeName);
            try {
                $tagModel = TagModel::where('name', $typeName)->where('type', $typeId)->first();
                if (!$tagModel) {
                    $tagModel = TagModel::create([
                        'name'      => $tagName,
                        'type'      => $typeId,
                        'meta_type' => $typeName
                    ]);
                }

                $foodTagModel = FoodTagModel::firstOrCreate([
                    'food_id' => $foodId,
                    'tag_id'  => $tagModel->id
                ]);
                $result[]     = $foodTagModel->id;
            } catch (QueryException $e) {
                if ($e->getCode() == 23000) {
                    $tagModel = TagModel::where('name', $tagName)->where('type', $typeId)->first();
                    if ($tagModel) {
                        FoodTagModel::firstOrCreate(['food_id' => $foodId, 'tag_id' => $tagModel->id]);
                    }
                } else {
                    throw $e;
                }
            }
        }
        return $result;
    }
}
