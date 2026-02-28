<?php

namespace app\common\enum;

use app\common\trait\EnumCases;

enum NormalStatus: int
{
    use EnumCases;

    case YES = 1;
    case NO  = 0;

    public function label(): string
    {
        return match ($this) {
            self::YES => '是',
            self::NO => '否',
        };
    }
}
