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

    public function information(Request $request)
    {
        return $this->success('ok', UserBusiness::instance()->information($request));
    }

    /**
     * 同步步数
     * @param Request $request
     * @return \support\Response
     */
    public function steps(Request $request)
    {
        UserBusiness::instance()->uploadSteps($request);
        return $this->success('同步成功');
    }
}
