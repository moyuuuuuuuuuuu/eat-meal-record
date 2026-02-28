<?php

namespace app\controller;

use app\business\TopicBusiness;
use app\common\base\BaseController;
use app\format\TopicFormat;
use support\Request;

class TopicController extends BaseController
{
    protected $noNeedLogin = [
        'search',
        'hot'
    ];

    public function search(Request $request)
    {
        return $this->success('ok', TopicBusiness::instance()->search($request));
    }

    public function hot(Request $request)
    {
        return $this->success('ok', TopicBusiness::instance()->hot($request));
    }

    public function create(Request $request)
    {
        return $this->success('ok', (new TopicFormat())->format(TopicBusiness::instance()->create($request)));
    }
}
