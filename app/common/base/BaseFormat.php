<?php

namespace app\common\base;

use support\Request;

abstract class BaseFormat
{
    protected $request;

    public function __construct(Request $request = null)
    {
        $this->request = $request;
    }

    abstract public function format(?BaseModel $model = null): array;
}
