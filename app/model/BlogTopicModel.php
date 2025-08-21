<?php

namespace app\model;

use app\model\BaseModel;

class BlogTopicModel extends BaseModel
{
    protected $table      = 'blog_topic';
    protected $fillable   = ['blog_id', 'topic_id'];
    public    $timestamps = false;
}
