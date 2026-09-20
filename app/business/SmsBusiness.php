<?php

namespace app\business;

use app\common\base\BaseBusiness;
use support\Cache;

class SmsBusiness extends BaseBusiness
{
    /**
     * 发送验证码
     * @param string $mobile
     * @return bool
     * @throws \RuntimeException
     */
    public function send(string $mobile): bool
    {
        // 尚未接入短信服务，不能生成无法送达的验证码或误报发送成功。
        throw new \RuntimeException('短信登录暂不可用，请使用微信小程序登录');
    }

    /**
     * 校验验证码
     * @param string $mobile
     * @param string $code
     * @return bool
     */
    public function check(string $mobile, string $code): bool
    {
        if (config('app.debug') === true && $code === '123123') {
            return true;
        }
        $cacheKey  = "sms_code:{$mobile}";
        $savedCode = Cache::get($cacheKey);
        if ($savedCode && $savedCode == $code) {
            Cache::delete($cacheKey);
            return true;
        }
        return false;
    }
}
