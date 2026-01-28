<?php
require_once __DIR__ . "/Config/database.php";

return
[
    'paths' => [
        'migrations' => '%%PHINX_CONFIG_DIR%%/Database/Migrations',
        'seeds' => '%%PHINX_CONFIG_DIR%%/Database/db/seeds'
    ],
    'environments' => $db_config['environments'],
    'version_order' => 'creation'
];
