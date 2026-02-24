<?php

namespace app\model;

use app\common\base\BaseModel;

class TopicModel extends BaseModel
{
    protected $table = 'topics';

    protected $fillable = [
        'title',
        'thumb',
        'description',
        'status',
        'join',
        'post'
    ];
}
