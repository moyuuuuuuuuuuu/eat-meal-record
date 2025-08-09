<?php

namespace app\service\nutrition;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use support\Cache;

/**
 * @deprecated
 */
final class FatSecret
{
    const CLIENT_ID        = 'fedb4f6798ec44488f90011241ad5cc8';
    const CLIENT_SECRET    = 'c79e035501cb4da2b5494e9912da37f6';
    const DOMAIN           = 'https://platform.fatsecret.com/';
    const ACCESS_TOKEN_KEY = 'fatsecret_access_token';

    protected static $instance;
    protected        $client;

    protected function __construct()
    {
        $this->client = new \GuzzleHttp\Client([
            'base_uri' => self::DOMAIN,
            'verify'   => false
        ]);
    }

    public static function getInstance()
    {
        if (!self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }


    /**
     * 获取access token
     * @return string
     * @throws \Exception
     */
    protected function getAccessToken()
    {
        if (Cache::has(self::ACCESS_TOKEN_KEY)) {
            return Cache::get(self::ACCESS_TOKEN_KEY);
        }
        try {
            $response = (new Client([
                'base_uri' => 'https://oauth.fatsecret.com',
                'verify'   => false
            ]))->post('connect/token', [
                'auth'        => [
                    'client_id'     => self::CLIENT_ID,
                    'client_secret' => self::CLIENT_SECRET,
                ],
                'headers'     => [
                    'Content-Type' => 'application/x-www-form-urlencoded'
                ],
                'form_params' => [
                    'grant_type' => 'client_credentials',
                    'scope'      => 'basic'
                ],
            ]);
            // 获取响应体
            $body = $response->getBody()->getContents();
            $data = json_decode($body, true);
            if ($data['access_token']) {
                Cache::set(self::ACCESS_TOKEN_KEY, $data['access_token'], $data['expires_in'] - 200);
                return $data['access_token'];
            }
            throw new \Exception('获取食物信息失败');
        } catch (RequestException $e) {
            throw new \Exception($e->getMessage());
        }
    }

    /**
     * 搜索食物
     * @param string $name
     * @return array
     * @throws \Exception
     */
    public function search(string $name, int $page = 1)
    {
        try {
            $accessToken = $this->getAccessToken();

            $response = $this->client->post('rest/server.api', [
                'headers'     => [
                    'Authorization' => 'Bearer ' . $accessToken,
                ],
                'form_params' => [
                    'method'            => 'foods.search',
                    'region'            => 'cn',
                    'language'          => 'zh',
                    'search_expression' => $name,
                    'format'            => 'json',
                    'page_number'       => $page - 1
                ]
            ]);
            $body     = $response->getBody()->getContents();
            $data     = json_decode($body, true);
            if (isset($data['foods']['food'])) {
                return $data['foods']['food'];
            } else {
                throw new \Exception ($data['error']['message']);
            }
        } catch (RequestException $e) {
            throw new \Exception($e->getMessage());
        }
    }
}
