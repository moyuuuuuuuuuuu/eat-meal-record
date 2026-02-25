<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;

class TopicFormat extends BaseFormat
{
    public function format(?BaseModel $model = null): array
    {
        return [
            'id'          => $model->id,
            'title'       => $model->title,
            'thumb'       => source($model->thumb),
            'description' => $model->description,
            'join'        => intval($model->join),
            'post'        => intval($model->post),
        ];
    }
}
