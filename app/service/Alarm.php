<?php

namespace app\service;

use app\common\enum\RedisSubscribeEventName;
use Throwable;
use support\Log;
use support\Redis;
use GuzzleHttp\Client;

class Alarm
{
    /**
     * 告警主入口
     */
    public static function notify(Throwable $exception)
    {
        // 1. 频率限制：同一个地方的报错，1分钟内只发一次，防止被刷屏
        if (self::isFrequent($exception)) {
            return;
        }

        $request = request();
        $traceId = $request->getTraceId() ?? 'N/A';

        // 2. 收集统计信息
        $data = [
            'env'          => config('app.debug') ? '🛠️ 测试环境' : '🚀 生产环境',
            'time'         => date('Y-m-d H:i:s'),
            'trace_id'     => $traceId,
            'msg'          => $exception->getMessage(),
            'file'         => $exception->getFile(),
            'line'         => $exception->getLine(),
            'url'          => $request ? "[{$request->method()}] " . $request->fullUrl() : '非 HTTP 环境',
            'user_id'      => session('user.id') ?? 'Guest',
            'ip'           => $request ? $request->getRealIp() : '127.0.0.1',
            'duration'     => $traceId ? round((microtime(true) - $request->getStartTime()) * 1000, 2) . 'ms' : 'N/A',
            'clientParams' => self::getCleanParams($request),
        ];
        Redis::publish(RedisSubscribeEventName::SystemErrorNotify->value, json_encode($data));
        Log::info('异常通知已发布');
    }

    /**
     * 防刷逻辑
     */
    private static function isFrequent(Throwable $exception): bool
    {
        $key = 'alarm_lock:' . md5(request()->getRealIp() . $exception->getFile() . $exception->getLine());
        if (Redis::get($key)) return true;

        Redis::setEx($key, 5, 1); // 60秒锁定
        return false;
    }

    /**
     * 获取脱敏后的参数
     */
    private static function getCleanParams($request): string
    {
        if (!$request) return "{}";
        $params = $request->all();
        // 简单脱敏
        unset($params['password'], $params['token'], $params['app_secret']);
        return json_encode($params, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    }

    /**
     * 发送逻辑（异步请求防止阻塞）
     */
    private static function send(string $content)
    {
        MailService::sendText('Eat Clear系统异常告警', $content);
    }
}
