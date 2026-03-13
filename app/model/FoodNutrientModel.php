<?php

namespace app\model;

use app\common\base\BaseModel;

class FoodNutrientModel extends BaseModel
{
    const CREATED_AT = null;
    const UPDATED_AT = null;
    protected $table    = 'food_nutrients';
    protected $fillable = [
        'food_id', 'water', 'kcal', 'pro', 'fat', 'carb', 'sugar', 'fiber', 'chol',
        'purine', 'gi', 'vit_a', 'vit_c', 'vit_d', 'vit_e', 'folic', 'na', 'cal',
        'iron', 'kal', 'mag', 'zinc', 'sel', 'cup', 'mang', 'iod', 'fa', 'sfa',
        'mufa', 'pufa', 'origin'
    ];
}
