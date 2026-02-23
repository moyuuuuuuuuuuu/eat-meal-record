<?php

namespace app\queue;


use app\common\base\BaseConsumer;

use app\model\CatModel;
use app\model\FoodModel;
use app\model\FoodUnitModel;
use app\model\UnitModel;
use app\service\MailService;
use support\Db;
use support\Log;

/**
 * 从三方获取的数据同步到本地
 * 注意：
 * 1、三方返回的单位格式是“数量 单位名称”
 * 2、weight不一定是100g 需要处理成100g
 * 3、nutrition返回的是{name:key,value:value}而食品表存储的是{key:value,key1:value1}
 */
class RemoteFoodSyncJob extends BaseConsumer
{
    public $queue = 'remote_food_sync';

    public function consume($data)
    {
        /**
         * {
         * "foods": [
         * {
         * "name": "米饭",
         * "unit": "2 碗",
         * "weight": "300g",
         * "nutrition": [
         * {
         * "name": "protein",
         * "value": 7.8
         * },
         * ...
         * ]
         * },]}
         */
        $foodList = $data['foods'] ?? [];
        $newItems = ['foods' => [], 'units' => []];

        foreach ($foodList as $item) {
            Db::transaction(function () use ($item, &$newItems) {
                // 1. 解析单位 (例如 "2 碗")
                $unitStr = $item['unit'] ?? '1 份';
                $unitArr = explode(' ', trim($unitStr));
                $unitNum = (float)($unitArr[0] ?? 1);
                $unitName = $unitArr[1] ?? '份';

                // 2. 解析当前总重量 (例如 "300g")
                $totalWeightStr = $item['weight'] ?? '100g';
                $totalWeight = (float)preg_replace('/[^0-9.]/', '', $totalWeightStr);
                if ($totalWeight <= 0) $totalWeight = 100;

                // 3. 转换营养成分为本地格式 {key: value}，并换算为每 100g 的含量
                // 计算比例：100 / 当前总重量
                $ratio = bcdiv('100', (string)$totalWeight, 10);
                $localNutrition = [];
                foreach ($item['nutrition'] as $nut) {
                    $key = $nut['name'];
                    $val = (string)$nut['value'];
                    // 换算为每 100g 的值
                    $localNutrition[$key] = (float)bcmul($val, $ratio, 2);
                }

                // 4. 获取或创建单位
                $unit = UnitModel::where('name', $unitName)->first();
                if (!$unit) {
                    $unit = UnitModel::create([
                        'name' => $unitName,
                        'type' => 'count'
                    ]);
                    $newItems['units'][] = $unitName;
                }

                // 5. 获取或创建食品 (使用默认分类，如果没有则创建一个“其他”分类)
                $catId = CatModel::where('name', '其他')->value('id');
                if (!$catId) {
                    $catId = CatModel::insertGetId(['name' => '其他', 'pid' => 0, 'sort' => 100]);
                }

                $food = FoodModel::where('name', $item['name'])->first();
                if (!$food) {
                    $food = FoodModel::create([
                        'name' => $item['name'],
                        'cat_id' => $catId,
                        'nutrition' => $localNutrition,
                        'status' => 1
                    ]);
                    $newItems['foods'][] = $item['name'];
                } else {
                    $food->update([
                        'cat_id' => $catId,
                        'nutrition' => $localNutrition,
                        'status' => 1
                    ]);
                }

                // 6. 维护食物单位换算关系 (1 单位 = ? 克)
                // 1 单位重量 = 总重量 / 单位数量
                $singleUnitWeight = bcdiv((string)$totalWeight, (string)$unitNum, 2);
                FoodUnitModel::updateOrCreate(
                    ['food_id' => $food->id, 'unit_id' => $unit->id],
                    ['weight' => $singleUnitWeight, 'is_default' => 0]
                );
            });
        }

        // 7. 发送邮件通知
        if (!empty($newItems['foods']) || !empty($newItems['units'])) {
            try {
                $subject = '【同步提醒】有新的食品或单位新增';
                $content = "您好，系统在三方同步过程中发现了以下新增项：\n\n";
                if (!empty($newItems['foods'])) {
                    $content .= "新增食品：" . implode('、', array_unique($newItems['foods'])) . "\n";
                }
                if (!empty($newItems['units'])) {
                    $content .= "新增单位：" . implode('、', array_unique($newItems['units'])) . "\n";
                }
                $content .= "\n同步时间：" . date('Y-m-d H:i:s');
                
                MailService::sendText($subject, $content);
            } catch (\Throwable $e) {
                Log::error('邮件发送失败：' . $e->getMessage());
            }
        }
    }
}
