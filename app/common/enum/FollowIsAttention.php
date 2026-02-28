<?php

namespace app\common\enum;

use app\common\trait\EnumCases;

enum FollowIsAttention: int
{
    use EnumCases;

    case NO  = 0;
    case YES = 1;

    public function label(): string
    {
        return match ($this) {
            self::NO => '否',
            self::YES => '是',
        };
    }
}
