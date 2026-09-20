<?php

namespace app\common\validate;

use app\common\base\BaseValidator;
use app\common\enum\NutritionInputType;

class FoodValidator extends BaseValidator
{
    protected array $messages = [
        'type.required'              => '输入类型不能为空',
        'type.in'                    => '不支持的输入类型',
        'content.required'           => '内容数据不能为空',
        'content.string'             => '内容格式非法',
        'content.max'                => '内容长度超出限制', // 自动匹配下面的动态 max
        'options.array'              => '配置项格式不正确',
        'options.format.required_if' => '音频格式参数不能为空',
    ];
    protected array $scenes   = [
        'recognize' => ['type', 'content', 'options', 'options.format'],
    ];

    public function __construct()
    {
        $this->rules = [
            'type'           => 'required|in:' . implode(',', NutritionInputType::values()),
            'options'        => 'nullable|array',
            'options.format' => 'required_if:type,' . NutritionInputType::AUDIO->value,
            'content'        => ['required', 'string']
        ];
    }

    public function rules(): array
    {
        $this->rules['content'] = ['required', 'string',
            ($this->data()['type'] ?? null) === NutritionInputType::TEXT->value
                ? 'max:150' : 'max:10485760'];
        return parent::rules();
    }
}
