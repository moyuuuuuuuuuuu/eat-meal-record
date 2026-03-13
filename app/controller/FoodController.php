<?php

namespace app\controller;

use app\business\FoodBusiness;
use app\common\base\BaseController;
use app\common\enum\NutritionInputType;
use app\common\exception\DataNotFoundException;
use app\common\exception\ValidationException;
use app\service\FoodService;
use app\service\Nutrition;
use app\util\Helper;
use support\Request;

class FoodController extends BaseController
{
    protected $noNeedLogin = ['*'];

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
        /* $response = json_decode(file_get_contents(public_path() . '/qianfan_response.json'), true);
         return $this->success('ok', FoodBusiness::instance()->syncRemote($response));*/
        $content = $request->post('content', null);
        $type    = $request->post('type', null);
        $options = $request->post('options', []);
        if (!$type || !$content) {
            throw new ValidationException('类型', '内容');
        }

        if (!in_array($type, Helper::cases(NutritionInputType::class))) {
            return $this->fail('不支持的识别方式');
        }

//        if(TokenLimit::instance()->hasQuota())
        try {
            $type = NutritionInputType::tryFrom($type);
            if ($type == NutritionInputType::IMAGE) {
                $nutritionService = new Nutrition();
                $result           = $nutritionService->request($type, $content, $options);
            } else {
                $result = FoodService::nutrition($content, $type);
            }
            if (!isset($result['foods']) || empty($result['foods'])) {
                throw new DataNotFoundException('识别失败');
            }
            return $this->success('ok', FoodBusiness::instance()->syncRemote($result));
        } catch (\Exception $exception) {
            return $this->fail($exception->getMessage());
        }
    }
}
