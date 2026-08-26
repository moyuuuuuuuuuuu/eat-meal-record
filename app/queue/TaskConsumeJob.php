<?php

namespace app\queue;

use app\business\FoodBusiness;
use app\common\base\BaseConsumer;
use app\common\context\TokenLimit;
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
    private const MAX_ATTEMPTS = 3;
    private const RUNNING_TIMEOUT_MINUTES = 10;

    public string $queue = 'taskConsume';

    public function consume($data)
    {
        $taskInfo = TaskModel::query()->where('task_id', $data)->first();
        if (!$taskInfo) {
            throw new BusinessException('任务不存在', BusinessCode::SYSTEM_ERROR);
        }
        if ((int)$taskInfo->run_status === TaskRunStatus::Finished->value) {
            return true;
        }
        $staleBefore = date('Y-m-d H:i:s', strtotime('-' . self::RUNNING_TIMEOUT_MINUTES . ' minutes'));
        if ((int)$taskInfo->retry_count >= self::MAX_ATTEMPTS) {
            $finalized = TaskModel::query()
                ->where('id', $taskInfo->id)
                ->where('run_status', TaskRunStatus::Running->value)
                ->where('updated_at', '<', $staleBefore)
                ->update([
                    'run_status'      => TaskRunStatus::Finished->value,
                    'complete_status' => TaskCompleteStatus::Failed->value,
                    'error_msg'       => '任务执行超时且已达最大重试次数',
                    'additional'      => json_encode(array_merge($taskInfo->additional ?? [], [
                        'errorCode' => 'AI_TIMEOUT',
                        'retryable' => true,
                    ]), JSON_UNESCAPED_UNICODE),
                    'completed_at'    => date('Y-m-d H:i:s'),
                ]);
            if ($finalized) {
                $userId = $taskInfo->additional['userId'] ?? $taskInfo->user_id;
                Redis::setEx(
                    UserInfoContext::userInfoTaskCacheKey($userId, $taskInfo->task_id),
                    3600 + rand(10, 60),
                    TaskCompleteStatus::Failed->value
                );
            }
            return true;
        }
        $attempt = (int)$taskInfo->retry_count + 1;
        $claimed = TaskModel::query()
            ->where('id', $taskInfo->id)
            ->where(function ($query) use ($staleBefore) {
                $query->where('run_status', TaskRunStatus::Waiting->value)
                    ->orWhere(function ($query) use ($staleBefore) {
                        $query->where('run_status', TaskRunStatus::Running->value)
                            ->where('updated_at', '<', $staleBefore);
                    });
            })
            ->update([
                'run_status'  => TaskRunStatus::Running->value,
                'retry_count' => $attempt,
                'worker'      => gethostname() . ':' . getmypid(),
            ]);
        if (!$claimed) {
            return true;
        }
        $taskInfo->refresh();
        $userId = $taskInfo->additional['userId'] ?? 0;
        if (!$userId) {
            throw new BusinessException('用户ID不能为空', BusinessCode::SYSTEM_ERROR);
        }
        Context::set(UserInfoContext::UserId->value, $userId);
        $update = [
            'run_status'   => TaskRunStatus::Finished->value,
            'completed_at' => date('Y-m-d H:i:s'),
        ];
        try {
            if ($attempt === 1 && !TokenLimit::instance()->consumeQuota()) {
                throw new BusinessException('AI识别次数已经用完，请先手动选择食物吧', BusinessCode::PARAM_ERROR);
            }
            $result = FoodService::nutrition(...$taskInfo->params);
            if (!$result) {
                throw new DataNotFoundException('识别失败');
            }
            $update['response']        = FoodBusiness::instance()->syncRemote($result);
            $update['complete_status'] = TaskCompleteStatus::Success->value;
        } catch (\Throwable $exception) {
            $update['error_msg'] = mb_substr($exception->getMessage(), 0, 255);
            $failure = $this->failureMetadata($exception);
            Log::error('任务执行失败：' . $exception->getMessage(), [
                'code'       => $exception->getCode(),
                'file'       => $exception->getFile(),
                'line'       => $exception->getLine(),
                'taskId'     => $data,
                'userId'     => $userId,
                'trace'      => $exception->getTraceAsString()
            ]);
            if ($attempt < self::MAX_ATTEMPTS && !($exception instanceof BusinessException)) {
                $taskInfo->update([
                    'run_status' => TaskRunStatus::Waiting->value,
                    'error_msg'  => $update['error_msg'],
                ]);
                throw $exception;
            }
            $update['complete_status'] = TaskCompleteStatus::Failed->value;
            $update['additional'] = array_merge($taskInfo->additional ?? [], $failure);
        }
        $taskInfo->update($update);
        Redis::setEx(UserInfoContext::userInfoTaskCacheKey($userId, $taskInfo->task_id), 3600 + rand(10, 60), $update['complete_status']);
        return true;
    }

    private function failureMetadata(\Throwable $exception): array
    {
        $message = $exception->getMessage();
        if (str_contains($message, '次数已经用完')) {
            return ['errorCode' => 'AI_QUOTA_EXHAUSTED', 'retryable' => false];
        }
        if ($exception instanceof DataNotFoundException) {
            return ['errorCode' => 'AI_NO_RESULT', 'retryable' => true];
        }
        if ($exception instanceof BusinessException) {
            return ['errorCode' => 'AI_REQUEST_REJECTED', 'retryable' => false];
        }
        return ['errorCode' => 'AI_SERVICE_ERROR', 'retryable' => true];
    }
}
