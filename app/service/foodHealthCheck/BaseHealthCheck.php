<?php

namespace app\service\foodHealthCheck;

use app\service\Alarm;
use Workerman\Coroutine\Parallel;

abstract class BaseHealthCheck
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

    /**
     * @param string[] $message
     * @return bool
     */
    public function run($message)
    {
        if (empty($message)) return true;

        $chunks   = array_chunk($message, 10);
        $parallel = new Parallel();
        foreach ($chunks as $names) {
            $parallel->add(fn() => $this->syncRemote($names));
        }

        $res = $parallel->wait();
        $allSuccessNames = array_merge(...($res ?: [[]]));

        $exceptions = $parallel->getExceptions();
        foreach ($exceptions as $exception) {
            Alarm::notify($exception);
        }

        return count($allSuccessNames) === count($message);
    }

    abstract protected function syncRemote(array $foodNameItem);
}
