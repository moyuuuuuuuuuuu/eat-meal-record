<?php

namespace app\common\validate;

use app\common\base\BaseValidator;
use app\common\enum\MealRecordType;
use support\validation\{Rule};

class MealRecordValidator extends BaseValidator
{

    protected array $messages = [
        'type.required'                => '请选择饮食类型',
        'type.in'                      => '饮食类型不合法',
        'nutrition.array'              => '营养成分数据格式不正确',
        'latitude.numeric'             => '纬度格式不正确',
        'longitude.numeric'            => '经度格式不正确',
        'address.string'               => '详细地址必须是字符串',
        'foods.required'               => '请选择饮食项目',
        'foods.array'                  => '饮食项目数据格式不正确',
        'foods.*.food_id.required'     => '食物ID不能为空',
        'foods.*.food_id.integer'      => '食物ID必须是整数',
        'foods.*.food_id.min'          => '食物ID不合法',
        'foods.*.unit_id.required'     => '单位ID不能为空',
        'foods.*.unit_id.integer'      => '单位ID必须是整数',
        'foods.*.unit_id.min'          => '单位ID不合法',
        'foods.*.number.required'      => '数量不能为空',
        'foods.*.number.numeric'       => '数量必须是数字',
        'foods.*.number.min'           => '数量不能小于0.01',
        'foods.*.nutrition.array'      => '饮食项目营养信息格式不正确',
        'meal_record_food_id.required' => '缺少记录ID',
        'meal_record_food_id.integer'  => '记录ID必须是整数',
        'meal_record_food_id.min'      => '记录ID不合法',
    ];

    public function __construct()
    {
        $this->rules = [
            'type'                => ['required', Rule::in(MealRecordType::values())],
            'nutrition'           => ['nullable', 'array'],
            'latitude'            => ['nullable', 'numeric'],
            'longitude'           => ['nullable', 'numeric'],
            'address'             => ['nullable', 'string'],
            'foods'               => ['required', 'array'],
            'foods.*.food_id'     => ['required', 'integer', 'min:1'],
            'foods.*.unit_id'     => ['required', 'integer', 'min:1'],
            'foods.*.number'      => ['required', 'numeric', 'min:0.01'],
            'foods.*.nutrition'   => ['nullable', 'array'],
            // 删除食物场景
            'meal_record_food_id' => ['required', 'integer', 'min:1'],
        ];
    }

    protected array $scenes = [
        'create' => ['type', 'nutrition', 'latitude', 'longitude', 'address', 'foods',
            'foods.*.food_id', 'foods.*.unit_id', 'foods.*.number', 'foods.*.nutrition'],
        'delete' => ['meal_record_food_id'],
    ];
}
