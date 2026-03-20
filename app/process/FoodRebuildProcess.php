<?php

namespace app\process;

use app\common\enum\QueueEventName;
use app\model\FoodModel;
use Webman\RedisQueue\Client;

class FoodRebuildProcess
{
    protected $interval  = 1.0;
    protected $batchSize = 5; // 每次推多少条进队列
    protected $workerIndex;

    public function onWorkerStart($worker)
    {
        $this->workerIndex = $worker->id;
        echo "[Worker:{$this->workerIndex}] 推队列进程已就绪...\n";
        $this->dispatch();
    }

    public function dispatch()
    {
        // 查出待处理的数据，直接按单条推进队列
        $foodList = FoodModel::where('coze_status', 0)
            ->orderBy('id', 'asc')
            ->limit($this->batchSize)
            ->get(['id', 'name']);

        if ($foodList->isEmpty()) {
            return;
        }

        $ids = $foodList->pluck('id')->toArray();

        // 先标记为处理中，防止重复推队列
        FoodModel::whereIn('id', $ids)->update(['coze_status' => 2]);

        // 按你的QPS需求，每5条一组推一个Job
        $chunks = $foodList->chunk(5);
        $delay  = 0;
        foreach ($chunks as $chunk) {
            Client::send(QueueEventName::FoodNutritionSync->value, $chunk->pluck('name')->toArray(), $delay);
            $delay += 5;
        }

        echo "[" . date('H:i:s') . "][Worker:{$this->workerIndex}] 已推入队列: " . count($ids) . "[" . implode(',', $chunk->pluck('name')->toArray()) . "] 条\n";
        $this->dispatch();
    }
}
