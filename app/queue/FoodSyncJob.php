<?php

namespace app\queue;

use app\common\base\BaseConsumer;
use app\common\enum\BusinessCode;
use app\common\exception\BusinessException;
use app\model\FoodModel;
use app\service\Alarm;
use app\service\BooHee;
use app\service\foodHealthCheck\FoodNutritionSync;
use support\Log;
use support\Redis;

/**
 * 当用户查询到不存在的食物时从薄荷健康获取食物名称，然后同步完整食品信息。
 */
class FoodSyncJob extends BaseConsumer
{
    public $queue = 'FoodSync';
    public $connection = 'default';

    public function consume($data)
    {
        try {
            $name = $data['foodName'] ?? null;
            if (!$name) {
                Alarm::notify(new BusinessException('空字符串调用食品查询接口', BusinessCode::BUSINESS_ERROR));
                return null;
            }
            if (!BooHee::instance()->canUse()) {
                Alarm::notify(new BusinessException('薄荷健康调用次数达到上限', BusinessCode::THREE_PART_ERROR));
                return null;
            }

            Log::info("[$this->queue]开始同步不存在的食品", ['name' => $name]);
            $cacheKey = 'boohee:response:' . date('Ymd') . ':' . $name;
            $foodList = Redis::get($cacheKey);
            $foodList = $foodList ? json_decode($foodList, true) : BooHee::instance()->search($name);
            if (!$foodList) {
                Log::info("[$this->queue]薄荷健康未返回食品信息", ['name' => $name]);
                return null;
            }
            Redis::setEx($cacheKey, 1800, json_encode($foodList, JSON_UNESCAPED_UNICODE));

            $foodNames = array_column($foodList, 'name');
            [$isBatchSuccess, $foodIds] = FoodNutritionSync::instance()->run($foodNames);
            if (!$isBatchSuccess) {
                throw new BusinessException('食品三方信息同步失败', BusinessCode::THREE_PART_ERROR);
            }

            FoodModel::query()->whereIn('id', $foodIds)->update(['coze_status' => 1]);
            Redis::del($cacheKey);
            Log::info('同步食品成功', ['count' => count($foodIds)]);
            return true;
        } catch (\Throwable $exception) {
            Log::error('食品同步队列异常', [
                'message' => $exception->getMessage(),
                'trace'   => $exception->getTraceAsString(),
            ]);
            Alarm::notify($exception);
            throw $exception;
        }
    }
}
