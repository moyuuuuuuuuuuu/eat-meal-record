<?php

namespace app\service;

class BaseGuzzleHttpClient
{

    protected        $client;
    protected static $instance;

    protected function __construct()
    {

    }

    /**
     * @return static
     */
    public static function getInstance()
    {
        if (static::$instance == null) {
            static::$instance = new static();
        }
        return static::$instance;
    }

    /**
     * @param $response
     * @return array|null
     * @throws \Exception
     */
    protected function handleResponse($response)
    {
        if ($response->getStatusCode() != 200) {
            throw new \Exception('请求失败');
        }
        $body = $response->getBody()->getContents();
        $data = json_decode($body, true);
        return $data;
    }
}
