<?php

namespace app\queue;

use app\business\FoodBusiness;
use app\common\base\BaseConsumer;
use app\common\enum\BusinessCode;
use app\common\enum\TaskCompleteStatus;
use app\common\enum\TaskRunStatus;
use app\common\enum\UserInfoContext;
use app\common\exception\BusinessException;
use app\common\exception\DataNotFoundException;
use app\model\TaskModel;
use app\service\FoodService;
use support\Log;
use support\Redis;
use Webman\Context;
use function Illuminate\Support\now;

class TaskConsumeJob extends BaseConsumer
{
    public string $queue = 'taskConsume';

    public function consume($data)
    {

        $taskInfo = TaskModel::query()->where('task_id', $data)->first();
        if (!$taskInfo) {
            throw new BusinessException('任务不存在', BusinessCode::SYSTEM_ERROR);
        }
        $params = json_decode($taskInfo->params, true);
        $userId = $params['userId'] ?? 0;
        unset($params['userId']);
        $update = [];
        try {
            Context::set(\app\common\enum\UserInfoContext::UserId->value, $userId);
            $result = FoodService::nutrition($params['type'], $params['content']);

            if (!$result) {
                throw new DataNotFoundException('识别失败');
            }
            $update['response']        = FoodBusiness::instance()->syncRemote($result ?? []);
            $update['complete_status'] = TaskCompleteStatus::Success->value;
        } catch (\Exception $exception) {
            $update['complete_status'] = TaskCompleteStatus::Failed->value;
            $update['error_msg']       = $exception->getMessage();
            Log::error($exception->getMessage(), [$exception->getCode(), $exception->getFile(), $exception->getLine(), $exception->getTraceAsString()]);
        }
        $update['run_status']   = TaskRunStatus::Finished->value;
        $update['completed_at'] = date('Y-m-d H:i:s');
        $taskInfo->update($update);
        Redis::setEx(UserInfoContext::userInfoTaskCacheKey($userId, $taskInfo->task_id), 3600 + rand(10, 60), $update['complete_status']);
        return true;
    }
}
