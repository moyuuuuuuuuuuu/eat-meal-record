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
