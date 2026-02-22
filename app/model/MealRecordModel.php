<?php

namespace app\model;


use app\common\base\BaseModel;

class MealRecordModel extends BaseModel
{
    protected $table      = 'meal_record';
    protected $primaryKey = 'id';
    protected $fillable = [
        'user_id',
        'type',
        'nutrition',
        'meal_date',
        'latitude',
        'longitude',
        'address',
    ];
    protected $casts = [
        'nutrition' => 'json',
        'user_id'   => 'integer',
        'type'      => 'integer',
        'meal_date' => 'date',
        'latitude'  => 'float',
        'longitude' => 'float',
        'address'   => 'string',
    ];

    public function food(){}
}
