<?php

namespace app\controller;

use app\business\DiaryBusiness;
use app\common\base\BaseController;
use support\Request;

class DiaryController extends BaseController
{
    protected $noNeedLogin = [];

    /**
     * 获取饮食记录列表
     */
    public function meals(Request $request)
    {
        $data = DiaryBusiness::instance()->meals($request);
        return $this->success('ok', $data);
    }

    /**
     * 获取饮食总结
     */
    public function summary(Request $request)
    {
        $data = DiaryBusiness::instance()->summary($request);
        return $this->success('ok', $data);
    }

    /**
     * 添加饮食记录
     */
    public function add(Request $request)
    {
        $data = DiaryBusiness::instance()->addMeal($request);
        return $this->success('添加成功', $data);
    }

    /**
     * 删除饮食中的某项食物
     */
    public function delete(Request $request)
    {
        DiaryBusiness::instance()->delete($request);
        return $this->success('删除成功');
    }
}
