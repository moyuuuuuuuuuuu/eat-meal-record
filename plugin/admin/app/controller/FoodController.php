<?php

namespace plugin\admin\app\controller;

use plugin\admin\app\model\FoodNutrition;
use support\Db;
use support\Request;
use support\Response;
use plugin\admin\app\model\Food;
use support\exception\BusinessException;

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
        $this->model = new Food;
    }

    /**
     * 浏览
     * @return Response
     */
    public function index(): Response
    {
        return view('food/index');
    }

    protected function afterQuery($items)
    {
        foreach ($items as &$item) {
            $item['cat_name'] = $item['cat']->name;
        }
        return $items;
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
            $name  = $request->post('name');
            $kal   = $request->post('kal');
            $catId = $request->post('cat_id');
            if (!$name || !$kal || !$catId) {
                return $this->json(1, '食物名称、卡路里、分类不能为空');
            }
            Db::beginTransaction();
            $food = Food::create([
                'name'   => $name,
                'kal'    => $kal,
                'cat_id' => $catId,
            ]);

            if (!$food->save()) {
                Db::rollback();
                return $this->json(1, '添加食物失败');
            }

            $nutrition = $request->post('nutrition');
            if (!$nutrition) {
                Db::rollback();
                return $this->json(1, '添加营养信息失败');
            }
            $saveAll = [];

            $unitFields = array_keys($nutrition);
            $unitCount  = count(current($nutrition));

            for ($i = 1; $i <= $unitCount; $i++) {
                $unitItem = [];
                foreach ($unitFields as $field) {
                    $unitItem[$field] = $nutrition[$field][$i] ?? '';
                    if ($field !== 'image' && !$unitItem[$field]) {
                        Db::rollback();
                        return $this->json(1, '营养信息内容均不能为空');
                    }
                }
                $unitItem['food_id']    = $food->id;
                $unitItem['created_at'] = date('Y-m-d H:i:s');
                $saveAll[]              = $unitItem;
            }

            if (empty($saveAll)) {
                Db::rollback();
                return $this->json(1, '未添加营养信息');
            }

            if (!FoodNutrition::insert($saveAll)) {
                Db::rollback();
                return $this->json(2, '添加营养信息失败');
            }
            Db::commit();
            return $this->json(0, '添加成功');
        }
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
            return parent::update($request);
        }
        return view('food/update');
    }

}
