<?php

namespace plugin\admin\app\model;

use Illuminate\Database\Eloquent\SoftDeletes;
use plugin\admin\app\model\Base;

/**
 * @property integer $id ID(主键)
 * @property string $title 文章标题
 * @property integer $type 文章类型
 * @property string $content 文章正文
 * @property string $brief 简介/摘要
 * @property integer $status 状态
 * @property integer $sort 排序权重
 * @property string $show_start_time 展示开始时间
 * @property string $show_end_time 展示结束时间
 * @property integer $is_top 是否置顶
 * @property string $creator 创建人
 * @property string $create_time 创建时间
 * @property string $update_time 更新时间
 * @property string $deleted_at
 */
class Article extends Base
{
    use SoftDeletes;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'articles';

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
