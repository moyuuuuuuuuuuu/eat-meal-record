<?php

namespace plugin\admin\app\controller;

use support\Request;
use support\Response;
use plugin\admin\app\model\Unit;
use plugin\admin\app\controller\Crud;
use support\exception\BusinessException;

/**
 * 食品单位 
 */
class UnitController extends Crud
{
    
    /**
     * @var Unit
     */
    protected $model = null;

    /**
     * 构造函数
     * @return void
     */
    public function __construct()
    {
        $this->model = new Unit;
    }
    
    /**
     * 浏览
     * @return Response
     */
    public function index(): Response
    {
        return view('unit/index');
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
        return view('unit/insert');
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
        return view('unit/update');
    }

}
