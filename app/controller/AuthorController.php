<?php

namespace app\controller;

use app\controller\BaseController;
use app\service\wechat\WxMini;
use support\Request;

class AuthorController extends BaseController
{
    public function getSessionKey(Request $request)
    {
        $code = $request->post('code', '');
        if (!$code) {
            return $this->error(1001, '缺少参数');
        }
        try {
            $jscode2Session = WxMini::getInstance()->jsCode2Session($code);
            $sessionKey     = $jscode2Session['sessionKey'];
        } catch (\Exception $e) {
            return $this->error($e->getCode(), $e->getMessage(), $e->getTrace());
        }
        return $this->success('', ['sessionKey' => $sessionKey]);
    }
}
