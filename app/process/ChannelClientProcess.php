<?php

namespace app\process;

use app\common\enum\ChannelEventName;
use app\service\foodHealthCheck\BaseHealthCheck;
use Channel\Client;
use support\Log;
use Workerman\Timer;
use Workerman\Worker;

/**
 * 改为进程间通信不用redis的Sub/Pub了
 * 仅异常信息收集使用 现已经改为SystmNotifyProcess进程处理
 * @deprecated
 */
class ChannelClientProcess
{
    public function onWorkerStart(Worker $worker): void
    {
        $channelList = ChannelEventName::channels();
        Client::connect('127.0.0.1', 2206);
        foreach ($channelList as $k => $v) {
            $channelEnum = ChannelEventName::tryFrom($v);
            Client::on($channelEnum->value, fn($data) => $channelEnum->handlerClass()->run($data));
        }
    }

    /**
     * @return void
     * @deprecated
     */
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
            $this->client->subscribe(ChannelEventName::channels(), fn($channel, $message) => $this->dispatch($channel, $message));
        } catch (\Throwable $e) {
            echo "[RedisSubscribe] 连接断开: {$e->getMessage()}, 3秒后重连...\n";
            Timer::add(3, function () {
                $this->subscribe();
            }, [], false);
        }
    }

    /**
     * @param string $channel
     * @param string $message
     * @return void
     * @deprecated
     */
    private function dispatch(string $channel, string $message): void
    {
        Log::debug('redisSubscribe:dispatch', [$channel, $message]);

        $channelEnum = ChannelEventName::tryFrom($channel);

        if (!$channelEnum) {
            Log::error("未知的频道[{$channel}]", [$message]);
            return;
        }

        try {
            /** @var BaseHealthCheck $handlerClass */
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
