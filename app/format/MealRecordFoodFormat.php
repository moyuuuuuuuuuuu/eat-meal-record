<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;

class MealRecordFoodFormat extends BaseFormat
{

    public function format(?BaseModel $model = null): array
    {
        return [
            'id'       => $model->id,
            'name'     => $model->food?->name,
            'amount'   => intval($model->number),
            'unit'     => $model->unit?->name,
            'calories' => $model->nutrition['kcal'],
            'protein'  => $model->nutrition['protein'],
            'carbs'    => $model->nutrition['carbohydrate'],
        ];
    }
}
