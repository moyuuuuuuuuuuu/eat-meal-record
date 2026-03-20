<?php

namespace app\common\context;

use app\common\enum\UserInfoContext;
use app\model\UserModel;
use app\model\UserStepsModel;
use app\service\wechat\WxMini;
use app\util\Energy;
use app\util\Helper;
use app\util\Jwt;
use support\Redis;
use Webman\Context;

final class UserInfo
{
    static function setUserInfo(UserModel $userInfo)
    {
        $userId       = $userInfo->id;
        $userInfoData = (new UserInfoData());
        $userInfoData->refreshUserInfo($userInfo);
        $token        = Jwt::instance()->encode([
            'id' => $userId,
        ], 86400 * 7); // 7天有效期
        return [
            'token'    => $token,
            'userInfo' => $userInfoData->toArray(),
        ];
    }

    /**
     * @param \support\Request|null $request
     * @return UserInfoData|null
     */
    static function getUserInfo(): ?UserInfoData
    {
        $request = request();
        // 优先从 request 对象获取中间件已解析好的数据
        if ($request && isset($request->userInfo)) {
            return $request->userInfo;
        }

        $token = $request ? $request->header('Authorization') : null;
        if (!$token) {
            return null;
        }

        // 兼容 "Bearer " 前缀
        if (str_starts_with($token, 'Bearer ')) {
            $token = substr($token, 7);
        }
        $userInfo = Jwt::instance()->decode($token);
        if (!$userInfo) {
            return null;
        }
        Context::set(UserInfoContext::UserId->value, $userInfo->id);
        $request->userInfo = $userInfo;
        return $userInfo;
    }

    static function information($userInfo)
    {
        return [];
    }

    static function parseUserEncryptData(string $encryptedData, string $sessionKey, string $iv)
    {
        return WxMini::instance()->parseEncryptData($encryptedData, $sessionKey, $iv);
    }

    static function getUserSteps(string $date, $userId): ?int
    {
        $stepCacheKey = UserInfoContext::userInfoStepCacheKey($userId);
        $step         = Redis::get($stepCacheKey);
        if ($step) {
            return $step;
        }
        $timestamp = strtotime($date);
        $date      = date('Y-m-d', $timestamp);
        $step      = UserStepsModel::query()->where('user_id', $userId)->where('record_date', $date)->value('steps') ?? 0;
        Redis::set($stepCacheKey, $step, Helper::todayEndTimestamp());
        return $step;
    }

    static function getUserBurned(string $date, ?UserInfoData $userInfo)
    {
        if (!$userInfo) {
            return 0;
        }
        $step     = self::getUserSteps($date, $userInfo->id);
        $userInfo = UserModel::query()->select('sex', 'weight', 'tall')->where('id', $userInfo->id)->first();

        return Energy::runningBurn(
            $userInfo->sex,
            $userInfo->weight,
            $userInfo->tall,
            $step
        );
    }

    static function clearRemoteUserInfo(int $userId)
    {
        Redis::del(UserInfoContext::userInfoCacheKey($userId));
    }

}
