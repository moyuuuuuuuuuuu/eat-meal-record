<?php

namespace app\common\enum;

use app\service\redisSubscribe\{BaseFoodSync};

enum RedisSubscribe: string
{
    case FoodTagSync  = 'foodTagSync';
    case FoodUnitSync = 'foodUnitSync';

    case FoodNutritionSync = 'foodNutritionSync';

    static function channels(): array
    {
        return [
            self::FoodTagSync->value,
            self::FoodNutritionSync->value,
            self::FoodUnitSync->value,
        ];
    }

    public function handlerClass(): BaseFoodSync|null
    {
        $class = ucfirst($this->value);
        $class = "\\app\\service\\redisSubscribe\\" . $class;
        if (!class_exists($class)) return null;
        /**
         * @var BaseFoodSync $class
         */
        return $class::instance();
    }

}
