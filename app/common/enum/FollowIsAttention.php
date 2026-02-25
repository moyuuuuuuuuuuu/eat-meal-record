<?php

namespace app\common\enum;

use app\common\trait\EnumCases;

enum FollowIsAttention: int
{
    use EnumCases;

    case NO  = 0;
    case YES = 1;
}
