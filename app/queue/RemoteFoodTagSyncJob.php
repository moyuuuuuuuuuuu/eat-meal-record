<?php

namespace app\queue;

use app\common\base\BaseConsumer;
use app\service\foodHealthCheck\FoodTagSync;

class RemoteFoodTagSyncJob extends BaseConsumer
{

    public $queue      = 'foodTagSync';
    public $connection = 'default';

    public function consume($data)
    {
        FoodTagSync::instance()->run($data);
    }
}
