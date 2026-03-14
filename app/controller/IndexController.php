<?php

namespace app\controller;

use app\business\FoodBusiness;
use app\common\base\BaseController;
use app\common\enum\NutritionInputType;
use app\common\enum\QueueEventName;
use app\model\FoodModel;
use app\service\BooHee;
use app\service\FoodService;
use support\Db;
use support\Log;
use support\Redis;
use support\Request;
use Webman\RedisQueue\Client;

class IndexController extends BaseController
{
    public function index(Request $request)
    {
        return ;
        /*$str = '{"foods":[{"name":"米饭","nutrition":[{"name":"pro","value":7.8},{"name":"fat","value":0.9},{"name":"carb","value":76.8},{"name":"fiber","value":0.9},{"name":"vit_c","value":0},{"name":"kal","value":348},{"name":"mag","value":45},{"name":"folic","value":11.7},{"name":"cal","value":21},{"name":"iron","value":3.9},{"name":"vit_e","value":1.38},{"name":"chol","value":0},{"name":"na","value":21},{"name":"zinc","value":0.42},{"name":"sel","value":2.1},{"name":"pufa","value":0.9}],"unit":"2 碗","weight":"300g"},{"name":"黄焖鸡","nutrition":[{"name":"pro","value":40},{"name":"fat","value":24},{"name":"carb","value":12.6},{"name":"fiber","value":1.01},{"name":"vit_c","value":13.7},{"name":"kal","value":428},{"name":"mag","value":51.7},{"name":"folic","value":25.7},{"name":"cal","value":22.4},{"name":"iron","value":3.26},{"name":"vit_e","value":1.62},{"name":"chol","value":212},{"name":"na","value":500},{"name":"zinc","value":1.96},{"name":"sel","value":15.6},{"name":"pufa","value":2.4}],"unit":"1 份","weight":"300g"},{"name":"苹果","nutrition":[{"name":"pro","value":0.36},{"name":"fat","value":0.36},{"name":"carb","value":24.3},{"name":"fiber","value":2.16},{"name":"vit_c","value":7.2},{"name":"kal","value":93.6},{"name":"mag","value":7.2},{"name":"folic","value":3.6},{"name":"cal","value":7.2},{"name":"iron","value":1.08},{"name":"vit_e","value":3.82},{"name":"chol","value":0},{"name":"na","value":2.88},{"name":"zinc","value":0.18},{"name":"sel","value":0.36},{"name":"pufa","value":0.36}],"unit":"1 个","weight":"180g"},{"name":"苏打水","nutrition":[{"name":"pro","value":0},{"name":"fat","value":0},{"name":"carb","value":0},{"name":"fiber","value":0},{"name":"vit_c","value":0},{"name":"kal","value":0},{"name":"mag","value":0},{"name":"folic","value":0},{"name":"cal","value":0},{"name":"iron","value":0},{"name":"vit_e","value":0},{"name":"chol","value":0},{"name":"na","value":20},{"name":"zinc","value":0},{"name":"sel","value":0},{"name":"pufa","value":0}],"unit":"1 盒","weight":"330ml"}],"tokens":0.00,"total_nutritions":[{"name":"pro","value":48.16},{"name":"fat","value":25.26},{"name":"carb","value":113.7},{"name":"fiber","value":4.07},{"name":"vit_c","value":20.9},{"name":"kal","value":869.6},{"name":"mag","value":103.9},{"name":"folic","value":41},{"name":"cal","value":50.6},{"name":"iron","value":8.24},{"name":"vit_e","value":6.82},{"name":"chol","value":212},{"name":"na","value":543.88},{"name":"zinc","value":2.56},{"name":"sel","value":18.06},{"name":"pufa","value":3.66},{"name":"iod","value":0},{"name":"pot","value":1232},{"name":"phos","value":349}]}';
        FoodBusiness::instance()->syncRemote(json_decode($str, true));
        return ;*/
        $result = FoodService::unit(['馒头']);
        return $this->success('', $result);
        $result = FoodService::tag(['馒头']);
//        $result = Food::nutrition('我吃了一个馒头两碗米饭和三盒牛奶', NutritionInputType::TEXT);
//        Log::error('口子', $result);
        return response(json_encode($result));
//
//        $jsonString = '{"foods":[{"name":"黄焖鸡","unit":"1 份","weight":"300g","nutrition":[{"name":"protein","value":28},{"name":"fat","value":18},{"name":"carbohydrate","value":25},{"name":"fiber","value":3.5},{"name":"vitaminC","value":12},{"name":"vitaminK","value":15},{"name":"potassium","value":450},{"name":"magnesium","value":35},{"name":"folate","value":25},{"name":"calcium","value":30},{"name":"iron","value":2.5},{"name":"vitaminE","value":1.2}]},{"name":"米饭","unit":"2 碗","weight":"300g","nutrition":[{"name":"protein","value":6},{"name":"fat","value":1.5},{"name":"carbohydrate","value":90},{"name":"fiber","value":2},{"name":"vitaminC","value":0},{"name":"vitaminK","value":0.5},{"name":"potassium","value":100},{"name":"magnesium","value":25},{"name":"folate","value":40},{"name":"calcium","value":20},{"name":"iron","value":1.2},{"name":"vitaminE","value":0.3}]}],"total_nutritions":[{"name":"protein","value":34},{"name":"fat","value":19.5},{"name":"carbohydrate","value":115},{"name":"fiber","value":5.5},{"name":"vitaminC","value":12},{"name":"vitaminK","value":15.5},{"name":"potassium","value":550},{"name":"magnesium","value":60},{"name":"folate","value":65},{"name":"calcium","value":50},{"name":"iron","value":3.7},{"name":"vitaminE","value":1.5},{"name":"vitaminA","value":0},{"name":"vitaminD","value":0},{"name":"vitaminB1","value":0.3},{"name":"vitaminB6","value":0.4},{"name":"vitaminB12","value":0.8},{"name":"iodine","value":5},{"name":"sodium","value":400},{"name":"cholesterin","value":60},{"name":"se","value":10},{"name":"zn","value":2.5},{"name":"omega3","value":0.5}]}';
//        $data       = json_decode($jsonString, true);
//        $res        = FoodBusiness::instance()->syncRemote($data);
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
