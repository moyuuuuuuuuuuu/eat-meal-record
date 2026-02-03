<?php

namespace app\controller;

use app\common\base\BaseController;
use app\common\enum\NutritionInputType;
use app\queue\contant\QueueEventName;
use app\service\Nutrition;
use app\util\Helper;
use support\Log;
use support\Request;
use Webman\RedisQueue\Client;

class NutritionController extends BaseController
{
    /**
     * AI识别餐食营养信息
     * @param Request $request
     * @return \support\Response
     */
    public function analysis(Request $request)
    {
        $content = $request->post('content', null);
        $type    = $request->post('type', null);
        $options = $request->post('options',[]);
        if (!$type || !$content) {
            return $this->fail('请选择要识别的餐品');
        }

        if (!in_array($type, Helper::cases(NutritionInputType::class))) {
            return $this->fail('不支持的识别方式');
        }
        try {
            $nutritionService = new Nutrition();
            $result           = $nutritionService->request($type, $content, $options);
            Log::info($type.'的请求结果',$result);
            Client::send(QueueEventName::REMOTE_FOOD_SYNC->value,$result);
            return $this->success('', $result);
        } catch (\Exception $exception) {
            return $this->fail($exception->getMessage());
        }

    }
}
