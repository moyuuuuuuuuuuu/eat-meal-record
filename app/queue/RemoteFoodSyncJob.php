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
use app\service\FoodService;
use app\util\Calculate;
use support\Db;
use support\Log;
use support\Redis;
use Webman\RedisQueue\Consumer;
use Workerman\Coroutine\Parallel;

/**
 * 当用户查询到不存在的食物时从薄荷健康获取食物名称 然后交给模型去获取食品具体信息并落地到数据库
 */
class RemoteFoodSyncJob implements Consumer
{
    public        $queue       = 'remoteFoodSync';
    public        $connection  = 'default';
    private array $typeMapping = [
        '餐次'     => 1, '口味' => 2, '营养' => 3, '营养特点' => 3,
        '烹饪方式' => 4, '适用人群' => 5, '食材状态' => 6,
        '过敏原'   => 7, '品牌产地' => 8, '时令季节' => 9,
        '特殊场景' => 10, '存储方式' => 11
    ];

    public function consume($data)
    {
        try {

            Log::info('队列来了', $data);
            $name = $data['foodName'] ?? null;
            if (!$name) {
                Alarm::notify(new BusinessException('空字符串调用食品查询接口', BusinessCode::BUSINESS_ERROR));
                return;
            } else if (!BooHee::instance()->canUse()) {
                Alarm::notify(new BusinessException('薄荷健康调用次数达到上限', BusinessCode::THREE_PART_ERROR));
                return;
            }
            echo '队列接收到为查询到的食物' . $name . PHP_EOL;
            $booheeResponseCacheKey = 'boohee:response:' . date('Ymd') . ':' . $name;
            $booheeNameList         = Redis::get($booheeResponseCacheKey);
            if ($booheeNameList) {
                $booheeNameList = json_decode($booheeNameList, true);
            } else {
                $booheeNameList = BooHee::instance()->search($name);
                if (!$booheeNameList) {
                    Alarm::notify(new BusinessException('薄荷健康为返回食品信息', BusinessCode::THREE_PART_ERROR));
                    return;
                }
                Redis::setEx($booheeResponseCacheKey, 600, json_encode($booheeNameList));
            }
            $foodNameList = array_column($booheeNameList, 'name');

            $foodNameList = array_chunk($foodNameList, 10);

            $parallel = new Parallel();
            foreach ($foodNameList as $foodNameItem) {
                $parallel->add(function () use ($foodNameItem) {
                    $this->sync($foodNameItem);
                });
            }

            $result = $parallel->wait();
            Log::info('同步食物成功', $result);
            Redis::del($booheeResponseCacheKey);
            $exceptionList = $parallel->getExceptions();
            foreach ($exceptionList as $exception) {
                Log::error('食品同步队列异常', [$exception]);
                Alarm::notify($exception);
            }
        } catch (\Exception $e) {
            Log::error($e->getMessage(), [$e]);
            Alarm::notify($e);
        }
    }

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
        $codeResponseCacheKey = 'coze:response:' . date('Ymd') . ':' . md5(json_encode($foodNameItem));
        $foodNutritionList    = Redis::get($codeResponseCacheKey);
        if ($foodNutritionList) {
            $foodNutritionList = json_decode($foodNutritionList, true);
        } else {
            $foodNutritionList = FoodService::nutritionForFood($foodNameItem);
            Redis::set($codeResponseCacheKey, json_encode($foodNutritionList));
            Redis::setEx($codeResponseCacheKey, 600, json_encode($foodNutritionList));
        }
        if (empty($foodNutritionList)) {
            Redis::del($codeResponseCacheKey);
            return [];
        }
        /**
         * [{"cat":"五谷","is_common":1,"is_ingredient":2,"name":"八宝粥","nutrition":[{"name":"kcal","value":68.0},{"name":"pro","value":2.4},{"name":"fat","value":0.3},{"name":"carb","value":14.7},{"name":"fiber","value":1.2},{"name":"vit_c","value":2.0},{"name":"mag","value":17.0},{"name":"folic","value":12.0},{"name":"cal","value":7.0},{"name":"iron","value":0.5},{"name":"vit_e","value":0.12}],"tags":{"口味":"甜","推荐餐次":"早餐、加餐","特性":"易消化、中等热量"},"units":[{"is_default":1,"name":"罐","type":"package","weight":360},{"is_default":0,"name":"碗","type":"service","weight":250}]},{"cat":"五谷","is_common":2,"is_ingredient":2,"name":"壮馍","nutrition":[{"name":"kcal","value":280.0},{"name":"pro","value":8.0},{"name":"fat","value":10.0},{"name":"carb","value":38.0},{"name":"fiber","value":1.5},{"name":"vit_c","value":0.0},{"name":"mag","value":25.0},{"name":"folic","value":15.0},{"name":"cal","value":30.0},{"name":"iron","value":1.2},{"name":"vit_e","value":0.8}],"tags":{"口味":"咸香","推荐餐次":"午餐、晚餐","特性":"高热量、饱腹感强"},"units":[{"is_default":1,"name":"个","type":"count","weight":500}]}]
         */
        $result = [];
        foreach ($foodNutritionList as $item) {
            $foodName = $item['name'] ?? null;
            if (!$foodName) {
                continue;
            }

            $foodId   = Db::transaction(function () use ($item) {

                $localNutrition = [];
                foreach ($item['nutrition'] as $nut) {
                    $key                  = $nut['name'];
                    $val                  = (string)($nut['value'] ?? 0);
                    $localNutrition[$key] = (float)Calculate::mul($val, 1, 2);
                }

                // 维护数据关系
                $catName = $item['cat'] ?? '其他';
                $catId   = CatModel::where('name', $catName)->value('id') ?:
                    CatModel::insertGetId(['name' => $catName, 'pid' => 0, 'sort' => 100]);

                $food = FoodModel::updateOrCreate(
                    ['name' => $item['name']],
                    ['cat_id' => $catId, 'status' => 1, 'is_common' => $item['is_common'] ?? 2, 'is_ingredient' => $item['is_ingredient'] ?? 2]
                );

                FoodNutrientModel::updateOrCreate(['food_id' => $food->id], $localNutrition);
                foreach ($item['units'] as $unit) {
                    $unit = UnitModel::firstOrCreate(['name' => $unit['name']], ['type' => $unit['type']]);
                    FoodUnitModel::updateOrCreate(
                        ['food_id' => $food->id, 'unit_id' => $unit->id],
                        ['weight' => $unit['weight'], 'is_default' => $unit['is_default']]
                    );
                }
                $tags = $item['tags'] ?? [];
                foreach ($tags as $tagName => $typeName) {
                    $typeId = $this->typeMapping[$tagName] ?? 3;
                    try {
                        $tagModel = TagModel::where('name', $typeName)->where('type', $typeId)->first();
                        if (!$tagModel) {
                            $tagModel = TagModel::create([
                                'name'      => $tagName,
                                'type'      => $typeId,
                                'meta_type' => $typeName
                            ]);
                        }

                        FoodTagModel::firstOrCreate([
                            'food_id' => $food->id,
                            'tag_id'  => $tagModel->id
                        ]);
                    } catch (\Illuminate\Database\QueryException $e) {
                        if ($e->getCode() == 23000) {
                            $tagModel = TagModel::where('name', $tagName)->where('type', $typeId)->first();
                            if ($tagModel) {
                                FoodTagModel::firstOrCreate(['food_id' => $food->id, 'tag_id' => $tagModel->id]);
                            }
                        } else {
                            throw $e;
                        }
                    }
                }
                return $food->id;
            });
            $result[] = $foodId;
        }

        Redis::del($codeResponseCacheKey);
        return $result;
    }
}
