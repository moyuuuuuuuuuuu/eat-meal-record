<?php
return  [
    'default' => 'mysql',
    'connections' => [
        'mysql' => [
            'driver'      => 'mysql',
            'host'        => getenv('MYSQL_HOST'),
            'port'        => getenv('MYSQL_PORT'),
            'database'    => getenv('MYSQL_DATABASE'),
            'username'    => getenv('MYSQL_USER'),
            'password'    => getenv('MYSQL_PASSWORD'),
            'charset'     => getenv('MYSQL_CHARSET'),
            'collation'   => getenv('MYSQL_COLLATION'),
            'prefix'      => getenv('MYSQL_PREFIX'),
            'strict'      => true,
            'engine'      => null,
            'options'   => [
                \PDO::ATTR_EMULATE_PREPARES => false, // Must be false for Swoole and Swow drivers.
            ],
            'pool' => [
                'max_connections' => 5,
                'min_connections' => 1,
                'wait_timeout' => 3,
                'idle_timeout' => 60,
                'heartbeat_interval' => 50,
            ],
        ],
    ],
];
