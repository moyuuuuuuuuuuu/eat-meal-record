<?php

namespace app\common\enum;

use app\common\trait\EnumCases;

enum NutritionInputType: string
{

    use EnumCases;

    case IMAGE = 'image';
    case TEXT  = 'text';
    case AUDIO = 'audio';

    public function label(): string
    {
        return match ($this) {
            self::IMAGE => '图片',
            self::TEXT => '文字',
            self::AUDIO => '语音',
        };
    }
}
