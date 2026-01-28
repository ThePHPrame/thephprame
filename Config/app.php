<?php
$timezone = $_ENV['TIMEZONE'] ?? "UTC";

date_default_timezone_set($timezone);
define("APP_ENV", $_ENV["APP_ENV"] ?? "development");
define("ENCRYPTION_KEY", $_ENV["ENCRYPTION_KEY"] ?? "");
define("SECRET_KEY", $_ENV["SECRET_KEY"] ?? "");
define("ENCRYPT_COOKIES", ($_ENV["ENCRYPT_COOKIES"] ?? "false") == "true");
define("SESSION_DRIVER", $_ENV["SESSION_DRIVER"] ?? "");
