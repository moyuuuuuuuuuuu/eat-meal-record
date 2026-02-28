<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;
use app\common\context\NutritionTemplate;
use app\model\FoodUnitModel;
use app\util\Calculate;

class FoodFormat extends BaseFormat
{

    public function format(?BaseModel $model = null): array
    {
        $model->getNutrition();
        return [
            'id'       => $model->id,
            'name'     => $model->name,
            'category' => $model->cat?->name,
            'unit'     => $model->unit?->name,
            ... NutritionTemplate::instance()->transformation($model->nutrition?->toArray()),
            'units'    => $this->getUnits($model),
        ];
    }

    /**
     * 获取食物关联的所有单位及其换算后的营养成分
     *
     * @return array
     */
    public function getUnits(BaseModel $model)
    {
        $foodUnits = FoodUnitModel::query()
            ->where('food_id', $model->id)
            ->orderBy('is_default', 'desc')
            ->get();
        $units     = [];

        foreach ($foodUnits as $fu) {
            $unit = $fu->unit;
            if (!$unit) continue;

            $ratio         = Calculate::div($fu->weight, '100');
            $calcNutrition = Calculate::mapMul($model->nutrition?->toArray() ?? [], $ratio);
            $units[]       = [
                'unit_id'    => $fu->unit_id,
                'unit_name'  => $unit->name,
                'weight'     => (float)$fu->weight,
                'is_default' => (bool)$fu->is_default,
                'nutrition'  => NutritionTemplate::instance()->transformation($calcNutrition)
            ];
        }

        return $units;
    }
}
