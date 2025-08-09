<?php

namespace app\queue;

use app\model\FoodModel;
use Webman\RedisQueue\Process\Consumer;

/**
 * 保存远端食物数据
 */
class InsertRemoteFoodQueue extends Consumer
{
    const QUEUE_NAME = 'insertRemoteFood';
    public $queue = 'insertRemoteFood';

    /**
     * @param array{
     *     name:string,
     *     page:int
     * } $data
     * @return void
     */
    public function consume(array $data)
    {
        FoodModel::insertRemoteFoodByName(...$data);
    }
}
