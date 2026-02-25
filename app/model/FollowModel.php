<?php

namespace app\model;

use app\common\base\BaseModel;

class FollowModel extends BaseModel
{
    protected $table    = 'follow';
    protected $fillable = [
        'user_id',
        'follow_id',
        'is_attention'
    ];

    /**
     * 检查用户是否关注
     * @param $userId
     * @param $followId
     * @return bool
     */
    static function isAttention($userId, $followId)
    {
        if (!$userId || !$followId) {
            return false;
        }

        return self::where('user_id', $userId)
            ->where('follow_id', $followId)
            ->exists();
    }
}
