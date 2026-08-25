<?php

namespace app\queue;

use app\common\base\BaseConsumer;
use app\model\BlogModel;
use support\Redis;

class FeedViewIncrease extends BaseConsumer
{
    public $queue = 'feedViewIncrease';

    public function consume($data)
    {
        $viewer = $data['viewer'] ?? null;
        $ids = array_values(array_unique(array_map('intval', $data['ids'] ?? [])));
        if (!$viewer || !$ids) {
            return true;
        }
        $newViewIds = [];
        foreach ($ids as $id) {
            $key = "feed:view:{$viewer}:{$id}";
            if (Redis::setNx($key, 1)) {
                Redis::expire($key, 300);
                $newViewIds[] = $id;
            }
        }
        if ($newViewIds) {
            BlogModel::query()->whereIn('id', $newViewIds)->increment('views');
        }
        return true;
    }

}
