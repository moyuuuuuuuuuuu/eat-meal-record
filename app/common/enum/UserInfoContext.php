<?php

namespace app\common\enum;

use app\util\Helper;

enum UserInfoContext: string
{
    case UserId   = 'userId';
    case UserInfo = 'userinfo:%d:info';

    case UserInfoStep = 'userinfo:%d:step:%s';

    case UserInfoQuota = 'userinfo:%d:quota:%s';

    case UserInfoTotalToken = 'userinfo:%d:total-token:%s';

    static function userInfoStepCacheKey(int $userId, string $date = null)
    {
        return sprintf(self::UserInfoStep->value, $userId, $date ?? date('Ymd'));
    }

    static function userInfoCacheKey(int $userId)
    {
        return sprintf(self::UserInfo->value, $userId);
    }

    static function userInfoQuotaCacheKey(int $userId, string $date = null)
    {
        return sprintf(self::UserInfoQuota->value, $userId, $date ?? date('Ymd'));
    }

    static function userInfoTotalTokenCacheKey(int $userId, string $date = null)
    {
        return sprintf(self::UserInfoTotalToken->value, $userId, $date ?? date('Ymd'));
    }
}
