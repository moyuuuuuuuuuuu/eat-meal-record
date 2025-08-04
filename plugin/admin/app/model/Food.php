<?php

namespace plugin\admin\app\model;

use plugin\admin\app\model\Base;

/**
 * @property integer $id (主键)
 * @property integer $user_id 所属用户 0为公共数据
 * @property integer $cat_id 分类
 * @property string $name 食物名称
 * @property string $kal 每100g卡路里
 * @property string $created_at 创建时间
 * @property string $updated_at 更新时间
 */
class Food extends Base
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'food';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';

    protected $fillable = [
        'name',
        'kal',
        'cat_id',
    ];

    public function cat()
    {
        return $this->belongsTo(FoodCat::class, 'cat_id', 'id');
    }


}
