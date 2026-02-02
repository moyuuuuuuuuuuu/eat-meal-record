<?php

namespace app\controller;

use plugin\admin\app\model\Cat;
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
        $list = Cat::query()
            ->orderBy('sort', 'desc')
            ->orderBy('id', 'asc')
            ->get(['id', 'name', 'pid', 'sort']);
            
        return $this->success('ok', $list->toArray());
    }
}
