<?php

namespace app\common\context;

use app\common\enum\UserInfoContext;
use app\format\UserInformationFormat;
use app\model\UserModel;
use support\Redis;

/**
 * @property int $id 用户ID
 * @property string $username 用户名
 * @property string $nickname 昵称
 * @property string $avatar 头像地址
 * @property int $sex 性别: 1-男, 2-女
 * @property int $age 年龄
 * @property int $tall 身高(cm)
 * @property string $weight 当前体重(kg)
 * @property string $birthday 出生日期
 * @property int $target 目标热量摄入
 * @property int $role 角色权限
 * @property int $status 状态
 * @property string $last_time 最后登录时间
 * @property string $created_at 注册时间
 * @property string $updated_at 更新时间
 * * --- 关联数据 & 动态计算属性 ---
 * @property int $goaldaily_calories 每日目标热量
 * @property object|array{
 *     protein:float,
 *     fat:float,
 *     carbohydrate:float,
 *     weight:float
 * } $goal 目标蛋白质(g)
 * @property object|array{
 *     bmr:string,
 *     totalBurn:string,
 *     intake:string,
 *     deficit:string,
 *     completionRate:string,
 *     bmi:string
 * } $energy 基础代谢率
 * * @property float $joinDays 加入天数
 * @property string $currentWeight 当前体重
 * @property float $targetWeight 目标体重
 */
final class UserInfoData implements \JsonSerializable
{
    protected array $data      = [];
    protected array $hidden    = [];
    protected array $jsonField = ['energy', 'goal'];

    public function setUserInfo(int|UserModel $userId)
    {
        if (!Redis::exists(UserInfoContext::UserInfo->value . $userId)) {
            $userInfo = $this->refreshUserInfo($userId);
        } else {
            $userInfo = Redis::hGetAll(UserInfoContext::UserInfo->value . $userId);
        }
        foreach ($userInfo as $k => $v) {
            if (in_array($k, $this->hidden)) {
                continue;
            } else if (in_array($k, $this->jsonField)) {
                $v = json_decode($v);
            }
            $this->data[$k] = $v;
        }
        return $this;
    }

    public function refreshUserInfo(int|UserModel $userInfo)
    {
        if (!$userInfo instanceof UserModel) {
            $userInfo = UserModel::query()->where('id', $userInfo)->first();
        }
        $userInfo->load('goal');
        $userId   = $userInfo->id;
        $userInfo = (new UserInformationFormat())->format($userInfo);
        Redis::hMSet(UserInfoContext::UserInfo->value . $userId, $userInfo);
        Redis::expire(UserInfoContext::UserInfo->value . $userId, 3600 + rand(10, 99));
        return $userInfo;
    }

    public function setHidden(array $hidden)
    {
        $this->hidden = $hidden;
        return $this;
    }

    public function toArray(): array
    {
        $array = [];
        foreach ($this->data as $k => $v) {
            if (in_array($k, $this->hidden)) {
                unset($array[$k]);
                continue;
            } else if (in_array($k, $this->jsonField) && is_string($v)) {
                $v = json_decode($v, true);
            }
            $array[$k] = $v;
        }
        return $array;
    }

    public function jsonSerialize(): array
    {
        return $this->toArray();
    }

    public function __get(string $name)
    {
        return $this->data[$name] ?? null;
    }

    public function hidden(...$field): self
    {
        $this->hidden = $field;
        return $this;
    }

}
