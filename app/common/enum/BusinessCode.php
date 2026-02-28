<?php

namespace app\common\enum;

use app\common\trait\EnumCases;

enum BusinessCode:int
{

    use EnumCases;
    /**
     * 请求成功
     */
    case SUCCESS = 200;

    /**
     * 未登陆
     */
    case NO_LOGIN = 400;
    /**
     * 未授权
     */
    case NO_AUTH = 403;

    /**
     * 参数错误类
     */
    case PARAM_ERROR = 103;

    /**
     * 业务逻辑错误类
     */
    case BUSINESS_ERROR = 501;

    /**
     * 系统异常类
     * @desc 参数配置错误等等
     */
    case SYSTEM_ERROR = 505;

    /**
     * 资源为找到
     */
    case NOT_FOUND = 404;
    public function label(): string
    {
        return match ($this) {
            self::SUCCESS => '请求成功',
            self::NO_LOGIN => '未登录',
            self::NO_AUTH => '未授权',
            self::PARAM_ERROR => '参数错误',
            self::BUSINESS_ERROR => '业务逻辑错误',
            self::SYSTEM_ERROR => '系统异常',
            self::NOT_FOUND => '资源未找到',
        };
    }

}
