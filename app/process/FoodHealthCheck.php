<?php

namespace app\process;

use app\common\enum\RedisSubscribe;
use app\model\FoodModel;
use app\model\FoodNutrientModel;
use app\model\FoodTagModel;
use app\model\FoodUnitModel;
use support\Log;
use support\Redis;
use Workerman\Crontab\Crontab;

/**
 * 每周日凌晨3点执行食物健康检测
 * @desc 获取没有营养信息、没有单位、没有标签的食品
 */
class FoodHealthCheck
{
    public function onWorkerStart($worker)
    {
        new Crontab('0 3 * * 0', function () {
            $this->withoutNutrition();
        });

        new Crontab('0 4 * * 0', function () {
            $this->withoutUnit();
        });
        new Crontab('0 5 * * 0', function () {
            $this->withoutTag();
        });
    }

    private function withoutNutrition()
    {
        $foodTable      = (new FoodModel())->getTable();
        $nutrientsTable = (new FoodNutrientModel())->getTable();

        $withoutNutritionFoodIdList = FoodModel::query()->leftJoin($nutrientsTable, "{$nutrientsTable}.food_id", "{$foodTable}.id")
            ->whereNull("{$nutrientsTable}.id")
            ->whereNotNull("{$foodTable}.id")
            ->pluck("{$nutrientsTable}.id")
            ->toArray();
        if (empty($withoutNutritionFoodIdList)) {
            Log::info('没有不携带营养信息的食品');
            return;
        }
        Redis::publish(RedisSubscribe::FoodNutritionSync->value, json_encode($withoutNutritionFoodIdList));
    }

    private function withoutTag()
    {
        $foodTable                  = (new FoodModel())->getTable();
        $nutrientsTable             = (new FoodTagModel())->getTable();
        $withoutNutritionFoodIdList = FoodModel::query()->leftJoin($nutrientsTable, "{$nutrientsTable}.food_id", "{$foodTable}.id")
            ->whereNull("{$nutrientsTable}.id")
            ->whereNotNull("{$foodTable}.id")
            ->pluck("{$nutrientsTable}.id")
            ->toArray();
        if (empty($withoutNutritionFoodIdList)) {
            Log::info('没有不携带标签的食品');
            return;
        }
        Redis::publish(RedisSubscribe::FoodTagSync->value, json_encode($withoutNutritionFoodIdList));
    }

    private function withoutUnit()
    {
        $foodTable                  = (new FoodModel())->getTable();
        $nutrientsTable             = (new FoodUnitModel())->getTable();
        $withoutNutritionFoodIdList = FoodModel::query()->leftJoin($nutrientsTable, "{$nutrientsTable}.food_id", "{$foodTable}.id")
            ->whereNull("{$nutrientsTable}.id")
            ->whereNotNull("{$foodTable}.id")
            ->pluck("{$nutrientsTable}.id")
            ->toArray();
        if (empty($withoutNutritionFoodIdList)) {
            Log::info('没有不携带单位的食品');
            return;
        }
        Redis::publish(RedisSubscribe::FoodUnitSync->value, json_encode($withoutNutritionFoodIdList));
    }
}
