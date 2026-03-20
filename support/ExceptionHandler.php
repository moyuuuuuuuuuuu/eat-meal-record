<?php

namespace support;

use app\common\enum\BusinessCode;
use app\common\exception\BusinessException;
use app\common\exception\DataNotFoundException;
use app\common\exception\ValidationException;
use app\service\Alarm;
use app\service\MailService;
use Throwable;
use Webman\Http\Request;
use Webman\Http\Response;

class ExceptionHandler extends exception\Handler
{
    public $dontReport = [
        DataNotFoundException::class,
        ValidationException::class,
    ];

    public function report(Throwable $exception)
    {
        parent::report($exception);
    }

    public function render(Request $request, Throwable $exception): Response
    {
        // 1. 尝试从异常 Code 获取业务枚举
        $businessCode = BusinessCode::tryFrom($exception->getCode());

        // 2. 关键报警逻辑：如果是严重的业务错误且是生产环境，触发报警
        if (($businessCode && $businessCode->value >= 500)) {
            Alarm::notify($exception);
        }
        return parent::render($request, $exception);
    }
}
