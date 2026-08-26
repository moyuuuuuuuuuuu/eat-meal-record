<?php

namespace app\controller;

use app\business\FoodBusiness;
use app\common\base\BaseController;
use app\common\context\TokenLimit;
use support\Request;

class FoodController extends BaseController
{
    protected $noNeedLogin = ['search', 'detail', 'recommendation'];

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

    /**
     * 获取当前用户今日 AI 识别额度。
     */
    public function recognizeQuota(): \support\Response
    {
        return $this->success('ok', TokenLimit::instance()->getQuotaInfo());
    }

    public function recommendation(Request $request): \support\Response
    {
        $data = FoodBusiness::instance()->recommendation($request);
        return $this->success('ok', $data ?? []);
    }
}
