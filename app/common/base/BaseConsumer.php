<?php

namespace app\common\base;

use support\Log;
use Webman\RedisQueue\Consumer;

abstract class BaseConsumer implements Consumer
{
    public $queue;
    public $connection = 'default';
    abstract public function consume($data);

    public function onConsumeFailure(\Throwable $e, $package)
    {
        Log::error('消费者处理失败',[
            'package' => $package,
            'message' => $e->getMessage(),
            'trace' => $e->getTraceAsString(),
        ]);
    }
}
