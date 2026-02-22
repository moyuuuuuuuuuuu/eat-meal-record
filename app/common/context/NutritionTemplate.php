<?php

namespace app\common\context;

use Illuminate\Support\Facades\Cache;
use plugin\admin\app\model\Dict;

class NutritionTemplate
{
    const KEY_NAME = 'nutrition';
    static $instance;

    private function __construct(){

    }
    static function instance(){
        if(!self::$instance instanceof self){
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function template(){
        if(!Cache::has(self::KEY_NAME)){
            $nutritionTemplate = Dict::get(self::KEY_NAME);
            Cache::add(self::KEY_NAME, $nutritionTemplate);
        }else{
            $nutritionTemplate = Cache::get(self::KEY_NAME);
        }
        return $nutritionTemplate;
    }

    public function merge(array $nutrition){
        return array_merge($this->template(), $nutrition);
    }
}
