<?php

namespace app\queue;


use app\common\base\BaseConsumer;

class RemoteFoodSyncJob extends BaseConsumer
{
    public $queue = 'remote_food_sync';
    public function consume($data)
    {

    }
}
