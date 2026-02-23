<?php

namespace app\common\context;

use app\model\UserModel;
use app\util\Jwt;

final class UserInfo
{

    static function setUserInfo(UserModel $userInfo)
    {
        $userInfo->setAppends(['sex_text', 'avatar_text', 'status_text']);
        $userInfo = $userInfo->only([
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
            'status_text'
        ]);
        $token    = Jwt::encode($userInfo, 86400 * 7); // 7天有效期
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
        // 优先从 request 对象获取中间件已解析好的数据
        if ($request = request()) {
            if (isset($request->userInfo)) {
                return $request->userInfo;
            }
        }

        $token = $request ? $request->header('Authorization') : null;
        if (!$token) {
            return null;
        }

        // 兼容 "Bearer " 前缀
        if (str_starts_with($token, 'Bearer ')) {
            $token = substr($token, 7);
        }
        return Jwt::decode($token);
    }
}
