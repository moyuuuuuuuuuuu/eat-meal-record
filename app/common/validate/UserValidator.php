<?php

namespace app\common\validate;

use app\common\base\BaseValidator;
use app\common\enum\user\Sex;
use support\validation\Rule;

class UserValidator extends BaseValidator
{
    protected array $rules = [
        'nickname'  => 'max:50',
        'avatar'    => 'max:255',
        'sex'       => 'in:1,2,3',
        'signature' => 'max:255',
        'age'       => 'integer|min:0|max:150',
        'tall'      => 'integer|min:0|max:300',
        'weight'    => 'numeric|min:0|max:500',
        'birthday'  => 'date',
    ];

    protected array $messages = [
        'nickname.max'   => '昵称不能超过50个字符',
        'avatar.max'     => '头像地址长度不能超过255个字符',
        'sex.in'         => '性别不合法',
        'signature.max'  => '个性签名不能超过255个字符',
        'age.integer'    => '年龄必须是整数',
        'age.min'        => '年龄不能小于0',
        'age.max'        => '年龄不能大于150',
        'tall.integer'   => '身高必须是整数',
        'tall.min'       => '身高不能小于0',
        'tall.max'       => '身高不能大于300',
        'weight.numeric' => '体重必须是数字',
        'weight.min'     => '体重不能小于0',
        'weight.max'     => '体重不能大于500',
        'birthday.date'  => '生日格式不正确',
    ];

    protected array $scenes = [
        'update' => ['nickname', 'avatar', 'sex', 'signature', 'age', 'tall', 'weight', 'birthday'],
    ];
}
