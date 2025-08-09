<?php

namespace app\service\nutrition;

use GuzzleHttp\Exception\RequestException;

class Nutrition extends Base
{

    protected static $instance;

    public function search($name, int $page = 1, int $limit = 20)
    {
        try {
            $response = $this->client->post('nutrient/index', [
                'form_params' => [
                    'key'  => self::API_KEY,
                    'word' => $name,
                    'page' => $page,
                    'num'  => $limit,
                    'mode' => 0
                ]
            ]);
            if ($response->getStatusCode() !== 200) {
                throw new \Exception('请求异常');
            }
            return $this->handleResponse($response);
        } catch (RequestException $e) {
            throw new \Exception($e->getMessage());
        }
    }

    public function image(string $imageUrl, $isPath = true)
    {
        if ($isPath) {
            if (!str_contains($imageUrl, 'http://') || !str_contains($imageUrl, 'https://')) {
                //获取图片内容并转换为base
                $imageUrl = public_path($imageUrl);
            }
            $imageContent = base64_encode(file_get_contents($imageUrl));
        } else {
            $imageContent = base64_encode($imageUrl);
        }
        if (!$imageContent) {
            throw new \Exception('图片读取失败');
        }
        $params = [
            'key' => self::API_KEY,
        ];
        if ($imageContent) {
            $params['img'] = $imageContent;
        } else {
            $params['imgurl'] = $imageUrl;
        }

        $response = $this->client->post('imgnutrient/index', [
            'form_params' => $params
        ]);
        return $this->handleResponse($response);
    }
}
