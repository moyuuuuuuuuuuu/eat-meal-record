<?php

namespace app\model;

use app\common\base\BaseModel;
use app\util\Jwt;

class UserModel extends BaseModel
{

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'wa_users';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';

    static function getUserInfo(){
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
        if (strpos($token, 'Bearer ') === 0) {
            $token = substr($token, 7);
        }

        return Jwt::decode($token);
    }

}
