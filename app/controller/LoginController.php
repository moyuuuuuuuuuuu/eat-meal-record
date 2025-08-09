<?php

namespace app\controller;

use app\controller\BaseController;
use app\model\UserModel;
use app\service\Jwt;
use app\service\sms\Sms;
use app\service\wechat\WxMini;
use support\Cache;
use support\Request;

class LoginController extends BaseController
{
    public function sendSms(Request $request)
    {
        try {

            $ip = $request->getRemoteIp();
            if (Cache::has("sms_ip_{$ip}")) {
                return $this->error(1006, '短信发送频率过快');
            }
            Cache::set("sms_ip_{$ip}", 1, 60);
            $phone = $request->post('phoneNumber');
            if (!$phone) {
                return $this->error(1001, '请输入手机号');
            }
            if (!preg_match('/^1[3456789]\d{9}$/', $phone)) {
                return $this->error(1002, '手机号格式错误');
            }
            $sms  = new \app\service\sms\Sms($phone);
            $code = rand(1000, 9999);
            $sms->setPhoneNumber($phone)->setTemplet(Sms::LOGIN_TEMPLET_CODE)->setTempletParams(['code' => $code])->send();
            Cache::set("sms_code_{$phone}", $code, 60 * 5);
            return $this->success('短信发送成功');
        } catch (\Exception $e) {
            return $this->error($e->getCode(), $e->getMessage(), $e->getTrace());
        }
    }

    public function sms(Request $request)
    {
        $phone = $request->post('phone');
        $code  = $request->post('code');
        if (!$phone) {
            return $this->error(1001, '请输入手机号');
        }
        if (!$code) {
            return $this->error(1002, '请输入验证码');
        }
        if (!Cache::has("sms_code_{$phone}")) {
            return $this->error(1003, '验证码错误');
        }
        $smsCode = Cache::get("sms_code_{$phone}");
        if ($smsCode != $code) {
            return $this->error(1004, '验证码错误');
        }
        Cache::delete("sms_code_{$phone}");
        $userInfo = UserModel::where('phone', $phone)->first();
        if (!$userInfo) {
            //创建用户
            $userInfo = UserModel::createUser([
                'phone' => $phone,
            ]);
        }
        if ($userInfo->status !== UserModel::STATUS_NORMAL) {
            return $this->error(1005, '用户已被禁用');
        }
        return $this->success('', UserModel::login($userInfo));
    }

    public function wechat(Request $request)
    {
        $code          = $request->post('code', '');
        $encryptedData = $request->post('encryptedData', '');
        $iv            = $request->post('iv', '');
        if (!$code) {
            return $this->error(1001, '缺少参数');
        }
        try {
            $jscode2Session = WxMini::getInstance()->jsCode2Session($code);
            $openId         = $jscode2Session['openId'];
            $sessionKey     = $jscode2Session['sessionKey'];
            $unoinId        = $jscode2Session['unionId'] ?? null;
        } catch (\Exception $e) {
            return $this->error($e->getCode(), $e->getMessage(), $e->getTrace());
        }

        if (!$openId) {
            return $this->error(1006, '微信授权登录失败');
        }
        $parseUserInfo = WxMini::getInstance()->parseEncryptData($encryptedData, $sessionKey, $iv);
        if (!$parseUserInfo) {
            return $this->error(1007, '微信授权登录失败');
        }

        $userInfo = UserModel::where('openid', $openId)->first();
        if (!$userInfo) {
            //创建用户
            $userInfo = UserModel::createUser([
                'openid'  => $openId,
                'unionid' => $unoinId,
                'avatar'  => $parseUserInfo['avatarUrl'] ?? '',
                'name'    => $parseUserInfo['nickName'] ?? '',
            ]);
        }
        if ($userInfo->status !== UserModel::STATUS_NORMAL) {
            return $this->error(1005, '用户已被禁用');
        }
        return $this->success('', UserModel::login($userInfo));
    }

    public function account(Request $request)
    {
        $username = $request->post('username');
        $password = $request->post('password');
        if (!$username) {
            return $this->error(1001, '请输入用户名');
        }
        if (!$password) {
            return $this->error(1002, '请输入密码');
        }
        $user = UserModel::where('username', $username)->first();
        if (!$user) {
            return $this->error(1003, '用户不存在');
        }
        if (!password_verify($password, $user->password)) {
            return $this->error(1004, '密码错误');
        }
        if ($user->status !== UserModel::STATUS_NORMAL) {
            return $this->error(1005, '用户已被禁用');
        }
        return $this->success('', UserModel::login($user));
    }

    public function mp()
    {

    }

    public function refresh(Request $request)
    {
        $token     = $request->input('token', '');
        $tokenInfo = Jwt::decode($token);
        $userId    = $tokenInfo->user_id;
        $userInfo  = UserModel::find($userId);
        if (!$userInfo) {
            return $this->error(1006, '用户不存在');
        }
        if ($userInfo->status !== UserModel::STATUS_NORMAL) {
            return $this->error(1005, '用户已被禁用');
        }
        return $this->success('', UserModel::login($userInfo));
    }
}
