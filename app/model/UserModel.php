<?php

namespace app\model;

use app\queue\CheckInRecordQueue;
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
        'name', 'phone', 'email', 'openid', 'unionid', 'avatar', 'age', 'gender', 'status', 'tall', 'weight', 'is_full', 'target', 'status', 'created_at', 'updated_at', 'last_login_time', 'last_login_ip', 'last_login_platform'
    ];

    /**
     * 创建用户
     * @param array $data
     * @return self
     */
    static function createUser(array $data)
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
        return UserModel::create($data);
    }

    static function login(self $userInfo)
    {
        $userInfo->last_login_time     = date('Y-m-d H:i:s');
        $userInfo->last_login_ip       = request()->getRemoteIp();
        $userInfo->last_login_platform = request()->header('user-agent');
        $userInfo->save();
        list($token, $refreshToken) = Jwt::encode($userInfo->id);
        return [
            'token'        => $token,
            'refreshToken' => $refreshToken,
            'userInfo'     => [
                'name'        => $userInfo->name,
                'avatar'      => self::getAvatarUrl($userInfo->avatar),
                'age'         => $userInfo->age,
                'gender'      => $userInfo->gender,
                'tall'        => $userInfo->tall,
                'bmi'         => $userInfo->bmi,
                'waist'       => $userInfo->waist,
                'hip'         => $userInfo->hip,
                'arm'         => $userInfo->arm,
                'weight'      => $userInfo->weight,
                'target'      => $userInfo->target,
                'isFull'      => (int)$userInfo->is_full,
                'checkInDays' => 0,//TODO:计算用户连续签到天数
                'followers'   => Redis::get('user:followers:' . $userInfo->id) ?? 0,
                'likes'       => Redis::get('user:likes:' . $userInfo->id) ?? 0,
                'fans'        => Redis::get('user:fans:' . $userInfo->id) ?? 0
            ]
        ];
    }

    static function calcKcalWithStepNumber(self $userInfo, int $stepNumber): string
    {
        if ($stepNumber <= 0) {
            return '0';
        }
        $tall   = $userInfo->tall ?? 175;
        $weight = $userInfo->weight ?? 65;

        $calc1 = bcmul((string)$stepNumber, (string)$tall, 2);
        $calc2 = bcmul($calc1, (string)$weight, 2);
        if ($userInfo->gender === self::GENDER_MAN) {
            // 男性公式：步数 × 身高（cm）× 体重（kg）× 0.000002905
            return bcmul($calc2, '0.000002905', 2);
        }
        // 女性公式：步数 × 身高（cm）× 体重（kg）× 0.000002891
        return bcmul($calc2, '0.000002891', 2);
    }

    static function generateAvatar(string $text, $size = 64)
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

    static function generateUserName()
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

    static function getAvatarUrl(string $avatar)
    {
        if (str_contains($avatar, 'http://') || str_contains($avatar, 'https://')) {
            return $avatar;
        }
        $request = request();
        return $request->domain() . $avatar;
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
}
