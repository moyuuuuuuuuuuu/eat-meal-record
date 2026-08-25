<?php

$root = dirname(__DIR__);
$failures = [];

function read_file(string $path): string
{
    $content = file_get_contents($path);
    if ($content === false) {
        throw new RuntimeException("Unable to read {$path}");
    }
    return $content;
}

function expect_contains(string $label, string $haystack, string $needle): void
{
    global $failures;
    if (!str_contains($haystack, $needle)) {
        $failures[] = "{$label}: expected to contain {$needle}";
    }
}

function expect_not_contains(string $label, string $haystack, string $needle): void
{
    global $failures;
    if (str_contains($haystack, $needle)) {
        $failures[] = "{$label}: expected not to contain {$needle}";
    }
}

$sms = read_file($root . '/app/business/SmsBusiness.php');
expect_not_contains('SMS debug gate', $sms, "getenv('APP_DEBUG') && \$code == 123123");
expect_contains('SMS debug gate', $sms, "config('app.debug') === true");

$taskController = read_file($root . '/app/controller/TaskController.php');
expect_contains('Task ownership status query', $taskController, "where('user_id', \$request->userInfo->id)");
expect_contains('Task ownership response query', $taskController, "where('user_id', \$request->userInfo->id)");

$taskModel = read_file($root . '/app/model/TaskModel.php');
expect_contains('Task model user ownership', $taskModel, "'user_id'");

$schema = read_file($root . '/eat_clear.sql');
expect_contains('Task schema user ownership', $schema, '`user_id` BIGINT NOT NULL');
expect_contains('Task schema ownership index', $schema, 'INDEX `idx_user_task`');

$foodBusiness = read_file($root . '/app/business/FoodBusiness.php');
expect_not_contains('AI quota should not be checked before enqueue', $foodBusiness, 'TokenLimit::instance()->hasQuota()');
expect_contains('Task creation stores user_id', $foodBusiness, "'user_id'    => \$request->userInfo->id");
expect_not_contains('Food API must not echo SQL', $foodBusiness, 'echo TaskModel::printSql');
expect_not_contains('Food search must not echo queue status', $foodBusiness, "echo '食品'");
expect_contains('Tasks start in waiting state', $foodBusiness, "'run_status' => TaskRunStatus::Waiting->value");

$taskConsumer = read_file($root . '/app/queue/TaskConsumeJob.php');
expect_contains('AI quota consumed before workflow call', $taskConsumer, 'TokenLimit::instance()->consumeQuota()');
expect_contains('Task is claimed conditionally', $taskConsumer, "where('run_status', TaskRunStatus::Waiting->value)");
expect_contains('Task retries are bounded', $taskConsumer, 'private const MAX_ATTEMPTS = 3');
expect_contains('Stale running tasks are recoverable', $taskConsumer, 'private const RUNNING_TIMEOUT_MINUTES = 10');
expect_contains('Exhausted stale tasks are finalized', $taskConsumer, '任务执行超时且已达最大重试次数');

$feedBusiness = read_file($root . '/app/business/FeedBusiness.php');
expect_not_contains('Feed detail must not bypass visibility', $feedBusiness, 'BlogModel::find($blogId)');
expect_contains('Feed visibility helper', $feedBusiness, 'visibleBlogQuery');
expect_contains('Feed record attachments require ownership', $feedBusiness, "->where('user_id', \$userId)");
expect_contains('Feed visibility requires reverse follow', $feedBusiness, "whereColumn(\$followTable . '.user_id', \$blogTable . '.user_id')");
expect_not_contains('Video poster must not replace attachment', $feedBusiness, "\$item['attach'] = '/' . ltrim(\$item['poster'], '/')");

$feedValidator = read_file($root . '/app/common/validate/FeedValidator.php');
expect_contains('Topic input is validated with the API field name', $feedValidator, "'topic.*'");
expect_contains('Visibility participates in create validation', $feedValidator, "'create' => ['content', 'visibility'");

$blogAttachFormat = read_file($root . '/app/format/BlogAttachFormat.php');
expect_contains('Record attachment read is owner scoped', $blogAttachFormat, "where('user_id', \$this->blogOwnerId)");

$accessLog = read_file($root . '/app/middleware/AccessLog.php');
expect_contains('Access log runs for successful and failed requests', $accessLog, 'finally {');
expect_contains('Access log is written', $accessLog, "Log::channel('access')->info");

$userInfo = read_file($root . '/app/common/context/UserInfo.php');
expect_contains('Step cache uses relative TTL', $userInfo, 'Helper::todayEndTimestamp() - time()');

$baseBusiness = read_file($root . '/app/common/base/BaseBusiness.php');
expect_contains('Base business model class property is declared', $baseBusiness, 'protected ?string $staticModelClass = null;');

$uploadController = read_file($root . '/app/controller/UploadController.php');
expect_contains('Upload extension whitelist', $uploadController, '$allowedExtensions');
expect_contains('Upload size limit', $uploadController, 'getSize()');

$userInfoData = read_file($root . '/app/common/context/UserInfoData.php');
expect_contains('Disabled users rejected from token context', $userInfoData, '账号已被禁用');

if ($failures) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo "security regression checks passed" . PHP_EOL;
