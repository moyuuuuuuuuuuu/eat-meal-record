<?php

namespace app\controller;

use plugin\admin\app\model\User;
use support\Request;
use support\Response;
use app\util\Jwt;

class AuthController extends BaseController
{
    /**
     * 小程序登录
     *
     * @param Request $request
     * @return Response
     */
    public function login(Request $request): Response
    {
        $code = $request->post('code');
        if (!$code) {
            return $this->fail('Code 不能为空');
        }

        $appId = getenv('MP_APPID');
        $secret = getenv('MP_SECRET');

        if (!$appId || !$secret) {
            return $this->fail('小程序配置缺失');
        }

        // 调用微信接口换取 openid
        $url = "https://api.weixin.qq.com/sns/jscode2session?appid={$appId}&secret={$secret}&js_code={$code}&grant_type=authorization_code";

        $response = file_get_contents($url);
        $result = json_decode($response, true);

        if (isset($result['errcode']) && $result['errcode'] != 0) {
            return $this->fail('登录失败: ' . ($result['errmsg'] ?? '未知错误'));
        }

        $openid = $result['openid'];
        $unionid = $result['unionid'] ?? null;

        // 查找或创建用户
        $user = User::where('openid', $openid)->first();
        if (!$user) {
            $user = new User();
            $user->openid = $openid;
            $user->unionid = $unionid;
            $user->username = 'wx_' . substr(md5($openid), 0, 8);
            $user->nickname = '微信用户';
            $user->password = ''; // 小程序用户不需要密码
            $user->join_time = date('Y-m-d H:i:s');
            $user->join_ip = $request->getRealIp();
            $user->status = 0;
            $user->save();
        } else {
            // 更新登录信息
            $user->last_time = date('Y-m-d H:i:s');
            $user->last_ip = $request->getRealIp();
            if ($unionid && !$user->unionid) {
                $user->unionid = $unionid;
            }
            $user->save();
        }

        // 生成 JWT Token
        $token = Jwt::encode([
            'id' => $user->id,
            'openid' => $openid,
        ], 86400 * 7); // 7天有效期

        return $this->success('登录成功', [
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'nickname' => $user->nickname,
                'avatar' => $user->avatar,
            ]
        ]);
    }
}
