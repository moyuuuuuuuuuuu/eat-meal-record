<?php

namespace app\model;


use app\business\FoodBusiness;
use app\common\base\BaseModel;
use app\common\enum\MealRecordType;
use Illuminate\Database\Eloquent\Casts\Attribute;

class MealRecordModel extends BaseModel
{
    protected $table      = 'meal_record';
    protected $primaryKey = 'id';
    protected $fillable   = [
        'user_id',
        'type',
        'nutrition',
        'meal_date',
        'latitude',
        'longitude',
        'address',
    ];
    protected $casts      = [
        'nutrition' => 'json',
        'user_id'   => 'integer',
        'type'      => 'integer',
        'meal_date' => 'date',
        'latitude'  => 'float',
        'longitude' => 'float',
        'address'   => 'string',
    ];

    public function foods()
    {
        return $this->hasMany(MealRecordFoodModel::class, 'meal_id', 'id')->with(['food','unit']);
    }

    protected function type(): Attribute
    {
        return Attribute::make(
            get: function ($value) {
                return match ($value) {
                    MealRecordType::BREAK_FIRST->value => '早餐',
                    MealRecordType::LUNCH->value => '午餐',
                    MealRecordType::DINNER->value => '晚餐',
                    MealRecordType::OTHER->value => '加餐',
                    default => '未知',
                };
            });
    }
}
