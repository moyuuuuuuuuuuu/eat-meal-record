<?php

namespace app\command;

use app\format\FoodFormat;
use app\model\CatModel;
use app\model\FoodModel;
use app\model\FoodNutrientModel;
use app\model\FoodUnitModel;
use app\model\UnitModel;
use app\service\FoodService;
use app\util\Calculate;
use support\Db;
use support\Log;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class SyncFood extends Command
{
    protected static $defaultName        = 'food:sync';
    protected static $defaultDescription = '使用多进程并行同步食物营养数据';

    private const NUTRIENT_FIELD_MAP = [
        'potassium'   => 'kalium',
        'folate'      => 'folic',
        'cholesterin' => 'cholesterol',
        'vitaminA'    => 'vitamin_a',
    ];

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        // 1. 加载数据
        $jsonPath = runtime_path() . '/library/food.json';
        if (!file_exists($jsonPath)) {
            $output->writeln('<error>找不到 food.json 文件</error>');
            return self::FAILURE;
        }

        $foodNameList = json_decode(file_get_contents($jsonPath), true);
        if (empty($foodNameList)) {
            $output->writeln('<info>food.json 为空，无需处理。</info>');
            return self::SUCCESS;
        }

        $totalCount   = count($foodNameList);
        $workerNumber = 5; // 设置并行进程数

        // 2. 将任务切分为 N 份
        $chunks = array_chunk($foodNameList, (int)ceil($totalCount / $workerNumber));
        $pids   = [];

        $output->writeln("<info>主进程启动：共 $totalCount 条数据，派生 $workerNumber 个子进程并行处理...</info>");

        // 3. 派生进程
        foreach ($chunks as $index => $chunk) {
            $pid = pcntl_fork();

            if ($pid === -1) {
                $output->writeln("<error>进程派生失败 (pcntl_fork failed)</error>");
                exit(1);
            } elseif ($pid > 0) {
                // 父进程：记录子进程 PID 备用
                $pids[] = $pid;
            } else {
                // 子进程：执行具体同步逻辑
                $this->childProcessWorker($index, $chunk, $output);
                exit(0); // 子进程必须退出，防止继续跑外层循环
            }
        }

        // 4. 父进程阻塞等待所有子进程结束
        foreach ($pids as $pid) {
            pcntl_waitpid($pid, $status);
        }

        $output->writeln('<info>恭喜：所有并行同步任务已完成！</info>');
        return self::SUCCESS;
    }

    /**
     * 子进程业务处理逻辑
     */
    private function childProcessWorker($workerId, $items, $output)
    {
        // 1. 【核心】子进程必须断开并重连数据库
        \support\Db::connection()->disconnect();

        $output->writeln("子进程 [$workerId] 启动，分配任务量: " . count($items));

        // 2. 使用原生 array_chunk 替代 collect()->chunk()，设定每批 15 个
        $chunks = array_chunk($items, 10);

        foreach ($chunks as $index => $batchNames) {
            try {
                // 1. 过滤掉数据库已存在的
                $todoNames = $this->filterExists($batchNames);

                // 记录日志 (使用 Webman 的 Log)
                \support\Log::info("子进程 [$workerId] 待处理名单: ", $todoNames);

                if (empty($todoNames)) {
                    $output->writeln("<info>子进程 [$workerId] 批次 " . ($index + 1) . " 无需更新</info>");
                    continue;
                }

                // 2. 调用服务获取营养信息
                $remoteFoods = FoodService::nutritionForFood(array_values($todoNames));

                \support\Log::info("子进程 [$workerId] 远程获取数据: ", (array)$remoteFoods);

                if (!empty($remoteFoods)) {
                    // 执行同步入库
                    $this->syncRemote($remoteFoods);
                    $output->writeln("<comment>子进程 [$workerId] 同步进度: 批次 " . ($index + 1) . " 成功 +" . count($remoteFoods) . "</comment>");
                }

            } catch (\Exception $e) {
//                echo ;
                $output->writeln("<error>子进程 [$workerId] 批次 " . ($index + 1) . " 发生异常: " . $e->getMessage() . "</error>");
                $output->writeln(json_encode($batchNames));
                \support\Log::error("子进程 [$workerId] 异常详情: " . $e);
            } finally {
                $output->writeln("<info>子进程 [$workerId] 执行批次 " . ($index + 1) . " 完成</info>");
            }
        }
    }

    /**
     * 同步逻辑（保持事务原子性）
     */
    public function syncRemote(array $foodList)
    {
        if (empty($foodList)) return [];

        $result     = [];
        $foodFormat = new FoodFormat(null);

        foreach ($foodList as $item) {
            $foodModel = Db::transaction(function () use ($item) {
                // 单位与重量解析
                $unitStr  = $item['unit'] ?? '1 份';
                $unitArr  = explode(' ', trim($unitStr));
                $unitNum  = (float)($unitArr[0] ?? 1);
                $unitName = $unitArr[1] ?? '份';

                $totalWeightStr = $item['weight'] ?? '100g';
                $totalWeight    = (float)preg_replace('/[^0-9.]/', '', $totalWeightStr);
                if ($totalWeight <= 0) $totalWeight = 100;

                // 100g 比例换算
                $ratio = Calculate::div('100', (string)$totalWeight, 10);

                $localNutrition = [];
                foreach ($item['nutrition'] as $nut) {
                    $key                    = $nut['name'];
                    $dbKey                  = $key;
                    $val                    = (string)($nut['value'] ?? 0);
                    $localNutrition[$dbKey] = (float)Calculate::mul($val, $ratio, 2);
                }

                if (!isset($localNutrition['kcal'])) {
                    $localNutrition['kcal'] = $localNutrition['kal'] ?? 0;
                }

                // 维护数据关系
                $catName = $item['cat'] ?? '其他';
                $catId   = CatModel::where('name', $catName)->value('id') ?:
                    CatModel::insertGetId(['name' => $catName, 'pid' => 0, 'sort' => 100]);

                $food = FoodModel::updateOrCreate(
                    ['name' => $item['name']],
                    ['cat_id' => $catId, 'status' => 1, 'is_common' => $item['is_common'] ?? 2, 'is_ingredient' => $item['is_ingredient'] ?? 2]
                );

                FoodNutrientModel::updateOrCreate(['food_id' => $food->id], $localNutrition);

                $unit             = UnitModel::firstOrCreate(['name' => $unitName], ['type' => 'count']);
                $singleUnitWeight = Calculate::div((string)$totalWeight, (string)$unitNum, 2);

                FoodUnitModel::updateOrCreate(
                    ['food_id' => $food->id, 'unit_id' => $unit->id],
                    ['weight' => $singleUnitWeight, 'is_default' => 0]
                );

                return $food;
            });
            $result[]  = $foodFormat->format($foodModel);
        }
        return $result;
    }

    /**
     * 辅助方法：过滤已同步的食物
     */
    private function filterExists(array $names): array
    {
        $foodTable          = (new FoodModel())->getTable();
        $foodNutrientsTable = (new FoodNutrientModel())->getTable();
        $exists             = FoodModel::query()
            ->whereIn('name', $names)
            ->whereExists(function ($query) use ($foodNutrientsTable, $foodTable) {
                $query->from($foodNutrientsTable)
                    ->whereColumn($foodNutrientsTable . '.food_id', $foodTable . '.id');
            })
            ->pluck('name')
            ->toArray();

        return array_diff($names, $exists);
    }
}
