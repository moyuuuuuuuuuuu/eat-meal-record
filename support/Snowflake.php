<?php

namespace support;

use Godruoyi\Snowflake\Snowflake as BaseSnowflake;

class Snowflake
{
    private static $instance;

    public static function instance()
    {
        if (!self::$instance) {
            $workerId = posix_getpid() % 1024;
            $snowflake = new BaseSnowflake(1, $workerId);
            self::$instance = $snowflake;
        }

        return self::$instance;
    }

    public static function id()
    {
        return self::instance()->id();
    }
}
