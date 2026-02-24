<?php

namespace app\model;

use app\common\base\BaseModel;
use app\common\enum\blog\AttachType;
use app\common\enum\NormalStatus;

class BlogAttachModel extends BaseModel
{
    protected $table = 'blog_attach';

    protected $fillable = [
        'blog_id',
        'attach',
        'poster',
        'sort',
        'type'
    ];

    public function format()
    {
        return [
            'attach' => match ($this->type) {
                AttachType::FOOD => $this->food(),
                AttachType::RECORD => $this->record(),
                AttachType::REPRICE => $this->reprice(),
                default => source($this->attach)
            },
            'type'   => $this->type,
            'poster' => $this->poster,
        ];
    }

    protected function food(): array
    {
        return FoodModel::query()->select(['id', 'nutrition', 'name'])
            ->where('id', $this->attach)
            ->where('status', NormalStatus::YES->value)
            ->first()->toArray();
    }

    protected function record(): array
    {
        $mealRecordInfo = MealRecordModel::query()->select('type', 'nutrition', 'id')->where('id', $this->attach)->first();
        if (!$mealRecordInfo) {
            return [];
        }

        $mainTable    = (new MealRecordFoodModel())->getTable();
        $foodTable    = (new FoodModel())->getTable();
        $mealFoodList = MealRecordFoodModel::query()
            ->leftJoin($foodTable, $foodTable . '.id', '=', $mainTable . '.food_id')
            ->where('meal_id', $this->attach)
            ->pluck($foodTable . '.name');

        return [
            'id'       => $this->attach,
            'calories' => $mealRecordInfo->nutrition->kcal,
            'type'     => $mealRecordInfo->type,
            'foods'    => $mealFoodList,
        ];
    }

    protected function reprice(): array
    {
        return [];
    }
}
