<?php

namespace app\middleware;

use app\service\Jwt;
use support\Log;
use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;

class VerifyToken implements MiddlewareInterface
{

    /**
     * @inheritDoc
     */
    public function process(Request $request, callable $handler): Response
    {
        $token = $request->header('Authorization');
        if (!$token) {
            if ($request->isJson()) {
                return response(json_encode(['code' => 401, 'message' => '请先登录']), 401);
            }
            return response('请先登录', 401);
        }
        try {
            $token           = explode(' ', $token)[1] ?? '';
            $result          = Jwt::decode($token);
            $request->userId = $result->user_id;
        } catch (\Exception $e) {
            Log::error('jwt decode error: ' . $e->getMessage(), ['trace' => $e->getTrace()]);
            if ($request->isJson()) {
                return response(json_encode(['code' => 401, 'message' => '请先登录']), 401);
            }
            return response('请先登录', 401);
        }
        return $handler($request);
    }
}
