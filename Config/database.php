<?php
require_once "./Config/app.php";

// Check configuration options: https://book.cakephp.org/phinx/0/en/contents.html
$db_config = [
    'environments' => [
        'default_migration_table' => 'phinxlog',
        'default_environment' => APP_ENV,
        'production' => [
            'adapter' => 'pgsql',
            'host' => $_ENV["DB_HOST"],
            'name' => $_ENV["DB_NAME"],
            'user' => $_ENV["DB_USER"],
            'pass' => $_ENV["DB_PASS"],
            'port' => $_ENV['DB_PORT'],
            'charset' => 'utf8',
        ],
        'development' => [
            'adapter' => 'mysql',
            'host' => 'localhost',
            'name' => 'development_db',
            'user' => 'root',
            'pass' => '',
            'port' => '3306',
            'charset' => 'utf8',
        ],
        'testing' => [
            'adapter' => 'mysql',
            'host' => 'localhost',
            'name' => 'testing_db',
            'user' => 'root',
            'pass' => '',
            'port' => '3306',
            'charset' => 'utf8',
        ]
    ]
];
