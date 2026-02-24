<?php

namespace app\controller;

use app\business\FeedBusiness;
use app\common\base\BaseController;
use support\Request;

class FeedController extends BaseController
{
    public function list(Request $request)
    {
        return $this->success('ok', FeedBusiness::instance()->list($request));
    }

    public function detail(Request $request)
    {
        return $this->success('ok', FeedBusiness::instance()->detail($request));
    }

    public function posts(Request $request)
    {
        return $this->success('ok', FeedBusiness::instance()->post($request));
    }

    public function like(Request $request)
    {
        return $this->success('操作成功', FeedBusiness::instance()->like($request));
    }

    public function create(Request $request)
    {
        return $this->success('ok', FeedBusiness::instance()->create($request));
    }
}
