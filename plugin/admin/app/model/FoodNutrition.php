<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id (主键)
 * @property integer $food_id 食物id
 * @property integer $unit_id 单位
 * @property integer $number 默认数量
 * @property string $kal 卡路里
 * @property string $protein 蛋白质
 * @property string $fat 脂肪
 * @property string $carbo 碳水化合物
 * @property string $sugar 糖分
 * @property string $image 参考图片
 * @property string $created_at 创建时间
 * @property string $updated_at
 */
class FoodNutrition extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'food_nutrition';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'food_id',
        'unit_id',
        'number',
        'kal',
        'protein',
        'fat',
        'carbo',
        'sugar',
        'image',
    ];

    function food()
    {
        return $this->hasOne(Food::class, 'id', 'food_id');
    }


    function unit()
    {
        return $this->hasOne(FoodsUnit::class, 'id', 'unit_id');
    }

}
