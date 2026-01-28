# Thephprame — Lightweight PHP Microframework ⚡

**Thephprame** is a compact, easy-to-understand PHP microframework for building web apps and APIs. It keeps the surface area small while using separate Composer packages for the core framework and router so the app stays clean and easy to reason about.

---

## 🔧 Key Features

- Minimal routing powered by the `thephprame-router` package
- Small, focused framework core in `thephprame-core`
- Dependency Injection with PHP-DI for controller/service wiring
- Simple controller & model structure (`App/Controllers`, `App/Models`)
- Basic middleware support (`App/Middleware`)
- Config-driven (see `Config/app.php`, `Config/database.php`)

---

## ✅ Requirements

- PHP 7.2+ (or a current PHP 7.x runtime)
- Composer

---

## 🚀 Quick Start

1. Docker

```docker compose up --build -d```

## 📁 Project Layout (important files)

- `Public/index.php` — front controller
- `Bootstrap/bootstrap.php` — framework bootstrap
- `Bootstrap/container.php` — DI container setup
- `Config/di.php` — DI definitions
- `Routes/web.php`, `Routes/api.php` — route declarations
- `App/Controllers/` — your HTTP controllers
- `App/Middleware/` — middleware classes
- `App/Models/` — lightweight models
- `Config/` — app and DB configuration
- `Views/` — view templates
- `Storage/` — runtime storage (sessions, etc.)

---

## 🧭 Routing & Controllers — Example

Add routes in `Routes/web.php`:

```php
Routes::get('/', [App\Controllers\HomeController::class, 'index']);
```

Controllers are resolved via the DI container, so dependencies are injected automatically:

```php
namespace App\Controllers;

use App\Services\ExampleService;

class HomeController
{
    public function __construct(private ExampleService $service) {}

    public function index()
    {
        return view('home');
    }
}
```

---

## 🧩 Dependency Injection (PHP-DI)

The container is built in `Bootstrap/container.php` and definitions live in `Config/di.php`. Autowiring is enabled, so you only need explicit definitions for interfaces, factories, or scalar config values.

If you add a service class under `App/Services`, it can be injected into controllers and other services automatically.

---

## 🔐 Middleware & Authentication

Middleware classes live in `App/Middleware/` (e.g., `WebAuthentication`, `ApiAuthentication`). Apply middleware to routes in `Routes/*` or in your router configuration depending on convention.

---

## 💾 Configuration

Edit `Config/app.php` and `Config/database.php` to adjust environment settings and database connection details. If your project uses `.env` values, set them in your environment or a `.env` file.

---

## 🗄️ Database Configuration

Database settings live in `Config/database.php` and are read from environment variables:

- `DB_HOST`
- `DB_NAME`
- `DB_USER`
- `DB_PASS`
- `DB_PORT` (defaults to `5432` if not set)

The default adapter in the production environment is PostgreSQL (`pgsql`). Development and testing defaults are MySQL in the current config. Adjust the adapter and credentials per environment as needed.

---

## 🧬 Migrations (Phinx)

This project uses **Phinx** for database migrations.

Configuration lives in `phinx.php` (PHP config). It loads the database config from `Config/database.php` and sets:

- migrations path: `Database/Migrations`
- seeds path: `Database/db/seeds`

### Create a migration

```bash
vendor/bin/phinx create CreateUsersTable
```

This creates a new migration file with a timestamped filename inside `Database/Migrations`.

### Run migrations

```bash
vendor/bin/phinx migrate -e production
```

Use the `-e` flag to target the configured environment (e.g. `production`, `development`, `testing`).

References:

- Phinx migrations: https://book.cakephp.org/phinx/0/en/migrations.html#creating-a-new-migration
- Phinx commands: https://book.cakephp.org/phinx/0/en/commands.html

---

## 🛠️ Makefile Commands

The Makefile provides shortcuts for generating models and migrations. Always include `--` before flags so Make doesn’t treat them as its own options.

### Create a model (optionally with migration)

```bash
make model -- --name User
make model -- --name User --migration
```

This creates `App/Models/User.php` and (when `--migration` is used) a migration in `Database/Migrations` with a basic template that sets:

```
$table = $this->table("users");
```

### Create a custom migration for a model

```bash
make migration -- --model User --name addEmailColumn
```

This creates a migration named like `YYYYMMDDHHMMSS_add_email_column_to_user.php` and pre-fills the table based on the model name.

### Overwrite existing files

```bash
make model -- --name User --migration --force
make migration -- --model User --name addEmailColumn --force
```

---

## 🧪 Tests & Development

This repository does not include a test suite by default. For local debugging, use the PHP built-in server and add unit/integration tests as needed.

---

## Contributing

Contributions and improvements are welcome. Please open issues or submit PRs with clear descriptions and tests where appropriate.

---
