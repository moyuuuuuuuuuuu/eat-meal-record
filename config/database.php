<?php
return [
    'default'     => 'mysql',
    'connections' => [
        'mysql' => [
            'driver'    => 'mysql',
            'host'      => env('MYSQL_HOST'),
            'port'      => env('MYSQL_PORT'),
            'database'  => env('MYSQL_DATABASE'),
            'username'  => env('MYSQL_USER'),
            'password'  => env('MYSQL_PASSWORD'),
            'charset'   => env('MYSQL_CHARSET'),
            'collation' => env('MYSQL_COLLATION'),
            'prefix'    => env('MYSQL_PREFIX'),
            'strict'    => true,
            'engine'    => null,
            'options'   => [
                PDO::ATTR_EMULATE_PREPARES => false, // Must be false for Swoole and Swow drivers.
            ],
            'pool'      => [
                'max_connections'    => 5,
                'min_connections'    => 1,
                'wait_timeout'       => 3,
                'idle_timeout'       => 60,
                'heartbeat_interval' => 50,
            ],
        ],
    ],
];
