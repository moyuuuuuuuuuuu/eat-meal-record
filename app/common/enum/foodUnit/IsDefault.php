<?php

namespace app\common\enum\foodUnit;

use app\common\trait\EnumCases;

enum IsDefault:int
{
    use EnumCases;
    case NO = 0;
    case YES = 1;
}
