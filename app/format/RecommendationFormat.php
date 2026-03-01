<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;
use app\common\context\NutritionTemplate;

class RecommendationFormat extends BaseFormat
{

    public function format(?BaseModel $model = null): array
    {
        $tagList = $model->getTag();
        $model->getNutrition();
        return [
            'id'       => $model->id,
            'name'     => $model->name,
            'category' => $model->cat?->name,
            ... NutritionTemplate::instance()->transformation($model->nutrition?->toArray()),
            'tag' => $tagList->pluck('name')->toArray(),
        ];
    }
}
