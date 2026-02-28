<?php

namespace app\model;


use app\common\base\BaseModel;

class FoodUnitModel extends BaseModel
{

    const CREATED_AT = null;
    const UPDATED_AT = null;
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'food_units';

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
        'food_id',
        'unit_id',
        'weight',
        'is_default',
        'remark'
    ];

    public function unit()
    {
        return $this->hasOne(UnitModel::class, 'id', 'unit_id');
    }

}
