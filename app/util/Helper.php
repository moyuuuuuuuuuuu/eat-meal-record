<?php

namespace app\util;

class Helper
{
    static function cases($enum): array
    {
        if (!enum_exists($enum)) {
            return [];
        }
        $cases  = $enum::cases();
        $return = [];
        foreach ($cases as $case) {
            $return[$case->name] = $case->value;
        }
        return $return;
    }
}
