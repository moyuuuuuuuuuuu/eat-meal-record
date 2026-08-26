# AI 识别接口交互协议

## 推荐调用顺序

1. 打开 AI 识别面板时调用 `GET /api/food/recognize/quota`，展示今日剩余次数。
2. 用户提交后调用 `POST /api/food/recognize`，保存返回的 `taskId`。
3. 调用 `GET /api/task/enquire?taskId=...` 查询任务；页面隐藏时停止高频轮询，但保留 `taskId`。
4. 页面重新显示后继续查询。`completed` 时进入食物与份量确认页，`failed` 时根据 `retryable` 提供重试或手动添加入口。

消费者仍在真正执行前原子扣减额度，额度预览只用于改善交互，不能替代服务端校验。

## 创建任务

`POST /api/food/recognize` 保留原有 `taskId`，并新增：

- `status`：新任务为 `running`，复用历史成功结果为 `completed`；
- `reused`：是否复用了最近 7 天的相同成功任务。

## 查询任务

`GET /api/task/enquire?taskId=...` 的 `status` 保持为：

- `running`：尚未完成；
- `completed`：识别成功，`data` 为候选食品；
- `failed`：识别失败，同时返回 `errorCode`、`message`、`retryable`。

`stage` 用于展示更准确的等待文案：

- `queued`：等待消费者处理；
- `analyzing`：AI 识别或食品标准化中；
- `completed`：完成；
- `failed`：失败。

前端建议前 15 秒每 2 秒查询一次，之后每 5 秒查询一次；超过 60 秒允许用户离开并提示任务仍在后台继续，不要在前端直接将任务判定为失败。

## 失败交互

- `AI_QUOTA_EXHAUSTED`：不可重试，提示手动添加；
- `AI_REQUEST_REJECTED`：不可原样重试，引导修改输入；
- `AI_NO_RESULT`：允许修改描述或图片后重试；
- `AI_TIMEOUT`、`AI_SERVICE_ERROR`、`AI_TASK_FAILED`：允许重新提交。

AI 返回内容是候选结果。正式记餐前必须让用户确认食物、单位、数量和餐次。
