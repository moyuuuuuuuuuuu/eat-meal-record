<?php

namespace app\controller;

use app\business\FoodBusiness;
use app\common\base\BaseController;
use app\common\context\TokenLimit;
use app\common\enum\BusinessCode;
use app\common\enum\NutritionInputType;
use app\common\exception\DataNotFoundException;
use app\common\exception\ValidationException;
use app\common\validate\FoodValidator;
use app\common\validate\MealRecordValidator;
use app\service\baidu\Bos;
use app\service\FoodService;
use app\service\Nutrition;
use app\util\Helper;
use Moyuuuuuuuu\QianFan\Payload\Audio;
use support\exception\BusinessException;
use support\Log;
use support\Request;
use Webman\Validation\Annotation\Validate;

class FoodController extends BaseController
{
    protected $noNeedLogin = ['search','detail','recommendation'];

    /**
     * 搜索食物列表
     *
     * @param Request $request
     * @return \support\Response
     */
    public function search(Request $request)
    {
        return $this->success('ok', FoodBusiness::instance()->search($request));
    }

    /**
     * 食物详情
     *
     * @param Request $request
     * @return \support\Response
     */
    public function detail(Request $request)
    {
        return $this->success('ok', FoodBusiness::instance()->detail($request));
    }

    /**
     * AI识别餐食营养信息
     * @param Request $request
     * @return \support\Response
     */
    public function recognize(Request $request)
    {
        return $this->success('ok', FoodBusiness::instance()->recognize($request));
    }

    public function recommendation(Request $request): \support\Response
    {
        try {
            $data = FoodBusiness::instance()->recommendation($request);
            return $this->success('ok', $data);
        } catch (\Throwable $e) {
            return $this->fail($e->getMessage());
        }
    }
}
