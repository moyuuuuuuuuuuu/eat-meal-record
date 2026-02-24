<?php

namespace plugin\admin\app\model;

use Illuminate\Database\Eloquent\Casts\Attribute;
use plugin\admin\app\model\Base;

/**
 * @property integer $id 话题ID(主键)
 * @property string $title 标题
 * @property string $thumb 封面
 * @property string $description 话题描述
 * @property integer $creator_id 创建者
 * @property integer $status 状态
 * @property integer $join 参与人数
 * @property integer $post 关联文章/餐食记录数
 * @property string $created_at 创建时间
 * @property string $updated_at 更新时间
 */
class Topic extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'topics';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';


    protected function creatorId()
    {
        return Attribute::make(set: function () {
            return admin_id();
        });
    }
}
