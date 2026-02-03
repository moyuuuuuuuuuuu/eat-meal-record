<?php

namespace app\middleware;

use app\common\enum\BusinessCode;
use app\common\trait\ReturnMessage;
use Webman\Http\Request;
use Webman\Http\Response;
use Webman\MiddlewareInterface;

class AuthMiddleware implements MiddlewareInterface
{
    use ReturnMessage;
    public function process(Request $request, callable $handler): Response
    {
        $userInfo = $request->userInfo;
        if($userInfo){
            return $handler($request);
        }
        $controller = new \ReflectionClass($request->controller);
        $noNeedLogin = $controller->getDefaultProperties()['noNeedLogin'] ?? [];
        if(in_array($request->action, $noNeedLogin) || in_array('*', $noNeedLogin)){
            return $handler($request);
        }else if(!$userInfo){
            return $this->json(BusinessCode::NO_LOGIN->value,'您还未登陆');
        }
        // 不需要登录，请求继续向洋葱芯穿越
        return $handler($request);
    }
}
