<?php

namespace app\process;

use app\common\enum\RedisSubscribeEventName;
use app\service\redisSubscribe\BaseRedisSubscribe;
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
            $redis = Redis::connection('subscribe')->client();
            $redis->setOption(\Redis::OPT_TCP_KEEPALIVE, true);
            $redis->setOption(\Redis::OPT_READ_TIMEOUT, -1);
            $redis->subscribe(RedisSubscribeEventName::channels(), fn($message, $channel) => $this->dispatch($message, $channel));
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

        $channelEnum = RedisSubscribeEventName::tryFrom($channel);

        if (!$channelEnum) {
            Log::error("未知的频道[{$channel}]", [$message]);
            return;
        }

        try {
            /** @var BaseRedisSubscribe $handlerClass */
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
