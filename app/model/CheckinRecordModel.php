<?php

namespace app\model;

use app\model\BaseModel;

class CheckinRecordModel extends BaseModel
{
    const SUCCESS       = 'success';
    const FAILURE_OVER  = 'failure_over';
    const FAILURE_UNDER = 'failure_under';
    protected $table    = 'checkin_record';
    protected $fillable = [
        'user_id',
        'date',
        'target_calorie',
        'total_calorie',
        'result',
        'date'
    ];
}
