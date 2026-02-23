<?php

namespace app\common\base;

use support\Model;
use DateTimeInterface;

class BaseModel extends Model
{

    /**
     * 格式化日期
     *
     * @param DateTimeInterface $date
     * @return string
     */
    protected function serializeDate(DateTimeInterface $date)
    {
        return $date->format('Y-m-d H:i:s');
    }

    static function printSql($query){
        if (!config('app.debug')) {
            return '';
        }
        $sql      = $query->toSql();
        $bindings = $query->getBindings();

        $fullSql = vsprintf(
            str_replace('?', '%s', $sql),
            collect($bindings)->map(fn($v) => is_numeric($v) ? $v : "'" . $v . "'")->toArray()
        );
        return $fullSql;
    }

}
