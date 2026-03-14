<?php

namespace plugin\admin\app\model;

use app\model\BlogLocationModel;
use app\model\BlogTopicModel;
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

    const VisitibilityTextMap  = [
        '已隐藏',
        '公开',
        '秘密',
        '好友可见'
    ];
    const VisitibilityClassMap = [
        'layui-bg-gray',
        'layui-bg-green',
        'layui-bg-blue',
        'layui-bg-orange'
    ];

    static function getVisibility($visibility)
    {
        return [
            'text'  => self::VisitibilityTextMap[$visibility],
            'class' => self::VisitibilityClassMap[$visibility]
        ];
    }

    public function userInfo(){
        return $this->hasOne(User::class,'id','user_id')->select(['id','nickname','avatar','username']);
    }

    public function location(){
        return $this->hasOne(BlogLocationModel::class ,'blog_id','id');
    }

    public function topics(){
        return $this->hasManyThrough(Topic::class,BlogTopicModel::class ,'blog_id','id','id','topic_id');
    }

}
