<?php

namespace app\service;

use app\common\enum\ChannelEventName;
use app\common\enum\UserInfoContext;
use support\Log;
use support\Redis;
use Throwable;
use Channel\Client;
use Webman\Context;

class Alarm
{
    /**
     * 告警主入口
     */
    public static function notify(Throwable $exception)
    {
        // 1. 频率限制：同一个地方的报错，1分钟内只发一次
        if (self::isFrequent($exception)) {
            return;
        }

        // 兼容非 HTTP 环境获取 request 对象
        $request = class_exists('\support\Request') ? request() : null;

        // 提取 Trace ID，优先从 Context 获取以支持多环境
        $traceId = Context::get('trace_id') ?: ($request ? $request->getTraceId() : 'N/A');

        // 2. 收集统计信息
        $data = [
            'env'          => config('app.debug') ? '🛠️ 测试环境' : '🚀 生产环境',
            'time'         => date('Y-m-d H:i:s'),
            'trace_id'     => $traceId,
            'msg'          => $exception->getMessage(),
            'file'         => $exception->getFile(),
            'line'         => $exception->getLine(),
            // 识别环境：HTTP 还是 命令行/进程
            'url'          => $request ? "[{$request->method()}] " . $request->fullUrl() : 'CLI / Process / Queue',
            'user_id'      => Context::get(UserInfoContext::UserId->value) ?? 'System',
            'ip'           => $request ? ($request->getRealIp() ?? '127.0.0.1') : 'Internal',
            'duration'     => $request ? (round((microtime(true) - $request->getStartTime()) * 1000, 2) . 'ms') : 'N/A',
            'clientParams' => self::getCleanParams($request),
            'stack_trace'  => $exception->getTraceAsString(),
        ];

        try {
            Client::connect();
            Client::publish(ChannelEventName::SystemErrorNotify->value, $data);
            Log::info('异常通知已发布', $data);
        } catch (Throwable $e) {
            // 防止告警组件本身崩溃导致业务中断
            Log::error('告警发布失败: ' . $e->getMessage());
        }
    }

    /**
     * 防刷逻辑
     */
    private static function isFrequent(Throwable $exception): bool
    {
        // 如果没有 request，则不基于 IP 锁定，仅基于错误位置
        $request = class_exists('\support\Request') ? request() : null;
        $ip      = $request ? $request->getRealIp() : 'system';

        $key = 'alarm_lock:' . md5($ip . $exception->getFile() . $exception->getLine());

        if (Redis::get($key)) return true;

        Redis::setEx($key, 60, 1);
        return false;
    }

    /**
     * 获取脱敏后的参数
     */
    private static function getCleanParams($request): string
    {
        // 如果是队列或进程，尝试从 Context 获取上下文参数，否则返回空
        if (!$request) {
            $contextParams = Context::get('process_params') ?? [];
            return empty($contextParams) ? "{}" : json_encode($contextParams, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        }

        $params = $request->all();
        unset($params['password'], $params['token'], $params['app_secret']);
        return json_encode($params, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    }
}
