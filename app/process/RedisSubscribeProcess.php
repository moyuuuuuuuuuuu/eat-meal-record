<?php

namespace app\process;

use app\common\enum\RedisSubscribeEventName;
use app\service\redisSubscribe\BaseRedisSubscribe;
use support\Log;
use support\Redis;
use Workerman\Redis\Client;
use Workerman\Timer;
use Workerman\Worker;

class RedisSubscribeProcess
{
    protected ?Client $client = null;

    public function onWorkerStart(Worker $worker): void
    {
        $this->subscribe();
    }

    private function subscribe(): void
    {
        try {
            $host         = getenv('REDIS_HOST');
            $port         = getenv('REDIS_PORT');
            $password     = getenv('REDIS_PASSWORD');
            $this->client = new Client("redis://{$host}:{$port}");
            if ($password) {
                $this->client->auth($password);
            }
            $this->client->subscribe(RedisSubscribeEventName::channels(), fn($channel, $message) => $this->dispatch($channel, $message));
        } catch (\Throwable $e) {
            echo "[RedisSubscribe] 连接断开: {$e->getMessage()}, 3秒后重连...\n";
            Timer::add(3, function () {
                $this->subscribe();
            }, [], false);
        }
    }

    private function dispatch(string $channel, string $message): void
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
