<?php

namespace app\controller;

use app\business\UserGoalBusiness;
use app\common\base\BaseController;
use app\common\validate\UserGoalValidator;
use Webman\Validation\Annotation\Validate;
use support\Request;

class UserGoalController extends BaseController
{
    /**
     * 获取目标设置
     * @param Request $request
     * @return \support\Response
     */
    public function get(Request $request)
    {
        $userId = $request->userInfo->id;
        return $this->success('ok', UserGoalBusiness::instance()->getGoal($userId));
    }

    /**
     * 保存目标设置
     * @param Request $request
     * @return \support\Response
     */
    #[Validate(validator: UserGoalValidator::class, scene: 'save')]
    public function save(Request $request)
    {
        return $this->success('保存成功', UserGoalBusiness::instance()->saveGoal($request));
    }
}
