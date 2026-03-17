<?php

namespace app\service;

use app\common\context\TokenLimit;
use app\common\enum\BusinessCode;
use app\common\enum\NutritionInputType;
use Moyuuuuuuuu\QianFan\{Contants\RequestMethod, Contants\Role, Payload\Universal, Request};
use app\common\exception\BusinessException;
use support\Log;

class Nutrition
{
    protected string $apiKey;
    protected static $instance;

    public function __construct()
    {
        $this->apiKey = getenv('API_KEY');
    }

    static function instance()
    {
        if (self::$instance == null) {
            self::$instance = new static;
        }
        return self::$instance;
    }

    public function request(string $type, mixed $content, ?array $options = []): array
    {
        $originalType = $type;
        $templateType = ($type == NutritionInputType::AUDIO->value) ? NutritionInputType::TEXT->value : $type;
        $template     = base_path() . '/template/' . $templateType;
        if (!file_exists($template)) {
            throw new BusinessException('服务器错误，未找到对应的食品参考模版', BusinessCode::SYSTEM_ERROR->value);
        }

        if ($originalType == NutritionInputType::AUDIO->value) {
            $type    = NutritionInputType::TEXT->value;
            $payload = (new Universal())
                ->setDomain('http://vop.baidu.com')
                ->setUri('/server_api')
                ->setMethod(RequestMethod::POST)
                ->setHeader('Content-Type', 'application/json')
                ->add('speech', $content)
                ->add('format', $options['format'] ?? 'm4a')
                ->add('channel', $options['channel'] ?? 1)
                ->add('cuid', $options['cuid'] ?? uniqid())
                ->add('dev_pid', $options['dev_pid'] ?? 1537)
                ->add('len', strlen($content))
                ->add('rate', $options['rate'] ?? 16000);
            $request = new Request(getenv('API_KEY'), ['timeout' => 240]);
            $result  = $request->send($payload);
            if (!$result || (isset($result['err_no']) && $result['err_no'] != 0)) {
                throw new BusinessException('语音识别失败', BusinessCode::BUSINESS_ERROR->value);
            }
            $content = $result['result'] ?? '';
            if (empty($content)) {
                throw new BusinessException('未识别到有效文字', BusinessCode::BUSINESS_ERROR->value);
            }
        }

        $payload = (new Universal())->setMethod(RequestMethod::POST)
            ->setDomain('https://qianfan.baidubce.com')
            ->setUri('v2/chat/completions');
        $message = match ($type) {
            NutritionInputType::TEXT->value => [
                [
                    'role'    => Role::SYSTEM->value,
                    'content' => file_get_contents($template)
                ],
                [
                    'role'    => Role::USER->value,
                    'content' => $content
                ]
            ],
            NutritionInputType::IMAGE->value => [
                [
                    'role'    => Role::USER->value,
                    'content' => [
                        [
                            'type' => 'text',
                            'text' => file_get_contents($template)
                        ],
                        [
                            'type'      => 'image_url',
                            'image_url' => [
                                'url' => $content
                            ]
                        ]
                    ]
                ]
            ],
            default => throw new BusinessException('不支持的识别方式', BusinessCode::PARAM_ERROR->value)
        };
        $payload->add('model', $options['mode'] ?? 'ernie-5.0-thinking-preview');
        $payload->add('messages', $message);
        try {
            $request = new Request(getenv('API_KEY'), ['timeout' => 300]);
            $result  = $request->send($payload, ['stream' => true, 'read_timeout' => null, 'connect_timeout' => 10, 'verify' => false, 'proxy' => '']);
            Log::channel('access')->debug('千帆Api返回结果', [$result]);
            if (isset($result['error'])) {
                throw new BusinessException($result['error']['message'], BusinessCode::THREE_PART_ERROR->value);
            }
            $usage = $result['usage'] ?? [];
            if ($usage) {
                TokenLimit::instance()->consume($usage['total_tokens'] ?? 0);
            }
            $result = $result['choices'][0]['message']['content'] ?? null;
            if (!$result) {
                throw new BusinessException('未能成功分析餐品', BusinessCode::BUSINESS_ERROR->value);
            }
            return json_decode($result, true) ?? [];
        } catch (\RuntimeException $e) {
            $data      = json_decode($e->getMessage(), true) ?? [];
            $errorCode = BusinessCode::SYSTEM_ERROR->value;
            if (!$data) {
                Log::error('调用千帆异常：' . $e->getMessage(), $e->getTrace());
            } else {
                Log::error('千帆数据异常', $data);
                $errorCode = BusinessCode::THREE_PART_ERROR->value;
            }
            throw new BusinessException('未能成功分析餐品', $errorCode);
        }
    }

}
