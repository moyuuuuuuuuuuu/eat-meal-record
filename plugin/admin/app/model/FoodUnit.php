<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id ID(主键)
 * @property integer $food_id 食物
 * @property integer $unit_id 所属单位
 * @property string $weight 换算重量 (1单位 ≈ ? g)
 * @property integer $is_default 是否为默认
 * @property string $remark 备注
 */
class FoodUnit extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'food_units';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';
    /**
     * Indicates if the model should be timestamped.
     *
     * @var bool
     */
    public $timestamps = false;

    
    
}
