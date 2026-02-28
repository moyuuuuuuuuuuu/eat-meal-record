<?php

namespace app\common\enum;

use app\common\trait\EnumCases;

enum LikeFavType: int
{
    use EnumCases;

    case BLOG    = 1; // 动态
    case FOOD    = 2; // 食物
    case REPRICE = 3; // 食谱

    public function label(): string
    {
        return match ($this) {
            self::BLOG => '动态',
            self::FOOD => '食物',
            self::REPRICE => '食谱',
        };
    }
}
