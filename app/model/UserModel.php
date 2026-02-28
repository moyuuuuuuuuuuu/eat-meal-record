<?php

namespace app\model;

use app\common\base\BaseModel;
use app\common\enum\user\{Sex, Status};
use Illuminate\Database\Eloquent\Casts\Attribute;

/**
 * @property integer $id 主键
 * @property string $username 用户名
 * @property string $nickname 昵称
 * @property string $password 密码
 * @property string $sex 性别
 * @property string $avatar 头像
 * @property string $email 邮箱
 * @property string $mobile 手机
 * @property string $openid 微信小程序openid
 * @property string $unionid 微信unionid
 * @property string $signature 个性签名
 * @property string $background 背景图
 * @property integer $age 年龄
 * @property integer $tall 身高 cm
 * @property float $weight 体重 kg
 * @property float $bmi bmi
 * @property float $bust 胸围 cm
 * @property float $waist 腰围 cm
 * @property float $hip 臀围 cm
 * @property integer $target 卡路里目标
 * @property integer $level 等级
 * @property string $birthday 生日
 * @property float $money 余额
 * @property integer $score 积分
 * @property string $last_time 登录时间
 * @property string $last_ip 登录ip
 * @property string $join_time 注册时间
 * @property string $join_ip 注册ip
 * @property string $token token
 * @property string $created_at 创建时间
 * @property string $updated_at 更新时间
 * @property integer $role 角色
 * @property integer $status 禁用
 */
class UserModel extends BaseModel
{

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'wa_users';

    /**
     * The primary key associated with the table.
     *
     * @var string
     */
    protected $primaryKey = 'id';

    protected function sexText(): Attribute
    {
        return Attribute::make(
            get: function ($value, $attributes) {
                return Sex::tryFrom($attributes['sex'])->label() ?? '未知';
            }
        );
    }

    protected function statusText(): Attribute
    {
        return Attribute::make(
            get: function ($value, $attributes) {
                return Status::tryFrom($attributes['status']??'')->label() ?? '未知';
            }
        );
    }

    protected function avatarText(): Attribute
    {
        return Attribute::make(
            get: function ($value, $attributes) {
                return source($attributes['avatar'] ?? '');
            }
        );
    }

}
