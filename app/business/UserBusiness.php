<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\context\UserInfo;
use app\common\context\UserInfoData;
use app\common\enum\BusinessCode;
use app\common\enum\NormalStatus;
use app\common\enum\user\Sex;
use app\common\enum\user\Status;
use app\common\enum\UserInfoContext;
use app\common\validate\LoginValidator;
use app\common\validate\UserValidator;
use app\model\UserModel;
use app\model\UserStepsModel;
use app\service\wechat\WxMini;
use app\common\exception\BusinessException;
use app\util\Helper;
use support\Redis;
use support\Request;
use Webman\Validation\Annotation\Validate;

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
        $wxMini   = WxMini::instance();
        $wxResult = $wxMini->jsCode2Session($code);

        $openid     = $wxResult['openId'];
        $unionid    = $wxResult['unionId'] ?? null;
        $sessionKey = $wxResult['sessionKey'] ?? null;

        if (!$openid) {
            throw new BusinessException('获取 openid 失败', BusinessCode::PARAM_ERROR);
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
            $user->status    = Status::NORMAL->value;
            $user->sex       = Sex::NONE->value;
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
        return UserInfo::setUserInfo(userInfo: $user);
    }

    #[Validate(validator: LoginValidator::class, scene: 'sms')]
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
                'status'    => NormalStatus::YES->value
            ]);
        } else {
            // 更新登录信息
            $user->last_time = date('Y-m-d H:i:s');
            $user->last_ip   = $request->getRealIp();
            $user->save();
        }
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
            throw new BusinessException('缺少必要参数', BusinessCode::PARAM_ERROR);
        }

        $sessionKey = \support\Cache::get('wx_session_key_' . $userId);
        if (!$sessionKey) {
            throw new BusinessException('登录状态失效，请重新登录', BusinessCode::NO_LOGIN);
        }

        // 解密数据
        $data = WxMini::instance()->parseEncryptData($encryptedData, $sessionKey, $iv);

        // stepInfoList 包含过去三十天的步数
        $stepInfoList = $data['stepInfoList'] ?? [];
        if (empty($stepInfoList)) {
            return false;
        }
        $todaySteps = 0;
        foreach ($stepInfoList as $info) {
            $date  = date('Y-m-d', $info['timestamp']);
            $steps = $info['step'];
            if ($date === date('Y-m-d')) {
                $todaySteps = $steps;
            }
            UserStepsModel::updateOrCreate(
                ['user_id' => $userId, 'record_date' => $date],
                ['steps' => $steps]
            );
        }
        Redis::set(UserInfoContext::userInfoStepCacheKey($userId), $todaySteps);
        Redis::expire(UserInfoContext::userInfoStepCacheKey($userId), Helper::todayEndTimestamp() - time());
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
        $userInfo = $request->userInfo->toArray();

        return [
            'name'          => $userInfo['nickname'] ?? '用户',
            'joinDays'      => $userInfo['joinDays'] ?? 0,
            'totalRecords'  => $userInfo['totalRecords'] ?? 0,
            'avgCalories'   => $userInfo['avgCalories'] ?? 0,
            'currentWeight' => $userInfo['weight'] ?? 65,
            'targetWeight'  => $userInfo['targetWeight'] ?? 0,
            'height'        => $userInfo['tall'] ?? 175,
            'age'           => $userInfo['age'] ?? 0,
            'gender'        => Sex::tryFrom($userInfo['sex'])->label(),
        ];
    }

    /**
     * 用户信息
     * @param Request $request
     * @return array
     */
    public function information(Request $request): array
    {
        return $request->userInfo->toArray();
    }

    /**
     * 更新用户信息
     * @param Request $request
     * @return array
     */
    #[Validate(validator: UserValidator::class, scene: 'update')]
    public function update(Request $request): array
    {
        $userId = $request->userInfo->id;
        $user   = UserModel::find($userId);
        if (!$user) {
            throw new BusinessException('用户不存在', BusinessCode::NOT_FOUND);
        }

        $params = $request->post();
        $fields = ['nickname', 'avatar', 'sex', 'signature', 'age', 'tall', 'weight', 'birthday', 'target'];

        foreach ($fields as $field) {
            if ($request->post($field) !== null) {
                $user->$field = $params[$field];
            }
        }

        if (!$user->save()) {
            throw new BusinessException('用户信息保存失败', BusinessCode::BUSINESS_ERROR);
        }
        $userInfoData = new UserInfoData();
        $userInfoData->refreshUserInfo($user);
        return $userInfoData->toArray();
    }
}
