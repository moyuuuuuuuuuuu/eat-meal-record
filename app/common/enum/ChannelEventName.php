<?php

namespace app\common\enum;

use app\service\channelClient\{BaseChannelClient};

enum ChannelEventName: string
{
    case FoodTagSync  = 'foodTagSync';
    case FoodUnitSync = 'foodUnitSync';

//    case FoodNutritionSync = 'foodNutritionSync';
    case SystemErrorNotify = 'systemErrorNotify';

    static function channels(): array
    {
        return array_column(static::cases(), 'value');
    }

    public function handlerClass(): BaseChannelClient|null
    {
        $class = ucfirst($this->value);
        $class = "\\app\\service\\redisSubscribe\\" . $class;
        if (!class_exists($class)) return null;
        /**
         * @var BaseChannelClient $class
         */
        return $class::instance();
    }

}
