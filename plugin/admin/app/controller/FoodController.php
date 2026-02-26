<?php

namespace plugin\admin\app\controller;

use plugin\admin\app\model\addtional\FoodModelAdditional;
use plugin\admin\app\model\Dict;
use plugin\admin\app\model\Food;
use support\exception\BusinessException;
use support\Request;
use support\Response;
use support\View;

/**
 * 食品列表
 */
class FoodController extends Crud
{

    /**
     * @var Food
     */
    protected $model = null;

    /**
     * 构造函数
     * @return void
     */
    public function __construct()
    {
        $this->model = new FoodModelAdditional();
    }

    /**
     * 浏览
     * @return Response
     */
    public function index(): Response
    {
        return view('food/index');
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
            $data              = $request->post();
            $data['nutrition'] = json_encode($data['nutrition']);
            $id                = $this->doInsert($data);
            return $this->json(0, 'ok', ['id' => $id]);
        }
        $nutritionDict = Dict::get('nutrition');
        View::assign('nutritionDict', (array)$nutritionDict);
        return view('food/insert');
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
            [$id, $data] = $this->updateInput($request);
            $nutritionDict   = Dict::get('nutrition');
            $submitNutrition = json_decode($data['nutrition'], true);
            $nutrition       = [];
            foreach ($nutritionDict as $item) {
                $nutrition[$item['value']] = $submitNutrition[$item['name']];
            }
            $data['nutrition'] = json_encode($nutrition);
            $this->doUpdate($id, $data);
            return $this->json(0);
        }

        $nutritionDict = Dict::get('nutrition');
        View::assign('nutritionDict', (array)$nutritionDict);
        return view('food/update');
    }

}
