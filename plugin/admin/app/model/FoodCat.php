<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id (主键)
 * @property string $name 分类名称
 * @property integer $pid 上级分类id
 * @property integer $sort 排序
 * @property string $created_at 创建时间
 * @property string $updated_at
 */
class FoodCat extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'food_cat';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';
    
    
    
}
