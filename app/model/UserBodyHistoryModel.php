<?php

namespace app\model;

use app\model\BaseModel;

class UserBodyHistoryModel extends BaseModel
{
    protected $table    = 'user_body_history';
    protected $fillable = [
        'user_id',
        'tall',
        'weight',
        'bmi',
        'bust',
        'waist',
        'hip',
    ];
    protected $guarded  = ['id'];
}
