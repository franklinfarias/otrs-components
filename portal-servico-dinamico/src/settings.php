<?php
return [
    'displayErrorDetails' => true, // set to false in production
    'addContentLengthHeader' => false, // Allow the web server to send the content-length header
    'settings' => [
        // Monolog settings
        'logger' => [
            'name' => 'my-app',
            'path' => __DIR__ . '/../logs/app.log',
            'level' => \Monolog\Logger::DEBUG,
        ],
        // Database
        'db' => [
            'driver'    => 'mysql',
            'host'      => '172.98.0.10',
            'database'  => 'otrs',
            'username'  => 'root',
            'password'  => '2f3a90',
            'charset'   => 'utf8',
            'collation' => 'utf8_unicode_ci', // e.g: utf8_unicode_ci
            'prefix'    => '', // e.g: tbl_
        ],
        // Web service
        'ws_location' => 'http://172.98.0.10/otrs/nph-genericinterface.pl/Webservice/wbx',
    ],
];