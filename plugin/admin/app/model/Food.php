<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id ID(主键)
 * @property string $name 食物名称
 * @property integer $cat_id 食物分类
 * @property integer $user_id 所属用户
 * @property integer $status 状态
 * @property integer $is_ingredient 食材
 * @property mixed $created_at 创建时间
 * @property mixed $updated_at 更新时间
 * @property mixed $delete_at
 * @property integer $is_common 常见食物
 */
class Food extends Base
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


    public function cats()
    {
        return $this->belongsTo(Cat::class, 'cat_id', 'id');
    }

    public function tags()
    {
        return $this->hasManyThrough(FoodTag::class, Tag::class, 'id', 'tag_id', 'id')->select('id', 'name');
    }

    public function units()
    {
        return $this->hasManyThrough(FoodUnit::class, Unit::class, 'id', 'id', 'unit_id', 'id')->select('id', 'name');
    }


}
