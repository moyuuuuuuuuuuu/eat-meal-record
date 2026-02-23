<?php

namespace app\business;

use app\common\base\BaseBusiness;
use support\Request;

class FeedBusiness extends BaseBusiness
{
    public function list(Request $request): array
    {
        return [
            ['id' => 1, 'title' => '今日份减脂餐', 'content' => '鸡胸肉+西兰花...', 'author' => '健康达人', 'likes' => 120],
            ['id' => 2, 'title' => '坚持运动第30天', 'content' => '打卡！', 'author' => '运动狂', 'likes' => 350]
        ];
    }

    public function detail(Request $request): array
    {
        return [
            'id' => 1,
            'title' => '今日份减脂餐',
            'content' => '详细做法如下...',
            'comments' => [
                ['user' => '路人甲', 'text' => '学到了']
            ]
        ];
    }

    public function like(Request $request)
    {
        return ['status' => 'success', 'new_likes' => 121];
    }

    public function post(Request $request):array
    {

    }
}
