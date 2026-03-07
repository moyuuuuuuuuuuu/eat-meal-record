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

return [
    'default' => [
        'password' => env('REDIS_PASSWORD'),
        'host'     => env('REDIS_HOST'),
        'port'     => env('REDIS_PORT'),
        'database' => env('REDIS_DATABASE'),
        'pool'     => [
            'max_connections'    => env('REDIS_MAX_CONNECTIONS'),
            'min_connections'    => env('REDIS_MIN_CONNECTIONS'),
            'wait_timeout'       => env('REDIS_WAIT_TIMEOUT'),
            'idle_timeout'       => env('REDIS_IDLE_TIMEOUT'),
            'heartbeat_interval' => env('REDIS_HEART_BEAT_INTERVAL'),
        ],
    ]
];
