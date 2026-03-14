<?php

namespace app\model;

use app\common\base\BaseModel;

class UserUsageModel extends BaseModel
{
    const UPDATED_AT = null;
    protected $fillable = [
        'user_id',
        'usage',
        'token',
        'date'
    ];
}
