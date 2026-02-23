<?php

namespace app\controller;

use app\common\base\BaseController;
use app\common\enum\NutritionInputType;
use app\common\exception\ParamException;
use app\queue\contant\QueueEventName;
use app\service\Nutrition;
use app\util\Helper;
use support\Log;
use support\Request;
use Webman\RedisQueue\Client;

class NutritionController extends BaseController
{

    public function analysis(Request $request)
    {

    }
}
