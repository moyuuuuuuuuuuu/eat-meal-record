<?php

namespace app\common\enum;

enum UserInfoContext: string
{
    case UserId   = 'userId';
    case UserInfo = 'userInfo:';

    case UserInfoSteps = 'userInfo:Step:';
}
