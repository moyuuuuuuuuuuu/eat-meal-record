<?php

namespace app\common\exception;

use app\common\enum\BusinessCode;
use support\exception\BusinessException;

class DataNotFoundException extends BusinessException
{
    public function __construct(string $message = "无数据", ?Throwable $previous = null)
    {
        parent::__construct($message, BusinessCode::NOT_FOUND->value, $previous);
    }
}
