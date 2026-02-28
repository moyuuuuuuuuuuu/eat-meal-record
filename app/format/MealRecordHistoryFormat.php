<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;
use app\model\MealRecordFoodModel;
use app\util\Energy;
use Carbon\Carbon;

class MealRecordHistoryFormat extends BaseFormat
{


    public function format(?BaseModel $model = null): array
    {
        $mealDateCarbon = Carbon::parse($model->meal_date)->toDateString();
        return [
            'id'            => $mealDateCarbon,
            'date'          => $mealDateCarbon,
            'totalCalories' => $model->totalCalories,
            'totalBurned'   => $this->calculateBurned($model),
            'mealCount'     => $model->mealCount,
            'items'         => $this->meals($model)
        ];
    }

    protected function calculateBurned(?BaseModel $model): float
    {
        if (!$model) {
            return 0;
        }
        //依据用户bmi、身高、体重、步数计算卡路里消耗
        return Energy::runningBurn(
            $this->request->userInfo->sex,
            $this->request->userInfo->weight,
            $this->request->userInfo->tall,
            $model->steps ?? 0
        );
    }


    protected function meals(?BaseModel $model)
    {
        if (!$model) {
            return [];
        }
        $parseTime                      = Carbon::parse($model->meal_date);
        $startOfDay                     = $parseTime->startOfDay()->format('Y-m-d H:i:s');
        $endOfDay                       = $parseTime->endOfDay()->format('Y-m-d H:i:s');
        $mealRecordFoodList             = MealRecordFoodModel::query()
            ->whereBetween('created_at', [$startOfDay, $endOfDay])
            ->get();
        $mealRecordFoodForHistoryFormat = new MealRecordFoodForHistoryFormat($this->request);
        $mealRecordFoodList->transform(function ($item,) use ($mealRecordFoodForHistoryFormat) {
            return $mealRecordFoodForHistoryFormat->format($item);
        });
        return $mealRecordFoodList;
    }
}
