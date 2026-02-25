<?php

namespace app\model;

use app\common\base\BaseModel;

class BlogTopicModel extends BaseModel
{
    protected $table    = 'blog_topic';
    protected $fillable = [
        'blog_id',
        'topic_id'
    ];
}
