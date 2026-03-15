<?php

namespace app\model;

use app\common\base\BaseModel;
use app\common\enum\NormalStatus;
use Carbon\Carbon;

class ArticleModel extends BaseModel
{
    protected $table = 'articles';
    public function scopeInShowTime($query)
    {
        $now = Carbon::now()->toDateTimeString();
        return $query->where(function ($q) use ($now) {
            $q->where('is_top', NormalStatus::YES)
                ->orWhere(function ($sub) use ($now) {
                    $sub->where('show_start_time', '<', $now)
                        ->where('show_end_time', '>', $now);
                });
        });
    }
}
