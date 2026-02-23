<?php

namespace app\controller;

use app\business\UserBusiness;
use app\common\base\BaseController;
use support\Request;

class UserController extends BaseController
{
    protected $noNeedLogin = [];

    /**
     * 用户统计（/api/v3/user/stats）
     */
    public function stats(Request $request)
    {
        $data = UserBusiness::instance()->stats($request);
        return $this->success('ok', $data);
    }
}
