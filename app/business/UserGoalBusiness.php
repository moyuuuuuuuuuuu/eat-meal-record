<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\validate\UserGoalValidator;
use app\model\UserGoalModel;
use app\model\UserModel;
use support\Request;
use Webman\Validation\Annotation\Validate;

class UserGoalBusiness extends BaseBusiness
{
    /**
     * 获取用户目标设置
     * @param int $userId
     * @return array
     */
    public function getGoal(int $userId): array
    {
        $goal = UserGoalModel::where('user_id', $userId)->first();
        if (!$goal) {
            // 返回默认值，逻辑参考图片
            return [
                'user_id'        => $userId,
                'daily_calories' => 2000,
                'protein'        => 150,
                'fat'            => 55,
                'carbohydrate'   => 225,
                'weight'    => 60.00
            ];
        }
        return $goal->toArray();
    }

    /**
     * 保存用户目标设置
     * @param Request $request
     * @return array
     */
    #[Validate(validator: UserGoalValidator::class, scene: 'save')]
    public function saveGoal(Request $request): array
    {
        $userId = $request->userInfo->id;
        $params = $request->post();

        $goal = UserGoalModel::updateOrCreate(
            ['user_id' => $userId],
            [
                'daily_calories' => $params['daily_calories'],
                'protein'        => $params['protein'],
                'fat'            => $params['fat'],
                'carbohydrate'   => $params['carbohydrate'],
                'weight'    => $params['weight'],
            ]
        );

        // 同时更新 wa_users 表中的 target (卡路里) 字段以保持兼容
        UserModel::where('id', $userId)->update(['target' => $params['daily_calories']]);

        return $goal->toArray();
    }
}
