<?php

namespace app\model;


use app\business\FoodBusiness;
use app\common\base\BaseModel;

class MealRecordFoodModel extends BaseModel
{
    protected $table      = 'meal_record_foods';
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
    protected $casts    = [
        'nutrition' => 'json',
    ];

    public function food()
    {
        return $this->hasOne(FoodModel::class, 'id', 'food_id')->select('id', 'name');
    }

    public function unit()
    {
        return $this->hasOne(UnitModel::class, 'id', 'unit_id')->select('id','name');
    }
}
