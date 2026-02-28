<?php

namespace app\controller;

use app\business\SmsBusiness;
use app\common\base\BaseController;
use app\common\validate\SmsValidator;
use support\Request;
use support\Response;
use Webman\Validation\Annotation\Validate;

class SmsController extends BaseController
{
    /**
     * 发送验证码
     * @param Request $request
     * @return Response
     */
    public function send(Request $request): Response
    {
        $mobile = $request->post('mobile');
        try {
            SmsBusiness::instance()->send($mobile);
            return $this->success('短信验证码已发送');
        } catch (\Exception $e) {
            return $this->fail($e->getMessage());
        }
    }
}
