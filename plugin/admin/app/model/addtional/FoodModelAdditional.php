<?php

namespace plugin\admin\app\model\addtional;

use plugin\admin\app\model\Dict;
use plugin\admin\app\model\Food;
use plugin\admin\app\model\FoodNutrient;

class FoodModelAdditional extends Food
{

    protected $appends = [
        'user',
        'nutrition',
    ];

    public function getNutritionAttribute()
    {
        $data          = FoodNutrient::query()->where('food_id', $this->id)->first();
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
