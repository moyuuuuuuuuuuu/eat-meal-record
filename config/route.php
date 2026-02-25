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
use app\controller\{
    TopicController,
    UserController,
    RecommendationController,
    AuthController,
    CategoryController,
    FoodController,
    DiaryController,
    PetController,
    FeedController
};

Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/login/mock', [AuthController::class, 'mock']);

Route::group('/food', function () {
    Route::get('/search', [FoodController::class, 'search']);
    Route::get('/detail', [FoodController::class, 'detail']);
    Route::post('/recognize', [FoodController::class, 'recognize']);
});

Route::get('/recommendation/today', [RecommendationController::class, 'today']);

Route::get('/categories', [CategoryController::class, 'index']);

// 饮食记录 (Diary)
Route::group('/diary', function () {
    Route::get('/meals', [DiaryController::class, 'meals']);
    Route::post('/meal/add', [DiaryController::class, 'add']);
    Route::post('/meal/food/delete', [DiaryController::class, 'delete']);
    Route::get('/summary', [DiaryController::class, 'summary']);
});

// 用户统计与资料
Route::group('/user', function () {
    Route::get('/stats', [UserController::class, 'stats']);
    Route::get('/information', [UserController::class, 'information']);
    Route::post('/steps', [UserController::class, 'steps']);
});

// 宠物相关 (Pet)
Route::group('/pet', function () {
    Route::get('/findByStatus', [PetController::class, 'findByStatus']);
    Route::post('', [PetController::class, 'add']);
    Route::put('', [PetController::class, 'update']);
    Route::get('/{petId:\d+}', [PetController::class, 'detail']);
    Route::post('/{petId:\d+}', [PetController::class, 'updateWithForm']);
    Route::delete('/{petId:\d+}', [PetController::class, 'delete']);
    Route::post('/{petId:\d+}/uploadImage', [PetController::class, 'uploadImage']);
});

// 动态社交 (Feed)
Route::group('/feed', function () {
    Route::get('/list', [FeedController::class, 'list']);
    Route::get('/detail', [FeedController::class, 'detail']);
    Route::get('/posts', [FeedController::class, 'posts']);
    Route::post('/create', [FeedController::class, 'create']);
    Route::post('/post/like', [FeedController::class, 'like']);
});

//话题
Route::group('/topic', function () {
    Route::get('/search', [TopicController::class, 'search']);
});







