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
     * @return array{
     *     bool,int[]
     * }
     */
    public function run($message)
    {
        if (empty($message)) return [false, []];

        $chunks = array_chunk($message, 10);
//        $parallel = new Parallel();
        $results = [];
        foreach ($chunks as $names) {
            $resultIdList = $this->syncRemote($names);
            $results      = array_merge($results, $resultIdList);
        }

//        $res              = $parallel->wait();
//        $allSuccessFoodId = array_merge(...($res ?: [[]]));

        /*  $exceptions = $parallel->getExceptions();
          foreach ($exceptions as $exception) {
              Alarm::notify($exception);
          }*/
        if (count($results) === count($message)) {
            return [true, $results];
        }
        return [false, $results];
    }

    abstract protected function syncRemote(array $foodNameItem);
}
