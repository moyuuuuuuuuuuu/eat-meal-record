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

    public function format()
    {
        $attachList = $this->attachs();
        return [
            'location'   => $this->location?->toArray(),
            'attach'     => $attachList,
            'content'    => $this->content,
            'topics'     => $this->topics->toArray(),
            'like'       => $this->like,
            'view'       => $this->view,
            'fav'        => $this->fav,
            'comment'    => $this->comment,
            'status'     => $this->status,
            'user'       => $this->user->toArray(),
            'created_at' => Carbon::parse($this->created_at)->format('Y-m-d H:i:s'),
        ];
    }

    public function user()
    {
        return $this->hasOne(UserModel::class, 'id', 'user_id')->select('nickname', 'avatar');
    }

    public function location()
    {
        return $this->hasOne(BlogLocationModel::class, 'blog_id', 'id');
    }

    public function attachs()
    {
        return BlogAttachModel::query()->where('blog_id', $this->id)->select(['attach', 'poster', 'type'])->orderBy('sort')->get()->transform(function ($item) {
            return $item->format();
        });
    }

    public function topics()
    {
        return $this->belongsToMany(TopicModel::class, 'blog_topic', 'blog_id', 'topic_id')
            ->where('status', NormalStatus::YES->value)
            ->select([
                'topics.id',
                'topics.title',
                'topics.join',
                'topics.thumb',
                'topics.description'
            ]);
    }
}
