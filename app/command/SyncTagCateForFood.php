<?php

namespace app\command;

use app\model\CatModel;
use app\model\FoodModel;
use app\model\FoodTagModel;
use app\model\TagModel;
use app\service\FoodService;
use support\Db;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class SyncTagCateForFood extends Command
{
    protected static $defaultName        = 'tag-cate-for-food:sync';
    protected static $defaultDescription = '多进程并发同步食物标签（优化死锁与重试版）';

    protected $typeMapping = [
        '餐次'     => 1, '口味' => 2, '营养' => 3, '营养特点' => 3,
        '烹饪方式' => 4, '适用人群' => 5, '食材状态' => 6,
        '过敏原'   => 7, '品牌产地' => 8, '时令季节' => 9,
        '特殊场景' => 10, '存储方式' => 11
    ];

    protected function configure()
    {
        $this->addOption('workers', 'w', InputOption::VALUE_OPTIONAL, '启动的进程数量', 4);
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $workerCount = (int)$input->getOption('workers');
        $output->writeln("🚀 正在启动 $workerCount 个 Worker 进程...");

        $maxId = FoodModel::max('id') ?? 0;
        $minId = FoodModel::min('id') ?? 0;
        $range = ceil(($maxId - $minId + 1) / $workerCount);

        $pids = [];
        for ($i = 0; $i < $workerCount; $i++) {
            $startId = $minId + ($i * $range);
            $endId   = $startId + $range - 1;
            $pid     = pcntl_fork();
            if ($pid == -1) return self::FAILURE;
            if ($pid) {
                $pids[] = $pid;
            } else {
                $this->doWorkerJob($startId, $endId, $output, $i + 1);
                exit(0);
            }
        }
        foreach ($pids as $pid) pcntl_waitpid($pid, $status);
        $output->writeln("✨ 同步任务执行完毕！");
        return self::SUCCESS;
    }

    private function doWorkerJob($startId, $endId, $output, $workerId)
    {
        Db::connection()->reconnect();

        FoodModel::query()
            ->whereBetween('id', [$startId, $endId])
            ->select('id', 'name', 'cat_id')
            ->whereNotExists(function ($query) use ($startId, $endId, $workerId) {
                $query->select(Db::raw(1))
                    ->from('food_tags')
                    ->whereRaw('food_tags.food_id = foods.id');
            })
            ->chunk(50, function ($foods) use ($output, $workerId) {
                $names = $foods->pluck('name')->toArray();

                // 1. API 增加简单重试逻辑
                $result   = null;
                $attempts = 0;
                while ($attempts < 3) {
                    try {
                        $result = FoodService::tag($names);
                        break;
                    } catch (\Exception $e) {
                        $attempts++;
                        if ($attempts >= 3) {
                            $output->writeln("Worker [#{$workerId}] ⚠️ API 彻底失败: " . $e->getMessage());
                            return;
                        }
                        sleep(2); // 遇到大模型 internal error 歇会儿再试
                    }
                }

                if (empty($result)) return;
                $resultData  = is_string($result) ? json_decode($result, true) : $result;
                $foodsByName = $foods->keyBy('name');

                foreach ($resultData as $foodInfo) {
                    $foodName    = $foodInfo['food'] ?? null;
                    $currentFood = $foodsByName->get($foodName);
                    if (!$currentFood) continue;

                    try {
                        // 2. 将大事务拆分为“独立的小事务”或“单次写入”，降低死锁概率
                        Db::transaction(function () use ($foodInfo, $currentFood) {
                            // 处理分类
                            $cateModel = CatModel::firstOrCreate(['name' => $foodInfo['cate'] ?? '其他']);

                            $currentFood->update([
                                'cat_id'    => $cateModel->id,
                                'is_common' => ($foodInfo['isCommon'] ?? false) ? 1 : 2
                            ]);

                            $tags = $foodInfo['tags'] ?? [];
                            foreach ($tags as $tagName => $typeName) {
                                $typeId = $this->typeMapping[$typeName] ?? 3;

                                // 3. 针对 Tags 表，先查后增，并捕获并发冲突
                                try {
                                    $tagModel = TagModel::where('name', $tagName)->where('type', $typeId)->first();
                                    if (!$tagModel) {
                                        $tagModel = TagModel::create([
                                            'name'      => $tagName,
                                            'type'      => $typeId,
                                            'meta_type' => $typeName
                                        ]);
                                    }

                                    FoodTagModel::firstOrCreate([
                                        'food_id' => $currentFood->id,
                                        'tag_id'  => $tagModel->id
                                    ]);
                                } catch (\Illuminate\Database\QueryException $e) {
                                    // 如果依然报 Duplicate entry，说明别的进程刚好抢先存了，直接忽略即可
                                    if ($e->getCode() == 23000) {
                                        $tagModel = TagModel::where('name', $tagName)->where('type', $typeId)->first();
                                        if ($tagModel) {
                                            FoodTagModel::firstOrCreate(['food_id' => $currentFood->id, 'tag_id' => $tagModel->id]);
                                        }
                                    } else {
                                        throw $e;
                                    }
                                }
                            }
                        }, 3); // 这里的 3 表示事务死锁时自动重试 3 次
                    } catch (\Exception $e) {
                        $output->writeln("Worker [#{$workerId}] ❌ 处理 [{$foodName}] 失败: " . $e->getMessage());
                    }
                }
                $output->writeln("Worker [#{$workerId}] ✅ 同步批次完成");
            });
    }
}
