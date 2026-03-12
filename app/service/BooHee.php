<?php

namespace app\service;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use GuzzleHttp\RequestOptions;
use support\Cache;

class BooHee extends BaseGuzzleHttpClient
{

    protected string $appId;
    protected string $appUserId;

    protected string $appKey;

    public function __construct()
    {
        $this->client = new Client([
            'base_uri' => 'https://fc.boohee.com/api/',
            'timeout'  => 10.0,
        ]);
    }

    public function getAccessToken()
    {
        $accessToken = Cache::get('boohee_access_token');
        if ($accessToken) {
            return $accessToken;
        }
        $time = time();
        try {
            $result = $this->client->post('v2/access_tokens', [
                RequestOptions::HEADERS => [
                    'Accept' => 'application/json',
                ],
                RequestOptions::JSON    => [
                    'app_id'      => $this->appId,
                    'app_user_id' => $this->appUserId,
                    'timestamp'   => $time,
                    'sign'        => $this->sign($time)
                ]
            ]);
            if (isset($result['access_token'])) {
                Cache::set('boohee_access_token', $result['access_token'], strtotime($result['expired_at']) - 100);
            }
            return $result['access_token'] ?? null;
        } catch (RequestException $e) {
            throw new \Exception($e->getMessage());
        }
    }

    protected function sign($now)
    {
        return md5(sprintf('%sapp_id%stimestamp:%s', $this->appKey, $this->appId, $now));
    }

    public function search(string $name, int $page, string $foodType)
    {
        $this->client->get('v1/foods/search', [
            RequestOptions::QUERY => [
                
            ]
        ]);
    }
}
