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
use support\Request;
use Webman\Validation\Annotation\Validate;

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

    #[Validate(validator: FoodValidator::class, scene: 'recognize')]
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

        if (!TokenLimit::instance()->hasQuota()) {
            return $this->fail('抱歉，AI识别次数已经用完，请先手动选择食物吧');
        }
        try {
            $type   = NutritionInputType::tryFrom($type);
            $result = match ($type) {
                NutritionInputType::IMAGE => (new Nutrition())->request($type, $content),
                NutritionInputType::TEXT => FoodService::nutrition($type, $content),
                NutritionInputType::AUDIO => (function () use ($type, $content, $options) {
                    $result = Bos::instance()->putObjFromBase($content, $options);
                    if (!$result) {
                        throw new BusinessException('录音文件上传失败', BusinessCode::THREE_PART_ERROR->value);
                    }
                    return FoodService::nutrition($type, $result);
                })(),
                default => throw new BusinessException('不支持的识别方式', BusinessCode::BUSINESS_ERROR->value),
            };
            if (!isset($result['foods']) || empty($result['foods'])) {
                throw new DataNotFoundException('识别失败');
            }
            return $this->success('ok', FoodBusiness::instance()->syncRemote($result));
        } catch (\Exception $exception) {
            return $this->fail($exception->getMessage());
        }
    }
}
