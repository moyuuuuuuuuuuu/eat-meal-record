<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;

class CatFormat extends BaseFormat
{
    public function format(?BaseModel $model = null): array
    {
        return [
            'id'    => $model->id,
            'name'  => $model->name,
            'pid'   => intval($model->pid),
            'sort'  => intval($model->sort),
        ];
    }
}
