<?php

namespace app\model\traits;

use app\queue\InteractiveUser;
use Webman\RedisQueue\Client;

/**
 * @InteractiveTrait 用户互动Trait
 * @package app\model\traits
 *
 */
trait InteractiveTrait
{
    /**
     * 点赞
     * @param $target
     * @return mixed
     */
    static function like($target)
    {
        self::sendInteractiveUserQueue(__FUNCTION__, $target, request()->userId, static::class);
        return self::where('id', $target)->increment('like_count', 1);
    }

    /**
     * 取消点赞
     * @param $target
     * @return mixed
     */
    static function unlike($target)
    {
        self::sendInteractiveUserQueue(__FUNCTION__, $target, request()->userId, static::class);
        return self::where('id', $target)->decrement('like_count', 1);
    }

    /**
     * 查看
     * @param $target
     * @return mixed
     */
    static function view($target)
    {
        self::sendInteractiveUserQueue(__FUNCTION__, $target, request()->userId, static::class);
        if (is_array($target)) {
            return self::whereIn('id', $target)->increment('view_count', 1);
        } else if (is_numeric($target)) {
            return self::where('id', $target)->increment('view_count', 1);
        }
    }

    /**
     * 收藏
     * @param $target
     * @return mixed
     */
    static function fav($target)
    {
        self::sendInteractiveUserQueue(__FUNCTION__, $target, request()->userId, static::class);
        return self::where('id', $target)->increment('fav_count', 1);
    }

    /**
     * 取消收藏
     * @param $target
     * @return mixed
     */
    static function unfav($target)
    {
        self::sendInteractiveUserQueue(__FUNCTION__, $target, request()->userId, static::class);
        return self::where('id', $target)->decrement('fav_count', 1);
    }


}
