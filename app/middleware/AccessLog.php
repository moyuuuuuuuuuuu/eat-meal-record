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

        $response = null;
        try {
            $response = $handler($request);
            $response->header('X-Trace-Id', $request->getTraceId());
            return $response;
        } finally {
            $duration = round((microtime(true) - $request->getStartTime()) * 1000, 2);
            $postData = $request->post();
            if (!empty($postData)) {
                array_walk_recursive($postData, function (&$value, $key) {
                    if (in_array(strtolower((string)$key), ['password', 'token', 'code', 'encrypteddata', 'iv'], true)) {
                        $value = '******';
                        return;
                    }
                    if (is_string($value) && mb_strlen($value) > 100) {
                        $value = mb_substr($value, 0, 100) . '...[truncated]';
                    }
                });
            }

            Log::channel('access')->info('', [
                'trace_id' => $request->getTraceId(),
                'ip'       => $request->getRealIp(),
                'method'   => $request->method(),
                'uri'      => $request->path(),
                'query'    => $request->get(),
                'post'     => $postData,
                'status'   => $response?->getStatusCode() ?? 500,
                'duration' => $duration . 'ms',
                'ua'       => $request->header('user-agent'),
                'user_id'  => Context::get(UserInfoContext::UserId->value),
            ]);
        }
    }
}
