<?php

namespace app\controller;

use app\business\ArticleBusiness;
use app\common\base\BaseController;
use support\Request;

class ArticleController extends BaseController
{
    protected $noNeedLogin = ['*'];

    public function notice(Request $request)
    {
        return $this->success('ok', ArticleBusiness::instance()->notice($request));
    }

    public function userAgreement(Request $request)
    {
        return $this->success('ok', ArticleBusiness::instance()->userAgreement());
    }

    public function info(Request $request)
    {
        return $this->success('ok',ArticleBusiness::instance()->info($request));
    }
}
