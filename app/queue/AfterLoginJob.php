<?php

namespace app\queue;

use app\common\base\BaseConsumer;

class AfterLoginJob extends BaseConsumer
{
    public $queue = 'afterLogin';

    public function consume($data)
    {

    }
}
