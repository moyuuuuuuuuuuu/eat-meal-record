<?php
/**
 * This file is part of webman.
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the MIT-LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author    walkor<walkor@workerman.net>
 * @copyright walkor<walkor@workerman.net>
 * @link      http://www.workerman.net/
 * @license   http://www.opensource.org/licenses/mit-license.php MIT License
 */

$redisPassword = getenv('REDIS_PASSWORD');
$redisPassword = is_string($redisPassword) ? trim($redisPassword) : $redisPassword;
$redisPassword = $redisPassword === '' ? null : $redisPassword;

return [
    'default'   => [
        'password' => $redisPassword,
        'host'     => getenv('REDIS_HOST'),
        'port'     => (int)getenv('REDIS_PORT'),
        'database' => (int)getenv('REDIS_DATABASE'),
        'pool'     => [
            'max_connections'    => (int)getenv('REDIS_MAX_CONNECTIONS'),
            'min_connections'    => (int)getenv('REDIS_MIN_CONNECTIONS'),
            'wait_timeout'       => (int)getenv('REDIS_WAIT_TIMEOUT'),
            'idle_timeout'       => (int)getenv('REDIS_IDLE_TIMEOUT'),
            'heartbeat_interval' => (int)getenv('REDIS_HEART_BEAT_INTERVAL'),
        ],
    ],
    'subscribe' => [
        'password' => $redisPassword,
        'host'     => getenv('REDIS_HOST'),
        'port'     => (int)getenv('REDIS_PORT'),
        'database' => (int)getenv('REDIS_DATABASE'),
        'options'  => [
            // 必须：设置永不超时，防止阻塞订阅被断开
            \Redis::OPT_READ_TIMEOUT => -1,
        ]
    ]
];
