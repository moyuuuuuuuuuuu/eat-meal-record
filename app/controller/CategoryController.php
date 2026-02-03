<?php

namespace app\controller;

use app\business\CatBusiness;
use app\common\base\BaseController;
use support\Request;

class CategoryController extends BaseController
{
    /**
     * 获取食物分类列表
     *
     * @param Request $request
     * @return \support\Response
     */
    public function index(Request $request)
    {
        return $this->success('ok', CatBusiness::instance()->list($request));
    }
}
