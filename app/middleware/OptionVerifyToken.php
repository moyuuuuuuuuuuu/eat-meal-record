<?php

namespace app\middleware;

use app\service\Jwt;
use support\Log;
use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;

/**
 * 非必拦截token
 */
class OptionVerifyToken implements MiddlewareInterface
{

    /**
     * @inheritDoc
     */
    public function process(Request $request, callable $handler): Response
    {
        $token = $request->header('Authorization');
        if (!$token) {
            return $handler($request);
        }
        try {
            $token           = explode(' ', $token)[1] ?? '';
            $result          = Jwt::decode($token);
            $request->userId = $result->user_id;
        } catch (\Exception $e) {
            Log::error('jwt decode error: ' . $e->getMessage(), ['trace' => $e->getTrace()]);
            return $handler($request);
        }
        return $handler($request);
    }
}
