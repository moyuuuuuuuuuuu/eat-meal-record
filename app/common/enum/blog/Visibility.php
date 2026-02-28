<?php

namespace app\common\enum\blog;

/**
 * 博客可见度
 */
enum Visibility:int
{
    /**
     * 隐藏
     */
    case HIDDEN = 0;
    /**
     * 所有人可见
     */
    case EVERYONE = 1;
    /**
     * 仅自己可见
     */
    case SELF = 2;
    /**
     * 仅好友可见
     */
    case FRIEND = 3;

    public function label(): string
    {
        return match ($this) {
            self::HIDDEN => '隐藏',
            self::EVERYONE => '所有人可见',
            self::SELF => '仅自己可见',
            self::FRIEND => '仅好友可见',
        };
    }
}
