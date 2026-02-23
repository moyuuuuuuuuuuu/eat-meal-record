<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id (主键)
 * @property integer $user_id 所属用户
 * @property string $title 标题
 * @property integer $like 点赞数量
 * @property integer $view 查看数量
 * @property integer $comment 评论数量
 * @property integer $fav 收藏数量
 * @property string $content 动态内容
 * @property integer $status 状态
 * @property string $created_at 创建时间
 * @property string $updated_at 编辑时间
 */
class Blog extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'blog';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';
    
    
    
}
