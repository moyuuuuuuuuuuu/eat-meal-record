<?php

namespace app\model;

use app\common\base\BaseModel;
use Illuminate\Database\Eloquent\SoftDeletes;

class CatModel extends BaseModel
{
    use SoftDeletes;

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

    protected $fillable = [
        'name',
        'pid',
        'sort'
    ];
}
