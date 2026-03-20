<?php

namespace app\queue;

use app\common\base\BaseConsumer;
use app\model\FoodModel;
use app\service\foodHealthCheck\FoodNutritionSync;
use support\Log;

class FoodNutritionSyncJob extends BaseConsumer
{
    public $queue = 'foodNutritionSync';

    public function consume($data)
    {
        list($isBatchSuccess, $foodIdList) = FoodNutritionSync::instance()->run($data);
        if (!$isBatchSuccess) {
            Log::info('食品三方信息同步失败');
            return null;
        }
        FoodModel::query()->whereIn('id', $foodIdList)->update(['coze_status' => 1]);
        Log::info('同步食物成功', [$isBatchSuccess]);
        return true;
    }
}
