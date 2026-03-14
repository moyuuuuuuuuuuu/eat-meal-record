<?php

namespace plugin\admin\app\controller;

use app\common\enum\NormalStatus;
use app\model\BlogModel;
use app\model\FollowModel;
use plugin\admin\app\model\Cat;
use plugin\admin\app\model\FoodTag;
use plugin\admin\app\model\FoodUnit;
use plugin\admin\app\model\Tag;
use plugin\admin\app\model\Unit;
use plugin\admin\app\model\User;
use support\Db;
use support\Request;
use support\Response;
use plugin\admin\app\model\Food;
use plugin\admin\app\controller\Crud;
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

    protected function afterQuery($items)
    {
        $foodIdList    = array_column($items, 'id');
        $foodUnitTable = (new FoodUnit())->getTable();
        $unitTable     = (new Unit())->getTable();

        $unitList = Unit::query()
            ->select([$unitTable . '.id', $unitTable . '.name', $foodUnitTable . '.food_id'])
            ->leftJoin($foodUnitTable, $foodUnitTable . '.unit_id', '=', $unitTable . '.id')
            ->whereIn($foodUnitTable . '.food_id', $foodIdList)
            ->get()
            ->groupBy('food_id') // 集合会自动识别别名或完整路径名
            ->toArray();

        $tagTable     = (new Tag())->getTable();
        $foodTagTable = (new FoodTag())->getTable();

        $tagCollection = Tag::query()
            ->select([$tagTable . '.id', $tagTable . '.name', $foodTagTable . '.food_id'])
            ->leftJoin($foodTagTable, $foodTagTable . '.tag_id', '=', $tagTable . '.id')
            ->whereIn($foodTagTable . '.food_id', $foodIdList)
            ->get();

        $catList = Cat::query()->whereIn('id', array_column($items, 'cat_id'))->pluck('name', 'id')->toArray();

        $tagList  = $tagCollection->groupBy('food_id')->toArray();
        $userList = User::query()->whereIn('id', array_column($items, 'user_id'))->pluck('nickname', 'id')->toArray();
        foreach ($items as &$item) {
            $fid              = $item['id'];
            $item['tags']     = $tagList[$fid] ?? [];
            $item['units']    = $unitList[$fid] ?? [];
            $item['cat_name'] = $catList[$item['cat_id'] ?? 0] ?? '未知';
            $item['username'] = $userList[$item['user_id'] ?? 0] ?? '-';
        }
        unset($item); // 销毁引用，防止后续污染
        return $items;
    }

}
