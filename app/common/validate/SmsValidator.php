<?php

namespace app\common\validate;

use app\common\base\BaseValidator;

class SmsValidator extends BaseValidator
{
    protected array $messages = [
        'mobile.required' => '请输入手机号',
        'mobile.regex'    => '手机号格式不正确',
    ];
    protected array $rule     = [
        'mobile' => ['required', 'regex:/^1[3456789]\d{9}$/'],
    ];
    protected array $scenes   = [
        'send' => ['mobile'],
    ];
}
