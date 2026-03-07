<?php

namespace app\common\context;

use app\common\base\BaseModel;
use app\common\enum\user\Sex;
use app\model\UserGoalModel;
use app\model\UserModel;
use app\model\UserStepsModel;
use app\service\wechat\WxMini;
use app\util\Energy;
use app\util\Jwt;
use support\Log;
use Webman\Context;

final class UserInfo
{
    static function setUserInfo(UserModel $userInfo)
    {
        $userInfo->setAppends(['sex_text', 'avatar_text', 'status_text']);
        $userInfo = $userInfo->toArray();
        $goal     = UserGoalModel::query()->where('user_id', $userInfo['id'])->first();
        if (!$goal) {
            // 返回默认值，逻辑参考图片
            $goal = [
                'daily_calories' => 2000,
                'protein'        => 150,
                'fat'            => 55,
                'carbohydrate'   => 225,
                'weight'         => 60.00
            ];
        }
        $userInfo['goal'] = $goal;
        $userInfo         = array_intersect_key($userInfo, array_flip([
            'id',
            'username',
            'nickname',
            'sex',
            'avatar',
            'email',
            'mobile',
            'openid',
            'unionid',
            'signature',
            'background',
            'age',
            'tall',
            'weight',
            'bmi',
            'bust',
            'waist',
            'hip',
            'target',
            'level',
            'birthday',
            'status',
            'sex_text',
            'avatar_text',
            'status_text',
            'created_at',
            'goal'
        ]));

        $token = Jwt::instance()->encode($userInfo, 86400 * 7); // 7天有效期
        return [
            'token'    => $token,
            'userInfo' => $userInfo
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
        Context::set(\app\common\enum\Context::UserId->value, $userInfo->id);
        return $userInfo;
    }

    static function parseUserEncryptData(string $encryptedData, string $sessionKey, string $iv)
    {
        return WxMini::instance()->parseEncryptData($encryptedData, $sessionKey, $iv);
    }

    static function getUserSteps(string $date, $userId): ?int
    {
        $timestamp = strtotime($date);
        $date      = date('Y-m-d', $timestamp);
        return UserStepsModel::query()->where('user_id', $userId)->where('record_date', $date)->value('steps') ?? 0;
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
}
