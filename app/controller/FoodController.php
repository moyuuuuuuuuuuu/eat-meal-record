<?php

namespace app\controller;

use app\common\base\BaseController;
use app\model\FoodModel;
use app\model\FoodModel as Food;
use support\Request;

class FoodController extends BaseController
{
    protected $noNeedLogin = ['*'];
    /**
     * 搜索食物列表
     *
     * @param Request $request
     * @return \support\Response
     */
    public function search(Request $request)
    {
        $name     = $request->get('name');
        $catId    = $request->get('cat_id');
        $page     = (int)$request->get('page', 1);
        $pageSize = (int)$request->get('pageSize', 10);
        $pageSize = max(1, min($pageSize, 50));

        $query = Food::query()->where('status', 1);

        if ($name) {
            $query->where('name', 'like', "%$name%");
        }

        if ($catId) {
            $query->where('cat_id', $catId);
        }

        $paginate = $query->with(['cat' => function($q) {
            $q->select('id', 'name');
        }, 'tags'])->paginate($pageSize, ['*'], 'page', $page);

        $items = $paginate->items();
        /**
         * @var $item FoodModel
         */
        foreach ($items as $item) {
            // 为列表提供简化的单位信息（第一个单位或默认单位，或者干脆只给基础营养）
            // UI 稿中搜索结果通常显示每100g的热量，点击进入详情才选单位
            $item->unit_list = $item->getUnits();
        }

        return $this->success('ok', [
            'items' => $items,
            'total' => $paginate->total(),
        ]);
    }

    /**
     * 食物详情
     *
     * @param Request $request
     * @return \support\Response
     */
    public function detail(Request $request)
    {
        $id = $request->get('id');
        if (!$id) {
            return $this->fail('参数错误');
        }

        $food = Food::query()->with(['cat' => function($q) {
            $q->select('id', 'name');
        }, 'tags'])->find($id);

        if (!$food) {
            return $this->fail('食物不存在');
        }

        $data = $food->toArray();
        $data['unit_list'] = $food->getUnits();

        return $this->success('ok', $data);
    }
}
