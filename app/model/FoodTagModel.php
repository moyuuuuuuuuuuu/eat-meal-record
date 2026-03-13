<?php

namespace app\model;

use app\common\base\BaseModel;

class FoodTagModel extends BaseModel
{
    const CREATED_AT = null;
    const UPDATED_AT = null;
    protected $table    = 'food_tags';
    protected $fillable = [
        'food_id',
        'tag_id',
    ];
}
