<?php

namespace app\common\enum;

enum ArticleStatus: int
{
    case Draft     = 0;
    case Publish   = 1;
    case UnPublish = 2;
}
