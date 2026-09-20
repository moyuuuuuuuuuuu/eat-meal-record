<?php

namespace app\common\base;

use app\common\enum\BusinessCode;
use app\common\exception\BusinessException;
use support\validation\{Validator};

class BaseValidator extends Validator
{
    public function validate(): array
    {
        if (parent::fails()) {
            throw new BusinessException($this->errors()->first(), BusinessCode::PARAM_ERROR->value);
        }
        return parent::validate();
    }
}
