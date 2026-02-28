<?php

namespace app\controller;

use app\business\UserBusiness;
use app\common\base\BaseController;
use app\common\exception\ValidationException;
use app\common\validate\LoginValidator;
use support\Request;
use support\Response;
use Webman\Validation\Annotation\Validate;

class AuthController extends BaseController
{
    /**
     * 小程序登录
     *
     * @param Request $request
     * @return Response
     */
    #[Validate(validator: LoginValidator::class, scene: 'wx')]
    public function login(Request $request): Response
    {
        $code = $request->post('code');

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

    public function sms(Request $request): Response
    {
        try {
            $result = UserBusiness::instance()->sms($request);
            return $this->success('登录成功', $result);
        } catch (\Exception $e) {
            return $this->fail('登录失败: ' . $e->getMessage());
        }
    }
}
