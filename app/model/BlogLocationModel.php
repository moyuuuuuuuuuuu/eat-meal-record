<?php

namespace app\model;

use app\common\base\BaseModel;

class BlogLocationModel extends BaseModel
{
    const CREATED_AT = null;
    const UPDATED_AT = null;
    protected $table    = 'blog_locations';
    protected $fillable = [
        'blog_id',
        'latitude',
        'longitude',
        'address',
        'name'
    ];
}
