<?php

namespace app\process;

use app\common\enum\RedisSubscribe;
use app\service\redisSubscribe\BaseFoodSync;
use support\Log;
use support\Redis;
use Workerman\Timer;
use Workerman\Worker;

class RedisSubscribeProcess
{
    public function onWorkerStart(Worker $worker): void
    {
        $this->subscribe();
    }

    private function subscribe(): void
    {
        try {
            Redis::subscribe(RedisSubscribe::channels(), fn($message, $channel) => $this->dispatch($message, $channel));
        } catch (\Throwable $e) {
            echo "[RedisSubscribe] 连接断开: {$e->getMessage()}, 3秒后重连...\n";
            Timer::add(3, function () {
                $this->subscribe();
            }, [], false);
        }
    }

    private function dispatch(string $message, string $channel): void
    {
        Log::debug('redisSubscribe:dispatch', [$channel, $message]);

        $channelEnum = RedisSubscribe::tryFrom($channel);

        if (!$channelEnum) {
            Log::error("未知的频道[{$channel}]", [$message]);
            return;
        }

        try {
            /** @var BaseFoodSync $handlerClass */
            $handlerClass = $channelEnum->handlerClass();
            if ($handlerClass) {
                $handlerClass->run($message);
            }
        } catch (\Throwable $e) {
            Log::error('RedisSubscribe:dispatch:error:' . $e->getMessage(), [
                'channel' => $channel,
                'message' => $message,
                'trace'   => $e->getTraceAsString(),
            ]);
        }
    }
}
