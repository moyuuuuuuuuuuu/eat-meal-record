<?php

namespace app\queue;

use app\model\CheckinRecordModel;
use app\model\UserModel;
use support\Db;
use support\Log;
use Webman\RedisQueue\Process\Consumer;

/**
 * 记录用户打卡数据队列
 */
class CheckInRecordQueue extends Consumer
{
    const QUEUE_NAME = 'checkInRecordQueue';
    public $queue = 'checkInRecordQueue';

    /**
     * @param array{
     *     checkInRecordList:array{
     *
     *     },
     *     successUserIdList:int[],
     *     failureUserIdList:int[]
     * } $data
     * @return void
     */
    public function consume($data)
    {
        Db::beginTransaction();
        try {
            if (CheckinRecordModel::insert($data['checkInRecordList']) &&
                UserModel::update(['check_in_days' => '+1'], ['id' => $data['successUserIdList']]) &&
                UserModel::update(['check_in_days' => 0], ['id' => $data['failureUserIdList']])
            ) {
                Db::commit();
            } else {
                throw new \Exception('保存用户打卡记录及编辑连续签到天数失败');
            }
        } catch (\Exception $e) {
            Db::rollBack();
            Log::error('计算用户打卡失败:' . $e->getMessage(), [
                'error' => $e->getMessage(),
                'trace' => $e->getTrace(),
                ...$data
            ]);
        }
    }

}
