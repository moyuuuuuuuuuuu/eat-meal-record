<?php

namespace app\service;

abstract class BaseGuzzleHttpClient
{

    protected        $client;
    protected static $instance;

    abstract protected function __construct();

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
     * @throws \RuntimeException
     */
    protected function handleResponse($response): array
    {
        if ($response->getStatusCode() != 200) {
            throw new \RuntimeException($response->getRe);
        }
        $body = $response->getBody()->getContents();
        $data = json_decode($body, true);
        return $data;
    }
}
