<?php

namespace app\controller;

use app\business\FoodBusiness;
use support\Request;

class IndexController
{
    public function index(Request $request)
    {
        $jsonString = '{"foods":[{"name":"黄焖鸡","unit":"1 份","weight":"300g","nutrition":[{"name":"protein","value":28},{"name":"fat","value":18},{"name":"carbohydrate","value":25},{"name":"fiber","value":3.5},{"name":"vitaminC","value":12},{"name":"vitaminK","value":15},{"name":"potassium","value":450},{"name":"magnesium","value":35},{"name":"folate","value":25},{"name":"calcium","value":30},{"name":"iron","value":2.5},{"name":"vitaminE","value":1.2}]},{"name":"米饭","unit":"2 碗","weight":"300g","nutrition":[{"name":"protein","value":6},{"name":"fat","value":1.5},{"name":"carbohydrate","value":90},{"name":"fiber","value":2},{"name":"vitaminC","value":0},{"name":"vitaminK","value":0.5},{"name":"potassium","value":100},{"name":"magnesium","value":25},{"name":"folate","value":40},{"name":"calcium","value":20},{"name":"iron","value":1.2},{"name":"vitaminE","value":0.3}]}],"total_nutritions":[{"name":"protein","value":34},{"name":"fat","value":19.5},{"name":"carbohydrate","value":115},{"name":"fiber","value":5.5},{"name":"vitaminC","value":12},{"name":"vitaminK","value":15.5},{"name":"potassium","value":550},{"name":"magnesium","value":60},{"name":"folate","value":65},{"name":"calcium","value":50},{"name":"iron","value":3.7},{"name":"vitaminE","value":1.5},{"name":"vitaminA","value":0},{"name":"vitaminD","value":0},{"name":"vitaminB1","value":0.3},{"name":"vitaminB6","value":0.4},{"name":"vitaminB12","value":0.8},{"name":"iodine","value":5},{"name":"sodium","value":400},{"name":"cholesterin","value":60},{"name":"se","value":10},{"name":"zn","value":2.5},{"name":"omega3","value":0.5}]}';
        $data       = json_decode($jsonString, true);
        $res        = FoodBusiness::instance()->syncRemote($data);
        return response(json_encode($res));
    }

    public function view(Request $request)
    {
        return view('index/view', ['name' => 'webman']);
    }

    public function json(Request $request)
    {
        return json(['code' => 0, 'msg' => 'ok']);
    }

}
