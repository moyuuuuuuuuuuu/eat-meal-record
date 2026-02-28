<?php

namespace app\common\enum\user;

enum Status: int
{
    case NORMAL = 1;
    case FORBID = 2;

    /**
     * 临时封禁
     */
    case OFF = 3;

    public function label(): string
    {
        return match ($this) {
            self::NORMAL => '正常',
            self::FORBID => '封禁',
            self::OFF => '临时封禁',
        };
    }
}
