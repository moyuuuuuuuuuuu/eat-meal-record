<?php

namespace app\common\base;

use support\Log;
use Webman\RedisQueue\Consumer;

abstract class BaseConsumer implements Consumer
{
    public $connection = 'default';

    abstract public function consume($data);

    public function onConsumeFailure(\Throwable $exception, $package)
    {
        Log::error('消费者处理失败', [
            'package' => $package,
            'code'    => $exception->getCode(),
            'file'    => $exception->getFile(),
            'line'    => $exception->getLine(),
            'message' => $exception->getMessage(),
            'trace'   => $exception->getTraceAsString(),
        ]);
    }
}
