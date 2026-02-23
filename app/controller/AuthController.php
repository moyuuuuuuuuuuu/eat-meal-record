<?php

namespace app\controller;

use app\business\UserBusiness;
use app\common\base\BaseController;
use app\common\exception\ParamException;
use support\Request;
use support\Response;

class AuthController extends BaseController
{
    /**
     * 小程序登录
     *
     * @param Request $request
     * @return Response
     */
    public function login(Request $request): Response
    {
        $code = $request->post('code');
        if (!$code) {
            throw new ParamException('授权码');
        }

        try {
            $result = UserBusiness::instance()->login($code, $request->getRealIp());
            return $this->success('登录成功', $result);
        } catch (\Exception $e) {
            return $this->fail('登录失败: ' . $e->getMessage());
        }
    }

    public function mock(Request $request): Response
    {
        $userId = $request->post('userId');
        try {
            $result = UserBusiness::instance()->mock($userId, $request->getRealIp());
            return $this->success('登录成功', $result);
        } catch (\Exception $e) {
            return $this->fail('登录失败: ' . $e->getMessage());
        }
    }
}
