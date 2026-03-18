<?php

namespace app\process;

use app\common\enum\ChannelEventName;
use Webman\Channel\Client;

/**
 * 弃用Channel 因为channel为广播模式 有几个订阅者publish之后就会被执行几次 所以改为队列执行
 * @deprecated
 */
class FoodHealthChannelProcess
{
    public function __construct()
    {
    }

    public function onWorkerStart()
    {
        Client::connect();
        $channels = [
            ChannelEventName::FoodTagSync,
            ChannelEventName::FoodUnitSync,
            ChannelEventName::FoodNutritionSync,
        ];
        /**
         * @var ChannelEventName[] $channels
         */
        foreach ($channels as $channel) {
            Client::on($channel->value, fn($data) => $channel->handlerClass()->run($data));
        }
    }

}
