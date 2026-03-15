<?php

namespace app\model;

use app\common\base\BaseModel;

class BlogAttachModel extends BaseModel
{
    protected $table = 'blog_attaches';

    protected $fillable = [
        'blog_id',
        'attach',
        'poster',
        'sort',
        'type'
    ];
}
