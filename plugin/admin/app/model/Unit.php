<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id 单位ID(主键)
 * @property string $name 单位名称
 * @property string $type 单位类型 
 * @property string $desc 描述
 * @property mixed $created_at 创建时间
 * @property mixed $updated_at 更新时间
 * @property mixed $delete_at
 */
class Unit extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'units';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';
    
    
    
}
