<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;

class MealRecordFormat extends BaseFormat
{

    public function format(?BaseModel $model = null): array
    {
        $foodFormat = new MealRecordFoodFormat($this->request);
        return [
            'id'        => $model->id,
            'type'      => $model->type,
            'nutrition' => $model->nutrition,
            'foods'     => $model->foods->map(function ($item) use ($foodFormat) {
                return $foodFormat->format($item);
            })->toArray()
        ];
    }
}
