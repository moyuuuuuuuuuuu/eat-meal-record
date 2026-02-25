<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;
use app\common\enum\blog\AttachType;
use app\common\enum\NormalStatus;
use app\model\FoodModel;
use app\model\MealRecordFoodModel;
use app\model\MealRecordModel;

class BlogAttachFormat extends BaseFormat
{

    public function format(?BaseModel $model = null): array
    {
        return [
            'attach' => match ($model->type) {
                AttachType::FOOD->value => $this->food($model),
                AttachType::RECORD->value => $this->record($model),
                AttachType::REPRICE->value => $this->reprice($model),
                default => source($model->attach)
            },
            'type'   => $model->type,
            'poster' => source($model->poster),
        ];
    }


    protected function food($model): array
    {
        $food = FoodModel::query()->select(['id', 'nutrition', 'name'])
            ->where('id', $model->attach)
            ->where('status', NormalStatus::YES->value)
            ->first();
        return $food ? (new FoodFormat($this->request))->format($food) : [];
    }

    protected function record($model): array
    {
        $mealRecordInfo = MealRecordModel::query()->select('type', 'nutrition', 'id')->where('id', $model->attach)->first();
        if (!$mealRecordInfo) {
            return [];
        }

        $mainTable    = (new MealRecordFoodModel())->getTable();
        $foodTable    = (new FoodModel())->getTable();
        $mealFoodList = MealRecordFoodModel::query()
            ->leftJoin($foodTable, $foodTable . '.id', '=', $mainTable . '.food_id')
            ->where('meal_id', $model->attach)
            ->pluck($foodTable . '.name')->toArray();

        return [
            'id'       => $model->attach,
            'calories' => $mealRecordInfo?->nutrition['kcal'] ?? 0,
            'type'     => $mealRecordInfo->type,
            'foods'    => $mealFoodList,
        ];
    }

    protected function reprice($model): array
    {
        return [];
    }
}
