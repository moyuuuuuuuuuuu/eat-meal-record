<?php

namespace app\common\enum;

enum NutritionInputType: string
{
    case IMAGE = 'image';
    case TEXT  = 'text';
    case AUDIO = 'audio';
}
