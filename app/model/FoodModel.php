<?php

namespace app\model;


use app\queue\InsertRemoteFoodQueue;
use app\service\nutrition\Nutrition;
use plugin\admin\app\model\Food;
use support\Db;
use support\Log;
use Webman\RedisQueue\Client;

class FoodModel extends BaseModel
{
    const STATUS_NORMAL  = 1;
    const STATUS_DISABLE = 2;

    /**
     * 从第三方获取食物信息并添加到数据库
     * @param string $name 食物名称
     * @param int $page 页码
     * @return bool
     */
    protected $table   = 'food';
    protected $guarded = ['id'];

    public function nutrition()
    {
        return $this->hasMany(FoodNutrition::class, 'food_id', 'id')->with(['unit']);
    }

    /**
     * 添加第三方食物到本地
     * @param array $foodList
     * @return array|bool
     */
    static function insertRemoteFood(array $foodList)
    {
        Log::info('测试', ['foodList' => $foodList]);
        $currentDateTime         = date('Y-m-d H:i:s');
        $foodNutritionInsertList = $categoryList = $foodInsertList = [];
        foreach ($foodList as $item) {
            if ($item['type'] === '未知结果') {
                continue;
            }
            if (!in_array($item['type'], $categoryList)) {
                $categoryList[] = $item['type'];
            }
            $foodInsertList[$item['type']][] = [
                'name'       => $item['name'],
                'kal'        => $item['rl'],
                'status'     => self::STATUS_NORMAL,
                'created_at' => $currentDateTime,
                'updated_at' => $currentDateTime,
            ];

            $foodNutritionInsertList[$item['name']][] = [
                'unit_id'    => 1,
                'number'     => 100,
                'kal'        => $item['rl'],
                'fat'        => $item['zf'],
                'protein'    => $item['dbz'],
                'carbo'      => $item['shhf'],
                'desc'       => '每100g含量',
                'created_at' => $currentDateTime,
                'updated_at' => $currentDateTime,
            ];
        }
        Db::beginTransaction();
        try {
            $foodCatIdRelation = [];
            foreach ($categoryList as $catName) {
                $foodCatInfo = FoodCatModel::where('name', $catName)->first();
                if (!$foodCatInfo) {
                    $foodCatInfo = FoodCatModel::create([
                        'name' => $catName
                    ]);
                }
                $foodCatIdRelation[$catName] = $foodCatInfo->id;
            }
            $saveAll = [];
            foreach ($foodInsertList as $catName => $item) {
                foreach ($item as $key => $value) {
                    if ($value) {
                        $value['cat_id'] = $foodCatIdRelation[$catName] ?? 0;
                        if (!Food::where('name', $value['name'])->first()) {
                            $saveAll[] = $value;
                        }
                    }
                }
            }
            unset($foodInsertList, $foodCatIdRelation, $foodCatInfo, $categoryList);
            if ($saveAll && !Food::insert($saveAll)) {
                throw new \Exception('添加食物失败');
            }
            $foodNameList = array_keys($foodNutritionInsertList);
            $foodIdList   = Food::whereIn('name', $foodNameList)->pluck('id', 'name');
            $saveAll      = [];
            foreach ($foodNutritionInsertList as $foodName => $item) {
                foreach ($item as $key => $value) {
                    if (!$value) {
                        continue;
                    }

                    $value['food_id'] = $foodIdList[$foodName] ?? 0;
                    if (!$value['food_id']) {
                        continue;
                    }

                    if (!FoodNutrition::where('food_id', $value['food_id'])->where('unit_id', $value['unit_id'])->first()) {
                        $saveAll[] = $value;
                    }
                }
            }
            if ($saveAll && !FoodNutrition::insert($saveAll)) {
                throw new \Exception('添加食物营养信息失败');
            }
            Db::commit();
            return $foodIdList->toArray();
        } catch (\Exception $e) {
            Log::error('添加从远端获取的食物信息失败', ['error' => $e->getMessage(), 'trace' => $e->getTrace()]);
            Db::rollBack();
            return false;
        }
    }

    static function searchRemoteFoodByName(string $name, int $page = 1, int $limit = 20)
    {

        try {
            $foodList = Nutrition::getInstance()->search($name, $page, $limit);
        } catch (\Exception $e) {
            Log::error('获取食物信息失败', ['name' => $name, 'page' => $page, 'error' => $e->getMessage()]);
            return false;
        }
        if (count($foodList) >= $limit) {
            Client::send(InsertRemoteFoodQueue::QUEUE_NAME, ['name' => $name, 'page' => $page + 1, 'limit' => 20]);
        }
        return self::insertRemoteFood($foodList);
    }

    static function searchRemoteFoodByImageContent(string $imageContent)
    {
        try {
            $foodList = Nutrition::getInstance()->image($imageContent, false);
        } catch (\Exception $e) {
            Log::error('获取食物信息失败', ['error' => $e->getMessage(), 'trace' => $e->getTrace()]);
            return false;
        }
        return self::insertRemoteFood($foodList);

    }

    static function getListByName(string $name, array $field = [], int $page = 1, int $limit = 100, string $sort = 'id desc')
    {

        $query = self::query();
        $query->where('name', $name);
        if (!empty($field)) {
            $query->select($field);
        }
        $query->order($sort);
        return $query->limit($limit)->offset($page)->get();
    }

}
