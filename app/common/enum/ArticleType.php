<?php

namespace app\common\enum;

enum ArticleType: int
{
    case UserAgreement = 1;
    case Notice        = 2;
    case Other         = 3;
}
