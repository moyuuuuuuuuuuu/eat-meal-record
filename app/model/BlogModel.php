<?php

namespace app\model;

use app\model\traits\InteractiveTrait;

class BlogModel extends BaseModel
{
    use InteractiveTrait;

    const CITY_RADIUS        = 100;
    const STATUS_LIST        = [0, 1, 2, 3];
    const STATUS_HIDDEN      = 0;
    const STATUS_NORMAL      = 1;
    const STATUS_ONLY_ME     = 2;
    const STATUS_ONLY_FRIEND = 3;

    protected $table = 'blog';

    protected $appends = [
        'isLike',
        'isFav',
    ];


    protected $beginFormatTime = true;

    protected $fillable = [
        'user_id',
        'title',
        'like_count',
        'view_count',
        'comment_count',
        'fav_count',
        'content',
        'status',
    ];

    public function getIsLikeAttribute()
    {
        if (request()->userId !== null) {
            return LikeModel::where('user_id', request()->userId)->where('type', LikeModel::TYPE_BLOG)->where('target', $this->id)->first() !== null;
        }
        return false;
    }

    public function getIsFavAttribute()
    {
        if (request()->userId !== null) {
            return FavoriteModel::where('user_id', request()->userId)->where('type', FavoriteModel::TYPE_BLOG)->where('target', $this->id)->first() !== null;
        }
        return false;
    }

    public function topic()
    {
        return $this->hasManyThrough(TopicModel::class, BlogTopicModel::class, 'blog_id', 'id', 'id', 'topic_id');
    }

    public function attach()
    {
        return $this->hasMany(BlogAttachModel::class, 'blog_id', 'id');
    }

    public function location()
    {
        return $this->hasOne(BlogLocationModel::class, 'blog_id', 'id');
    }

    public function author()
    {
        return $this->hasOne(UserModel::class, 'id', 'user_id')->select(['id', 'name', 'avatar']);
    }

}
