<?php

namespace plugin\admin\app\controller;

use support\Request;
use support\Response;
use plugin\admin\app\model\FoodNutrition;
use plugin\admin\app\controller\Crud;
use support\exception\BusinessException;

/**
 * 每单位营养成分
 */
class FoodNutritionController extends Crud
{

    /**
     * @var FoodNutrition
     */
    protected $model = null;

    /**
     * 构造函数
     * @return void
     */
    public function __construct()
    {
        $this->model = new FoodNutrition;
    }

    /**
     * 浏览
     * @return Response
     */
    public function index(): Response
    {
        return view('food-nutrition/index');
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
        return view('food-nutrition/insert');
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
        return view('food-nutrition/update');
    }

    protected function afterQuery($items)
    {
        foreach ($items as &$item) {
            $item['food_name'] = $item->food->name;
            $item['unit_name'] = $item->unit->name;
        }
        return $items;
    }

}
