<?php

namespace app\model\interfaces;

interface TargetModelInterface
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

    /**
     * 点赞类型：话题
     */
    const TYPE_TOPIC = 6;

    const TYPE_LIST = [
        self::TYPE_BLOG    => 'blog',
        self::TYPE_FOOD    => 'food',
        self::TYPE_RECIPE  => 'recipe',
        self::TYPE_COMMENT => 'comment',
        self::TYPE_USER    => 'user',
    ];

    static function getTargetModel(int $type): string|null;
}
