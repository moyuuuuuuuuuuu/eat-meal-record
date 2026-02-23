<?php

namespace app\common\enum\blog;

/**
 * 博客可见度
 */
enum Status:int
{
    /**
     * 隐藏
     */
    case HIDDEN = 0;
    /**
     * 所有人可见
     */
    case ALL = 1;
    /**
     * 仅自己可见
     */
    case SELF = 2;
    /**
     * 仅好友可见
     */
    case FRIEND = 3;
}
