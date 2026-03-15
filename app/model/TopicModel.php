<?php

namespace app\model;

use app\common\base\BaseModel;
use Illuminate\Database\Eloquent\SoftDeletes;

class TopicModel extends BaseModel
{
    use SoftDeletes;

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
