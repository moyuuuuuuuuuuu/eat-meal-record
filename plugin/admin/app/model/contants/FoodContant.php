<?php

namespace plugin\admin\app\model\contants;

use plugin\admin\app\model\Dict;
use plugin\admin\app\model\Food;

class FoodContant extends Food
{
    protected $appends = [
        'user'
    ];

    public function getNutritionAttribute(string $value)
    {
        $data          = json_decode($value, true);
        $nutritionDict = (array)Dict::get('nutrition');
        $nutrition     = [];
        foreach ($nutritionDict as $item) {
            if (isset($data[$item['value']])) {
                $nutrition[$item['name']] = $data[$item['value']];
            }
        }
        return json_encode($nutrition, JSON_UNESCAPED_UNICODE);
    }

    public function getUserAttribute()
    {
        return $this->user();
    }

}
