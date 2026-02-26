<?php

namespace plugin\admin\app\model;

/**
 * @property integer $id
 * @property integer $user_id
 * @property integer $type 0早餐 1午餐 2晚餐 3加餐
 * @property integer $kal
 * @property integer $fat
 * @property integer $protein
 * @property integer $carbo
 * @property string $meal_date
 */
class MealRecord extends Base
{
    protected $table = 'meal_records';
    protected $primaryKey = 'id';
}
