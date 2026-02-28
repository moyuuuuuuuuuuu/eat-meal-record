<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;
use app\common\context\NutritionTemplate;

class MealRecordFoodFormat extends BaseFormat
{

    public function format(?BaseModel $model = null): array
    {
        $nutrition = NutritionTemplate::instance()->transformation($model->nutrition);
        return [
            'id'     => $model->id,
            'name'   => $model->food?->name,
            'amount' => intval($model->number),
            'unit'   => $model->unit?->name,
            ...$nutrition,
        ];
    }
}
