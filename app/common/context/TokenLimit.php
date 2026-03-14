<?php

namespace app\common\context;

use app\model\UserUsageModel;
use support\Redis;
use Webman\Context;

final class TokenLimit
{
    protected static ?self $instance = null;

    /**
     * 阶梯限流规则（累计 token => 每日最大调用次数）
     * 按 threshold 从大到小排列，匹配第一个满足条件的规则
     */
    protected array $rules = [
        600000 => 5,   // 累计 > 60w token，每天限 5 次
        100000 => 10,  // 累计 > 10w token，每天限 10 次
        0      => 50,  // 默认每天 50 次
    ];

    private function __construct() {}

    public static function instance(): self
    {
        return self::$instance ??= new self();
    }

    // -------------------------------------------------------------------------
    // Public API
    // -------------------------------------------------------------------------

    /**
     * 检查当前登录用户是否还有今日额度
     */
    public function hasQuota(): bool
    {
        $userId    = $this->currentUserId();
        $limit     = $this->getDailyLimit($userId);
        $usedCount = $this->getUsedCount($userId);

        return $usedCount < $limit;
    }

    /**
     * 原子性地消耗一次次数，并异步累积 token 到数据库
     * 返回 false 表示已超限，本次不记录
     */
    public function consume(int $tokens): bool
    {
        if ($tokens <= 0) return true;

        $userId = $this->currentUserId();
        $limit  = $this->getDailyLimit($userId);

        // 先 incr，再判断是否超限（原子性，避免并发漏洞）
        $key      = $this->quotaKey($userId);
        $newCount = Redis::incr($key);

        // 首次写入时设置过期（精确到当天结束）
        if ($newCount === 1) {
            Redis::expireAt($key, $this->todayEndTimestamp());
            $this->ensureDailyRecord($userId);
        }

        if ($newCount > $limit) {
            // 超限：回滚计数，让用户感知明确
            Redis::decr($key);
            return false;
        }

        // 异步写 token 到数据库（不阻塞主流程）
        $this->persistTokens($userId, $tokens);
        return true;
    }

    /**
     * 获取当前用户今日用量详情（用于前端展示）
     */
    public function getQuotaInfo(): array
    {
        $userId    = $this->currentUserId();
        $limit     = $this->getDailyLimit($userId);
        $usedCount = $this->getUsedCount($userId);

        return [
            'used'      => $usedCount,
            'limit'     => $limit,
            'remaining' => max(0, $limit - $usedCount),
            'reset_at'  => $this->todayEndTimestamp(),
        ];
    }

    // -------------------------------------------------------------------------
    // Private helpers
    // -------------------------------------------------------------------------

    private function currentUserId(): int
    {
        return (int) Context::get(\app\common\enum\Context::UserId->value);
    }

    /**
     * 根据用户历史累计 token 计算今日限额
     * 累计 token 优先走 Redis 缓存，避免每次都查 DB
     */
    private function getDailyLimit(int $userId): int
    {
        $totalTokens = $this->getTotalTokensCached($userId);

        foreach ($this->rules as $threshold => $limit) {
            if ($totalTokens >= $threshold) {
                return $limit;
            }
        }

        return 50; // fallback，理论上不会走到这里
    }

    /**
     * 从 Redis 缓存读取用户累计 token，缓存 1 小时
     * 避免每次请求都打数据库
     */
    private function getTotalTokensCached(int $userId): int
    {
        $cacheKey = "user_total_tokens:{$userId}";
        $cached   = Redis::get($cacheKey);

        if ($cached !== null) {
            return (int) $cached;
        }

        $total = (int) (UserUsageModel::where('user_id', $userId)->sum('token') ?: 0);
        Redis::setEx($cacheKey, 3600, $total); // 缓存 1 小时

        return $total;
    }

    /**
     * 读取今日已使用次数
     */
    private function getUsedCount(int $userId): int
    {
        return (int) (Redis::get($this->quotaKey($userId)) ?: 0);
    }

    /**
     * 确保数据库中今日记录存在（首次调用时创建）
     */
    private function ensureDailyRecord(int $userId): void
    {
        UserUsageModel::firstOrCreate(
            ['user_id' => $userId, 'date' => date('Y-m-d')],
            ['token' => 0, 'usage' => 0]
        );
    }

    /**
     * 将 token 写入数据库，同时让累计缓存失效（下次重新算）
     */
    private function persistTokens(int $userId, int $tokens): void
    {
        UserUsageModel::where('user_id', $userId)
            ->whereDate('date', date('Y-m-d'))
            ->increment('token', $tokens);

        // 使累计 token 缓存失效，让下次 getDailyLimit 读到最新值
        Redis::del("user_total_tokens:{$userId}");
    }

    /**
     * Redis key：每日次数计数器
     */
    private function quotaKey(int $userId): string
    {
        return 'user_quota:' . date('Ymd') . ':' . $userId;
    }

    /**
     * 今天结束的 Unix 时间戳（明天 00:00:00）
     * 用 expireAt 比 expire(TTL) 更精确，不受请求时刻影响
     */
    private function todayEndTimestamp(): int
    {
        return (int) strtotime('tomorrow 00:00:00');
    }
}
