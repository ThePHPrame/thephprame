<?php
require_once __DIR__ . "/app.php";

// Check configuration options: https://book.cakephp.org/phinx/0/en/contents.html
$db_config = [
    'environments' => [
        'default_migration_table' => 'phinxlog',
        'default_environment' => APP_ENV,
        'production' => [
            'adapter' => $_ENV['DB_ADAPTER'] ?? 'pgsql',
            'host' => $_ENV['DB_HOST'] ?? 'localhost',
            'name' => $_ENV['DB_NAME'] ?? '',
            'user' => $_ENV['DB_USER'] ?? '',
            'pass' => $_ENV['DB_PASS'] ?? '',
            'port' => $_ENV['DB_PORT'] ?? null,
            'charset' => $_ENV['DB_CHARSET'] ?? 'utf8',
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
