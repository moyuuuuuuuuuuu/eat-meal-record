<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id 食物ID(主键)
 * @property string $name 食物名称
 * @property integer $cat_id 食物分类
 * @property integer $user_id 所属用户
 * @property integer $status 状态
 * @property mixed $nutrition 每100g的营养信息
 * @property mixed $created_at 创建时间
 * @property mixed $updated_at 更新时间
 * @property mixed $delete_at
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


    public function user()
    {
        return $this->hasOne(User::class, 'id', 'user_id');
    }

}
