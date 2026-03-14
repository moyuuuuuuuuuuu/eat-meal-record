<?php

namespace plugin\admin\app\controller;

use plugin\admin\app\model\Food;
use support\Db;
use support\Request;
use support\Response;
use plugin\admin\app\model\FoodUnit;
use plugin\admin\app\controller\Crud;
use support\exception\BusinessException;

/**
 * 单位食品列表
 */
class FoodUnitController extends Crud
{

    /**
     * @var FoodUnit
     */
    protected $model = null;

    /**
     * 构造函数
     * @return void
     */
    public function __construct()
    {
        $this->model = new FoodUnit;
    }

    /**
     * 浏览
     * @return Response
     */
    public function index(): Response
    {
        return view('food-unit/index');
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
        $assignData = [];
        if ($foodId = $request->get('id')) {
            $assignData['foodId'] = $foodId;
        }
        return view('food-unit/insert', $assignData);
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
            return Db::transaction(function () use ($request) {
                [$id, $data] = $this->updateInput($request);
                $model = $this->model->find($id);
                if ($data['is_default']) {
                    $this->model->where('food_id', $model->food_id)->where('id', '<>', $id)->update(['is_default' => 0]);
                }
                foreach ($data as $key => $val) {
                    $model->{$key} = $val;
                }
                $model->save();
                return $this->json(0);
            });
        }
        return view('food-unit/update');
    }

}
