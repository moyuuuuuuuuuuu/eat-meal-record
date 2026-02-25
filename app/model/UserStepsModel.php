<?php

namespace app\model;

use app\common\base\BaseModel;

/**
 * @property integer $id 主键
 * @property integer $user_id 用户ID
 * @property integer $steps 步数
 * @property string $record_date 记录日期
 * @property string $created_at 创建时间
 * @property string $updated_at 更新时间
 */
class UserStepsModel extends BaseModel
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'user_steps';

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
        'steps',
        'record_date'
    ];
}
