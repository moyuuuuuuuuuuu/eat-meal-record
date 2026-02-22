<?php

namespace app\controller;

use app\business\MealRecordBusiness;
use app\common\base\BaseController;
use support\Request;

class MealRecordController extends BaseController
{
    public function list(Request $request)
    {
        return $this->success('获取成功', MealRecordBusiness::instance()->list($request));
    }

    public function create(Request $request)
    {
        try {
            $result = MealRecordBusiness::instance()->create($request);
            return $this->success('', $result->toarray());
        } catch (\Exception $e) {
            $message = $e->getMessage();
            if($e->getCode() === 0){
                $message = '餐食记录添加失败';
            }
            return $this->fail($message);
        }
    }

    public function delete(Request $request){
        try {
            $result = MealRecordBusiness::instance()->delete($request);
            return $this->success('', $result);
        } catch (\Exception $e) {
            $message = $e->getMessage();
            if($e->getCode() === 0){
                $message = '餐食记录添加失败';
            }
            return $this->fail($message);
        }
    }
}
