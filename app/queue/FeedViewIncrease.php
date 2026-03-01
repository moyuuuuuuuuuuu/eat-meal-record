<?php

namespace app\queue;

use app\common\base\BaseConsumer;
use app\model\BlogModel;

class FeedViewIncrease extends BaseConsumer
{
    public $queue = 'feedViewIncrease';

    public function consume($data)
    {
        if(!empty($data)){
            BlogModel::query()->whereIn('id', $data)->increment('views');
        }
    }

}
