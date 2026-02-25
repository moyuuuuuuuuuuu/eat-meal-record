<?php

namespace app\model;

use app\common\base\BaseModel;
use app\common\enum\blog\AttachType;
use app\common\enum\NormalStatus;

class BlogAttachModel extends BaseModel
{
    protected $table = 'blog_attach';

    protected $fillable = [
        'blog_id',
        'attach',
        'poster',
        'sort',
        'type'
    ];
}
