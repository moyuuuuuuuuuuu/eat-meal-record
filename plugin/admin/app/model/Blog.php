<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id (主键)
 * @property integer $user_id 用户id
 * @property string $title 标题
 * @property integer $likes 点赞数量
 * @property integer $views 查看数量
 * @property integer $comments 评论数量
 * @property integer $favs 收藏数量
 * @property string $content 
 * @property integer $visibility 状态 0隐藏 1所有人可见 2仅自己可见 3仅好友可见
 * @property string $created_at 创建时间
 * @property string $updated_at
 */
class Blog extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'blogs';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';
    
    
    
}
