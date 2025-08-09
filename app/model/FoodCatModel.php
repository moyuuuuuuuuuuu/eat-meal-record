<?php

namespace app\model;

use app\model\BaseModel;

class FoodCatModel extends BaseModel
{
    protected $table    = 'food_cat';
    protected $fillable = ['name', 'pid', 'sort'];
}
