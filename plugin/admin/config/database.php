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
        ],
    ],
];
