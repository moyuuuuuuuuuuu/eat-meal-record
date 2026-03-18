<?php

namespace app\model;

use app\common\base\BaseModel;
use support\Redis;

class OptionModel extends BaseModel
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'wa_options';

    static function getConfig(string $name, string $field = '*')
    {
        if ($field != '*') {
            $option = self::query()->where('name', $name)->selectRaw("`value`->>'$.{$field}' as `value`")->first();
        } else {
            $option = self::query()->where('name', $name)->select('value')->first();
        }
        if (!$option) {
            return null;
        }
        $value  = $option->value;
        $option = json_decode($value, true);
        return $option ?: $value;
    }

    static function isAudit()
    {
        if (Redis::exists('system:config:is-audit')) {
            return Redis::get('system:config:is-audit') == 'on';
        }
        $isAudit = self::query()->where('name', 'system_config')->selectRaw("`value`->>'$.logo.audit' as `value`")->value('value');
        Redis::set('system:config:is-audit', $isAudit);
        return $isAudit == 'on';
    }
}
