<?php

namespace app\queue;

use app\business\FoodBusiness;
use app\common\base\BaseConsumer;
use app\common\enum\BusinessCode;
use app\common\enum\NutritionInputType;
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

class TaskConsumeJob extends BaseConsumer
{
    public string $queue = 'taskConsume';

    public function consume($data)
    {
        $taskInfo = TaskModel::query()->where('task_id', $data)->first();
        if (!$taskInfo) {
            throw new BusinessException('任务不存在', BusinessCode::SYSTEM_ERROR);
        }
        $taskInfo->update(['run_status' => TaskRunStatus::Running->value]);
        $params = $taskInfo->params;
        $userId = $params['userId'] ?? 0;
        if (!$userId) {
            throw new BusinessException('用户ID不能为空', BusinessCode::SYSTEM_ERROR);
        }
        $type    = $params['type'] ?? null;
        $content = $params['content'] ?? null;
        if (!$type || !$content) {
            throw new BusinessException('任务参数不完整', BusinessCode::SYSTEM_ERROR);
        }
        Context::set(UserInfoContext::UserId->value, $userId);
        $type   = NutritionInputType::tryFrom($type);
        $update = [
            'run_status'   => TaskRunStatus::Finished->value,
            'completed_at' => date('Y-m-d H:i:s'),
        ];
        try {
            $result = FoodService::nutrition($type, $content);
            if (!$result) {
                throw new DataNotFoundException('识别失败');
            }
            $update['response']        = FoodBusiness::instance()->syncRemote($result);
            $update['complete_status'] = TaskCompleteStatus::Success->value;
        } catch (\Exception $exception) {
            $update['complete_status'] = TaskCompleteStatus::Failed->value;
            $update['error_msg']       = $exception->getMessage();
            Log::error('任务执行失败：' . $exception->getMessage(), [
                'code'   => $exception->getCode(),
                'file'   => $exception->getFile(),
                'line'   => $exception->getLine(),
                'taskId' => $data,
                'userId' => $userId,
                'params' => $params,
                'trace'  => $exception->getTraceAsString()
            ]);
        }
        $taskInfo->update($update);
        Redis::setEx(UserInfoContext::userInfoTaskCacheKey($userId, $taskInfo->task_id), 3600 + rand(10, 60), $update['complete_status']);
        return true;
    }
}
