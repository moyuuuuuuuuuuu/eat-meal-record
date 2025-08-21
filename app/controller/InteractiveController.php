<?php

namespace app\controller;

use app\model\BaseModel;
use app\model\FavoriteModel;
use app\model\LikeModel;
use app\model\traits\InteractiveTrait;
use support\Db;
use support\Request;

class InteractiveController extends BaseController
{

    /**
     * 点赞
     * @param Request $request
     * @param int $type 类型 blog|food|recipe|comment|user
     * @param int $id
     * @return \support\Response|void
     */
    public function like(Request $request, string $type, int $id)
    {
        $userId = $request->userId;
        if (!in_array($type, LikeModel::TYPE_LIST)) {
            return $this->error(4004, '类型不存在');
        }
        $typeList = array_flip(LikeModel::TYPE_LIST);
        $type     = $typeList[$type];
        Db::beginTransaction();
        /**
         * @var $targetModel InteractiveTrait
         */
        $targetModel = LikeModel::getTargetModel($type);
        if (!$targetModel) {
            return $this->error(4004, '目标不存在');
        }
        $target = $targetModel::query()->where('id', $id)->first();
        if (!$target) {
            return $this->error(4004, '目标不存在');
        }

        $like = LikeModel::where('user_id', $userId)->where('type', $type)->where('target', $id)->first();
        if ($like) {
            if ($target->unlike($id) && $like->delete()) {
                Db::commit();
                return $this->success('取消点赞成功', ['like_count' => $target->like_count - 1, 'isLike' => false]);
            }
            Db::rollback();
            return $this->error(1, '取消点赞失败');
        }

        $like = LikeModel::create([
            'user_id' => $userId,
            'type'    => $type,
            'target'  => $id,
        ]);
        if ($like && $target->like($id)) {
            Db::commit();
            return $this->success('点赞成功', ['like_count' => $target->like_count + 1, 'isLike' => true]);
        }
        Db::rollback();
        return $this->error(1, '点赞失败');
    }

    public function comment(Request $request, string $type, int $id)
    {
    }

    public function fav(Request $request, string $type, int $id)
    {
        $userId = $request->userId;
        if (!in_array($type, FavoriteModel::TYPE_LIST)) {
            return $this->error(4004, '类型不存在');
        }
        $typeList = array_flip(FavoriteModel::TYPE_LIST);
        $type     = $typeList[$type];

        /**
         * @var $targetModel BaseModel
         */
        $targetModel = FavoriteModel::getTargetModel($type);
        if (!$targetModel) {
            return $this->error(4004, '目标不存在');
        }
        $target = $targetModel::query()->where('id', $id)->first();
        if (!$target) {
            return $this->error(4004, '目标不存在');
        }

        $favInfo = FavoriteModel::where('user_id', $userId)->where('type', $type)->where('target', $id)->first();
        if ($favInfo) {
            if ($target->unfav($id) && $favInfo->delete()) {
                return $this->success('取消收藏成功', ['fav_count' => $target->fav_count - 1, 'isFav' => false]);
            }
            return $this->error(1, '取消收藏失败');
        }

        $favInfo = FavoriteModel::create([
            'user_id' => $userId,
            'type'    => $type,
            'target'  => $id,
        ]);
        if ($favInfo && $target->fav($id)) {
            return $this->success('收藏成功', ['fav_count' => $target->fav_count + 1, 'isFav' => true]);
        }
        return $this->error(1, '收藏失败');
    }
}
