<?php

namespace app\controller;

use app\common\base\BaseController;
use support\Request;
use support\Response;

class RecommendationController extends BaseController
{
    /**
     * 今日吃什么推荐
     *
     * @param Request $request
     * @return Response
     */
    public function today(Request $request): Response
    {
        try {
            $data = \app\business\RecommendationBusiness::instance()->today($request);
            return $this->success('ok', $data);
        } catch (\Throwable $e) {
            return $this->fail($e->getMessage());
        }
    }
}
