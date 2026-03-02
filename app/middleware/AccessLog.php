<?php

namespace app\middleware;

use Webman\MiddlewareInterface;
use Webman\Http\Response;
use Webman\Http\Request;
use support\Log;
class AccessLog implements MiddlewareInterface
{
    public function process(Request $request, callable $handler): Response
    {
        $start_time = microtime(true);
        $response = $handler($request);
        $end_time = microtime(true);
        $duration = round(($end_time - $start_time) * 1000, 2); // 转化为毫秒
        $postData = $request->post();
        array_walk_recursive($postData, function (&$value) {
            if (is_string($value) && strlen($value) > 100) {
                $value = mb_substr($value, 0, 100) . '...';
            }
        });
        Log::channel('access')->info('request', [
            'time_start' => date('Y-m-d H:i:s', (int)$start_time),
            'method'     => $request->method(),
            'uri'        => $request->path(),
            'query'      => $request->get(),   // GET 参数
            'post'       => $postData,  // POST 参数
            'ip'         => $request->getRemoteIp(),
            'status'     => $response->getStatusCode(),
            'duration'   => $duration . 'ms',  // 耗时
        ]);
        return $response;
    }
}
