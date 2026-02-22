<?php

namespace app\model;


use app\common\base\BaseModel;

class MealRecordFoodModel extends BaseModel
{
    protected $table      = 'meal_record_food';
    protected $primaryKey = 'id';

    protected $fillable = [
        'meal_id',
        'user_id',
        'food_id',
        'unit_id',
        'nutrition',
        'number',
        'image',
        'name',
    ];
    protected $casts = [
        'nutrition' => 'json',
    ];
}
