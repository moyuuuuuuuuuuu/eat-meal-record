<?php

namespace plugin\admin\app\model;

/**
 * @property integer $id ID(主键)
 * @property string $name 标签名称
 * @property integer $type 类型: 1-餐次, 2-口味, 3-营养特点
 * @property mixed $created_at 创建时间
 */
class Tag extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'tags';

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
