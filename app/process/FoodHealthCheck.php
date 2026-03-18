<?php

namespace app\process;

use app\common\enum\ChannelEventName;
use app\model\FoodModel;
use Channel\Client;
use support\Log;
use Workerman\Crontab\Crontab;

class FoodHealthCheck
{
    public function onWorkerStart($worker)
    {
        Client::connect();
        #每周日 凌晨2、3、4点钟检测食品营养、标签、单位等
        new Crontab('0 2 * * 0', fn() => $this->check('nutrients', ChannelEventName::FoodNutritionSync));
        new Crontab('0 3 * * 0', fn() => $this->check('units', ChannelEventName::FoodUnitSync));
        new Crontab('0 4 * * 0', fn() => $this->check('tags', ChannelEventName::FoodTagSync));
    }

    /**
     * 通用检测逻辑
     * @param string $relation 关联名称 (需在 FoodModel 中定义)
     * @param ChannelEventName $event 发布的事件枚举
     */
    private function check(string $relation, ChannelEventName $event)
    {
        Log::info("开始检查缺失[{$relation}]的食品");

        $count = 0;
        FoodModel::query()
            ->whereDoesntHave($relation)
            ->select('id', 'name')
            ->chunk(50, function ($foods) use ($event, &$count) {
                $names = $foods->pluck('name')->toArray();
                Client::publish($event->value, $names);
                $count += count($names);
            });

        Log::info("检查完成，共计推送 {$count} 条记录至 {$event->value}");
    }
}
