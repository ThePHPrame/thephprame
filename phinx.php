<?php
require_once "./Config/database.php";

return
[
    'paths' => [
        'migrations' => '%%PHINX_CONFIG_DIR%%/Database/Migrations',
        'seeds' => '%%PHINX_CONFIG_DIR%%/Database/db/seeds'
    ],
    'environments' => [$db_config],
    'version_order' => 'creation'
];
