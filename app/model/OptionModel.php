<?php

namespace app\model;

use app\common\base\BaseModel;

class OptionModel extends BaseModel
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'wa_options';

    static function getConfig(string $name, $field = '*')
    {
        if ($field != '*') {
            $option = self::query()->where('name', $name)->selectRaw("JSON_EXTRACT(value, '$.{$field}') as value")->first();
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
}
