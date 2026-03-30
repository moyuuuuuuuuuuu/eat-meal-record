<?php

namespace app\common\enum;

enum UserInfoContext: string
{
    case UserId   = 'userId';
    case UserInfo = 'userinfo:%d:info';

    case UserInfoStep = 'userinfo:%d:step:%s';

    case UserInfoQuota = 'userinfo:%d:quota:%s';

    case UserInfoTotalToken = 'userinfo:%d:total-token:%s';
    case UserInfoTask       = 'userinfo:%d:task:%s';

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

    static function userInfoTaskCacheKey(int $userId, int|string $taskId = null)
    {
        return sprintf(self::UserInfoTask->value, $userId, $taskId);
    }
}
