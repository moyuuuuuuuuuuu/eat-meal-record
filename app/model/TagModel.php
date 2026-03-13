<?php

namespace app\model;


use app\common\base\BaseModel;

class TagModel extends BaseModel
{
    const UPDATED_AT = null;
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
    public    $timestamps = false;
    protected $fillable   = [
        'name',
        'type',
        'meal_type'
    ];
}
