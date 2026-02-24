<?php

namespace app\controller;

use app\business\TopicBusiness;
use app\common\base\BaseController;
use support\Request;

class TopicController extends BaseController
{
    public function search(Request $request)
    {
        return $this->success('ok', TopicBusiness::instance()->search($request));
    }
}
