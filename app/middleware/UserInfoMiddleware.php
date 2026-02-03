<?php

namespace app\middleware;

use app\common\context\UserInfo;
use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;

class UserInfoMiddleware implements MiddlewareInterface
{
    public function process(Request $request, callable $handler): Response
    {
        $request->userInfo = UserInfo::getUserInfo();
        return $handler($request);
    }
}
