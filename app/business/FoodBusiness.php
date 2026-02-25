<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\enum\BusinessCode;
use app\common\exception\DataNotFoundException;
use app\common\exception\ParamException;
use app\format\FoodFormat;
use app\model\{FoodModel as Food, FoodUnitModel, FoodModel};
use support\Db;
use support\Request;

class FoodBusiness extends BaseBusiness
{

    public function search(Request $request): array
    {
        $name     = $request->get('name');
        $catId    = $request->get('cat_id');
        $page     = (int)$request->get('page', 1);
        $pageSize = (int)$request->get('pageSize', 10);
        $pageSize = max(1, min($pageSize, 50));
        $query    = FoodModel::query()
            ->where('status', 1);

        if ($name) {
            $query->where('name', 'like', "%$name%");
        }

        if ($catId) {
            $query->where('cat_id', $catId);
        }
        $query->whereExists(function ($query) {
            $mainTable = (new FoodModel())->getTable();
            $subTable  = (new FoodUnitModel)->getTable();
            $query->select(Db::raw(1))
                ->from($subTable)
                ->whereColumn($subTable . '.food_id', $mainTable . '.id');
        });
        $paginate   = $query->with([
            'cat' => function ($q) {
                $q->select('cats.id', 'cats.name');
            },
            'unit'
        ])
            ->paginate($pageSize, ['*'], 'page', $page);
        $foodFormat = new FoodFormat($request);
        $paginate->getCollection()->transform(function ($item)use($foodFormat) {
            return $foodFormat->format($item);
        });
        return $paginate->toArray();
    }

    public function detail(Request $request)
    {
        $id = $request->get('id');
        if (!$id) {
            throw new ParamException('ID');
        }

        $food = Food::query()->with([
            'cat' => function ($q) {
                $q->select('id', 'name');
            }, 'tags'
        ])->find($id);

        if (!$food) {
            throw new DataNotFoundException();
        }

        return (new FoodFormat($request))->format($food);
    }
}
