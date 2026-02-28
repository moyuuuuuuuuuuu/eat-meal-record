<?php

namespace app\format;

use Carbon\Carbon;
use app\common\base\{BaseFormat, BaseModel};
use app\model\{FavoriteModel, FollowModel, BlogAttachModel, LikeModel};

class BlogFormat extends BaseFormat
{
    public function format(?BaseModel $model = null): array
    {
        return [
            'id'         => $model->id,
            'content'    => $model->content,
            'likes'       => $model->likes,
            'views'       => $model->views,
            'favs'        => $model->favs,
            'comments'    => $model->comments,
            'status'     => $model->status,
            'is_like'    => LikeModel::isLiked($this->request?->userInfo?->id, $model->id),
            'is_fav'     => FavoriteModel::isFav($this->request?->userInfo?->id, $model->id),
            'created_at' => Carbon::parse($model->created_at)->format('Y-m-d H:i:s'),
            'author'       => $this->author($model),
            'topics'     => $this->topic($model),
            'attach'     => $this->attach($model),
            'location'   => $this->location($model),
            'comment_list'   => []
        ];
    }

    public function location(BaseModel $model): ?array
    {
        return $model->location?->toArray();
    }

    public function author(BaseModel $model): array
    {
        $userInfo = $model->user?->toArray();
        if ($this->request?->userInfo?->id != $model->user_id) {
            $userInfo['follow'] = FollowModel::isAttention($this->request?->userInfo?->id, $model->user_id);
        }
        return $userInfo;
    }

    public function topic($model): ?array
    {
        return $model->topics?->toArray();
    }

    public function attach($model): ?array
    {
        $blogAttachFormat = (new BlogAttachFormat($this->request));
        return BlogAttachModel::query()
            ->select(['attach', 'poster', 'type'])
            ->where('blog_id', $model->id)
            ->orderBy('sort')
            ->get()->transform(function ($item) use ($blogAttachFormat) {
                return $blogAttachFormat->format($item);
            })->toArray();
    }
}
