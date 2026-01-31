<?php

namespace app\aspect;

use app\service\UploadService;
use Hyperf\Di\Aop\AbstractAspect;
use Hyperf\Di\Aop\ProceedingJoinPoint;

class UploadAspect extends AbstractAspect
{
    public array $classes = [
        UploadService::class . '::upload',
    ];
    public array $annotations = [
        UploadService::class . '::uploadAnnotation',
    ];

    public function process(ProceedingJoinPoint $proceedingJoinPoint)
    {
        // TODO: Implement process() method.
    }
}
