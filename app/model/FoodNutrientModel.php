<?php

namespace app\model;

use app\common\base\BaseModel;

class FoodNutrientModel extends BaseModel
{
    const CREATED_AT = null;
    const UPDATED_AT = null;
    protected $table    = 'food_nutrients';
    protected $fillable = [
        'food_id',
        'water',
        'sugar',
        'kcal',
        'protein',
        'fat',
        'carbohydrate',
        'fiber',
        'sodium',
        'cholesterol',
        'vitamin_a',
        'calcium',
        'iron',
        'kalium',
        'magnesium',
        'zinc',
        'selenium',
        'cuprum',
        'manganese',
        'iodine',
        'folic',
        'fatty_acid',
        'saturated_fatty_acid',
        'monounsaturated_fatty_acid',
        'polyunsaturated_fatty_acid',
        'origin_place'
    ];
}
