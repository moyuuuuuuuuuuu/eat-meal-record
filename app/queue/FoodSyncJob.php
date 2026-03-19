<?php

namespace app\queue;


use app\common\base\BaseConsumer;
use app\common\enum\BusinessCode;
use app\common\enum\QueueEventName;
use app\common\exception\BusinessException;
use app\model\CatModel;
use app\model\FoodModel;
use app\model\FoodNutrientModel;
use app\model\FoodTagModel;
use app\model\FoodUnitModel;
use app\model\TagModel;
use app\model\UnitModel;
use app\service\Alarm;
use app\service\BooHee;
use app\service\foodHealthCheck\FoodNutritionSync;
use app\service\FoodService;
use app\util\Calculate;
use app\util\FoodSyncByRemote;
use support\Db;
use support\Log;
use support\Redis;
use Webman\RedisQueue\Consumer;
use Workerman\Coroutine\Parallel;

/**
 * 当用户查询到不存在的食物时从薄荷健康获取食物名称 然后交给模型去获取食品具体信息并落地到数据库
 */
class FoodSyncJob extends BaseConsumer
{
    public $queue      = 'FoodSync';
    public $connection = 'default';

    public function consume($data)
    {
        try {
            Log::info("[$this->queue]队列开始处理不存在的食物", $data);
            $name = $data['foodName'] ?? null;
            if (!$name) {
                Alarm::notify(new BusinessException('空字符串调用食品查询接口', BusinessCode::BUSINESS_ERROR));
                return null;
            } else if (!BooHee::instance()->canUse()) {
                Alarm::notify(new BusinessException('薄荷健康调用次数达到上限', BusinessCode::THREE_PART_ERROR));
                return null;
            }
            $booheeResponseCacheKey = 'boohee:response:' . date('Ymd') . ':' . $name;
            $booheeNameList         = Redis::get($booheeResponseCacheKey);
            if ($booheeNameList) {
                $booheeNameList = json_decode($booheeNameList, true);
            } else {
                $booheeNameList = BooHee::instance()->search($name);
                if ($booheeNameList) {
                    Redis::setEx($booheeResponseCacheKey, 1800, json_encode($booheeNameList));
                }
            }
            if (!$booheeNameList) {
                Log::info("[{$this->queue}]薄荷健康未返回食品信息", $booheeNameList);
                return null;
            }
            $foodNameList = array_column($booheeNameList, 'name');
            list($isBatchSuccess, $foodIdList) = FoodNutritionSync::instance()->run($foodNameList);
            if (!$isBatchSuccess) {
                Log::info('食品三方信息同步失败');
                return null;
            }
            FoodModel::query()->whereIn('id', $foodIdList)->update(['coze_status' => 1]);
            Log::info('同步食物成功', [$isBatchSuccess]);
            Redis::del($booheeResponseCacheKey);
            return true;
            /*$foodNameList = array_chunk($foodNameList, 10);

            $parallel = new Parallel();
            foreach ($foodNameList as $foodNameItem) {
                $parallel->add(function () use ($foodNameItem) {
                });
            }

            $result = $parallel->wait();
            Log::info('同步食物成功', $result);
            Redis::del($booheeResponseCacheKey);
            $exceptionList = $parallel->getExceptions();
            foreach ($exceptionList as $exception) {
                Log::error('食品同步队列异常', [$exception]);
                Alarm::notify($exception);
            }*/
        } catch (\Exception $e) {
            Log::error($e->getMessage(), [$e]);
            Alarm::notify($e);
        }
    }

    /**
     * @param array $foodNameItem
     * @return array
     * @deprecated 使用FoodNutritionSync类处理
     */
    private function sync(array $foodNameItem)
    {
        $foodTable         = (new FoodModel())->getTable();
        $foodNutrientTable = (new FoodNutrientModel())->getTable();
        $foodUnitTable     = (new FoodUnitModel())->getTable();
        //获取没有营养信息、没有单位的食品
        $withoutNutrientOrUnitFoodList = FoodModel::query()
            ->leftJoin($foodNutrientTable, $foodNutrientTable . '.food_id', '=', $foodTable . '.id')
            ->leftJoin($foodUnitTable, $foodTable . '.id', '=', $foodUnitTable . '.food_id')
            ->where(function ($query) use ($foodNutrientTable, $foodUnitTable) {
                $query->whereNull($foodNutrientTable . '.id')
                    ->orWhereNull($foodUnitTable . '.id');
            })->get([$foodTable . '.id', $foodTable . '.name'])->keyBy($foodTable . '.name');
        if ($withoutNutrientOrUnitFoodList) {
            $foodNameItem = array_diff($foodNameItem, $withoutNutrientOrUnitFoodList->pluck('name')->toArray());
        }
        if (empty($foodNameItem)) {
            return [];
        }
        $codeResponseCacheKey = 'coze:response:' . date('Ymd') . ':nutrition:' . md5(json_encode($foodNameItem));
        $foodNutritionList    = Redis::get($codeResponseCacheKey);
        if ($foodNutritionList) {
            $foodNutritionList = json_decode($foodNutritionList, true);
        } else {
            $foodNutritionList = FoodService::nutritionForFood($foodNameItem);
            Redis::setEx($codeResponseCacheKey, 1800, json_encode($foodNutritionList));
        }
        if (empty($foodNutritionList)) {
            Redis::del($codeResponseCacheKey);
            return [];
        }
        /**
         * [{"cat":"五谷","is_common":1,"is_ingredient":2,"name":"八宝粥","nutrition":[{"name":"kcal","value":68.0},{"name":"pro","value":2.4},{"name":"fat","value":0.3},{"name":"carb","value":14.7},{"name":"fiber","value":1.2},{"name":"vit_c","value":2.0},{"name":"mag","value":17.0},{"name":"folic","value":12.0},{"name":"cal","value":7.0},{"name":"iron","value":0.5},{"name":"vit_e","value":0.12}],"tags":{"口味":"甜","推荐餐次":"早餐、加餐","特性":"易消化、中等热量"},"units":[{"is_default":1,"name":"罐","type":"package","weight":360},{"is_default":0,"name":"碗","type":"service","weight":250}]},{"cat":"五谷","is_common":2,"is_ingredient":2,"name":"壮馍","nutrition":[{"name":"kcal","value":280.0},{"name":"pro","value":8.0},{"name":"fat","value":10.0},{"name":"carb","value":38.0},{"name":"fiber","value":1.5},{"name":"vit_c","value":0.0},{"name":"mag","value":25.0},{"name":"folic","value":15.0},{"name":"cal","value":30.0},{"name":"iron","value":1.2},{"name":"vit_e","value":0.8}],"tags":{"口味":"咸香","推荐餐次":"午餐、晚餐","特性":"高热量、饱腹感强"},"units":[{"is_default":1,"name":"个","type":"count","weight":500}]}]
         */
        $result = [];
        foreach ($foodNutritionList as $key => $item) {
            try {
                $foodName = $item['name'] ?? null;
                if (!$foodName) {
                    unset($foodNutritionList[$key]);
                    continue;
                }

                $foodId = Db::transaction(function () use ($item) {
                    // 维护数据关系
                    $catId = FoodSyncByRemote::cats($item['cat'] ?? '其他');
                    $food  = FoodModel::updateOrCreate(
                        ['name' => $item['name']],
                        ['cat_id' => $catId, 'status' => 1, 'is_common' => $item['is_common'] ?? 2, 'is_ingredient' => $item['is_ingredient'] ?? 2]
                    );
                    FoodSyncByRemote::nutrition($food->id, $item['nutrition']);
                    FoodSyncByRemote::units($food->id, $item['units'] ?? []);
                    FoodSyncByRemote::tags($food->id, $item['tags'] ?? []);
                    return $food->id;
                });
            } catch (\Exception $e) {
                Alarm::notify($e);
                continue;
            }
            $result[] = $foodId;
        }
        if (count($result) != count($foodNutritionList)) {
            Alarm::notify(new BusinessException('食品同步未完全成功，存在部分完成情况', BusinessCode::BUSINESS_ERROR));
        }
        Redis::del($codeResponseCacheKey);
        return $result;
    }
}
