<?php

namespace app\command;

use app\model\FoodModel;
use app\model\FoodUnitModel;
use app\model\UnitModel;
use app\service\FoodService;
use support\Db;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class SyncUnitForFood extends Command
{
    protected static $defaultName        = 'unit-for-food:sync';
    protected static $defaultDescription = '多进程同步食物的标准计量单位';

    protected function configure()
    {
        $this->addOption('workers', 'w', InputOption::VALUE_OPTIONAL, '启动的进程数量', 4);
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $workerCount = (int)$input->getOption('workers');
        $output->writeln("🚀 正在启动 $workerCount 个 Worker 进程同步单位...");

        $maxId = FoodModel::max('id') ?? 0;
        $minId = FoodModel::min('id') ?? 0;
        $range = (int)ceil(($maxId - $minId + 1) / $workerCount);

        $pids = [];
        for ($i = 0; $i < $workerCount; $i++) {
            $startId = $minId + ($i * $range);
            $endId   = $startId + $range - 1;

            $pid = pcntl_fork();
            if ($pid == -1) return self::FAILURE;

            if ($pid) {
                $pids[] = $pid;
            } else {
                $this->doWorkerJob($startId, $endId, $output, $i + 1);
                exit(0);
            }
        }

        foreach ($pids as $pid) {
            pcntl_waitpid($pid, $status);
        }

        $output->writeln("✨ 单位同步任务执行完毕！");
        return self::SUCCESS;
    }

    private function doWorkerJob(int $startId, int $endId, OutputInterface $output, int $workerId): void
    {
        Db::connection()->reconnect();

        // ── 验证数据量 ───────────────────────────────────
        $totalInRange = FoodModel::whereBetween('id', [$startId, $endId])->count();
        $pendingCount = FoodModel::whereBetween('id', [$startId, $endId])
            ->whereNotExists(fn($q) => $q->select(Db::raw(1))
                ->from('food_units')
                ->whereRaw('food_units.food_id = foods.id'))
            ->count();

        $output->writeln("Worker #{$workerId} | 范围 {$startId}-{$endId} | 总计：{$totalInRange} | 待处理：{$pendingCount}");

        if ($pendingCount === 0) {
            $output->writeln("Worker #{$workerId} ⚠️ 无待处理数据，跳过");
            return;
        }

        FoodModel::query()
            ->whereBetween('id', [$startId, $endId])
            ->whereNotExists(fn($q) => $q->select(Db::raw(1))
                ->from('food_units')
                ->whereRaw('food_units.food_id = foods.id'))
            ->select('id', 'name')
            ->chunkById(20, function ($foods) use ($output, $workerId) {
                if ($foods->isEmpty()) return;

                $names = $foods->pluck('name')->toArray();
                $output->writeln("Worker #{$workerId} 本批食物：" . implode(', ', $names));

                // ── 调用 AI 接口 ─────────────────────────────
                $result   = null;
                $attempts = 0;
                while ($attempts < 3) {
                    try {
                        $result = FoodService::unit($names);
                        break;
                    } catch (\Exception $e) {
                        $attempts++;
                        $output->writeln("Worker #{$workerId} ⚠️ 第{$attempts}次重试：" . $e->getMessage());
                        sleep(2);
                    }
                }

                if (empty($result)) {
                    $output->writeln("Worker #{$workerId} ❌ AI接口3次重试全部失败");
                    return;
                }

                // ── 打印原始返回，确认数据结构 ───────────────
                $output->writeln("Worker #{$workerId} API原始返回：" . json_encode($result, JSON_UNESCAPED_UNICODE));

                $resultData = is_string($result) ? json_decode($result, true) : $result;

                if (!is_array($resultData)) {
                    $output->writeln("Worker #{$workerId} ❌ 返回值不是数组，实际类型：" . gettype($resultData));
                    return;
                }

                // ── 如果是 {"data": [...]} 嵌套结构，取内层 ──
                if (isset($resultData['data']) && is_array($resultData['data'])) {
                    $output->writeln("Worker #{$workerId} ℹ️ 检测到嵌套结构，取 data 字段");
                    $resultData = $resultData['data'];
                }

                $output->writeln("Worker #{$workerId} 解析到 " . count($resultData) . " 条单位数据");

                $foodsByName  = $foods->keyBy('name');
                $successCount = 0;

                foreach ($resultData as $item) {
                    $foodName  = $item['food'] ?? null;
                    $unitItems = $item['unit'] ?? [];   // unit 是数组

                    if (!$foodName || empty($unitItems)) continue;

                    $currentFood = $foodsByName->get($foodName);
                    if (!$currentFood) continue;

                    foreach ($unitItems as $unitItem) {   // ← 新增这层循环
                        $unitName  = $unitItem['name'] ?? '克';
                        $weight    = (float)($unitItem['weight'] ?? 100);
                        $isDefault = (int)($unitItem['is_default'] ?? 0);

                        try {
                            Db::transaction(function () use ($unitName, $currentFood, $weight, $isDefault) {
                                try {
                                    $unit = UnitModel::firstOrCreate(['name' => $unitName]);
                                } catch (\Illuminate\Database\QueryException $e) {
                                    if ($e->getCode() == 23000) {
                                        $unit = UnitModel::where('name', $unitName)->firstOrFail();
                                    } else {
                                        throw $e;
                                    }
                                }

                                FoodUnitModel::firstOrCreate(
                                    ['food_id' => $currentFood->id, 'unit_id' => $unit->id],
                                    ['weight' => $weight, 'is_default' => $isDefault]
                                );
                            }, 3);
                        } catch (\Exception $e) {
                            $output->writeln("Worker #{$workerId} ❌ [{$foodName}-{$unitName}] 写入失败：" . $e->getMessage());
                        }
                    }
                }

                $output->writeln("Worker #{$workerId} 本批完成：{$successCount}/{$foods->count()}");
            });
    }
}
