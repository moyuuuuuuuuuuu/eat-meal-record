<?php

namespace app\common\exception;

use app\common\enum\BusinessCode;
use support\exception\BusinessException;
use Webman\Http\Response;

class ValidationException extends BusinessException
{

    public function __construct(...$params)
    {
        $paramStr = implode(',', $params);

        parent::__construct(
            sprintf('%s参数错误', $paramStr),
            BusinessCode::PARAM_ERROR->value
        );
    }
}
