<?php

namespace app\service\redisSubscribe;

abstract class BaseRedisSubscribe
{
    private static array $instances = [];

    protected function __construct()
    {

    }

    private function __clone()
    {
    }

    public function __wakeup()
    {
        throw new \RuntimeException('Cannot unserialize singleton');
    }

    public static function instance(): static
    {
        $class = static::class;

        if (!isset(self::$instances[$class])) {
            self::$instances[$class] = new static();
        }

        return self::$instances[$class];
    }

    abstract public function run($message);
}
