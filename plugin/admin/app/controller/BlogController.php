<?php

namespace plugin\admin\app\controller;

use plugin\admin\app\model\User;
use support\Request;
use support\Response;
use plugin\admin\app\model\Blog;
use plugin\admin\app\controller\Crud;
use support\exception\BusinessException;

/**
 * 动态列表
 */
class BlogController extends Crud
{

    /**
     * @var Blog
     */
    protected $model = null;

    /**
     * 构造函数
     * @return void
     */
    public function __construct()
    {
        $this->model = new Blog;
    }

    /**
     * 浏览
     * @return Response
     */
    public function index(): Response
    {
        return view('blog/index');
    }

    /**
     * 插入
     * @param Request $request
     * @return Response
     * @throws BusinessException
     */
    public function insert(Request $request): Response
    {
        if ($request->method() === 'POST') {
            return parent::insert($request);
        }
        return view('blog/insert');
    }

    /**
     * 更新
     * @param Request $request
     * @return Response
     * @throws BusinessException
     */
    public function update(Request $request): Response
    {
        return view('blog/update');
    }

    protected function afterQuery($items)
    {
        $userInfoList = User::query()->whereIn('id', array_column($items, 'user_id'))->get(['avatar', 'id', 'nickname', 'username'])->transform(function ($item) {
            $item->avatar = source($item->avatar);
            return $item;
        })->keyBy('id')->toArray();
        foreach ($items as &$item) {
            $item['visibility_info'] = Blog::getVisibility($item['visibility']);
            $item['userInfo']        = $userInfoList[$item['user_id']];
        }
        return $items;
    }
}
