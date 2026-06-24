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

$taskConsumer = read_file($root . '/app/queue/TaskConsumeJob.php');
expect_contains('AI quota checked when task starts', $taskConsumer, 'TokenLimit::instance()->hasQuota()');
expect_contains('AI quota consumed before workflow call', $taskConsumer, 'TokenLimit::instance()->consumeQuota()');

$feedBusiness = read_file($root . '/app/business/FeedBusiness.php');
expect_not_contains('Feed detail must not bypass visibility', $feedBusiness, 'BlogModel::find($blogId)');
expect_contains('Feed visibility helper', $feedBusiness, 'visibleBlogQuery');

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
