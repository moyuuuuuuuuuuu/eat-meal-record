<?php

namespace app\model;

use app\model\BaseModel;

class MealRecordModel extends BaseModel
{
    protected $table    = 'meal_record';
    protected $fillable = [
        'user_id',
        'type',
        'kal',
        'protein',
        'fat',
        'carbo',
        'sugar',
        'fiber',
        'name',
        'address',
        'image',
        'latitude',
        'longitude',
    ];
    protected $guarded  = ['id'];

    public function foods()
    {
        return $this->hasMany(MealRecordFoodModel::class, 'meal_id', 'id')->with(['food', 'unit'])->select(['id', 'number', 'meal_id', 'food_id', 'unit_id', 'user_id', 'kal', 'protein', 'fat', 'carbo', 'sugar', 'fiber']);
    }
}
