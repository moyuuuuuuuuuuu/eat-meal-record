<?php

namespace app\common\enum\blog;

use app\common\trait\EnumCases;

enum AttachType: int
{
    use EnumCases;

    /**
     * 图片
     */
    case IMG = 0;
    /**
     * 视频
     */
    case VIDEO = 1;

    /**
     * 食物
     */
    case FOOD = 2;
    /**
     * 食谱
     */
    case REPRICE = 3;
    /**
     * 餐食记录
     */
    case RECORD = 4;
}
