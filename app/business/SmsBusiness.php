<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\validate\SmsValidator;
use support\Cache;
use app\common\exception\BusinessException;
use Webman\Validation\Annotation\Validate;

class SmsBusiness extends BaseBusiness
{
    /**
     * 发送验证码
     * @param string $mobile
     * @return bool
     * @throws \Exception
     */
    #[Validate(validator: SmsValidator::class, scene: 'send')]
    public function send(string $mobile): bool
    {
        $cacheKey = "sms_code:{$mobile}";
        $limitKey = "sms_limit:{$mobile}";

        // 1. 频率限制 (60秒内只能发一次)
        if (Cache::get($limitKey)) {
            throw new \Exception('发送过于频繁，请稍后再试');
        }

        // 2. 生成验证码
        $code = (string)mt_rand(100000, 999999);

        // 3. 模拟发送逻辑 (实际项目中对接第三方SDK)
        // Log::info("发送短信验证码: {$mobile} - {$code}");

        // 4. 存储验证码 (有效期5分钟)
        Cache::set($cacheKey, $code, 300);
        // 设置频率限制
        Cache::set($limitKey, 1, 60);

        return true;
    }

    /**
     * 校验验证码
     * @param string $mobile
     * @param string $code
     * @return bool
     */
    public function check(string $mobile, string $code): bool
    {
        if (getenv('APP_DEBUG') && $code == 123123) {
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
