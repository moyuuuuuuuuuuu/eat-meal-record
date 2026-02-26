<?php

namespace app\model;

use app\common\base\BaseModel;
use app\common\enum\LikeFavType;

class FavoriteModel extends BaseModel
{
    protected $table = 'favorites';

    /**
     * 是否收藏
     * @param int|null $userId
     * @param int|null $targetId
     * @param int|LikeFavType $type
     * @return bool
     */
    static function isFav(?int $userId, ?int $targetId, int|LikeFavType $type = LikeFavType::BLOG): bool
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
