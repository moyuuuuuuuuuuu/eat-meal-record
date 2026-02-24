<?php

namespace app\business;

use support\{Request, Db};
use support\exception\BusinessException;
use support\validation\annotation\Validate;
use app\common\enum\{BusinessCode, NormalStatus};
use app\common\{base\BaseBusiness, validate\FeedValidator};
use app\model\{TopicModel, BlogModel, BlogLocationModel, BlogAttachModel, BlogTopicModel};

class FeedBusiness extends BaseBusiness
{
    public function list(Request $request): array
    {
        return [
            ['id' => 1, 'title' => '今日份减脂餐', 'content' => '鸡胸肉+西兰花...', 'author' => '健康达人', 'likes' => 120],
            ['id' => 2, 'title' => '坚持运动第30天', 'content' => '打卡！', 'author' => '运动狂', 'likes' => 350]
        ];
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

    public function like(Request $request)
    {
        return ['status' => 'success', 'new_likes' => 121];
    }

    public function post(Request $request)
    {
        return [];
    }

    #[Validate(validator: FeedValidator::class, scene: 'create')]
    public function create(Request $request): array
    {
        return Db::transaction(function () use ($request) {
            $content     = $request->post('content');
            $topicIdList = $request->post('topics');
            $location    = $request->post('location');
            $attach      = $request->post('attach');

            $blogInfo = BlogModel::create([
                'user_id' => $request->userInfo->id,
                'content' => $content,
                'like'    => 0,
                'fav'     => 0,
                'view'    => 0,
                'comment' => 0
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
                    ->pluck('id');
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
                BlogLocationModel::query()->where('blog_id', $blogInfo->id)->delete();
                $blogLocationInfo = BlogLocationModel::create([
                    'blog_id'   => $blogInfo->id,
                    'latitude'  => $location['latitude'],
                    'longitude' => $location['longitude'],
                    'address'   => $location['address'],
                    'name'      => $location['name'],
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
            return $blogInfo->format();
        });
    }
}
