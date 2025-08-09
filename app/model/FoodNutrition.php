<?php

namespace app\model;


use Illuminate\Database\Eloquent\Casts\Attribute;

class FoodNutrition extends BaseModel
{
    protected $table   = 'food_nutrition';
    protected $appends = ['image', 'desc'];
    protected $guarded = ['id'];

    public function image(): Attribute
    {
        return Attribute::make(
            get: fn($value) => $this->getImageAttribute($value),
        );
    }

    public function desc(): Attribute
    {
        return Attribute::make(
            get: fn($value) => $value ?? '',
        );
    }

    public function getImageAttribute($value)
    {
        $value = $value ?? '';
        return $value ? request()->domain() . $value : '';
    }

    public function unit()
    {
        return $this->belongsTo(FoodUnitModel::class, 'unit_id');
    }

    public function food()
    {
        return $this->hasOne(FoodModel::class, 'id', 'food_id');
    }
}
