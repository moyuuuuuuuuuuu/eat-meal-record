<?php

namespace app\queue;

use app\common\base\BaseConsumer;

class AfterLoginJob extends BaseConsumer
{
    public $queue = 'after_login';

    public function consume($data)
    {

    }
}
