<?php

namespace app\service\channelClient;

use app\model\FoodModel;
use app\model\FoodUnitModel;
use app\model\UnitModel;
use app\service\FoodService;
use support\Db;
use support\Log;

final class FoodUnitSync extends BaseChannelClient
{
    public function run($message)
    {
        $foodIdList = json_decode($message, true);
        if (empty($foodIdList)) return [];
        FoodModel::query()
            ->whereIn('id', $foodIdList)
            ->whereNotExists(fn($q) => $q->select(Db::raw(1))
                ->from('food_units')
                ->whereRaw('food_units.food_id = foods.id'))
            ->select('id', 'name')
            ->chunkById(20, function ($foods) {
                $workerId = __CLASS__;
                if ($foods->isEmpty()) return;

                $names = $foods->pluck('name')->toArray();

                // ── 调用 AI 接口 ─────────────────────────────
                $result   = null;
                $attempts = 0;
                while ($attempts < 3) {
                    try {
                        $result = FoodService::unit($names);
                        break;
                    } catch (\Exception $e) {
                        $attempts++;
                        Log::error("Worker #{$workerId} ⚠️ 第{$attempts}次重试：" . $e->getMessage());
                        sleep(2);
                    }
                }

                if (empty($result)) {
                    Log::error("Worker #{$workerId} ❌AI接口3次重试全部失败");
                    return;
                }


                $resultData = is_string($result) ? json_decode($result, true) : $result;

                if (!is_array($resultData)) {
                    Log::error("Worker #{$workerId} ❌ 返回值不是数组，实际类型：" . gettype($resultData));
                    return;
                }

                // ── 如果是 {"data": [...]} 嵌套结构，取内层 ──
                if (isset($resultData['data']) && is_array($resultData['data'])) {
                    Log::error("Worker #{$workerId} ℹ️ 检测到嵌套结构，取 data 字段");
                    $resultData = $resultData['data'];
                }

                Log::error("Worker #{$workerId} 解析到 " . count($resultData) . " 条单位数据");

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
                            Log::error("Worker #{$workerId} ❌ [{$foodName}-{$unitName}] 写入失败：" . $e->getMessage());
                        }
                    }
                }

                Log::error("Worker #{$workerId} 本批完成：{$successCount}/{$foods->count()}");
            });
    }
}
