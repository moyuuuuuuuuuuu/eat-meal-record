<?php

namespace app\controller;

use app\common\base\BaseController;
use app\common\enum\TaskCompleteStatus;
use app\common\enum\UserInfoContext;
use app\model\TaskModel;
use support\Redis;
use support\Request;

class TaskController extends BaseController
{
    public function enquire(Request $request)
    {
        $taskId = $request->input('taskId');
        if (!$taskId) {
            return $this->fail('任务ID不能为空');
        }
        $userTaskCacheKey = UserInfoContext::userInfoTaskCacheKey($request->userInfo->id, $taskId);
        if (Redis::exists($userTaskCacheKey)) {
            $taskResult = Redis::get($userTaskCacheKey);
        } else {
            $taskResult = TaskModel::query()->where('task_id', $taskId)->value('complete_status');
        }
        $taskResult = TaskCompleteStatus::tryFrom($taskResult);

        if (!$taskResult) {
            return $this->fail('任务状态异常');
        }

        return $this->success('ok', ['status' => $taskResult->labelCode()]);
    }
}
