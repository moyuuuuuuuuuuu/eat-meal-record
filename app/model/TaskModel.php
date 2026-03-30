<?php

namespace app\model;

use app\common\base\BaseModel;

class TaskModel extends BaseModel
{
    protected $table = 'tasks';

    protected $fillable = [
        'id',
        'task_id',
        'type',
        'params',
        'response',
        'run_status',
        'complete_status',
        'retry_count',
        'worker',
        'error_msg',
        'completed_at',
    ];

    protected $casts = [
        'params'       => 'array',
        'response'     => 'array',
        'created_at'   => 'datetime',
        'updated_at'   => 'datetime',
        'completed_at' => 'datetime',
    ];
}
