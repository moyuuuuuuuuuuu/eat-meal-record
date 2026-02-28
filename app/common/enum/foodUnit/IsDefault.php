<?php

namespace app\common\enum\foodUnit;

use app\common\trait\EnumCases;

enum IsDefault:int
{
    use EnumCases;
    case NO = 0;
    case YES = 1;

    public function label(): string
    {
        return match ($this) {
            self::NO => '否',
            self::YES => '是',
        };
    }
}
