<?php

namespace app\queue;

use app\common\base\BaseConsumer;
use app\service\foodHealthCheck\FoodUnitSync;

class FoodUnitSyncJob extends BaseConsumer
{

    public $queue      = 'foodUnitSync';
    public $connection = 'default';

    public function consume($data)
    {
        FoodUnitSync::instance()->run($data);
    }
}
