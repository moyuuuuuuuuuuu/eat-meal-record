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

Route::group('/api', function () {
    Route::group('/author', function () {
        Route::post('/sessionKey', ['app\controller\AuthorController', 'getSessionKey']);//获取sessionKey
    });
    Route::group('/login', function () {
        Route::post('/sms', ['app\controller\LoginController', 'sms']);//发送短信验证码 废弃
        Route::post('/wechat/mini', ['app\controller\LoginController', 'wechat']);//微信小程序登录
        Route::post('/wechat/mp', ['app\controller\LoginController', 'mp']);//微信公众号登录 废弃
        Route::post('/account', ['app\controller\LoginController', 'account']);//账号密码登录 废弃
        Route::put('/refresh', ['app\controller\LoginController', 'refresh']);//刷新token
    });
    Route::post('/sms', ['app\controller\LoginController', 'sendSms']);//发送短信验证码 废弃
    Route::group('/food', function () {
        Route::any('/normal', ['app\controller\FoodController', 'index']);//普通查询
        Route::any('/history', ['app\controller\FoodController', 'history'])->middleware(\app\middleware\VerifyToken::class);//查询历史
        Route::any('/analysis', ['app\controller\FoodController', 'analysis']);//图片获取食物营养信息
    });
    Route::group('/meal', function () {
        Route::post('/create', ['app\controller\MealController', 'create']);//创建餐食记录
        Route::group('/today', function () {
            Route::get('', ['app\controller\MealController', 'today']);//查询今天的餐食记录
            Route::post('/statistics', ['app\controller\MealController', 'currentStatistics']);//查询今天的统计信息
        });
    })->middleware(\app\middleware\VerifyToken::class);
    Route::group('/user', function () {
        Route::get('/meal', ['app\controller\UserController', 'mealRecord']);//查询用户的餐食记录
        Route::put('/body', ['app\controller\UserController', 'body']);//更新用户的身材信息
        Route::get('/info', ['app\controller\UserController', 'info']);//查询用户信息
        Route::get('/fans', ['app\controller\UserController', 'fans']);//查询用户粉丝
        Route::get('/follow', ['app\controller\UserController', 'follow']);//查询用户关注
        Route::get('/friend', ['app\controller\UserController', 'friend']);//查询用户好友
    })->middleware(\app\middleware\VerifyToken::class);
    Route::group('/topic', function () {
        Route::get('', ['app\controller\TopicController', 'list']);//查询话题列表
        Route::post('create', ['app\controller\TopicController', 'create']);
    })->middleware(\app\middleware\VerifyToken::class);
    Route::post('/upload', ['app\controller\UploadController', 'upload']);//上传
});

Route::fallback(function () {
    return response('', 404);
});




