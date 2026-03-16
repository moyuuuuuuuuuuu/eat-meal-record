<?php

use app\controller\{AuthController,
    CategoryController,
    DiaryController,
    FeedController,
    FoodController,
    IndexController,
    MealRecordController,
    NutritionStatsController,
    OptionController,
    SmsController,
    TopicController,
    UploadController,
    UserController,
    UserGoalController,
    ArticleController,
    LocationController};
use support\Redis;
use Webman\Route;

Route::disableDefaultRoute();
Route::fallback(function () {
    $ip  = request()->getRealIp();
    $key = "attack_count:" . $ip;

    // 建议：增加 try-catch 避免 Redis 挂掉导致整个接口 500
    try {
        $count = Redis::incr($key);
        if ($count === 1) {
            Redis::expire($key, 86400);
        }
    } catch (\Throwable $e) {
        $count = 0;
    }

    return json([
        'code' => 404,
        'data' => [
            'ip'          => $ip,
            'visit_count' => $count,
            // 修复点：使用 . 进行字符串拼接
            'notice'      => 'Your IP has been logged for malicious probing.' . ($count > 50 ? ' Are you tired? Should we take a break?' : '')
        ],
        'msg'  => '404 Not Found'
    ]);
});

Route::group('/api', function () {

    if (config('app.debug')) {
        Route::any('/test', [IndexController::class, 'index']);
        Route::post('/auth/login/mock', [AuthController::class, 'mock']);
    }
    Route::get('/option/tabbar',[OptionController::class, 'tabbar']);
    #文章
    Route::get('/article/notice', [ArticleController::class, 'notice']);
    Route::get('/article/user-agreement', [ArticleController::class, 'userAgreement']);
    Route::get('/article/info', [ArticleController::class, 'info']);

    Route::get('/nutrition/stats', [NutritionStatsController::class, 'stats']);
    Route::post('/upload', [UploadController::class, 'uploadForBos']);
    #登录
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::post('/auth/sms/login', [AuthController::class, 'sms']);
    Route::post('/sms/send', [SmsController::class, 'send']);

    #食品相关
    Route::group('/food', function () {
        Route::get('/search', [FoodController::class, 'search']);
        Route::get('/detail', [FoodController::class, 'detail']);
        Route::post('/recognize', [FoodController::class, 'recognize']);
        Route::get('/categories', [CategoryController::class, 'index']);
    });

    Route::get('/recommendation', [FoodController::class, 'recommendation']);
//    Route::get('/recommendation', [RecommendationController::class,'today']);

    #饮食记录 (Diary)
    Route::group('/diary', function () {
        Route::get('', [DiaryController::class, 'meals']);
        Route::post('/meal/add', [DiaryController::class, 'add']);
        Route::post('/meal/food/delete', [DiaryController::class, 'delete']);
        Route::get('/summary', [DiaryController::class, 'summary']);
        Route::get('/history', [MealRecordController::class, 'history']);
    });

    #用户统计与资料
    Route::group('/user', function () {
        Route::get('/stats', [UserController::class, 'stats']);
        Route::get('/information', [UserController::class, 'information']);
        Route::post('/steps', [UserController::class, 'steps']);
        Route::post('/update', [UserController::class, 'update']);
        Route::group('/goal', function () {
            Route::get('', [UserGoalController::class, 'get']);
            Route::post('/save', [UserGoalController::class, 'save']);
        });
    });

    #动态社交 (Feed)
    Route::group('/feed', function () {
        Route::get('/list', [FeedController::class, 'list']);
        Route::get('/detail', [FeedController::class, 'detail']);
        Route::get('/posts', [FeedController::class, 'posts']);
        Route::post('/create', [FeedController::class, 'create']);
        Route::post('/post/like', [FeedController::class, 'like']);
    });

    #话题
    Route::group('/topic', function () {
        Route::get('/search', [TopicController::class, 'search']);
        Route::get('/hot', [TopicController::class, 'hot']);
        Route::post('/create', [TopicController::class, 'create']);
    });

    #餐食记录
    Route::group('/meal', function () {
        Route::get('/relation', [MealRecordController::class, 'relation']);
    });
    #地址信息
    Route::group('/location', function () {
        Route::get('/reverse/geo', [LocationController::class, 'rgeo']);
    });
});
