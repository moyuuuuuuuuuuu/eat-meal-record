<?php

namespace app\common\enum;
//1进行中 2已结束
enum TaskRunStatus: int
{
    case Waiting  = 0;
    case Running  = 1;
    case Finished = 2;

    public function label()
    {
        return match ($this) {
            self::Waiting => '等待中',
            self::Running => '进行中',
            self::Finished => '已完成',
        };
    }
}
