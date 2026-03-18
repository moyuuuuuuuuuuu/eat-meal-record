<?php

namespace app\process;

use app\common\enum\ChannelEventName;
use Webman\Channel\Client;

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
        foreach ($channels as $channel) {
            Client::on($channel->value, fn($data) => $channel->handlerClass()->run($data));
        }
    }

}
