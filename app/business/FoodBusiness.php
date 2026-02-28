<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\enum\BusinessCode;
use app\common\enum\NormalStatus;
use app\common\exception\DataNotFoundException;
use app\common\exception\ValidationException;
use app\format\FoodFormat;
use app\util\Calculate;
use app\model\{CatModel, FoodModel as Food, FoodUnitModel, FoodModel, UnitModel};
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
            ->with([
                'cat' => function ($q) {
                    $q->select('cats.id', 'cats.name');
                },
                'unit',
                'nutrition'
            ])
            ->where('status', NormalStatus::YES->value);

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
        $paginate   = $query->orderByDesc('id')
            ->paginate($pageSize, ['*'], 'page', $page);
        $foodFormat = new FoodFormat($request);
        $paginate->getCollection()->transform(function ($item) use ($foodFormat) {
            return $foodFormat->format($item);
        });
        return $paginate->toArray();
    }

    public function detail(Request $request)
    {
        $id = $request->get('id');
        if (!$id) {
            throw new ValidationException('ID');
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

    public function syncRemote($data)
    {
        $foodList = $data['foods'] ?? [];
        if (empty($foodList)) return true;
        $newFoodList = [];
        $foodFormat  = new FoodFormat(null);
        foreach ($foodList as $item) {
            $foodInfo      = Db::transaction(function () use ($item, $foodFormat) {
                // 1. 解析单位与重量 (保持你原有的逻辑)
                $unitStr  = $item['unit'] ?? '1 份';
                $unitArr  = explode(' ', trim($unitStr));
                $unitNum  = (float)($unitArr[0] ?? 1);
                $unitName = $unitArr[1] ?? '份';

                $totalWeightStr = $item['weight'] ?? '100g';
                $totalWeight    = (float)preg_replace('/[^0-9.]/', '', $totalWeightStr);
                if ($totalWeight <= 0) $totalWeight = 100;

                // 2. 换算 100g 营养成分
                $ratio          = Calculate::div('100', (string)$totalWeight, 10);
                $localNutrition = [];
                // 定义三方字段到数据库字段的映射
                $fieldMap = [
                    'potassium'   => 'kalium', // 三方叫 potassium, 数据库叫 kalium
                    'folate'      => 'folic',    // 三方叫 folate, 数据库叫 folic
                    'cholesterin' => 'cholesterol',
                    'vitaminA'    => 'vitamin_a',
                ];

                foreach ($item['nutrition'] as $nut) {
                    $key                    = $nut['name'];
                    $dbKey                  = $fieldMap[$key] ?? $key; // 转换映射，没有映射则用原名
                    $val                    = (string)$nut['value'];
                    $localNutrition[$dbKey] = (float)Calculate::mul($val, $ratio, 2);
                }

                // 3. 处理单位
                $unit = UnitModel::firstOrCreate(['name' => $unitName], ['type' => 'count']);
                if ($unit->wasRecentlyCreated) $newItems['units'][] = $unitName;

                // 4. 处理食物基础信息
                $catId = CatModel::where('name', '其他')->value('id') ?:
                    CatModel::insertGetId(['name' => '其他', 'pid' => 0, 'sort' => 100]);

                $food = FoodModel::updateOrCreate(
                    ['name' => $item['name']],
                    ['cat_id' => $catId, 'status' => 1]
                );

                // 5. 【核心补充】维护 food_nutrients 营养表
                // 注意：这里需要根据 food_id 更新或创建
                $localNutrition['food_id'] = $food->id;
                \app\model\FoodNutrientModel::updateOrCreate(
                    ['food_id' => $food->id],
                    $localNutrition
                );

                // 6. 维护食物单位换算关系
                $singleUnitWeight = Calculate::div((string)$totalWeight, (string)$unitNum, 2);
                FoodUnitModel::updateOrCreate(
                    ['food_id' => $food->id, 'unit_id' => $unit->id],
                    ['weight' => $singleUnitWeight, 'is_default' => 0]
                );
                return $food;
            });
            $newFoodList[] = $foodFormat->format($foodInfo);
        }
        return $newFoodList;
    }
}
