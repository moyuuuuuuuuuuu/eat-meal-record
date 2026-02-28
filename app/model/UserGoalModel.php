<?php

namespace app\model;

use app\common\base\BaseModel;

/**
 * @property integer $id 主键
 * @property integer $user_id 用户ID
 * @property integer $daily_calories 每日热量目标 (kcal)
 * @property integer $protein 蛋白质 (g)
 * @property integer $fat 脂肪 (g)
 * @property integer $carbohydrate 碳水化合物 (g)
 * @property float $weight 体重目标 (kg)
 * @property string $created_at 创建时间
 * @property string $updated_at 更新时间
 */
class UserGoalModel extends BaseModel
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'user_goals';

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
        'user_id',
        'daily_calories',
        'protein',
        'fat',
        'carbohydrate',
        'weight'
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'user_id' => 'integer',
        'daily_calories' => 'integer',
        'protein' => 'integer',
        'fat' => 'integer',
        'carbohydrate' => 'integer',
        'weight' => 'float'
    ];
}
