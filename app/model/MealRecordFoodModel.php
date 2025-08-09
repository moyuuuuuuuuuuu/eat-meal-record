<?php

namespace app\model;

use app\model\BaseModel;

class MealRecordFoodModel extends BaseModel
{
    protected $table    = 'meal_record_food';
    protected $fillable = [
        'meal_id',
        'user_id',
        'unit_id',
        'food_id',
        'number',
        'kal',
        'protein',
        'fat',
        'sugar',
        'carbo',
    ];
    protected $guarded  = ['id'];

    public function food()
    {
        return $this->belongsTo(FoodModel::class, 'food_id', 'id')->select('id', 'name', 'kal');
    }

    public function unit()
    {
        return $this->belongsTo(FoodUnitModel::class, 'unit_id', 'id')->select('id', 'name');
    }

}
