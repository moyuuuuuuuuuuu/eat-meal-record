<?php

namespace app\model;

use app\queue\CheckInRecordQueue;
use app\queue\LoginAfterQueue;
use app\service\Jwt;
use support\Db;
use support\Log;
use support\Redis;
use Webman\RedisQueue\Client;

class UserModel extends BaseModel
{
    const STATUS_NORMAL  = 1;
    const STATUS_DISABLE = 2;

    const GENDER_MAN   = 1;
    const GENDER_WOMAN = 2;
    protected $table = 'user';

    protected $fillable = [
        'age', 'avatar', 'background', 'birthday', 'bmi', 'bust', 'check_in_days', 'email', 'fav_count', 'gender', 'hip', 'is_full', 'last_login_ip', 'last_login_platform', 'last_login_time', 'like_count', 'name', 'openid', 'password', 'phone', 'signature', 'status', 'tall', 'target', 'unionid', 'view_count', 'waist', 'weight'
    ];

    public function getAvatarAttribute($value)
    {
        return self::getAttacheUrl($value);
    }

    /**
     * 更新用户信息
     * @param int $userId
     * @param $userInfo
     * @return mixed
     * @throws \Exception
     */
    static function updateUserInfo(int $userId, $userInfo)
    {

        self::removeUserCache($userId);
        $user = self::query()->where(['id' => $userId])->first();
        if (!$user) {
            throw new \Exception('用户不存在');
        }
        $allowField = [
            'age', 'avatar', 'background', 'birthday', 'bmi', 'bust', 'check_in_days', 'email', 'fav_count', 'gender', 'hip', 'is_full', 'last_login_ip', 'last_login_platform', 'last_login_time', 'like_count', 'name', 'openid', 'password', 'phone', 'signature', 'status', 'tall', 'target', 'unionid', 'view_count', 'waist', 'weight'
        ];
        $update     = array_intersect_key($userInfo, array_flip($allowField));

        if (isset($userInfo['birthday'])) {
            $update['age'] = date('Y') - date('Y', strtotime($update['birthday']));
        }
        if (isset($update['tall']) && isset($update['weight'])) {
            $update['bmi'] = $update['weight'] / ($update['tall'] / 100) ** 2;
        }
        if (isset($userInfo['waist'])) {
            $update['waist'] = $userInfo['waist'];
        }
        $user->update($update);
        self::removeUserCache($userId);
        return $user->toArray();
    }

    /**
     * 创建用户
     * @param array $data
     * @return array
     */
    static function createUser(array $data): array
    {
        if (empty($data)) {
            throw new \Exception('参数错误');
        }
        $originalName = $data['name'];
        if (!isset($data['name']) || $originalName === '微信用户') {
            $data['name'] = self::generateUserName();
        }
        if (!isset($data['avatar']) || $originalName === '微信用户') {
            $text           = $data['name'];
            $data['avatar'] = self::generateAvatar($text);
        }

        if (!isset($data['age'])) {
            $data['age'] = 25;
        }
        if (!isset($data['gender'])) {
            $data['gender'] = 1;
        }
        $data = array_merge($data, [
            'is_full' => 0,
            'target'  => 1200,
            'status'  => 1
        ]);
        return self::storageUserInfo(self::create($data));
    }

    static function getUserInfoByOpenId(string $openId)
    {
        $redisKey = 'user:openid:' . md5($openId);
        if (Redis::exists($redisKey)) {
            return self::getUserInfo((int)Redis::get($redisKey));
        }
        $userId = self::query()->where(['openid' => $openId])->value('id');
        if (!$userId) {
            return null;
        }
        Redis::set($redisKey, $userId, 86400 * 30 + rand(10, 150));
        return self::getUserInfo($userId);
    }

    /**
     * 获取用户信息
     * @param int $userId 用户ID
     * @return array|null
     * @throws \Exception
     */
    static function getUserInfo(int $userId): array|null
    {
        $redisKey = 'user:id:' . $userId;
        if (Redis::exists($redisKey)) {
            return Redis::hGetAll($redisKey);
        }
        $userInfo = self::query()->where('id', $userId)->first();
        if (!$userInfo) {
            return null;
        }
        return static::storageUserInfo($userInfo);
    }

    static function storageUserInfo(self $userInfo): array
    {
        $userInfo = [
            'name'           => $userInfo->name,
            'avatar'         => $userInfo->original['avatar'],
            'showAvatar'     => $userInfo->avatar,
            'age'            => $userInfo->age,
            'gender'         => $userInfo->gender,
            'tall'           => $userInfo->tall,
            'birthday'       => $userInfo->birthday,
            'bmi'            => $userInfo->bmi,
            'waist'          => $userInfo->waist,
            'hip'            => $userInfo->hip,
            'arm'            => $userInfo->arm,
            'weight'         => $userInfo->weight,
            'target'         => $userInfo->target,
            'isFull'         => (int)$userInfo->is_full,
            'checkInDays'    => 0,
            'followers'      => FollowModel::getFollowerCount($userInfo->id),
            'likes'          => LikeModel::getCount($userInfo->id, FavoriteModel::TYPE_USER),
            'fans'           => FollowModel::getFansCount($userInfo->id),
            'friend'         => FollowModel::getFriendCount($userInfo->id),
            'id'             => $userInfo->id,
            'status'         => $userInfo->status,
            'signature'      => $userInfo->signature,
            'background'     => $userInfo->background,
            'showBackground' => self::getAttacheUrl($userInfo->background),
        ];

        $redisKey = 'user:id:' . $userInfo['id'];
        Redis::hMSet($redisKey, $userInfo);
        Redis::expire($redisKey, 86400 * 7 + rand(10, 150));
        return $userInfo;
    }


    /**
     * 删除用户缓存
     * @param int $userId
     * @param string|null $openid
     * @return void
     */
    protected static function removeUserCache(int $userId, string $openid = null)
    {
        $redisKeys = ['user:id:' . $userId,];
        if ($openid) {
            $redisKeys[] = 'user:openid:' . md5($openid);
        }
        Redis::del(...$redisKeys);
    }

    /**
     * 登录
     * @param $userInfo
     * @return array
     */
    static function login(array $userInfo)
    {
        list($token, $refreshToken) = Jwt::encode($userInfo['id']);
//        TODO: 登录日志
        Client::send(LoginAfterQueue::QUEUE_NAME, [
            'userId'          => $userInfo['id'],
            'currentDateTime' => date('Y-m-d H:i:s'),
            'ip'              => request()->getRemoteIp(),
            'platform'        => request()->getPlatform(),
        ]);
        return [
            'token'        => $token,
            'refreshToken' => $refreshToken,
            'userInfo'     => $userInfo
        ];
    }

    /**
     * 计算用户是否达成目标
     * @return void
     */
    static function calcUserTarget()
    {
        $allUserNumber = self::where('status', self::STATUS_NORMAL)->count();
        $page          = 1;
        $limit         = 300;
        $maxPage       = ceil($allUserNumber / $limit);
        $today         = date('Y-m-d', strtotime('-1 day'));
        $currentDate   = date('Y-m-d H:i:s');
        while ($page < $maxPage) {
            $failureUserIdList = $successUserIdList = $checkInRecordList = [];
            $userList          = self::select('id,target')->where('status', self::STATUS_NORMAL)->offset(($page - 1) * $limit)->limit($limit)->get();
            collect($userList)->each(function ($item) use (&$continueCheckInUserIdList, &$failureUserIdList, &$today, &$checkInRecordList, &$currentDate) {
                $allKcal     = MealRecordFoodModel::selectRaw('sum(kal) as kal')->whereDate('created_at', $today)->where('user_id', $item->id)->value('kal') ?? 0;
                $checkInItem = [
                    'user_id'        => $item->id,
                    'date'           => $today,
                    'target_calorie' => $item->target,
                    'total_calorie'  => $allKcal,
                    'created_at'     => $currentDate,
                    'updated_at'     => $currentDate,
                ];
                if ($allKcal < $item->target && $allKcal > $item->target * (2 / 3)) {
                    $checkInItem['result']       = CheckinRecordModel::SUCCESS;
                    $continueCheckInUserIdList[] = $item->id;
                } elseif ($allKcal >= $item->target) {
                    $failureUserIdList[]   = $item->id;
                    $checkInItem['result'] = CheckinRecordModel::FAILURE_OVER;
                } else {
                    $failureUserIdList[]   = $item->id;
                    $checkInItem['result'] = CheckinRecordModel::FAILURE_UNDER;
                }
                $checkInRecordList[] = $checkInItem;
            });
            $page++;
            Client::send(CheckInRecordQueue::QUEUE_NAME, [
                'checkInRecordList' => $checkInRecordList,
                'successUserIdList' => $successUserIdList,
                'failureUserIdList' => $failureUserIdList,
            ]);
        }
    }

    /**
     * 计算卡路里
     * @param array $userInfo
     * @param int $stepNumber
     * @return string
     */
    static function calcKcalWithStepNumber(float $tall, float $weight, int $gender, int $stepNumber): string
    {
        if (!$tall || !$weight || $stepNumber <= 0) {
            return '0';
        }

        $calc1 = bcmul((string)$stepNumber, (string)$tall, 2);
        $calc2 = bcmul($calc1, (string)$weight, 2);
        if ($gender === self::GENDER_MAN) {
            // 男性公式：步数 × 身高（cm）× 体重（kg）× 0.000002905
            return bcmul($calc2, '0.000002905', 2);
        }
        // 女性公式：步数 × 身高（cm）× 体重（kg）× 0.000002891
        return bcmul($calc2, '0.000002891', 2);
    }

    /**
     * 生成头像
     * @param string $text
     * @param int $size
     * @return string
     */
    protected static function generateAvatar(string $text, $size = 64)
    {
        $firstChar = mb_substr($text, 0, 1, 'UTF-8');

        $img = imagecreatetruecolor($size, $size);

        $bgColor = imagecolorallocate($img, 100, 149, 237); // 蓝色
        imagefill($img, 0, 0, $bgColor);

        $textColor = imagecolorallocate($img, 255, 255, 255);

        $fontSize = $size * 0.5;

        $fontFile = public_path('/fonts/SourceHanSans-VF.ttf.ttc');

        if (!file_exists($fontFile)) {
            throw new \Exception("字体文件未找到: $fontFile");
        }

        $bbox = imagettfbbox($fontSize, 0, $fontFile, $firstChar);
        $x    = ($size - ($bbox[2] - $bbox[0])) / 2;
        $y    = ($size - ($bbox[7] - $bbox[1])) / 2;
        $y    -= $bbox[7]; // baseline

        imagettftext($img, $fontSize, 0, $x, $y, $textColor, $fontFile, $firstChar);
        $fileSavePath = '/uploads/avatar/' . md5($text) . '.png';
        $savePath     = public_path($fileSavePath);
        if (!is_dir(dirname($savePath))) {
            mkdir(dirname($savePath), 0777, true);
        }
        imagepng($img, $savePath);
        imagedestroy($img);

        return $fileSavePath;
    }

    /**
     * 生成用户名
     * @return string
     */
    protected static function generateUserName()
    {
        $prefixes = [
            '小', '大', '超', '萌', '黑', '白', '红', '蓝', '紫',
            'Cool', 'Dark', 'Happy', 'Lazy', 'Smart', 'Fast', 'Neo'
        ];

        $names = [
            '猫', '狗', '猪', '虎', '狼', '熊', '鱼', '鸟', '龙', '狐狸',
            'Coder', 'Tiger', 'Panda', 'Ninja', 'Dev', 'Wizard', 'Elf'
        ];

        $number = rand(100, 9999);

        $nickname = $prefixes[array_rand($prefixes)] .
                    $names[array_rand($names)] .
                    $number;

        return $nickname;
    }

}
