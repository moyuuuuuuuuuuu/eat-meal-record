<?php

namespace plugin\admin\app\controller;

use support\Request;
use support\Response;
use plugin\admin\app\model\Topic;
use plugin\admin\app\controller\Crud;
use support\exception\BusinessException;

/**
 * 话题列表
 */
class TopicController extends Crud
{

    protected $dataLimitField = 'creator_id';
    /**
     * @var Topic
     */
    protected $model = null;

    /**
     * 构造函数
     * @return void
     */
    public function __construct()
    {
        $this->model = new Topic;
    }

    /**
     * 浏览
     * @return Response
     */
    public function index(): Response
    {
        return view('topic/index');
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
        return view('topic/insert');
    }

    /**
     * 更新
     * @param Request $request
     * @return Response
     * @throws BusinessException
     */
    public function update(Request $request): Response
    {
        if ($request->method() === 'POST') {
            return parent::update($request);
        }
        return view('topic/update');
    }

}
