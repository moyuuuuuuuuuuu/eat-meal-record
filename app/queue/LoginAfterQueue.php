<?php

namespace app\queue;

use app\model\UserModel;
use Webman\RedisQueue\Process\Consumer;

class LoginAfterQueue extends Consumer
{
    const QUEUE_NAME = 'loginAfter';
    public $queue = 'loginAfter';

    /**
     * @param array{
     *     userId:int,
     *     currentDateTime: string,
     *     ip: string,
     *     platform: string,
     * } $data
     * @return void
     */
    public function consume($data)
    {
        UserModel::update([
            'last_login_time'     => $data['currentDateTime'],
            'last_login_ip'       => $data['ip'],
            'last_login_platform' => $data['platform'],
        ], ['id' => $data['userId']]);
    }
}
