<?php

namespace app\common\enum;

use app\service\foodHealthCheck\{BaseHealthCheck};

enum ChannelEventName: string
{
    case FoodTagSync  = 'foodTagSync';
    case FoodUnitSync = 'foodUnitSync';

    case FoodNutritionSync = 'foodNutritionSync';
    case SystemErrorNotify = 'systemErrorNotify';

    static function channels(): array
    {
        return array_column(static::cases(), 'value');
    }

    public function handlerClass(): BaseHealthCheck|null
    {
        $class = ucfirst($this->value);
        $class = "\\app\\service\\redisSubscribe\\" . $class;
        if (!class_exists($class)) return null;
        /**
         * @var BaseHealthCheck $class
         */
        return $class::instance();
    }

}
