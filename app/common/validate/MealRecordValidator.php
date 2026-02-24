<?php

namespace app\common\validate;

use app\common\enum\MealRecordType;
use support\validation\{Rule, Validator};

class MealRecordValidator extends Validator
{

    protected array $messages = [
        'type.required'              => '饮食类型不能为空',
        'type.in'                    => '饮食类型不合法',
        'nutrition.array'            => '营养信息格式不正确',
        'latitude.numeric'           => '纬度必须是数字',
        'longitude.numeric'          => '经度必须是数字',
        'address.string'             => '地址必须是字符串',
        'foods.required'             => '饮食项目不能为空',
        'foods.array'                => '饮食项目格式不正确',
        'foods.*.food_id.required'   => '食物ID不能为空',
        'foods.*.food_id.integer'    => '食物ID必须是整数',
        'foods.*.food_id.min'        => '食物ID不合法',
        'foods.*.unit_id.required'   => '单位ID不能为空',
        'foods.*.unit_id.integer'    => '单位ID必须是整数',
        'foods.*.unit_id.min'        => '单位ID不合法',
        'foods.*.number.required'    => '数量不能为空',
        'foods.*.number.integer'     => '数量必须是整数',
        'foods.*.number.min'         => '数量不能小于1',
        'foods.*.nutrition.required' => '项目营养信息不能为空',
        'foods.*.nutrition.array'    => '项目营养信息格式不正确',
    ];

    public function rules(): array
    {
        $this->rule = [
            'type'                => ['required', Rule::in(MealRecordType::values())],
            'nutrition'           => ['nullable', 'array'],
            'latitude'            => ['nullable', 'numeric'],
            'longitude'           => ['nullable', 'numeric'],
            'address'             => ['nullable', 'string'],
            'foods'               => ['required', 'array'],
            'foods.*.food_id'     => ['required', 'integer', 'min:1'],
            'foods.*.unit_id'     => ['required', 'integer', 'min:1'],
            'foods.*.number'      => ['required', 'integer', 'min:1'],
            'foods.*.nutrition'   => ['required', 'array'],
            // 删除食物场景
            'meal_record_food_id' => ['required', 'integer', 'min:1'],
        ];
        return parent::rules();
    }

    protected array $scenes = [
        'create' => ['type', 'nutrition', 'latitude', 'longitude', 'address', 'foods'],
        'delete' => ['meal_record_food_id'],
    ];
}
