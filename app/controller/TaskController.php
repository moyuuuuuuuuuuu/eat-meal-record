<?php

namespace app\controller;

use app\common\base\BaseController;
use app\common\enum\TaskCompleteStatus;
use app\common\enum\TaskRunStatus;
use app\model\TaskModel;
use support\Request;

class TaskController extends BaseController
{
    public function enquire(Request $request)
    {
        $taskId = $request->input('taskId');
        if (!$taskId) {
            return $this->fail('任务ID不能为空');
        }
        $task = TaskModel::query()
            ->where('task_id', $taskId)
            ->where('user_id', $request->userInfo->id)
            ->first();
        if (!$task) {
            return $this->fail('任务状态异常');
        }

        $isFinished = (int)$task->run_status === TaskRunStatus::Finished->value;
        $taskResult = $isFinished
            ? TaskCompleteStatus::tryFrom((int)$task->complete_status)
            : TaskCompleteStatus::Running;
        if (!$taskResult) {
            return $this->fail('任务状态异常');
        }

        $stage = match (true) {
            $taskResult === TaskCompleteStatus::Success => 'completed',
            $taskResult === TaskCompleteStatus::Failed => 'failed',
            (int)$task->run_status === TaskRunStatus::Waiting->value => 'queued',
            default => 'analyzing',
        };
        $additional = $task->additional ?? [];
        $errorCode = $additional['errorCode'] ?? 'AI_TASK_FAILED';
        $result = [
            'taskId' => (string)$task->task_id,
            'status' => $taskResult->labelCode(),
            'stage' => $stage,
            'message' => match ($stage) {
                'queued' => '任务已提交，正在等待处理',
                'analyzing' => 'AI 正在识别并整理餐食信息',
                'completed' => '识别完成，请确认食物和份量',
                default => match ($errorCode) {
                    'AI_QUOTA_EXHAUSTED' => '今日 AI 识别次数已用完，请手动添加食物',
                    'AI_REQUEST_REJECTED' => '当前内容无法识别，请修改后再试',
                    'AI_NO_RESULT' => '没有识别到有效食物，请换一张图片或补充描述',
                    'AI_TIMEOUT' => '本次识别超时，请稍后重新提交',
                    default => 'AI 服务暂时不可用，请稍后再试',
                },
            },
        ];
        if ($taskResult == TaskCompleteStatus::Success) {
            $result['data'] = $task->response ?? [];
        } elseif ($taskResult == TaskCompleteStatus::Failed) {
            $result['errorCode'] = $errorCode;
            $result['retryable'] = (bool)($additional['retryable'] ?? true);
        }

        return $this->success('ok', $result);
    }
}
