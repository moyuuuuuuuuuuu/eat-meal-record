<?php

namespace app\common\validate;

use app\common\base\BaseValidator;

class LoginValidator extends BaseValidator
{
    protected array $rules = [
        'mobile' => 'required|regex:/^1[3456789]\d{9}$/',
        'code'   => 'required|string',
    ];

    protected array $messages = [
        'mobile.required' => '手机号不能为空',
        'mobile.regex'    => '手机号格式不正确',
        'code.required'   => '验证码/授权码不能为空',
        'code.string'     => '验证码/授权码格式不正确',
    ];

    protected array $scenes = [
        'wx'  => ['code'],
        'sms' => ['mobile', 'code'],
    ];
}
