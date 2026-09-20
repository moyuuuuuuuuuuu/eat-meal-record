<?php

// Standalone regression runner. Uses only an in-memory SQLite database; no .env or services.
require getenv('EAT_MEAL_TEST_AUTOLOAD') ?: dirname(__DIR__) . '/vendor/autoload.php';

use app\business\DiaryBusiness;
use app\business\MealRecordBusiness;
use app\business\SmsBusiness;
use app\common\context\UserInfoData;
use app\common\exception\BusinessException;
use app\common\validate\{FeedValidator, FoodValidator, LoginValidator, MealRecordValidator, SmsValidator, UserGoalValidator, UserValidator};
use Illuminate\Database\Capsule\Manager as Capsule;
use Illuminate\Database\Schema\Blueprint;
use Webman\Validation\Middleware;

// Isolate Webman's service-backed model/context from real connections in this unit runner.
class_alias(Illuminate\Database\Eloquent\Model::class, 'support\Model');
class TestUserContext
{
    public static function getUserBurned(string $date, ?UserInfoData $userInfo): int
    {
        return 0;
    }
}
class_alias(TestUserContext::class, 'app\common\context\UserInfo');
class TestTaskController extends app\controller\TaskController
{
    // Skip the unrelated global audit-option lookup when formatting responses.
    protected function json(int $code, string $msg = 'ok', array $data = []): support\Response
    {
        return new support\Response(200, [], json_encode(['code' => $code, 'msg' => $msg, 'data' => $data]));
    }
}
Webman\Config::load(__DIR__ . '/config');

$db = new Capsule();
$db->addConnection(['driver' => 'sqlite', 'database' => ':memory:', 'prefix' => '']);
$db->setAsGlobal();
$db->bootEloquent();
$schema = $db->schema();
foreach (['meal_records', 'meal_record_foods', 'user_goals', 'user_steps'] as $table) {
    $schema->create($table, function (Blueprint $table) {
        $table->increments('id');
        $table->integer('user_id');
        $table->integer('type')->nullable();
        $table->integer('meal_id')->nullable();
        $table->date('meal_date')->nullable();
        $table->date('record_date')->nullable();
        $table->integer('steps')->default(0);
        $table->text('nutrition')->nullable();
    });
}

function expect(bool $condition, string $message): void
{
    if (!$condition) {
        throw new RuntimeException($message);
    }
}

function requestFor(string $controller, string $action, array $data = [], string $query = ''): support\Request
{
    $body = json_encode($data);
    $request = new support\Request("POST /api/test$query HTTP/1.1\r\nHost: localhost\r\nContent-Type: application/json\r\nContent-Length: " . strlen($body) . "\r\n\r\n$body");
    $request->controller = 'app\\controller\\' . $controller;
    $request->action = $action;
    $user = new UserInfoData();
    $user->refreshUserInfo(['id' => 1, 'status' => 1]);
    $request->userInfo = $user;
    return $request;
}

function invalid(string $validator, string $scene, array $data): void
{
    try {
        $validator::make($data)->withScene($scene)->validate();
    } catch (BusinessException $exception) {
        expect($exception->getCode() === 103, 'Validation must use code 103, not the login-expired code');
        return;
    }
    throw new RuntimeException("$validator accepted invalid input");
}

$tests = [];
$tests['controller middleware rejects invalid input before the handler'] = function () {
    foreach ([['DiaryController', 'add'], ['DiaryController', 'delete'], ['FoodController', 'recognize'],
        ['FeedController', 'create'], ['FeedController', 'like'], ['SmsController', 'send'],
        ['AuthController', 'sms'], ['AuthController', 'login'], ['UserGoalController', 'save'],
        ['UserController', 'update', ['weight' => -1]]] as $case) {
        $handled = false;
        try {
            (new Middleware())->process(requestFor($case[0], $case[1], $case[2] ?? []), function () use (&$handled) {
                $handled = true;
            });
            throw new RuntimeException("{$case[0]}::{$case[1]} did not reject input");
        } catch (BusinessException $exception) {
            expect($exception->getCode() === 103 && !$handled, 'Handler ran before validation');
        }
    }
};
$tests['meal nested rules reject invalid IDs and quantities but accept fractional servings'] = function () {
    $valid = ['type' => 4, 'foods' => [['food_id' => 1, 'unit_id' => 1, 'number' => 0.5]]];
    MealRecordValidator::make($valid)->withScene('create')->validate();
    foreach (['food_id' => 0, 'unit_id' => 0, 'number' => 0] as $field => $value) {
        $bad = $valid;
        $bad['foods'][0][$field] = $value;
        invalid(MealRecordValidator::class, 'create', $bad);
    }
    invalid(MealRecordValidator::class, 'create', ['type' => 0, 'foods' => $valid['foods']]);
    invalid(MealRecordValidator::class, 'create', ['type' => 1, 'foods' => []]);
    MealRecordValidator::make(['meal_record_food_id' => 1])->withScene('delete')->validate();
};
$tests['feed supports text and video without poster while enforcing nested fields'] = function () {
    $valid = ['content' => str_repeat('餐', 500), 'visibility' => 1, 'attach' => [], 'topic' => [], 'location' => null];
    FeedValidator::make($valid)->withScene('create')->validate();
    $valid['attach'] = [['type' => 1, 'attach' => '/video.mp4', 'poster' => '']];
    FeedValidator::make($valid)->withScene('create')->validate();
    $invalid = $valid;
    $invalid['attach'][0]['type'] = 99;
    invalid(FeedValidator::class, 'create', $invalid);
    $invalid = $valid;
    $invalid['topic'] = ['bad-id'];
    invalid(FeedValidator::class, 'create', $invalid);
    $invalid = $valid;
    $invalid['location'] = ['latitude' => 'bad-latitude'];
    invalid(FeedValidator::class, 'create', $invalid);
};
$tests['AI content and audio format rules work across successive requests'] = function () {
    FoodValidator::make(['type' => 'image', 'content' => str_repeat('x', 151)])->withScene('recognize')->validate();
    invalid(FoodValidator::class, 'recognize', ['type' => 'text', 'content' => str_repeat('x', 151)]);
    invalid(FoodValidator::class, 'recognize', ['type' => 'audio', 'content' => 'base64', 'options' => []]);
    FoodValidator::make(['type' => 'audio', 'content' => 'base64', 'options' => ['format' => 'wav']])->withScene('recognize')->validate();
};
$tests['profile, goal and login validation preserves valid payloads'] = function () {
    UserValidator::make(['nickname' => '测试', 'sex' => 1, 'tall' => 170, 'weight' => 60.5])->withScene('update')->validate();
    $goal = ['daily_calories' => 2000, 'protein' => 150, 'fat' => 55, 'carbohydrate' => 225, 'weight' => 60];
    UserGoalValidator::make($goal)->withScene('save')->validate();
    $goal['daily_calories'] = 0;
    invalid(UserGoalValidator::class, 'save', $goal);
    SmsValidator::make(['mobile' => '13800000000'])->withScene('send')->validate();
    invalid(SmsValidator::class, 'send', ['mobile' => 'bad']);
    LoginValidator::make(['mobile' => '13800000000', 'code' => '123456'])->withScene('sms')->validate();
};
$tests['unconfigured SMS never reports delivery success'] = function () {
    try {
        SmsBusiness::instance()->send('13800000000');
    } catch (RuntimeException $exception) {
        expect(str_contains($exception->getMessage(), '暂不可用'), 'Missing unavailable message');
        return;
    }
    throw new RuntimeException('Unconfigured SMS reported success');
};
$tests['missing, foreign and invalid tasks return terminal error metadata'] = function () use ($schema, $db) {
    $schema->create('tasks', function (Blueprint $table) {
        $table->increments('id');
        $table->string('task_id');
        $table->integer('user_id');
        $table->integer('run_status');
        $table->integer('complete_status');
    });
    $db->table('tasks')->insert([
        ['task_id' => 'foreign', 'user_id' => 2, 'run_status' => 1, 'complete_status' => 1],
        ['task_id' => 'invalid', 'user_id' => 1, 'run_status' => 2, 'complete_status' => 99],
    ]);
    foreach (['' => 'AI_TASK_INVALID', 'missing' => 'AI_TASK_NOT_FOUND', 'foreign' => 'AI_TASK_NOT_FOUND', 'invalid' => 'AI_TASK_INVALID'] as $id => $errorCode) {
        $response = (new TestTaskController())->enquire(requestFor('TaskController', 'enquire', ['taskId' => $id]));
        $result = json_decode($response->rawBody(), true);
        expect($result['code'] !== 0, 'Invalid task reported success');
        expect($result['data']['retryable'] === false && $result['data']['errorCode'] === $errorCode, 'Missing terminal task metadata');
    }
};
$tests['summary uses persisted pro and carb keys and includes all four meals'] = function () use ($db) {
    for ($type = 1; $type <= 4; $type++) {
        $db->table('meal_records')->insert(['user_id' => 1, 'type' => $type, 'meal_date' => date('Y-m-d'),
            'nutrition' => json_encode(['kcal' => 100, 'pro' => 5, 'fat' => 2, 'carb' => 10])]);
    }
    $db->table('meal_records')->insert(['user_id' => 2, 'type' => 1, 'meal_date' => date('Y-m-d'), 'nutrition' => '{"pro":999}']);
    $request = requestFor('DiaryController', 'summary');
    $summary = DiaryBusiness::instance()->summary($request);
    expect((float)$summary['totalIntake']['protein'] === 20.0, 'Protein sum is incorrect');
    expect((float)$summary['totalIntake']['carbs'] === 40.0, 'Carbohydrate sum is incorrect');
    $meals = DiaryBusiness::instance()->meals($request);
    expect(count($meals) === 4 && array_key_exists('加餐', $meals), 'Snack was omitted');
};
$tests['GET history returns distinct pages and honors pageSize'] = function () use ($db) {
    for ($day = 1; $day <= 14; $day++) {
        $db->table('meal_records')->insert(['user_id' => 1, 'type' => 1, 'meal_date' => date('Y-m-d', strtotime("-$day days")), 'nutrition' => '{"kcal":100}']);
    }
    $first = new support\Request("GET /api/diary/history?page=1&pageSize=5 HTTP/1.1\r\nHost: localhost\r\n\r\n");
    $second = new support\Request("GET /api/diary/history?page=2&pageSize=5 HTTP/1.1\r\nHost: localhost\r\n\r\n");
    $first->userInfo = $second->userInfo = requestFor('', '')->userInfo;
    $one = MealRecordBusiness::instance()->history($first);
    $two = MealRecordBusiness::instance()->history($second);
    expect(count($one['data']) === 5 && count($two['data']) === 5, 'pageSize was ignored');
    expect($two['current_page'] === 2, 'GET page was ignored');
    expect(!array_intersect(array_column($one['data'], 'date'), array_column($two['data'], 'date')), 'Repeated first-page dates');
};

$failures = 0;
foreach ($tests as $name => $run) {
    try {
        $run();
        echo "PASS $name\n";
    } catch (Throwable $exception) {
        $failures++;
        echo "FAIL $name: {$exception->getMessage()}\n{$exception->getTraceAsString()}\n";
    }
}
echo count($tests) . " checks, $failures failures\n";
exit($failures ? 1 : 0);
