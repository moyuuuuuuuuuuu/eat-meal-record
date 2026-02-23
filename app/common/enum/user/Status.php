<?php

namespace app\common\enum\user;

enum Status: int
{
    case NORMAL = 1;
    case FORBID = 2;

    /**
     * 临时封禁
     */
    case OFF    = 3;
}
