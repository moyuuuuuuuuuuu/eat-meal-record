<?php

namespace app\common\enum;

use app\common\trait\EnumCases;

enum NutritionInputType: string
{

    use EnumCases;

    case IMAGE = 'image';
    case TEXT  = 'text';
    case AUDIO = 'audio';
}
