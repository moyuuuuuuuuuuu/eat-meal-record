<?php

namespace app\controller;

use app\business\FoodBusiness;
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
        $json   = '[{"cat":"米面主食","is_common":1,"is_ingredient":2,"name":"重庆小面","nutrition":[{"name":"kcal","value":280.0},{"name":"pro","value":10.5},{"name":"fat","value":7.8},{"name":"carb","value":44.2},{"name":"fiber","value":2.1},{"name":"vit_c","value":2.3},{"name":"mag","value":29.5},{"name":"folic","value":14.8},{"name":"cal","value":38.2},{"name":"iron","value":2.4},{"name":"vit_e","value":1.1}],"tags":{"午餐":"餐次","晚餐":"餐次","煮制":"烹饪方式","麻辣":"口味"},"units":[{"is_default":1,"name":"碗","type":"service","weight":300}]},{"cat":"饮料","is_common":1,"is_ingredient":2,"name":"中杯可乐","nutrition":[{"name":"kcal","value":210.0},{"name":"pro","value":0.0},{"name":"fat","value":0.0},{"name":"carb","value":52.5},{"name":"fiber","value":0.0},{"name":"vit_c","value":0.0},{"name":"mag","value":9.8},{"name":"folic","value":0.0},{"name":"cal","value":9.5},{"name":"iron","value":0.1},{"name":"vit_e","value":0.0}],"tags":{"冷藏":"存储方式","甜":"口味","高糖":"营养"},"units":[{"is_default":1,"name":"杯","type":"volume","weight":500}]}]';
        $result = json_decode($json, true);
        return $this->success('',FoodBusiness::instance()->syncRemote($result ?? []));
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
