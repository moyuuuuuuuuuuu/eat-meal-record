<?php

namespace app\service;

use app\common\enum\BusinessCode;
use app\util\Helper;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use GuzzleHttp\RequestOptions;
use support\Redis;
use app\common\exception\BusinessException;

class BooHee extends BaseGuzzleHttpClient
{

    protected string $appId;
    protected string $appKey;
    private string   $cacheKey    = 'boohee:access_token';
    private string   $quantityKey = 'boohee:quantity';

    public function __construct()
    {
        $this->appId  = getenv('BOOHEE_APPID');
        $this->appKey = getenv('BOOHEE_APPKEY');

        $this->client = new Client([
            'base_uri' => 'https://fc.boohee.com/api/',
            'timeout'  => 10.0
        ]);
    }

    public function canUse(): bool
    {
        return Redis::get($this->quantityKey) < 50;
    }

    protected function handleResponse($response): array
    {
        $body = $response->getBody()->getContents();
        $data = json_decode($body, true);
        return $data['foods'] ?? [];
    }

    public function getAccessToken(): string|null
    {
        $callQuantity = Redis::get($this->quantityKey);
        echo 'Boohee call quantity is '.$callQuantity.PHP_EOL;
        if ($callQuantity < 50) {
            Redis::incr($this->quantityKey);
            Redis::expire($this->quantityKey, Helper::todayEndTimestamp() - time());
        } else {
            throw new BusinessException('薄荷健康业务已达今日上限', BusinessCode::THREE_PART_ERROR);
        }
        $accessToken = Redis::get($this->cacheKey);
        if ($accessToken) {
            return $accessToken;
        }
        $time = time();
        try {
            $result = $this->client->post('v2/access_tokens', [
                RequestOptions::JSON => [
                    'app_id'    => $this->appId,
                    'timestamp' => $time,
                    'sign'      => $this->sign($time)
                ]
            ]);
            $result = $this->handleResponse($result);
            if (isset($result['access_token'])) {
                Redis::set($this->cacheKey, $result['access_token'], strtotime($result['expired_at']) - 300);
            }
            return $result['access_token'] ?? null;
        } catch (RequestException $e) {
            $response = $e->getResponse();
            $result   = $this->handleResponse($response);
            throw new BusinessException($result['error']['message'] ?? '三方未知异常', BusinessCode::THREE_PART_ERROR->value);
        }
    }

    protected function sign($now)
    {
        $originalString = sprintf('%sapp_id%stimestamp%s%s', $this->appKey, $this->appId, $now, $this->appKey);
        return md5($originalString);
    }

    public function search(string $name, int $page = 1, string $foodType = '02')
    {
        try {
            $result = $this->client->get('v1/foods/search', [
                RequestOptions::HEADERS => [
                    'Accept'      => 'application/json',
                    'AccessToken' => $this->getAccessToken(),
                ],
                RequestOptions::QUERY   => [
                    'q'         => $name,
                    'page'      => $page,
                    'food_type' => $foodType,
                ]
            ]);

            return $this->handleResponse($result);
        } catch (RequestException $e) {
            $response = $e->getResponse();
            $result   = $this->handleResponse($response);
            var_dump($response);
            throw new BusinessException($result['error']['message'] ?? '三方未知异常', BusinessCode::THREE_PART_ERROR->value);
        }
    }

    /**
     * @param array<int,array{
     *         name:string,
     *         code:string
     *     }> $foods
     * @return array|null
     * @throws \GuzzleHttp\Exception\GuzzleException
     */
    public function nutrition(array $foods)
    {
        try {
            $result = $this->client->post('v2/foods/ingredients', [
                RequestOptions::HEADERS => [
                    'Accept'      => 'application/json',
                    'AccessToken' => $this->getAccessToken(),
                ],
                RequestOptions::JSON    => $foods
            ]);

            return $this->handleResponse($result);
        } catch (RequestException $e) {
            $response = $e->getResponse();
            $result   = $this->handleResponse($response);
            throw new BusinessException($result['error']['message'] ?? '三方未知异常', BusinessCode::THREE_PART_ERROR->value);
        }
    }


    public function info(string $code)
    {
        try {
            $result = $this->client->get('v3/foods/' . $code, [
                RequestOptions::HEADERS => [
                    'Accept'      => 'application/json',
                    'AccessToken' => $this->getAccessToken(),
                ],
            ]);

            return $this->handleResponse($result);
        } catch (RequestException $e) {
            $response = $e->getResponse();
            $result   = $this->handleResponse($response);
            throw new BusinessException($result['error']['message'] ?? '三方未知异常', BusinessCode::THREE_PART_ERROR->value);
        }
    }
}
