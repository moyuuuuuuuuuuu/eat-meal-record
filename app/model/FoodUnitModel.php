<?php

namespace app\model;


use app\common\base\BaseModel;

class FoodUnitModel extends BaseModel
{

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
    public $timestamps = false;

    public function unit()
    {
        return $this->hasOne(UnitModel::class, 'id', 'unit_id');
    }

}
