<?php

namespace app\common\enum;

use app\service\redisSubscribe\{BaseRedisSubscribe};

enum RedisSubscribeEventName: string
{
    case FoodTagSync  = 'foodTagSync';
    case FoodUnitSync = 'foodUnitSync';

    case FoodNutritionSync = 'foodNutritionSync';
    case SystemErrorNotify = 'systemErrorNotify';

    static function channels(): array
    {
        return array_column(BusinessCode::cases(), 'value');
    }

    public function handlerClass(): BaseRedisSubscribe|null
    {
        $class = ucfirst($this->value);
        $class = "\\app\\service\\redisSubscribe\\" . $class;
        if (!class_exists($class)) return null;
        /**
         * @var BaseRedisSubscribe $class
         */
        return $class::instance();
    }

}
