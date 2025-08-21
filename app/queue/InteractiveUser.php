<?php

namespace app\queue;

use Webman\RedisQueue\Process\Consumer;

/**
 * @InteractiveUser 互动用户队列
 * @package app\queue
 */
class InteractiveUser extends Consumer
{

    const QUEUE_NAME = 'interactiveUserQueue';
    public $queue = 'interactiveUserQueue';

    /**
     * @param array{
     *     type:string, //类型
     *     target:int,//目标id
     *     userId:int,//用户id
     *     model:string,//模型
     *     metadata:array, //元数据
     *     time:int, //时间
     * } $data
     * @return void
     */
    public function consume($data)
    {

    }
}
