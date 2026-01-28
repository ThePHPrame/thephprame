<?php
require_once "./Config/app.php";

function env_value($key, $default = null) {
    if (array_key_exists($key, $_ENV)) {
        return $_ENV[$key];
    }
    $value = getenv($key);
    if ($value !== false) {
        return $value;
    }
    return $default;
}

// Check configuration options: https://book.cakephp.org/phinx/0/en/contents.html
$db_config = [
    'environments' => [
        'default_migration_table' => 'phinxlog',
        'default_environment' => APP_ENV,
        'production' => [
            'adapter' => env_value('DB_ADAPTER', 'pgsql'),
            'host' => env_value('DB_HOST', 'localhost'),
            'name' => env_value('DB_NAME', ''),
            'user' => env_value('DB_USER', ''),
            'pass' => env_value('DB_PASS', ''),
            'port' => env_value('DB_PORT', null),
            'charset' => env_value('DB_CHARSET', 'utf8'),
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
