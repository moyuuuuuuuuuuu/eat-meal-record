<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\context\UserInfo;
use app\common\enum\BusinessCode;
use app\common\enum\NormalStatus;
use app\format\UserInformationFormat;
use app\model\UserModel;
use app\model\MealRecordModel;
use app\model\UserStepsModel;
use app\queue\contant\QueueEventName;
use app\service\wechat\WxMini;
use app\util\Jwt;
use Carbon\Carbon;
use plugin\admin\app\model\User;
use support\Context;
use support\Db;
use support\exception\BusinessException;
use support\Request;
use Webman\RedisQueue\Client;

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

        $openid     = $wxResult['openId'];
        $unionid    = $wxResult['unionId'] ?? null;
        $sessionKey = $wxResult['sessionKey'] ?? null;

        if (!$openid) {
            throw new \Exception('获取 openid 失败');
        }

        // 2. 查找或创建用户
        $user = UserModel::where('openid', $openid)->first();
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
        } else {
            // 更新登录信息
            $user->last_time = date('Y-m-d H:i:s');
            $user->last_ip   = $ip;
            if ($unionid && !$user->unionid) {
                $user->unionid = $unionid;
            }
            $user->save();
        }

        // 临时存储 session_key 用于后续解密（通常可以存入 Redis，这里简化处理返回或后续由前端传入）
        // 实际上 wx.getWeRunData 需要最新的 session_key，建议在登录时保存到 cache
        if ($sessionKey) {
            \support\Cache::set('wx_session_key_' . $user->id, $sessionKey, 7200);
        }

        /*Client::send(QueueEventName::AFTER_LOGIN->value, [
            'userId'        => $user->id,
            'ip'            => $ip,
            'lastLoginTime' => now(),
        ]);*/
        return UserInfo::setUserInfo(userInfo: $user);
    }

    public function sms(Request $request): array
    {
        $mobile = $request->post('mobile');
        $code   = $request->post('code');
        if (!(SmsBusiness::instance()->check($mobile, $code))) {
            throw new BusinessException('短信验证码错误', BusinessCode::PARAM_ERROR);
        }
        // 2. 查找或创建用户
        $user = UserModel::where('mobile', $mobile)->first();
        if (!$user) {
            $user = UserModel::create([
                'mobile'    => $mobile,
                'nickname'  => substr($mobile, 7) . rand(10000, 99999),
                'username'  => 'm_' . substr(md5($mobile), 0, 8),
                'join_time' => date('Y-m-d H:i:s'),
                'join_ip'   => $request->getRealIp(),
                'status'    => NormalStatus::YES
            ]);
        } else {
            // 更新登录信息
            $user->last_time = date('Y-m-d H:i:s');
            $user->last_ip   = $request->getRealIp();
            $user->save();
        }

        /*Client::send(QueueEventName::AFTER_LOGIN->value, [
            'userId'        => $user->id,
            'ip'            => $ip,
            'lastLoginTime' => now(),
        ]);*/
        return UserInfo::setUserInfo(userInfo: $user);
    }

    /**
     * 上传/同步微信步数
     *
     * @param Request $request
     * @return bool
     * @throws \Exception
     */
    public function uploadSteps(Request $request): bool
    {
        $userId        = $request->userInfo->id;
        $encryptedData = $request->post('encryptedData');
        $iv            = $request->post('iv');

        if (!$encryptedData || !$iv) {
            throw new \Exception('缺少必要参数');
        }

        // 从缓存获取 session_key
        $sessionKey = \support\Cache::get('wx_session_key_' . $userId);
        if (!$sessionKey) {
            throw new \Exception('登录态已失效，请重新登录', 401);
        }

        // 解密数据
        $data = WxMini::getInstance()->parseEncryptData($encryptedData, $sessionKey, $iv);

        // stepInfoList 包含过去三十天的步数
        $stepInfoList = $data['stepInfoList'] ?? [];
        if (empty($stepInfoList)) {
            return false;
        }

        // 我们通常只关心今天的步数，或者同步最近几天的
        // 这里同步所有返回的步数记录
        foreach ($stepInfoList as $info) {
            $date  = date('Y-m-d', $info['timestamp']);
            $steps = $info['step'];

            UserStepsModel::updateOrCreate(
                ['user_id' => $userId, 'record_date' => $date],
                ['steps' => $steps]
            );
        }

        return true;
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

    /**
     * 用户信息
     * @param Request $request
     * @return array
     */
    public function information(Request $request): array
    {
        return (new UserInformationFormat($request))->format();
    }
}
