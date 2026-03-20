<?php

namespace app\controller;

use app\command\SyncFood;
use app\common\base\BaseController;
use app\common\exception\BusinessException;
use app\model\TagModel;
use app\service\BooHee;
use support\Db;
use support\Request;

class IndexController extends BaseController
{
    protected $noNeedLogin = ['*'];
    public function index(Request $request)
    {
       }

    public function view(Request $request)
    {
        return view('index/view', ['name' => 'webman']);
    }

    /*public function json(Request $request)
    {
        return json(['code' => 0, 'msg' => 'ok']);
    }*/

}
