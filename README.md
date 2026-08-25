# Eat Meal Record

基于 Webman 的饮食记录与营养分析后端。项目面向健康饮食类小程序或客户端，提供食物检索与 AI 识别、饮食日记、营养统计、个性化推荐、用户目标、动态社区等能力，并带有 Webman Admin 管理后台、Redis 异步任务和食品数据健康检查进程。

## 主要功能

- 食物：分类、搜索、详情、营养识别和推荐
- 饮食日记：添加/删除餐食、每日汇总和历史记录
- 用户：微信/短信登录、资料、目标、步数与营养统计
- 社区：动态发布、列表、详情、点赞和话题
- 基础服务：文件上传、公告与协议、逆地理编码
- 后台任务：AI 识别任务、食品营养/标签/单位同步、系统通知
- 管理后台：用户、食品、分类、文章、字典等数据维护

## 技术栈

- PHP 8.1+
- Webman 2.1 / Workerman
- MySQL 8
- Redis、webman/redis-queue
- Webman Admin
- 百度智能云（图像识别、地图、BOS）
- Coze 工作流、微信小程序、SMTP

## 目录结构

```text
app/
├── controller/    HTTP 控制器
├── business/      业务编排
├── model/         数据模型
├── service/       外部服务与领域服务
├── format/        响应数据格式化
├── queue/         Redis 队列消费者
├── process/       常驻进程
├── command/       CLI 命令
└── middleware/    日志、用户上下文与鉴权中间件
config/            路由、数据库、Redis、进程等配置
plugin/admin/      Webman Admin 及业务管理页面
mock/              部分接口响应示例（文件名沿用早期 api_v3 命名）
tests/             可直接执行的回归检查脚本
sql/               补充 SQL
template/          AI 提示词与模板
eat_clear.sql      当前数据库建表脚本
```

## 快速开始

### 1. 环境要求

准备 PHP 8.1+、Composer、MySQL 8 和 Redis。需要启用项目依赖所用的常见扩展，包括 PDO MySQL、Redis、OpenSSL、JSON、cURL 和 mbstring。

食品批量同步命令使用 `pcntl_fork`，仅建议在安装了 `pcntl` 的 Linux 环境执行；Web 服务本身可在 Windows 开发环境运行。

### 2. 安装依赖

```bash
composer install
```

### 3. 配置环境变量

复制配置模板：

```bash
cp example.env .env
```

Windows PowerShell：

```powershell
Copy-Item example.env .env
```

至少需要填写：

```dotenv
APP_DEBUG=TRUE

MYSQL_HOST=127.0.0.1
MYSQL_PORT=3306
MYSQL_DATABASE=eat_clear
MYSQL_USERNAME=root
MYSQL_PASSWORD=your_password
MYSQL_PREFIX=
MYSQL_CHARSET=utf8mb4
MYSQL_COLLATION=utf8mb4_unicode_ci

REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DATABASE=1

JWT_KEY=replace_with_a_random_secret
JWT_AES_KEY=replace_with_a_32_byte_key
JWT_AES_IV=replace_with_a_16_byte_iv
```

其他变量按启用的功能填写：

| 配置前缀 | 用途 |
| --- | --- |
| `BAIDU_*`、`IBS_AK` | 百度图像识别与地图服务 |
| `BOS_*`、`SOURCE_DOMAIN` | 百度对象存储与资源域名 |
| `COZE_*` | Coze 营养、标签、单位等工作流 |
| `MP_*` | 微信小程序登录 |
| `SMTP_*` | 系统告警邮件 |

不要提交真实密钥；非本地环境请设置 `APP_DEBUG=FALSE`。

### 4. 初始化数据库

先创建 `.env` 中配置的数据库，再导入当前建表脚本：

```bash
mysql -u root -p eat_clear < eat_clear.sql
```

`eat_clear.sql` 只负责表结构，不包含可用的业务种子数据。根目录的 `base.sql` 保留了较早的、带固定 `eat_clear` 库名前缀的结构，不建议作为新环境的首选初始化脚本；增量或专项 SQL 位于 `sql/` 和 `modify_sql/`。

### 5. 启动服务

开发环境前台启动：

```bash
php webman start
```

服务默认监听 `http://127.0.0.1:8787`。Linux 生产环境可使用守护进程模式：

```bash
php webman start -d
php webman status
php webman restart
php webman stop
```

启动时会同时运行 Redis 队列消费者、系统通知和食品健康检查等进程，因此 MySQL 与 Redis 应先保持可用。

## API 概览

所有业务接口统一使用 `/api` 前缀，路由定义以 `config/route.php` 为准。

| 模块 | 主要接口 |
| --- | --- |
| 登录 | `POST /api/auth/login`、`POST /api/auth/sms/login`、`POST /api/sms/send` |
| 食物 | `GET /api/food/search`、`GET /api/food/detail`、`POST /api/food/recognize` |
| 推荐 | `GET /api/recommendation` |
| 饮食日记 | `GET /api/diary`、`POST /api/diary/meal/add`、`GET /api/diary/summary`、`GET /api/diary/history` |
| 用户 | `GET /api/user/information`、`POST /api/user/update`、`GET /api/user/stats`、`GET/POST /api/user/goal/*` |
| 动态 | `GET /api/feed/list`、`GET /api/feed/detail`、`POST /api/feed/create`、`POST /api/feed/post/like` |
| 话题 | `GET /api/topic/search`、`GET /api/topic/hot`、`POST /api/topic/create` |
| 其他 | `POST /api/upload`、`GET /api/location/reverse/geo`、`GET /api/task/enquire` |

需要登录的接口通过请求头传递登录返回的 JWT，两种写法均受支持：

```http
Authorization: Bearer <token>
```

```http
Authorization: <token>
```

部分只读接口允许匿名访问，实际边界由各控制器的 `noNeedLogin` 配置决定。`APP_DEBUG=TRUE` 时还会开放 `/api/test` 和 `/api/auth/login/mock`，生产环境不得开启。

## CLI 命令

查看所有命令：

```bash
php webman list
```

项目自定义命令包括：

```bash
php webman food:sync
php webman tag-cate-for-food:sync
php webman unit-for-food:sync
php webman migrate:menu-nutrition-full
```

这些命令会写入数据库或调用外部服务，请先核对环境、数据来源和命令实现；前三个同步命令还依赖 Linux `pcntl`。

## 验证

当前仓库没有 PHPUnit/Pest 配置，已有回归检查可直接执行：

```bash
php tests/recommendation_regression.php
php tests/security_regression.php
php tests/tag_normalization.php
node tests/security_regression.mjs
```

涉及数据库、Redis、队列或第三方服务的改动，还需要启动本地服务并对受影响接口做手工验证。`mock/` 中的文件可作为部分响应结构参考，但文件名中的 `api_v3` 是历史命名，当前路由前缀是 `/api`。

## 开发约定

- 控制器只处理请求与响应，业务规则放在 `app/business` 或 `app/service`
- 数据响应转换优先放在 `app/format`
- 新增或移动类后执行 `composer dump-autoload`
- 数据库变更同时提交 SQL，并说明执行顺序与影响范围
- 禁止将 `.env`、真实密钥、令牌或生产数据提交到仓库

## License

[MIT](LICENSE)
