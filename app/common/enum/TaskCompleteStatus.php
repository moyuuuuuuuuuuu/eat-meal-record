<?php

namespace app\common\enum;
enum TaskCompleteStatus: int
{
    case Running = 1;
    case Success = 2;
    case Failed  = 3;

    public function label()
    {
        return match ($this) {
            self::Running => '进行中',
            self::Success => '成功',
            self::Failed => '失败',
        };
    }

    public function labelCode()
    {
        return match ($this) {
            self::Running => 'running',
            self::Success => 'completed',
            self::Failed => 'failed',
        };
    }
}
