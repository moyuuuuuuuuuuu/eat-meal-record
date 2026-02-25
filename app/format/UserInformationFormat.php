<?php

namespace app\format;

use app\common\base\BaseFormat;
use app\common\base\BaseModel;
use app\common\context\UserInfo;
use app\model\MealRecordModel;
use app\model\UserStepsModel;
use app\util\Energy;
use Carbon\Carbon;

class UserInformationFormat extends BaseFormat
{

    public function format(?BaseModel $model = null): array
    {
        $userInfoObj = UserInfo::getUserInfo();
        $userInfo    = $userInfoObj->hidden(['openid', 'unionid'])->toArray();

        // 获取当日步数
        $today = Carbon::today()->toDateString();
        $steps = UserStepsModel::query()
            ->where('user_id', $userInfoObj->id)
            ->where('record_date', $today)
            ->value('steps') ?: 0;

        // 计算每日能量状态
        $energyResult = Energy::dailyStats([
            'gender' => $userInfoObj->sex ?? 1,
            'weight' => $userInfoObj->weight ?? 70,
            'height' => $userInfoObj->tall ?? 175,
            'age'    => $userInfoObj->age ?? 25,
            'steps'  => $steps,
            'intake' => MealRecordModel::getTodayIntake($userInfoObj->id),
            'target' => $userInfoObj->target
        ]);

        return array_merge($userInfo, [
            'joinDays'      => isset($userInfo['created_at']) && $userInfo['created_at'] ? Carbon::parse($userInfo['created_at'])->diffInDays() : 0,
            'totalRecords'  => 0,
            'avgCalories'   => 0,
            'currentWeight' => $userInfoObj->weight ?? 0,
            'targetWeight'  => 0,
            'energy'        => $energyResult
        ]);
    }
}
