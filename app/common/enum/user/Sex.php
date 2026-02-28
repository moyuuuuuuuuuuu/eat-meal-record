<?php

namespace app\common\enum\user;
use app\common\trait\EnumCases;

enum Sex: string
{
    use EnumCases;
    case MAN   = '1';
    case WOMEN = '2';
    case NONE  = '3';

    public function label(): string
    {
        return match ($this) {
            self::MAN => '男',
            self::WOMEN => '女',
            self::NONE => '保密',
        };
    }
}
