<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\context\UserInfo;
use app\model\UserModel;
use app\model\MealRecordModel;
use app\service\wechat\WxMini;
use app\util\Jwt;
use Carbon\Carbon;
use plugin\admin\app\model\User;
use support\Context;
use support\Request;

class UserBusiness extends BaseBusiness
{
    /**
     * 微信小程序登录
     *
     * @param string $code
     * @param string $ip
     * @return array
     * @throws \Exception
     */
    public function login(string $code, string $ip): array
    {
        // 1. 调用微信接口换取 openid
        $wxMini   = WxMini::getInstance();
        $wxResult = $wxMini->jsCode2Session($code);

        $openid  = $wxResult['openId'];
        $unionid = $wxResult['unionId'] ?? null;

        if (!$openid) {
            throw new \Exception('获取 openid 失败');
        }

        // 2. 查找或创建用户
        $user = User::where('openid', $openid)->first();
        if (!$user) {
            $user            = new User();
            $user->openid    = $openid;
            $user->unionid   = $unionid;
            $user->username  = 'wx_' . substr(md5($openid), 0, 8);
            $user->nickname  = '微信用户';
            $user->password  = ''; // 小程序用户不需要密码
            $user->join_time = date('Y-m-d H:i:s');
            $user->join_ip   = $ip;
            $user->status    = 0;
            $user->save();
        } else {
            // 更新登录信息
            $user->last_time = date('Y-m-d H:i:s');
            $user->last_ip   = $ip;
            if ($unionid && !$user->unionid) {
                $user->unionid = $unionid;
            }
            $user->save();
        }

        return UserInfo::setUserInfo(userInfo: $user);
    }

    public function mock(int $id, string $ip)
    {
        $openid  = uniqid();
        $unionid = uniqid();
        // 2. 查找或创建用户
        $user = UserModel::where('id', $id)->first();
        if (!$user) {
            $user            = new UserModel();
            $user->openid    = $openid;
            $user->unionid   = $unionid;
            $user->username  = 'wx_' . substr(md5($openid), 0, 8);
            $user->nickname  = '微信用户';
            $user->password  = ''; // 小程序用户不需要密码
            $user->join_time = date('Y-m-d H:i:s');
            $user->join_ip   = $ip;
            $user->status    = 0;
            $user->save();
        }
        // 更新登录信息
        $user->last_time = date('Y-m-d H:i:s');
        $user->last_ip   = $ip;
        $user->save();
        return UserInfo::setUserInfo(userInfo: $user);
    }

    /**
     * 用户统计信息
     *
     * 说明：
     * - 为兼容当前数据结构不完善的情况，以下统计做了容错与占位，
     *   当相关字段/表缺失时返回合理的默认值，待库表齐备后可进一步完善。
     */
    public function stats(Request $request): array
    {
        // 获取当前用户，若无登录信息则使用 id=1 作为演示用户
        $userInfo = $request->userInfo;

        // 加入天数：优先使用用户的 created_at，否则为 0
        $joinDays = 0;
        if ($userInfo && isset($userInfo->created_at)) {
            try {
                $joinDays = Carbon::parse($userInfo->created_at)->diffInDays();
            } catch (\Throwable $e) {
                $joinDays = 0;
            }
        }

        // 记录总数：基于 MealRecordModel，若表缺失或字段缺失，则返回 0
        $totalRecords = 0;
        try {
            $totalRecords = (int)MealRecordModel::query()->count();
        } catch (\Throwable $e) {
            $totalRecords = 0;
        }

        // 平均摄入热量：若无法统计则给出一个合理占位
        $avgCalories = 0;
        try {
            // 如果后续有每日摄入热量表，可在此改为 AVG 统计
            $avgCalories = $userInfo->target; // 合理占位，待接入真实数据
        } catch (\Throwable $e) {
            $avgCalories = 0;
        }

        // 身高/体重/目标体重等信息，当前项目暂无专用表，先给占位
        $currentWeight = $userInfo->weight;
        $targetWeight  = 0;
        $height        = $userInfo->tall;
        $age           = $userInfo->age;
        $gender        = '未知';

        return [
            'name'          => $user->username ?? '用户',
            'joinDays'      => $joinDays,
            'totalRecords'  => $totalRecords,
            'avgCalories'   => $avgCalories,
            'currentWeight' => $currentWeight,
            'targetWeight'  => $targetWeight,
            'height'        => $height,
            'age'           => $age,
            'gender'        => $gender,
        ];
    }
}
