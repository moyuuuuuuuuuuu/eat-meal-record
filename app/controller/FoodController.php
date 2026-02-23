<?php

namespace app\controller;

use app\business\FoodBusiness;
use app\common\base\BaseController;
use app\common\enum\BusinessCode;
use app\common\enum\NutritionInputType;
use app\common\exception\ParamException;
use app\model\FoodModel;
use app\model\FoodModel as Food;
use app\queue\contant\QueueEventName;
use app\service\Nutrition;
use app\util\Helper;
use support\Log;
use support\Request;
use Webman\RedisQueue\Client;

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

        $content = $request->post('content', null);
        $type    = $request->post('type', null);
        $options = $request->post('options', []);
        if (!$type || !$content) {
            throw new ParamException('类型', '内容');
        }

        if (!in_array($type, Helper::cases(NutritionInputType::class))) {
            return $this->fail('不支持的识别方式');
        }
        try {
            $nutritionService = new Nutrition();
            $result           = $nutritionService->request($type, $content, $options);
            Log::info($type . '的请求结果', $result);
            Client::send(QueueEventName::REMOTE_FOOD_SYNC->value, $result);
            return $this->success('', $result);
        } catch (\Exception $exception) {
            return $this->fail($exception->getMessage());
        }
    }
}
