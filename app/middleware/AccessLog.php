<?php

namespace app\middleware;

use app\common\enum\UserInfoContext;
use support\Log;
use Webman\Context;
use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;

class AccessLog implements MiddlewareInterface
{
    public function process(Request $request, callable $handler): Response
    {
        // 1. 生成 Trace ID 并注入 Request 对象
        $request->setTraceId($request->header('x-trace-id', bin2hex(random_bytes(8))));
        $request->setStartTime(microtime(true));

        // 2. 执行后续逻辑 (控制器等)
        $response = $handler($request);

        // 3. 计算耗时
        $endTime  = microtime(true);
        $duration = round(($endTime - $request->getStartTime()) * 1000, 2);

        // 4. 在响应头透传 Trace ID
        $response->header('X-Trace-Id', $request->getTraceId());
        return $response;
        // 5. 准备日志数据
        $postData = $request->post();
        if (!empty($postData)) {
            array_walk_recursive($postData, function (&$value) {
                // 敏感字段脱敏（可选）
//                 if (in_array($key, ['password', 'token'])) $value = '******';
                if (is_string($value) && mb_strlen($value) > 100) {
                    $value = mb_substr($value, 0, 100) . '...[truncated]';
                }
            });
        }

        // 6. 记录结构化日志
        Log::channel('access')->info('', [
            'trace_id' => $request->getTraceId(),
            'ip'       => $request->getRealIp(),
            'method'   => $request->method(),
            'uri'      => $request->path(),
            'query'    => $request->get(),
            'post'     => $postData,
            'status'   => $response->getStatusCode(),
            'duration' => $duration . 'ms',
            'ua'       => $request->header('user-agent'),
            'user_id'  => Context::get(UserInfoContext::UserId->value), // 关联当前操作用户
        ]);

        return $response;
    }
}
