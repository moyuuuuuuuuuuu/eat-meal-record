<?php

namespace app\common\validate;

use app\common\base\BaseValidator;

class LocationValidator extends BaseValidator
{
    protected array $rules = [
        'latitude'  => 'required|numeric',
        'longitude' => 'required|numeric',
    ];

    protected array $messages = [
        'latitude.required'  => '纬度不能为空',
        'latitude.numeric'    => '纬度格式不正确',
        'longitude.required' => '经度不能为空',
        'longitude.numeric'   => '经度格式不正确',
    ];

    protected array $scenes = [
        'rgeo' => ['latitude', 'longitude'],
    ];
}
