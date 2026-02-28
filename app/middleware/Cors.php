<?php

namespace app\middleware;

use Webman\Http\Request;
use Webman\Http\Response;

class Cors extends \Webman\Cors\CORS
{
    public function process(Request $request, callable $next): Response
    {
        if ($request->method() === 'OPTIONS') {
            return response('', 204)->withHeaders([
                'Access-Control-Allow-Origin'  => '*',
                'Access-Control-Allow-Methods' => 'GET,POST,PUT,DELETE,OPTIONS',
                'Access-Control-Allow-Headers' => 'Content-Type,Authorization,X-Requested-With,Accept,Origin',
                'Access-Control-Max-Age'       => '86400', // 缓存一天
            ]);
        }
        $response = $next($request);
        $response->withHeaders([
            'Access-Control-Allow-Credentials' => 'true',
            'Access-Control-Allow-Origin'      => $request->header('origin', '*'),
            'Access-Control-Allow-Methods'     => $request->header('access-control-request-method', '*'),
            'Access-Control-Allow-Headers'     => $request->header('access-control-request-headers', '*'),
        ]);

        return $response;
    }
}
