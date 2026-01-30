<?php

namespace plugin\admin\app\model;

use Illuminate\Database\Eloquent\SoftDeletes;

class FoodUnit extends Base
{
    use SoftDeletes;

    protected $table    = 'food_units';
    protected $fillable = [
        'name',
        'cat_id',
        'user_id',
        'status',
        'nutrition',
    ];
}
