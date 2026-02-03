<?php

namespace app\model;


use app\common\base\BaseModel;

class FoodModel extends BaseModel
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'foods';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';

    protected $casts = [
        'nutrition' => 'json',
    ];

    /**
     * 获取食物关联的所有单位及其换算后的营养成分
     *
     * @return array
     */
    public function getUnits()
    {
        $foodUnits = FoodUnitModel::query()
            ->where('food_id', $this->id)
            ->get();

        $units = [];
        // 默认包含 100g 这一项，方便前端展示
        $units[] = [
            'unit_id'    => 0,
            'unit_name'  => '克',
            'weight'     => 100.00,
            'is_default' => false,
            'kcal'       => $this->nutrition['kcal'] ?? 0,
            'protein'    => $this->nutrition['protein'] ?? 0,
            'fat'        => $this->nutrition['fat'] ?? 0,
            'carbs'      => $this->nutrition['carbs'] ?? 0,
        ];

        foreach ($foodUnits as $fu) {
            $unit = UnitModel::find($fu->unit_id);
            if (!$unit) continue;

            $ratio = $fu->weight / 100;
            $units[] = [
                'unit_id'    => $fu->unit_id,
                'unit_name'  => $unit->name,
                'weight'     => (float)$fu->weight,
                'is_default' => (bool)$fu->is_default,
                'kcal'       => round(($this->nutrition['kcal'] ?? 0) * $ratio, 2),
                'protein'    => round(($this->nutrition['protein'] ?? 0) * $ratio, 2),
                'fat'        => round(($this->nutrition['fat'] ?? 0) * $ratio, 2),
                'carbs'      => round(($this->nutrition['carbs'] ?? 0) * $ratio, 2),
            ];
        }

        return $units;
    }

    #===========

    /**
     * 模型关联逻辑
     *
     */
    public function user()
    {
        return $this->hasOne(UserModel::class, 'id', 'user_id');
    }

    public function cat()
    {
        return $this->hasOne(CatModel::class, 'id', 'cat_id');
    }

    /**
     * 食物标签关联
     */
    public function tags()
    {
        return $this->belongsToMany(TagModel::class, 'food_tags', 'food_id', 'tag_id');
    }
}
