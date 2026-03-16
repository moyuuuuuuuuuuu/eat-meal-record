<?php

namespace app\model;


use app\common\base\BaseModel;
use app\common\enum\foodUnit\IsDefault;
use Illuminate\Database\Eloquent\SoftDeletes;

class FoodModel extends BaseModel
{
    use SoftDeletes;

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
        'status',
        'is_common',
        'is_ingredient'
    ];

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

    public function getTag(int $limit = 3)
    {
        return TagModel::query()->whereIn('id', FoodTagModel::query()->select('tag_id')->where('food_id', $this->id))->limit($limit)->get();
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
