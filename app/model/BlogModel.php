<?php

namespace app\model;

use app\common\base\BaseModel;
use app\common\enum\NormalStatus;
use Carbon\Carbon;

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
    protected $table = 'blogs';

    protected $fillable = [
        'user_id',
        'title',
        'like',
        'view',
        'comment',
        'fav',
        'content',
        'visibility'
    ];

    public function user()
    {
        return $this->hasOne(UserModel::class, 'id', 'user_id')->select('id', 'nickname', 'avatar');
    }

    public function location()
    {
        return $this->hasOne(BlogLocationModel::class, 'blog_id', 'id');
    }


    public function topics()
    {
        $topicTable = (new TopicModel())->getTable();
        $blogTopicTable = (new BlogTopicModel())->getTable();
        return $this->belongsToMany(TopicModel::class, $blogTopicTable, 'blog_id', 'topic_id')
            ->where('status', NormalStatus::YES->value)
            ->select([
                $topicTable . '.id',
                $topicTable . '.title',
                $topicTable . '.join',
                $topicTable . '.thumb',
                $topicTable . '.description'
            ]);
    }
}
