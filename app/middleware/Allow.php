<?php

namespace app\middleware;

use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;

class Allow implements MiddlewareInterface
{

    public function process(Request $request, callable $next): Response
    {
        /** @var Response $response */
        $headers = [
            'Access-Control-Allow-Origin'      => '*',
            'Access-Control-Allow-Credentials' => 'true',
            'Access-Control-Allow-Methods'     => 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers'     => 'Origin, Content-Type, Authorization, Appid, Timestamp, Nonce, Sign,Referer,User-Agent',
        ];

        // 预检请求直接返回 204
        if ($request->method() === 'OPTIONS') {
            return response('', 204)->withHeaders($headers);
        }

        return $next($request)->withHeaders($headers);
    }
}
