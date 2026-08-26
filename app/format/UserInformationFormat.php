<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;
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
            'target' => $model['target'] ?? 0.00
        ]);
        $totalRecords = MealRecordModel::query()->distinct()->where('user_id', $model['id'])->count('meal_date');
        try {
            $allCalories = MealRecordModel::query()->where('user_id', $model['id'])->sum(Db::raw("nutrition->>'$.kcal'"));
            $avgCalories = $totalRecords > 0 ? round((float)Calculate::div((string)$allCalories, (string)$totalRecords)) : 0;
        } catch (\Throwable $e) {
            $avgCalories = 0;
        }

        $sex = (string)($model['sex'] ?? '3');
        $height = (int)($model['tall'] ?? 0);
        $weight = (float)($model['weight'] ?? 0);

        return array_merge($model, [
            // 标准展示字段；保留 sex/tall/weight 兼容旧客户端。
            'gender'        => \app\common\enum\user\Sex::tryFrom($sex)?->label() ?? '未知',
            'height'        => $height,
            'joinDays'      => !empty($model['created_at']) ? (int)floor(Carbon::parse($model['created_at'])->diffInDays()) + 1 : 0,
            'totalRecords'  => $totalRecords,
            'avgCalories'   => $avgCalories,
            'currentWeight' => $weight,
            'targetWeight'  => (float)($goal['weight'] ?? 0),
            'energy'        => json_encode($energyResult),
            'goal'          => json_encode($goal),
        ]);
    }
}
