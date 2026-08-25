<?php

namespace app\service;

use app\common\enum\BusinessCode;
use app\common\exception\BusinessException;
use app\model\FoodModel;
use app\util\FoodSyncByRemote;
use support\Db;

final class FoodSynchronizer
{
    /**
     * @return FoodModel[]
     */
    public function sync(array $foodList): array
    {
        $result = [];
        foreach ($foodList as $item) {
            if (empty($item['name']) || empty($item['nutrition'])) {
                continue;
            }
            $food = $this->syncOne($item);
            if ($food) {
                $result[] = $food;
            }
        }
        return $result;
    }

    public function syncOne(array $item): FoodModel
    {
        return Db::transaction(function () use ($item) {
            $catId = FoodSyncByRemote::cats($item['cat'] ?? '其他');
            $food = FoodModel::updateOrCreate(
                ['name' => $item['name']],
                [
                    'cat_id'        => $catId,
                    'status'        => 1,
                    'is_common'     => $item['is_common'] ?? 2,
                    'is_ingredient' => $item['is_ingredient'] ?? 2,
                ]
            );

            $nutritionSaved = FoodSyncByRemote::nutrition($food->id, $item['nutrition']);
            $unitsSaved = FoodSyncByRemote::units($food->id, $item['units'] ?? []);
            $tagsSaved = FoodSyncByRemote::tags($food->id, $item['tags'] ?? []);

            if (!$nutritionSaved || !$unitsSaved || !$tagsSaved) {
                throw new BusinessException('食品关联数据保存失败', BusinessCode::BUSINESS_ERROR);
            }
            return $food;
        });
    }
}
