<?php

namespace plugin\admin\app\controller;

use plugin\admin\app\model\addtional\FoodModelAdditional;
use plugin\admin\app\model\Dict;
use plugin\admin\app\model\Food;
use plugin\admin\app\model\FoodNutrient;
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
            $data                 = $request->only(['name', 'cat_id', 'user_id', 'status']);
            if (!$data['user_id']) {
                $data['user_id'] = 0;
            }
            $id                   = $this->doInsert($data);
            $nutrients            = $request->post('nutrients');
            $nutrients['food_id'] = $id;
            FoodNutrient::query()->where('food_id', $id)->delete();
            FoodNutrient::query()->insert($nutrients);
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
            $data = $request->only(['name', 'cat_id', 'user_id', 'status']);
            $id   = $request->post('id');
            if (!$this->model->newQuery()->where('id', $id)->exists()) {
                return $this->fail('食品不存在');
            }
            if (!$data['user_id']) {
                $data['user_id'] = 0;
            }
            if (!$this->model::query()->where('id', $id)->update($data)) return $this->fail('编辑失败');
            $nutrients            = $request->post('nutrients');
            $nutrients['food_id'] = $id;
            FoodNutrient::query()->where('food_id', $id)->delete();
            FoodNutrient::query()->insert($nutrients);
            return $this->json(0);
        }

        $nutritionDict = Dict::get('nutrition');
        View::assign('nutritionDict', (array)$nutritionDict);
        return view('food/update');
    }

}
