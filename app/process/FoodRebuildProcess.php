<?php

namespace app\process;

use app\model\FoodModel;
use app\service\foodHealthCheck\FoodNutritionSync;
use support\Log;
use Workerman\Timer;

class FoodRebuildProcess
{
    /**
     * QPS 策略：每 2.5 秒处理一批（10条），实际 QPS 为 4。
     * 考虑到扣子个人版的不稳定性，略微调大间隔更稳。
     */
    protected $interval = 2.5;

    protected $batchSize = 10;

    public function onWorkerStart()
    {
        echo "Eat Clear 数据重建进程启动，正在平滑同步食品数据...\n";

        Timer::add($this->interval, function () {
            $this->handle();
        });
    }

    public function handle()
    {
        // 1. 获取一批待处理的数据
        // 不再使用 page/offset，直接查询状态为 0 的前 N 条
        $foodList = FoodModel::where('coze_status', 0)
            ->limit($this->batchSize)
            ->orderBy('id', 'asc')
            ->get(['id', 'name']);

        if ($foodList->isEmpty()) {
            return;
        }

        $allNamesInBatch = $foodList->pluck('name')->toArray();
        $allIdsInBatch = $foodList->pluck('id')->toArray();

        // 2. 先锁定状态为“处理中”(2)，防止并发重复
        FoodModel::whereIn('id', $allIdsInBatch)->update(['coze_status' => 2]);

        try {
            echo "[" . date('H:i:s') . "] 正在处理: " . implode(',', $allNamesInBatch) . PHP_EOL;

            // 调用同步 Service
            // 注意：FoodNutritionSync 内部应包含对 meta_type 的补全逻辑
            list($success, $syncedNames) = FoodNutritionSync::instance()->run($allNamesInBatch);

            if (!empty($syncedNames)) {
                // 3. 既然 $syncedNames 明确是成功的，直接更新状态为 1
                FoodModel::whereIn('name', $syncedNames)
                    ->whereIn('id', $allIdsInBatch) // 增加 ID 过滤确保精准
                    ->update(['coze_status' => 1]);

                echo "--- 成功回填: " . count($syncedNames) . " 条数据 ---" . PHP_EOL;

                // 4. 处理“软失败”的数据：
                // 如果本批次中有名字不在成功列表里，说明 AI 跳过了它们或处理失败
                $failedNames = array_diff($allNamesInBatch, $syncedNames);
                if (!empty($failedNames)) {
                    // 将这些数据重置为 0，等待下次循环重试
                    FoodModel::whereIn('name', $failedNames)
                        ->whereIn('id', $allIdsInBatch)
                        ->update(['coze_status' => 0]);
                    Log::warning("食品 [" . implode(',', $failedNames) . "] 识别未完全成功，已重置待重试");
                }
            } else {
                // 5. 如果 syncedNames 完全为空，说明整批彻底失败
                FoodModel::whereIn('id', $allIdsInBatch)->update(['coze_status' => 0]);
            }

        } catch (\Exception $e) {
            // 6. 异常兜底：重置这批数据
            FoodModel::whereIn('id', $allIdsInBatch)->update(['coze_status' => 0]);

            // 针对扣子常见的 429 (频率限制) 做日志标记
            if (strpos($e->getMessage(), '429') !== false) {
                Log::error("触发扣子 QPS 限制，请考虑调大 \$interval");
            }
            Log::error("同步异常: " . $e->getMessage());
        }
    }
}
