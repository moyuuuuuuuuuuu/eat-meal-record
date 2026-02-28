<?php

namespace app\common\validate;

use app\common\base\BaseValidator;

class UserGoalValidator extends BaseValidator
{
    protected array $rules = [
        'daily_calories' => 'required|integer|min:1200|max:3500',
        'protein'        => 'required|integer|min:10|max:300',
        'fat'            => 'required|integer|min:10|max:200',
        'carbohydrate'   => 'required|integer|min:50|max:600',
        'weight'    => 'required|numeric|min:40|max:120',
    ];

    protected array $messages = [
        'daily_calories.required' => '每日热量目标不能为空',
        'daily_calories.integer'  => '每日热量目标必须是整数',
        'daily_calories.min'      => '每日热量目标最低不能小于1200',
        'daily_calories.max'      => '每日热量目标最高不能超过3500',
        'protein.required'        => '蛋白质目标不能为空',
        'protein.integer'         => '蛋白质目标必须是整数',
        'protein.min'             => '蛋白质目标最低不能小于10',
        'protein.max'             => '蛋白质目标最高不能超过300',
        'fat.required'            => '脂肪目标不能为空',
        'fat.integer'             => '脂肪目标必须是整数',
        'fat.min'                 => '脂肪目标最低不能小于10',
        'fat.max'                 => '脂肪目标最高不能超过200',
        'carbohydrate.required'   => '碳水化合物目标不能为空',
        'carbohydrate.integer'    => '碳水化合物目标必须是整数',
        'carbohydrate.min'        => '碳水化合物目标最低不能小于50',
        'carbohydrate.max'        => '碳水化合物目标最高不能超过600',
        'weight.required'    => '体重目标不能为空',
        'weight.numeric'     => '体重目标必须是数字',
        'weight.min'         => '体重目标最低不能小于40',
        'weight.max'         => '体重目标最高不能超过120',
    ];

    protected array $scenes = [
        'save' => ['daily_calories', 'protein', 'fat', 'carbohydrate', 'weight'],
    ];
}
