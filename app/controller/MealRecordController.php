<?php

namespace app\controller;

use app\business\MealRecordBusiness;
use app\common\base\BaseController;
use support\Request;

class MealRecordController extends BaseController
{
    protected $noNeedLogin = [];
    public function relation(Request $request){
        return $this->success('ok',MealRecordBusiness::instance()->relation($request));
    }
    public function history(Request $request){
        return $this->success('ok',MealRecordBusiness::instance()->history($request));
    }
}
