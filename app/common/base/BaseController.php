<?php

namespace app\common\base;


use app\common\trait\ReturnMessage;

class BaseController
{
    use ReturnMessage;
    protected $noNeedLogin = ['*'];
}
