<?php

namespace app\service;

use app\enum\NutritionInputType;
use Moyuuuuuuuu\QianFan\{Contants\RequestMethod, Contants\Role, Payload\Universal, Request};

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

    public function request(string $type, mixed $content): array
    {
        if ($type == NutritionInputType::AUDIO->value) {
            $payload = (new Universal())
                ->setDomain('http://vop.baidu.com')
                ->setUri('/server_api')
                ->setMethod(RequestMethod::POST)
                ->setHeader('Content-Type', 'application/json')
                ->add('speech', $content)
                ->add('format', 'm4a')
                ->add('channel', 1)
                ->add('cuid', 'default_user')
                ->add('dev_pid', 1537)
                ->add('len', strlen($content))
                ->add('rate', 16000);
            $request = new \Moyuuuuuuuu\QianFan\Request(getenv('API_KEY'));
            $result  = $request->send($payload);
            if (!$result || (isset($result['err_no']) && $result['err_no'] != 0)) {
                throw new \RuntimeException('语音识别失败');
            }
            $content = $result['result'] ?? '';
            $type    = NutritionInputType::TEXT->value;
            if (empty($content)) {
                throw new \RuntimeException('');
            }
        }

        $payload  = (new Universal())->setMethod(RequestMethod::POST)
            ->setDomain('https://qianfan.baidubce.com')
            ->setUri('v2/chat/completions');
        $template = base_path() . '/template/' . $type;
        if ($type == NutritionInputType::TEXT->value) {
            $message = [
                [
                    'role'    => Role::SYSTEM->value,
                    'content' => file_get_contents($template)
                ],
                [
                    'role'    => Role::USER->value,
                    'content' => $content
                ]
            ];
            $payload->add('model', 'ernie-5.0-thinking-preview');
        } else if (NutritionInputType::IMAGE->value) {
            $message = [
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
            ];
            $payload->add('model', 'ernie-4.5-turbo-vl-latest');
        } else {
            throw new \RuntimeException('不支持的识别方式');
        }
        $payload->add('messages', $message);
        $request = new Request(getenv('API_KEY'));
        $result  = $request->send($payload);
        $result  = $result['choices'][0]['message']['content'] ?? null;
        if (!$result) {
            throw new \RuntimeException('未能成功分析餐品', 4003);
        }
        return json_decode($result, true) ?? [];
    }

}
