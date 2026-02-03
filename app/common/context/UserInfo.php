<?php

namespace app\common\context;

use app\model\UserModel;
use app\util\Jwt;

class UserInfo
{

    static function setUserInfo(UserModel $userInfo)
    {
        // 生成 JWT Token
        return Jwt::encode([
            'id'     => $userInfo->id,
            'openid' => $userInfo->openid,
        ], 86400 * 7); // 7天有效期
    }

    /**
     * @param string $token
     * @return object{
     *     id:int,
     *     openid:string
     * }|null
     */
    static function getUserInfo()
    {
        // 优先从 request 对象获取中间件已解析好的数据
        if ($request = request()) {
            if (isset($request->userInfo)) {
                return $request->userInfo;
            }
        }

        $token = request()->header('Authorization');
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
