# Repository Guidelines

## Project Structure & Module Organization

This is a PHP 8.1+ Webman application. Application code lives in `app/`: controllers in `app/controller`, domain orchestration in `app/business`, models in `app/model`, integrations in `app/service`, queues in `app/queue`, CLI commands in `app/command`, middleware in `app/middleware`, and workers in `app/process`. Routes are centralized in `config/route.php`; other framework and plugin settings live under `config/`. Static assets and uploads are under `public/`. Admin plugin code is under `plugin/admin/`. SQL bootstrap data is in `base.sql` and `sql/`, API mock fixtures are in `mock/`, and media/prompt templates are in `template/`.

## Build, Test, and Development Commands

- `composer install`: install dependencies from `composer.lock`.
- `cp example.env .env`: create local configuration; fill database, Redis, JWT, Baidu, Coze, WeChat, BOS, and SMTP values.
- `php webman start`: run the Webman server in the foreground.
- `php webman start -d`: run as a daemon; use `php webman stop`, `restart`, and `status` for process control.
- `php webman list`: show CLI commands, including `app/command` entries.
- `composer dump-autoload`: refresh autoloading after adding or moving classes.

## Coding Style & Naming Conventions

Follow the PSR-4 layout and existing PHP style: 4-space indentation, one class per file, and explicit namespaces such as `app\controller` or `app\service`. Name classes by role, for example `FoodController`, `FoodBusiness`, `FoodModel`, and `FoodService`. Keep route handlers thin; put business rules in `app/business` or `app/service`, and response shaping in `app/format` where applicable.

## Testing Guidelines

No first-party PHPUnit or Pest configuration is currently present. Verify affected API paths manually with HTTP requests against `php webman start`, using matching files in `mock/` as response examples when available. For database changes, apply SQL locally and confirm related models and routes. Add automated tests only with the required runner configuration in the same change.

## Commit & Pull Request Guidelines

Recent history uses short prefixes such as `fix:` and `add:` followed by a concise Chinese description, for example `fix:百度云文件上传`. Keep commits focused on one behavior change. Pull requests should describe the affected API or process, list configuration or SQL changes, include manual verification steps, and attach screenshots only when admin UI or public assets change.

## Security & Configuration Tips

Use `example.env` as the contract for required settings, but keep real keys out of version control. Treat Redis queues, Baidu, Coze, WeChat, BOS, and SMTP as unavailable until their environment variables are set. Keep `APP_DEBUG=FALSE` outside local development.
