<?php

namespace app\controller;

use app\model\BlogAttachModel;
use app\model\BlogLocationModel;
use app\model\BlogModel;
use app\model\BlogTopicModel;
use app\model\FollowModel;
use app\model\LikeModel;
use support\Db;
use support\Log;
use support\Request;

class BlogController extends BaseController
{
    public function create(Request $request)
    {
        $attachList = $request->getParam('attach', [], 'a');
        $content    = $request->getParam('content', '');
        $location   = $request->getParam('location', [], 'a');
        $status     = $request->getParam('status', 1);
        $topicId    = $request->getParam('topicId', 0);
        $userId     = $request->userId;

        if (!$content && empty($attachList)) {
            return $this->error(1005, '内容不能为空');
        }

        if (!in_array($status, BlogModel::STATUS_LIST)) {
            return $this->error(1005, '添加失败');
        }

        Db::beginTransaction();
        try {
            $blog = BlogModel::create([
                'user_id' => $userId,
                'content' => $content,
                'status'  => $status,
            ]);
            if (!empty($attachList)) {
                BlogAttachModel::where('blog_id', $blog->id)->delete();
                $blogAttach = [];
                foreach ($attachList as $type => $item) {
                    $blogAttach = array_merge($blogAttach, BlogAttachModel::handle($item, $type, $blog->id));
                }
                if ($blogAttach) {
                    BlogAttachModel::insert($blogAttach);
                }
            }
            if (!empty($location)) {
                $location['blog_id'] = $blog->id;
                BlogLocationModel::create($location);
            }
            if ($topicId) {
                BlogTopicModel::create([
                    'blog_id'  => $blog->id,
                    'topic_id' => $topicId,
                ]);
            }
            Db::commit();
            return $this->success('已发布', [
                'id' => $blog->id,
            ]);
        } catch (\Exception $e) {
            Db::rollBack();
            Log::error('发布失败：' . $e->getMessage(), [
                'user_id' => $userId,
                'trace'   => $e->getTrace(),
            ]);
            return $this->error(1005, '发布失败');
        }
    }

    /**
     * 列表
     * @param Request $request
     * @param string $type friend|recommend|nearby|mine|user|topic|like 好友|推荐|同城|我的|指定用户|指定话题|点赞
     * @param int $id 指定用户|指定话题 时必填
     * @return \support\Response|void
     */
    public function list(Request $request, string $type = 'recommend', int $id = 0)
    {
        try {

            $userId    = $request->userId ?? 0;
            $page      = $request->getParam('page', 1, 'i');
            $limit     = $request->getParam('limit', 10, 'i');
            $topicId   = $request->getParam('topic', 0, 'i');
            $latitude  = $request->getParam('latitude', 0, 'f');
            $longitude = $request->getParam('longitude', 0, 'f');

            #TODO:是否关联最热的单条或者多条评论
            $query = BlogModel::query()->with(['author', 'attach', 'location', 'topic']);
            match ($type) {
                'friends' => $query->whereIn('user_id', FollowModel::getFriendsUserId($userId))->whereNotIn('status', [BlogModel::STATUS_ONLY_ME, BlogModel::STATUS_HIDDEN])->orderByDesc('created_at'),
                'mine' => $query->where('user_id', $userId)->orderByDesc('created_at'),
                'recommend' => $query->whereNotIn('status', [BlogModel::STATUS_ONLY_ME, BlogModel::STATUS_HIDDEN])->orderBy('id', 'desc')->orderBy('like_count', 'desc'),
                'topic' => $query->whereHas('topic', function ($query) use ($topicId) {
                    $query->where('topic_id', $topicId);
                })->orderBy('id', 'desc')->orderBy('like_count', 'desc'),
                'like' => $query->whereIn('id', LikeModel::getTargetIdList($userId, $id, LikeModel::TYPE_BLOG, true))->orderBy('id', 'desc'),
                'user' => $query->where('user_id', $id)->whereNotIn('status', [BlogModel::STATUS_ONLY_ME, BlogModel::STATUS_HIDDEN])->orderByDesc('created_at'),
                'nearby' => $query->join('user', 'user.id', '=', 'blog.user_id')->where('user_id', $userId)
                    ->whereNotIn('blog.status', [BlogModel::STATUS_ONLY_ME, BlogModel::STATUS_HIDDEN])
                    ->select('blog.*,distance')
                    ->selectRaw("
                (6371 * acos(
                    cos(radians(?)) * cos(radians(blog_location.latitude)) *
                    cos(radians(blog_location.longitude) - radians(?)) +
                    sin(radians(?)) * sin(radians(blog_location.latitude))
                )) AS distance
            ", [$latitude, $longitude, $latitude])
                    ->having('distance', '<', BlogModel::CITY_RADIUS)
                    ->orderBy('distance', 'asc')
                    ->orderByDesc('like_count')
                    ->orderByDesc('id'),
                'default' => throw new \Exception('不存在的列表类型')
            };
            $maxPage = 0;
            if ($page <= 1) {
                $cloneQuery = clone $query;
                $total      = $query->count();
                $maxPage    = ceil($total / $limit);
                unset($cloneQuery);
            }
            $list = $query->offset(($page - 1) * $limit)->limit($limit)->get();
            if ($list->isEmpty()) {
                return $this->success('暂无数据', [
                    'list'       => $list,
                    'maxPage'    => $maxPage,
                    'currentTab' => $type,
                ]);
            }
            $list       = $list->toArray();
            $viewIdList = [];
            foreach ($list as &$item) {
                $item         = array_merge($item, BlogAttachModel::getAttachList($item['attach']));
                $viewIdList[] = $item['id'];
            }
            BlogModel::view($viewIdList);
            return $this->success('获取成功', ['list' => $list, 'maxPage' => $maxPage, 'currentTab' => $type]);
        } catch (\Exception $e) {
            Log::error('列表失败：' . $e->getMessage(), [
                'user_id' => $userId,
                'trace'   => $e->getTrace(),
            ]);
            return $this->error(1005, '列表加载失败，请稍后重试');
        }
    }
}
