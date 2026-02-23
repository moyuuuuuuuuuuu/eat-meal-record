<?php

namespace app\model;

use app\common\base\BaseModel;

/**
 * @property int $user_id
 * @property string $title
 * @property int $like
 * @property int $view
 * @property int $comment
 * @property int $fav
 * @property string $content
 * @property int $status
 *
 */
class BlogModel extends BaseModel
{
    protected $table = 'blog';

    protected $fillable = [
        'user_id',
        'title',
        'like',
        'view',
        'comment',
        'fav',
        'content',
        'status'
    ];
}
