<?php

namespace app\common\validate;

use app\common\base\BaseValidator;
use app\common\enum\NutritionInputType;
use support\Redis;

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
        'recognize' => ['type', 'content', 'options'],
    ];

    public function __construct()
    {
        $request = request();
        $type    = $request ? $request->post('type') : null;
        $userId  = $request ? $request->user()->id : null; // 假设你有用户系统

        $rules = [
            'type'           => 'required|in:' . implode(',', NutritionInputType::values()),
            'options'        => 'nullable|array',
            'options.format' => 'required_if:type,' . NutritionInputType::AUDIO->value,
            'content'        => ['required', 'string']
        ];

        // 1. 动态字符长度校验
        if ($type === NutritionInputType::TEXT->value) {
            $rules['content'][] = 'max:150';
        } else {
            // 音频/图片 Base64 长度放宽
            $rules['content'][] = 'max:10485760';
        }

        // 2. 注入自定义 Token 阶梯校验 (匿名函数方式)
        if ($userId) {
            $rules['content'][] = function ($attribute, $value, $fail) use ($userId) {
                // 调用阶梯限制逻辑
                $check = $this->validateTokenLadder($userId, $value);
                if (!$check['allowed']) {
                    $fail($check['msg']);
                }
            };
        }

        $this->rules = $rules;
    }

    /**
     * 核心逻辑：Token 阶梯计费与次数限制校验
     */
    private function validateTokenLadder($userId, $content): array
    {
        $date     = date('Ymd');
        $tokenKey = "daily_token_sum:{$userId}:{$date}";
        $countKey = "daily_usage_count:{$userId}:{$date}";

        $currentTokens = (int)Redis::get($tokenKey) ?: 0;
        $currentCounts = (int)Redis::get($countKey) ?: 0;

        // 预估本次请求的 Token (如果是文本)
        $thisRequestTokens = 0;//TokenCounter::count($content);
        $projectedTokens   = $currentTokens + $thisRequestTokens;

        // 定义你的阶梯规则
        // 消耗越高，允许的总次数越少
        if ($projectedTokens >= 80000) {
            return ['allowed' => false, 'msg' => '今日Token消耗已达上限（8w），请明天再试'];
        }

        if ($projectedTokens >= 50000) {
            $limit = 2;
        } elseif ($projectedTokens >= 10000) {
            $limit = 5;
        } else {
            $limit = 10;
        }

        if ($currentCounts >= $limit) {
            return [
                'allowed' => false,
                'msg'     => "当前Token消耗阶段限额{$limit}次，您今日已达上限"
            ];
        }

        return ['allowed' => true];
    }
}
