<?php

namespace app\common\context;

use support\Redis;
use Webman\Context;

final class TokenLimit
{
    protected static $instance;
// 阶梯规则
    protected array $rules = [
        600000 => 5,   // 累计 > 80w，每天 5 次
        100000 => 10,  // 累计 > 10w，每天 10 次
        0      => 50,  // 默认 50 次
    ];

    protected function __construct()
    {

    }

    public static function instance()
    {
        if (self::$instance instanceof self) {
            return self::$instance;
        }
        return self::$instance = new self;
    }

    /**
     * 检查用户是否有额度
     */
    public function hasQuota(): bool
    {
        $userId = Context::get(\app\common\enum\Context::UserId->value);
        // 1. 获取用户累计消耗（建议从数据库或缓存获取）
        // 这里模拟从数据库读取，实际生产建议缓存该值
        $totalTokens = \app\model\UserUsageStats::where('user_id', $userId)->value('total_tokens') ?: 0;

        // 2. 计算今日限额
        $dailyLimit = 50;
        foreach ($this->rules as $threshold => $limit) {
            if ($totalTokens >= $threshold) {
                $dailyLimit = $limit;
                break;
            }
        }

        // 3. 检查 Redis 当日已用次数
        $key       = "user_quota:" . date('Ymd') . ":" . $userId;
        $usedCount = (int)Redis::get($key) ?: 0;

        return $usedCount < $dailyLimit;
    }

    /**
     * 记录消耗
     */
    public function recordUsage(int $userId, int $tokens)
    {
        if ($tokens <= 0) return;

        // 1. 增加每日次数计数
        $key = "user_quota:" . date('Ymd') . ":" . $userId;
        Redis::incr($key);
        Redis::expire($key, 86400);

        // 2. 增加累计 Token 消耗
        \app\model\UserUsageStats::where('user_id', $userId)->increment('total_tokens', $tokens);
    }

}
