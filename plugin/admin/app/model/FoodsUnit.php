<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id (主键)
 * @property string $name 单位名称
 * @property string $created_at 创建时间
 * @property string $updated_at
 */
class FoodsUnit extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'foods_unit';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';
    
    
    
}
