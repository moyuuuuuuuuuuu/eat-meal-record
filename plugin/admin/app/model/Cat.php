<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id (主键)
 * @property string $name 分类名称
 * @property integer $pid 上级分类
 * @property integer $sort 排序
 * @property string $created_at 创建时间
 * @property string $updated_at 编辑时间
 */
class Cat extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'cats';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';
    
    
    
}
