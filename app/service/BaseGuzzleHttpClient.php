<?php

namespace app\service;

abstract class BaseGuzzleHttpClient
{
    protected $client;

    protected static $instances = [];

    abstract protected function __construct();

    /**
     * @return static
     */
    public static function instance(): static
    {
        $calledClass = static::class;
        if (!isset(self::$instances[$calledClass])) {
            self::$instances[$calledClass] = new static();
        }
        return self::$instances[$calledClass];
    }

    /**
     * 阻止外部克隆和反序列化，确保单例安全性
     */
    protected function __clone() {}
    public function __wakeup() { throw new \Exception("Cannot unserialize singleton"); }

    protected function handleResponse($response): array
    {
        if ($response->getStatusCode() != 200) {
            throw new \RuntimeException($response->getReasonPhrase());
        }
        $body = (string)$response->getBody();
        $data = json_decode($body, true);

        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new \RuntimeException("Invalid JSON response");
        }

        return $data;
    }
}
