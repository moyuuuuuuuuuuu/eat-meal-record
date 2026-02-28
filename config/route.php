<?php
/**
 * This file is part of webman.
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the MIT-LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author    walkor<walkor@workerman.net>
 * @copyright walkor<walkor@workerman.net>
 * @link      http://www.workerman.net/
 * @license   http://www.opensource.org/licenses/mit-license.php MIT License
 */

use Webman\Route;
use app\controller\{MealRecordController,
    TopicController,
    UserController,
    UserGoalController,
    RecommendationController,
    AuthController,
    CategoryController,
    FoodController,
    DiaryController,
    FeedController,
    SmsController,
    UploadController};

Route::group('/api', function () {
    Route::any('/test',[\app\controller\IndexController::class,'index']);
    Route::post('/upload', [UploadController::class, 'upload']);
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::post('/auth/sms/login', [AuthController::class, 'sms']);
    Route::post('/auth/login/mock', [AuthController::class, 'mock']);
    Route::post('/sms/send', [SmsController::class, 'send']);

    #食品相关
    Route::group('/food', function () {
        Route::get('/search', [FoodController::class, 'search']);
        Route::get('/detail', [FoodController::class, 'detail']);
        Route::post('/recognize', [FoodController::class, 'recognize']);
        Route::get('/categories', [CategoryController::class, 'index']);
    });

    Route::get('/recommendation/today', [RecommendationController::class, 'today']);


    #饮食记录 (Diary)
    Route::group('/diary', function () {
        Route::get('', [DiaryController::class, 'meals']);
        Route::post('/meal/add', [DiaryController::class, 'add']);
        Route::post('/meal/food/delete', [DiaryController::class, 'delete']);
        Route::get('/summary', [DiaryController::class, 'summary']);
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
        Route::get('/history', [MealRecordController::class, 'history']);
        Route::get('/relation', [MealRecordController::class, 'relation']);
    });
    Route::group('/location', function () {
        Route::get('/reverse/geo',[\app\controller\LocationController::class, 'rgeo']);
    });
});







