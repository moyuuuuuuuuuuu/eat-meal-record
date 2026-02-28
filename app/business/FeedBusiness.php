<?php

namespace app\business;

use app\service\baidu\Ibs;
use app\common\{base\BaseBusiness, validate\FeedValidator};
use app\common\enum\{blog\Visibility, BusinessCode, LikeFavType, NormalStatus};
use app\format\BlogFormat;
use app\model\{BlogAttachModel, BlogLocationModel, BlogModel, BlogTopicModel, FollowModel, LikeModel, TopicModel};
use support\{Db, Log, Request};
use support\exception\BusinessException;
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

        $page     = (int)$request->get('page', 1);
        $pageSize = (int)$request->get('pageSize', 10);

        $query = BlogModel::query();
        if (!$currentUserId) {
            $query->where('visibility', Visibility::EVERYONE->value);
        } else {
            $query->where(function ($q) use ($currentUserId) {
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
                                ->where($followTable . '.is_attention', NormalStatus::YES);
                        });
                });
            });
        }
        // 排序优先级：最新 > 点赞 > 浏览 > 收藏
        $query->orderByDesc('id')
            ->orderByDesc('likes')
            ->orderByDesc('views')
            ->orderByDesc('favs');
        $paginate = $query->paginate($pageSize, ['*'], 'page', $page);

        $blogFormat = (new BlogFormat($request));
        $paginate->getCollection()->transform(function ($item) use ($blogFormat) {
            return $blogFormat->format($item);
        });

        return $paginate->toArray();
    }

    public function detail(Request $request): array
    {
        return [
            'id'       => 1,
            'title'    => '今日份减脂餐',
            'content'  => '详细做法如下...',
            'comments' => [
                ['user' => '路人甲', 'text' => '学到了']
            ]
        ];
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
            $blog = BlogModel::query()->lockForUpdate()->find($blogId);
            if (!$blog) {
                throw new BusinessException('动态不存在', BusinessCode::BUSINESS_ERROR->value);
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
        return Db::transaction(function () use ($request) {
            $content     = $request->post('content');
            $topicIdList = $request->post('topic');
            $location    = $request->post('location');
            $attach      = $request->post('attach');
            $visibility  = $request->post('visibility', Visibility::EVERYONE->value);

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
                throw new BusinessException('动态发布失败', BusinessCode::BUSINESS_ERROR->value);
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
                $blogTopicInsertResult = BlogTopicModel::insert($batchTopicInsertList);
                if (!$blogTopicInsertResult) {
                    throw new BusinessException('动态话题保存失败', BusinessCode::BUSINESS_ERROR->value);
                }
                TopicModel::query()->whereIn('id', $topicIdList)->increment('join');
                if ($originTopicIdList) {
                    TopicModel::query()->whereIn('id', $originTopicIdList)->decrement('join');
                }
            }

            if ($location) {
                if (!empty($location['latitude']) && !empty($location['longitude']) && empty($location['address'])) {
                    $addressData = Ibs::instance()->getAddress($location['latitude'], $location['longitude']);
                    $location['address'] = ($addressData['addressComponent']['province'] ?? '') . ($addressData['addressComponent']['city'] ?? '');
                    $location['name']    = explode(',', $addressData['business']);
                    if (!empty($location['name'])) {
                        $location['name'] = array_pop($location['name']);
                    } else {
                        $location['name'] = $addressData['addressComponent']['city'] ?? '';
                    }
                }
                BlogLocationModel::query()->where('blog_id', $blogInfo->id)->delete();
                $blogLocationInfo = BlogLocationModel::create([
                    'blog_id'   => $blogInfo->id,
                    'latitude'  => $location['latitude'],
                    'longitude' => $location['longitude'],
                    'address'   => $location['address'] ?? '',
                    'name'      => $location['name'] ?? '',
                ]);
                if (!$blogLocationInfo) {
                    throw new BusinessException('动态位置信息保存失败', BusinessCode::BUSINESS_ERROR->value);
                }
            }

            if ($attach) {
                BlogAttachModel::query()->where('blog_id', $blogInfo->id)->delete();
                $attachInsertList = [];
                foreach ($attach as $key => $item) {
                    $attachInsertList[] = [
                        'blog_id' => $blogInfo->id,
                        'attach'  => $item['attach'],
                        'poster'  => $item['poster'],
                        'sort'    => $key,
                        'type'    => $item['type'],
                    ];
                }
                $attachInsertResult = BlogAttachModel::insert($attachInsertList);
                if (!$attachInsertResult) {
                    throw new BusinessException('动态附件保存失败', BusinessCode::BUSINESS_ERROR->value);
                }
            }
            return (new BlogFormat($request))->format($blogInfo);
        });
    }
}
