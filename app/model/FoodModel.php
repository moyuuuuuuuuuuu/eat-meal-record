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
        $foodUnits = $this->foodUnit();

        $units     = [];
        $nutrition = $this->nutrition;
        // 默认包含 100g 这一项，方便前端展示
        $units[] = [
            'unit_id'    => 0,
            'unit_name'  => '克',
            'weight'     => 100.00,
            'is_default' => false,
            'nutrition'  => $nutrition
        ];

        foreach ($foodUnits as $fu) {
            $unit = $fu->unit;
            if (!$unit) continue;

            $ratio   = $fu->weight / 100;
            $units[] = [
                'unit_id'    => $fu->unit_id,
                'unit_name'  => $unit->name,
                'weight'     => (float)$fu->weight,
                'is_default' => (bool)$fu->is_default,
                'nutrition'  => array_map(function ($value) use ($ratio) {
                    return is_numeric($value)
                        ? round($value * $ratio, 2)
                        : $value;
                }, $nutrition)
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

    public function cats()
    {
        return $this->hasOne(CatModel::class, 'id', 'cat_id');
    }

    /**
     * 食物标签关联
     */
    public function tags()
    {
        $tagTable = (new TagModel())->getTable();
        return $this->belongsToMany(TagModel::class, 'food_tags', 'food_id', 'tag_id')->select($tagTable . '.id', $tagTable . '.name', $tagTable . '.type');
    }

    public function foodUnit()
    {
        return $this->hasOne(FoodUnitModel::class, 'food_id', 'id');
    }
}
