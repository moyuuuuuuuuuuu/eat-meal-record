<?php

namespace app\model;


use app\common\base\BaseModel;
use app\common\context\NutritionTemplate;
use app\common\enum\foodUnit\IsDefault;
use support\Log;

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

    protected $fillable = [
        'name',
        'cat_id',
        'user_id',
        'status'
    ];

    /**
     * 获取食物关联的所有单位及其换算后的营养成分
     *
     * @return array
     */
    public function getUnits()
    {
        $foodUnits = FoodUnitModel::query()->where('food_id', $this->id)->get();
        $units     = [];
        $nutrition = $this->nutrition;
        foreach ($foodUnits as $fu) {
            $unit = $fu->unit;
            if (!$unit) continue;

            $ratio   = $fu->weight / 100;
            $units[] = [
                'unit_id'    => $fu->unit_id,
                'unit_name'  => $unit->name,
                'weight'     => (float)$fu->weight,
                'is_default' => (bool)$fu->is_default,
                'nutrition'  => NutritionTemplate::instance()->format(array_map(function ($value) use ($ratio) {
                    return is_numeric($value)
                        ? round($value * $ratio, 2)
                        : $value;
                }, $nutrition))
            ];
        }

        return $units;
    }


    public function getNutrition()
    {
        $this->nutrition = FoodNutrientModel::query()->where('food_id', $this->id)->first();
        return $this;
    }

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

    public function nutrition()
    {
        return $this->hasOne(FoodNutrientModel::class, 'food_id', 'id')->select(explode(',', getenv('NUTRITION_TEMPLATE_SHOW_KEY')));
    }

    public function unit()
    {
        $foodUnitTable = (new FoodUnitModel())->getTable();
        $unitTable     = (new UnitModel())->getTable();
        return $this->hasOneThrough(
            UnitModel::class,
            FoodUnitModel::class,
            'food_id',
            'id',
            'id',
            'unit_id'
        )->select([$unitTable . '.id', $unitTable . '.name'])
            ->where($foodUnitTable . '.is_default', IsDefault::YES->value);
    }

    /**
     * 食物标签关联
     */
    public function tags()
    {
        $tagTable = (new TagModel())->getTable();
        return $this->belongsToMany(TagModel::class, 'food_tags', 'food_id', 'tag_id')->select($tagTable . '.id', $tagTable . '.name', $tagTable . '.type');
    }
}
