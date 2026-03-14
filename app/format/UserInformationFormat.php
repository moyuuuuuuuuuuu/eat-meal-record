<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;
use app\common\context\UserInfo;
use app\model\MealRecordModel;
use app\model\UserGoalModel;
use app\model\UserStepsModel;
use app\util\Calculate;
use app\util\Energy;
use Carbon\Carbon;
use support\Db;

class UserInformationFormat extends BaseFormat
{

    public function format(?BaseModel $model = null): array
    {
        $model = $model->setHidden(['role', 'openid', 'unionid', 'email', 'hip', 'mobile', 'password', 'signature', 'token', 'join_ip', 'last_time', 'last_ip'])->toArray();

        // 获取用户目标设置
        $goal = UserGoalModel::where('user_id', $model['id'])->first();
        if (!$goal) {
            $goal = [
                'daily_calories' => $model['target'] ?? 2000,
                'protein'        => 150,
                'fat'            => 55,
                'carbohydrate'   => 225,
                'weight'         => 60.00
            ];
        } else {
            $goal = $goal->toArray();
        }

        // 获取当日步数
        $today = Carbon::today()->toDateString();
        $steps = UserStepsModel::query()
            ->where('user_id', $model['id'])
            ->where('record_date', $today)
            ->value('steps') ?: 0;

        // 计算每日能量状态
        $energyResult = Energy::dailyStats([
            'gender' => $model['sex'] ?? 1,
            'weight' => $model['weight'] ?? 70,
            'height' => $model['tall'] ?? 175,
            'age'    => $model['age'] ?? 25,
            'steps'  => $steps,
            'intake' => MealRecordModel::getTodayIntake($model['id']),
            'target' => $model['target']
        ]);
        $totalRecords = MealRecordModel::query()->distinct()->where('user_id', $model['id'])->count('meal_date');
        try {
            $allCalories = MealRecordModel::query()->where('user_id', $model['id'])->sum(Db::raw("nutrition->>'$.kcal'"));
            $avgCalories = Calculate::div((string)$allCalories, (string)$totalRecords); // 合理占位，待接入真实数据
        } catch (\Throwable $e) {
            $avgCalories = 0;
        }

        return array_merge($model, [
            'joinDays'      => isset($userInfo['created_at']) && $model['created_at'] ? (int)Carbon::parse($model['created_at'])->diffInDays() : 0,
            'totalRecords'  => $totalRecords,
            'avgCalories'   => $avgCalories,
            'currentWeight' => $model['weight'] ?? 0,
            'targetWeight'  => $goal['weight'] ?? 0,
            'energy'        => json_encode($energyResult),
            'goal'          => json_encode($goal),
        ]);
    }
}
