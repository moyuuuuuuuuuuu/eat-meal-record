<?php
$redisHost     = env('REDIS_HOST');
$redisPort     = env('REDIS_PORT');
$redisPassword = env('REDIS_PASSWORD');
$redisDb       = env('REDIS_DB');
$redisPrefix   = env('REDIS_PREFIX');
if (!$redisPrefix) {
    $redisPrefix = 'queue:';
}
return [
    'default' => [
        'host'    => 'redis://' . $redisHost . ':' . $redisPort,
        'options' => [
            'auth'          => $redisPassword,
            'db'            => $redisDb,
            'prefix'        => $redisPrefix,
            'max_attempts'  => 5,
            'retry_seconds' => 5,
        ],
        // Connection pool, supports only Swoole or Swow drivers.
        'pool'    => [
            'max_connections'    => 5,
            'min_connections'    => 1,
            'wait_timeout'       => 3,
            'idle_timeout'       => 60,
            'heartbeat_interval' => 50,
        ]
    ],
];
