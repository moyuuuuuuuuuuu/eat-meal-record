<?php

namespace app\format;

use app\common\base\{BaseFormat, BaseModel};
use Carbon\Carbon;

class BlogFormat extends BaseFormat
{
    private array $likedIds = [];
    private array $favoredIds = [];
    private array $followedUserIds = [];

    public function withInteractions(array $likedIds, array $favoredIds, array $followedUserIds): self
    {
        $this->likedIds = array_fill_keys($likedIds, true);
        $this->favoredIds = array_fill_keys($favoredIds, true);
        $this->followedUserIds = array_fill_keys($followedUserIds, true);
        return $this;
    }

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
            'is_like'    => isset($this->likedIds[$model->id]),
            'is_fav'     => isset($this->favoredIds[$model->id]),
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
        $userInfo = $model->user?->toArray() ?? [];
        if ($this->request?->userInfo?->id != $model->user_id) {
            $userInfo['follow'] = isset($this->followedUserIds[$model->user_id]);
        }
        return $userInfo;
    }

    public function topic($model): ?array
    {
        return $model->topics?->toArray();
    }

    public function attach($model): ?array
    {
        $blogAttachFormat = (new BlogAttachFormat($this->request))->forBlogOwner((int)$model->user_id);
        return $model->attaches->transform(function ($item) use ($blogAttachFormat) {
                return $blogAttachFormat->format($item);
            })->toArray();
    }
}
