<?php

namespace app\model;

use app\queue\InteractiveUser;
use support\Log;
use support\Model;
use Webman\RedisQueue\Client;

class BaseModel extends Model
{
    protected $beginFormatTime = false;

    public function getCreatedAtAttribute($value)
    {
        if (!$this->beginFormatTime) {
            return $value;
        }
        return static::formatDateTime($value);
    }

    static function getAttacheUrl($image)
    {
        return getImageUrl(strval($image));
    }

    static function formatDateTime(string $datetime)
    {
        //本月的只显示月-日 当天的只显示 时：分
        $month = date('m', strtotime($datetime));
        $day   = date('d', strtotime($datetime));

        $nowMonth = date('m');
        $nowDay   = date('d');

        if ($month == $nowMonth && $day == $nowDay) {
            return date('H:i', strtotime($datetime));
        } else if ($month == $nowMonth) {
            return date('m-d', strtotime($datetime));
        }
        return date('Y-m-d', strtotime($datetime));
    }

    /**
     * 发送互动用户队列
     * @param string $type 类型
     * @param int|int[] $target 目标id
     * @param string $model 模型
     * @param array|mixed $metaData 元数据
     * @return void
     */
    protected static function sendInteractiveUserQueue($type, $target, mixed $metaData = [])
    {
        try {
            $userId     = request()->userId;
            $modelClass = static::class;
            Client::send(InteractiveUser::QUEUE_NAME, ['type' => $type, 'target' => $target, 'userId' => $userId, 'model' => $modelClass, 'time' => time(), 'metadata' => $metaData]);
        } catch (\Exception $e) {
            Log::error('发送互动用户队列失败', ['type' => $type, 'target' => $target, 'userId' => $userId, 'model' => $modelClass, 'metadata' => $metaData, 'error' => $e->getMessage()]);
        }
    }
}
