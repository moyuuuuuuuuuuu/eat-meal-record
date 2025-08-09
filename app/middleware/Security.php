<?php

namespace app\middleware;

use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;

class Security implements MiddlewareInterface
{

    const APPID_LIST = [
        '698234633657' => 'c79e035501cb4da2b5494e9912da37f6',//h5/小程序
    ];

    const APPID_WHITELIST = [
        '698234633656',
    ];

    public function process(Request $request, callable $handler): Response
    {
        $appid = $request->header('appid');
        if (in_array($appid, self::APPID_WHITELIST)) {
            return $handler($request);
        }
        if (!isset(self::APPID_LIST[$appid])) {
            if ($request->isJson()) {
                return json([
                    'code'    => 0,
                    'message' => 'appid not allowed',
                ]);
            }
            return response('<h1>403 forbidden</h1>', 400);
        }
        if (!in_array($request->header('appid'), array_keys(self::APPID_LIST))) {
            if ($request->isJson()) {
                return json([
                    'code'    => 0,
                    'message' => 'appid not match',
                ]);
            }
            return response('<h1>403 forbidden</h1>', 401);
        }
        if (!$this->verify($request)) {
            if ($request->isJson()) {
                return json([
                    'code'    => 0,
                    'message' => '签名不匹配',
                ]);
            }
            return response('<h1>403 forbidden</h1>', 402);
        }
        return $handler($request);
    }

    protected function verify(Request $request)
    {
        $appid               = $request->header('appid');
        $sign                = $request->header('sign');
        $timestamp           = $request->header('timestamp');
        $nonce               = $request->header('nonce');
        $secret              = self::APPID_LIST[$appid];
        $params              = $request->all();
        $params['appid']     = $appid;
        $params['timestamp'] = $timestamp;
        $params['nonce']     = $nonce;
        ksort($params);
        $signString = http_build_query($params) . '&secret=' . $secret;
        $calcSign   = md5($signString);
        return strtolower($calcSign) === strtolower($sign);
    }
}
