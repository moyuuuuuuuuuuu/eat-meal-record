<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;

class MealRecordFoodForHistoryFormat extends BaseFormat
{

    public function format(?BaseModel $model = null): array
    {

        return [
            'name'   => $model->food?->name,
            'amount' => intval($model->number) . $model->unit?->name
        ];
    }
}
