<?php

namespace app\model;

use app\common\base\BaseModel;
use app\common\enum\LikeFavType;

/**
 * @property int $user_id
 * @property int $target
 * @property int $type
 */
class LikeModel extends BaseModel
{
    protected $table = 'likes';

    protected $fillable = [
        'user_id',
        'target',
        'type',
    ];

    /**
     * 是否点赞
     * @param int|null $userId
     * @param int|null $targetId
     * @param int|LikeFavType $type
     * @return bool
     */
    static function isLiked(?int $userId, ?int $targetId, int|LikeFavType $type = LikeFavType::BLOG): bool
    {
        if (!$userId || !$targetId) {
            return false;
        }

        $typeValue = $type instanceof LikeFavType ? $type->value : $type;

        return self::where('user_id', $userId)
            ->where('target', $targetId)
            ->where('type', $typeValue)
            ->exists();
    }
}
