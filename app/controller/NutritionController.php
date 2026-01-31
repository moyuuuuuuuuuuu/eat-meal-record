<?php

namespace app\controller;

use app\enum\NutritionInputType;
use app\service\Nutrition;
use app\util\Helper;
use support\Request;

class NutritionController extends BaseController
{
    public function analysis(Request $request)
    {
        $content = $request->post('content', null);
        $type    = $request->post('type', null);
        if (!$type || !$content) {
            return $this->fail('请选择要识别的餐品');
        }

        if (!in_array($type, Helper::cases(NutritionInputType::class))) {
            return $this->fail('不支持的识别方式');
        }
        $template = base_path() . '/template/' . $type;
        if (!file_exists($template)) {
            return $this->fail('服务异常，请稍后再试');
        }
        try {
            $nutritionService = new Nutrition();
            $result           = $nutritionService->request($type, $content);
            return $this->success('', $result);
        } catch (\Exception $exception) {
            return $this->fail($exception->getMessage());
        }

    }
}
