<?php

namespace app\model;

use app\model\BaseModel;

class FollowModel extends BaseModel
{
    const IS_ATTENTION = 1;
    protected $table = 'follow';

    static function getFriendsUserId(int $userId): array
    {
        return self::query()->where('user_id', $userId)->where('is_attention', self::IS_ATTENTION)->pluck('follow_id')->toArray();
    }

    /**
     * 获取指定用户的关注数量
     * @param int $userId
     * @return int
     */
    static function getFollowerCount(int $userId): int
    {
        return self::query()->where('user_id', $userId)->count();
    }

    /**
     * 获取指定用户的粉丝数量
     * @param int $userId
     * @return int
     */
    static function getFansCount(int $userId): int
    {
        return self::query()->where('follow_id', $userId)->count();
    }

    /**
     * 获取指定用户互关数量
     * @param int $userId
     * @return int
     */
    static function getFriendCount(int $userId): int
    {
        return self::query()->where('user_id', $userId)->where('is_attention', self::IS_ATTENTION)->count();
    }

    /**
     * 获取指定用户互关列表
     * @param int $userId
     * @return \Illuminate\Support\Collection
     */
    static function getFriendList(int $userId)
    {
        return UserModel::select(['id', 'name', 'avatar'])->whereIn('id', function ($query) use ($userId) {
            $query = $query->select('user_id')->from('follow')->where('follow_id', $userId);
            $query->where('is_attention', self::IS_ATTENTION);
        })->get();
    }

    /**
     * 获取指定用户的粉丝列表
     * @param int $userId
     * @param bool $isAttention 是否互关
     * @return \Illuminate\Support\Collection
     */
    static function geFansList(int $userId, bool $isAttention = false)
    {
        return UserModel::select(['id', 'name', 'avatar'])->whereIn('id', function ($query) use ($userId, $isAttention) {
            $query = $query->select('user_id')->from('follow')->where('follow_id', $userId);
            if ($isAttention) {
                $query->where('is_attention', $isAttention);
            }
        })->get();
    }

    /**
     * 获取指定用户的关注列表
     * @param int $userId
     * @param bool $isAttention 是否互关
     * @return \Illuminate\Support\Collection
     */
    static function getFollowerList(int $userId, bool $isAttention = false)
    {
        return UserModel::select(['id', 'name', 'avatar'])->whereIn('id', function ($query) use ($userId, $isAttention) {
            $query = $query->select('follow_id')->from('follow')->where('user_id', $userId);
            if ($isAttention) {
                $query->where('is_attention', $isAttention);
            }
        })->get();
    }
}
