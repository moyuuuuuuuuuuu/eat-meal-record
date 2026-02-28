<?php

namespace app\common\enum;

use app\common\trait\EnumCases;

/**
 * 类型 1 早餐 2 午餐 3 晚餐 4加餐
 */
enum MealRecordType: int
{
    use EnumCases;

    /**
     * 早餐
     */
    case BREAK_FIRST = 1;

    /**
     * 午餐
     */
    case LUNCH = 2;
    /**
     * 晚餐
     */
    case DINNER = 3;

    /**
     * 加餐
     */
    case OTHER = 4;

    public function label(): string
    {
        return match ($this) {
            self::BREAK_FIRST => '早餐',
            self::LUNCH => '午餐',
            self::DINNER => '晚餐',
            self::OTHER => '加餐',
        };
    }
}
