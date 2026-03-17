<?php

namespace app\process;

use app\common\enum\RedisSubscribeEventName;
use app\service\redisSubscribe\BaseRedisSubscribe;
use support\Log;
use Workerman\Redis\Client;
use Workerman\Worker;

class RedisSubscribeProcess
{
    private ?Client $redis = null;

    public function onWorkerStart(Worker $worker): void
    {
        $this->connect();
    }

    private function connect(): void
    {
        $host     = getenv('REDIS_HOST');
        $port     = getenv('REDIS_PORT');
        $password = getenv('REDIS_PASSWORD');

        $dsn = "redis://{$host}:{$port}";

        $this->redis = new Client($dsn, [
            \Redis::OPT_TCP_KEEPALIVE => 1,
            \Redis::OPT_READ_TIMEOUT  => 1,
        ]);

        // 有密码时认证
        if ($password) {
            $this->redis->auth($password);
        }

        // 断线自动重连
        $this->redis->on('close', function () {
            Log::warning('[RedisSubscribe] 连接断开，3秒后重连...');
            \Workerman\Timer::add(3, function () {
                $this->connect();
            }, [], false);
        });

        $this->redis->on('error', function ($e) {
            Log::error('[RedisSubscribe] 连接错误: ' . $e);
        });

        // 异步订阅，不阻塞事件循环
        $channels = RedisSubscribeEventName::channels();
        $this->redis->subscribe($channels, function ($channel, $message) {
            Log::debug('redisSubscribe:dispatch', [$channel, $message]);
            $this->dispatch($message, $channel);
        });
    }

    private function dispatch(string $message, string $channel): void
    {

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
