<?php

namespace app\business;

use app\service\baidu\Solution;
use app\common\{base\BaseBusiness, exception\DataNotFoundException, validate\FeedValidator};
use app\common\enum\{blog\AttachType, blog\Visibility, BusinessCode, LikeFavType, NormalStatus};
use app\common\enum\QueueEventName;
use app\format\BlogFormat;
use app\model\{BlogAttachModel, BlogLocationModel, BlogModel, BlogTopicModel, FavoriteModel, FollowModel, LikeModel, TopicModel};
use app\service\baidu\Ibs;
use support\{Db, Request};
use app\common\exception\BusinessException;
use Webman\RedisQueue\Client;
use Webman\Validation\Annotation\Validate;

class FeedBusiness extends BaseBusiness
{
    /**
     * 动态列表
     * @param Request $request
     * @return array
     */
    public function list(Request $request): array
    {
        $currentUserId = $request->userInfo->id ?? null;

        $page     = max(1, (int)$request->get('page', 1));
        $pageSize = max(1, min((int)$request->get('pageSize', 10), 50));

        $query = $this->visibleBlogQuery($currentUserId)->with(['user', 'topics', 'location', 'attaches']);
        // 排序优先级：最新 > 点赞 > 浏览 > 收藏
        $query->orderByDesc('id')
            ->orderByDesc('likes')
            ->orderByDesc('views')
            ->orderByDesc('favs');
        $paginate = $query->paginate($pageSize, ['*'], 'page', $page);

        $blogFormat     = $this->makeBlogFormat($request, $paginate->getCollection());
        $increaseIdList = [];
        $paginate->getCollection()->transform(function ($item) use ($blogFormat, &$increaseIdList) {
            $increaseIdList[] = $item->id;
            return $blogFormat->format($item);
        });
        if ($increaseIdList) {
            Client::send(QueueEventName::FeedViewIncrease->value, [
                'viewer' => hash('sha256', ($currentUserId ?: $request->getRealIp()) . '|' . $request->header('user-agent', '')),
                'ids'    => $increaseIdList,
            ]);
        }
        return $paginate->toArray();
    }

    public function detail(Request $request): array
    {
        $blogId = $request->get('id');
        $blog   = $this->visibleBlogQuery($request->userInfo->id ?? null)
            ->with(['user', 'topics', 'location', 'attaches'])
            ->where('id', $blogId)
            ->first();
        if (empty($blog)) {
            throw new DataNotFoundException();
        }

        return $this->makeBlogFormat($request, collect([$blog]))->format($blog);
    }

    /**
     * 点赞动态
     * @param Request $request
     * @return mixed
     */
    #[Validate(validator: FeedValidator::class, scene: 'like')]
    public function like(Request $request)
    {
        $userId = $request->userInfo->id;
        $blogId = $request->post('id');

        return Db::transaction(function () use ($userId, $blogId) {
            $blog = $this->visibleBlogQuery($userId)->lockForUpdate()->find($blogId);
            if (!$blog) {
                throw new DataNotFoundException('动态不存在');
            }
            $blogLikes = $blog->likes;

            $like = LikeModel::where('user_id', $userId)
                ->where('target', $blogId)
                ->where('type', LikeFavType::BLOG->value)
                ->first();

            if ($like) {
                // 取消点赞
                $like->delete();
                $blog->decrement('likes');
                $blogLikes--;
                $isLike = false;
            } else {
                // 点赞
                LikeModel::create([
                    'user_id' => $userId,
                    'target'  => $blogId,
                    'type'    => LikeFavType::BLOG->value,
                ]);
                $blog->increment('likes');
                $blogLikes++;
                $isLike = true;
            }

            return [
                'isLike' => $isLike,
                'likes'  => $blogLikes
            ];
        });
    }

    public function post(Request $request)
    {
        return [];
    }

    /**
     * 新增动态
     * @param Request $request
     * @return array
     */
    #[Validate(validator: FeedValidator::class, scene: 'create')]
    public function create(Request $request): array
    {
        $userId      = $request->userInfo->id;
        $content     = $request->post('content');
        $topicIdList = $request->post('topic', []);
        $location    = $request->post('location');
        $attach      = $request->post('attach');
        $visibility  = $request->post('visibility', Visibility::EVERYONE->value);

        $recordIds = collect($attach)
            ->filter(fn(array $item) => (int)$item['type'] === AttachType::RECORD->value)
            ->pluck('attach')
            ->map(fn($id) => (int)$id)
            ->unique()
            ->values()
            ->all();
        if ($recordIds) {
            $ownedRecordCount = \app\model\MealRecordModel::query()
                ->where('user_id', $userId)
                ->whereIn('id', $recordIds)
                ->count();
            if ($ownedRecordCount !== count($recordIds)) {
                throw new BusinessException('餐食记录不存在或无权使用', BusinessCode::PARAM_ERROR);
            }
        }

        $solution = Solution::instance();
        $solution->text($content);
        foreach ($attach as $item) {
            $attachType = AttachType::tryFrom((int)$item['type']);
            if ($attachType === AttachType::IMG) {
                $solution->image($item['attach']);
            } elseif ($attachType === AttachType::VIDEO) {
                $solution->video($item['attach']);
            }
        }

        if ($location && !empty($location['latitude']) && !empty($location['longitude']) && empty($location['address'])) {
            $addressData = Ibs::instance()->getAddress($location['latitude'], $location['longitude']);
            $location['address'] = ($addressData['addressComponent']['province'] ?? '') . ($addressData['addressComponent']['city'] ?? '');
            $businessAreas = explode(',', $addressData['business'] ?? '');
            $location['name'] = array_pop($businessAreas) ?: ($addressData['addressComponent']['city'] ?? '');
        }

        return Db::transaction(function () use ($request, $content, $topicIdList, $location, $attach, $visibility) {
            $blogInfo = BlogModel::create([
                'user_id'    => $request->userInfo->id,
                'content'    => $content,
                'likes'      => 0,
                'favs'       => 0,
                'views'      => 0,
                'comments'   => 0,
                'visibility' => $visibility,
            ]);
            if (!$blogInfo) {
                throw new BusinessException('动态发布失败', BusinessCode::BUSINESS_ERROR);
            }

            if ($topicIdList) {
                $originTopicIdList = BlogTopicModel::query()->where('blog_id', $blogInfo->id)->pluck('topic_id')->toArray();
                BlogTopicModel::query()->where('blog_id', $blogInfo->id)->delete();
                $topicList            = TopicModel::query()
                    ->whereIn('id', $topicIdList)
                    ->where('status', NormalStatus::YES->value)
                    ->pluck('id')->toArray();
                $batchTopicInsertList = [];
                foreach ($topicList as $topic) {
                    $batchTopicInsertList[] = [
                        'topic_id' => $topic,
                        'blog_id'  => $blogInfo->id,
                    ];
                }
                $blogTopicInsertResult = $batchTopicInsertList && BlogTopicModel::insert($batchTopicInsertList);
                if ($batchTopicInsertList && !$blogTopicInsertResult) {
                    throw new BusinessException('动态话题保存失败', BusinessCode::BUSINESS_ERROR->value);
                }
                TopicModel::query()->whereIn('id', $topicList)->increment('join');
                if ($originTopicIdList) {
                    TopicModel::query()->whereIn('id', $originTopicIdList)->decrement('join');
                }
            }

            if ($location) {
                BlogLocationModel::query()->where('blog_id', $blogInfo->id)->delete();
                $blogLocationInfo = BlogLocationModel::create([
                    'blog_id'   => $blogInfo->id,
                    'latitude'  => $location['latitude'],
                    'longitude' => $location['longitude'],
                    'address'   => $location['address'] ?? '',
                    'name'      => $location['name'] ?? '',
                ]);
                if (!$blogLocationInfo) {
                    throw new BusinessException('动态位置信息保存失败', BusinessCode::BUSINESS_ERROR);
                }
            }

            if ($attach) {
                BlogAttachModel::query()->where('blog_id', $blogInfo->id)->delete();
                $attachInsertList = [];
                foreach ($attach as $key => $item) {
                    if (!empty($item['poster'])) {
                        $item['poster'] = '/' . ltrim($item['poster'], '/');
                    }

                    if (in_array($item['type'], [AttachType::VIDEO->value, AttachType::IMG->value]) && !empty($item['attach'])) {
                        $item['attach'] = '/' . ltrim($item['attach'], '/');
                    }

                    $attachInsertList[] = [
                        'blog_id' => $blogInfo->id,
                        'attach'  => $item['attach'],
                        'poster'  => $item['poster'] ?? '',
                        'sort'    => $key,
                        'type'    => $item['type'],
                    ];
                }
                $attachInsertResult = BlogAttachModel::insert($attachInsertList);
                if (!$attachInsertResult) {
                    throw new BusinessException('动态附件保存失败', BusinessCode::BUSINESS_ERROR);
                }
            }
            return (new BlogFormat($request))->format($blogInfo);
        });
    }

    private function visibleBlogQuery(?int $currentUserId)
    {
        $query = BlogModel::query();
        if (!$currentUserId) {
            return $query->where('visibility', Visibility::EVERYONE->value);
        }

        return $query->where(function ($q) use ($currentUserId) {
            // 公开
            $q->where('visibility', Visibility::EVERYONE->value);
            // 仅自己
            $q->orWhere(function ($sq) use ($currentUserId) {
                $sq->where('visibility', Visibility::SELF->value)
                    ->where('user_id', $currentUserId);
            });
            // 仅好友（互相关注）
            $q->orWhere(function ($sq) use ($currentUserId) {
                $sq->where('visibility', Visibility::FRIEND->value)
                    ->whereExists(function ($sub) use ($currentUserId) {
                        $followTable = (new FollowModel())->getTable();
                        $blogTable   = (new BlogModel())->getTable();
                        $sub->select(Db::raw(1))
                            ->from($followTable)
                            ->whereColumn($followTable . '.follow_id', $blogTable . '.user_id')
                            ->where($followTable . '.user_id', $currentUserId)
                            ->where($followTable . '.is_attention', NormalStatus::YES->value);
                    })
                    ->whereExists(function ($sub) use ($currentUserId) {
                        $followTable = (new FollowModel())->getTable();
                        $blogTable   = (new BlogModel())->getTable();
                        $sub->select(Db::raw(1))
                            ->from($followTable)
                            ->whereColumn($followTable . '.user_id', $blogTable . '.user_id')
                            ->where($followTable . '.follow_id', $currentUserId)
                            ->where($followTable . '.is_attention', NormalStatus::YES->value);
                    });
            });
        });
    }

    private function makeBlogFormat(Request $request, $blogs): BlogFormat
    {
        $currentUserId = $request->userInfo->id ?? null;
        if (!$currentUserId || $blogs->isEmpty()) {
            return (new BlogFormat($request))->withInteractions([], [], []);
        }

        $blogIds = $blogs->pluck('id')->all();
        $authorIds = $blogs->pluck('user_id')->unique()->all();
        $likedIds = LikeModel::query()
            ->where('user_id', $currentUserId)
            ->where('type', LikeFavType::BLOG->value)
            ->whereIn('target', $blogIds)
            ->pluck('target')->all();
        $favoredIds = FavoriteModel::query()
            ->where('user_id', $currentUserId)
            ->where('type', LikeFavType::BLOG->value)
            ->whereIn('target', $blogIds)
            ->pluck('target')->all();
        $followedUserIds = FollowModel::query()
            ->where('user_id', $currentUserId)
            ->whereIn('follow_id', $authorIds)
            ->pluck('follow_id')->all();

        return (new BlogFormat($request))->withInteractions($likedIds, $favoredIds, $followedUserIds);
    }
}
