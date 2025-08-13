<?php

namespace app\model;

use app\model\BaseModel;

class LikeModel extends BaseModel
{
    /**
     * 点赞类型：博客
     */
    const TYPE_BLOG = 1;
    /**
     * 点赞类型：食物
     */
    const TYPE_FOOD = 2;
    /**
     * 点赞类型：菜谱
     */
    const TYPE_RECIPE = 3;
    /**
     * 点赞类型：评论
     */
    const TYPE_COMMENT = 4;
    /**
     * 点赞类型：用户
     */
    const TYPE_USER = 5;
    protected $table = 'likes';

    /**
     * 获取指定用户的点赞数量
     * @param int $userId
     * @return int
     */
    static function getLikeCount(int $userId, int $type = 1): int
    {
        if (!in_array($type, [self::TYPE_BLOG, self::TYPE_FOOD, self::TYPE_RECIPE, self::TYPE_COMMENT, self::TYPE_USER])) {
            throw new \Exception('参数错误');
        }
        return self::query()->where('user_id', $userId)->where('type', $type)->count();
    }
}
