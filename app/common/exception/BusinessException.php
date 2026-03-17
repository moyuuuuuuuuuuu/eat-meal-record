<?php

namespace app\common\exception;

use app\common\enum\BusinessCode;

class BusinessException extends \support\exception\BusinessException
{
    public function __construct(string $message = "", int|BusinessCode $code = 0, ?Throwable $previous = null)
    {
        if ($code <= 0) {
            $code = BusinessCode::BUSINESS_ERROR->value;
        } else if ($code instanceof BusinessCode) {
            $code = $code->value;
        }
        parent::__construct($message, $code, $previous);
    }
}
