<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\enum\UserInfoContext;
use support\Db;
use Webman\Context;

/**
 * 营养统计 Service
 *
 * 数据来源：meal_record_foods.nutrition（JSON 列）
 *
 * nutrition JSON 结构（每行食物已按实际分量折算）：
 * {
 *   "kcal": 154.9, "pro": 13.55, "fat": 8.64, "carb": 12.0,
 *   "fiber": 0.24, "na": 120.0, "sugar": 2.1, ...
 * }
 *
 * 查询思路：
 *   对指定时间段内用户的所有 meal_record_foods 行，
 *   用 MySQL JSON_EXTRACT 提取各营养字段并 SUM，
 *   再除以天数得到日均值（雷达图对照的是每日 DRI）。
 */
class NutritionStatsBusiness extends BaseBusiness
{
    /**
     * 需要统计的营养字段（与前端 dimensions 对应）
     * key => JSON 路径
     */
    private const NUTRITION_KEYS = [
        'kcal',
        'pro',
        'fat',
        'carb',
        'fiber',
        'na',
        'sugar',
        'chol',
        'cal',
        'iron',
        'vit_c',
        'vit_a',
    ];

    /**
     * 成人每日营养参考摄入量 DRI
     * 用于计算健康得分，与前端 NutritionAnalyzer::DRI 保持一致
     */
    private const DRI = [
        'kcal'  => 2000,
        'pro'   => 60,
        'fat'   => 60,
        'carb'  => 300,
        'fiber' => 25,
        'na'    => 2000,
        'sugar' => 50,
        'chol'  => 300,
        'cal'   => 800,
        'iron'  => 12,
        'vit_c' => 100,
        'vit_a' => 800,
    ];

    // -------------------------------------------------------------------------

    /**
     * 获取指定时间段的营养统计
     *
     * @param int $userId
     * @param string $period week | month | quarter | year
     */
    public function getStats(string $period): array
    {
        $userId = Context::get(UserInfoContext::UserId->value);
        [$startDate, $endDate] = $this->getDateRange($period);

        $days = max(1, (strtotime($endDate) - strtotime($startDate)) / 86400 + 1);

        // 结束时间需要补全到当天 23:59:59 确保范围包含全天
        $totals = $this->sumNutrition($userId, $startDate . ' 00:00:00', $endDate . ' 23:59:59');

        $daily = [];
        foreach (self::NUTRITION_KEYS as $outKey) {
            $daily[$outKey] = round(($totals[$outKey] ?? 0) / $days, 2);
        }

        $score = $this->calcScore($daily);

        return [
            'period'      => $period,
            'date_range'  => ['start' => $startDate, 'end' => $endDate],
            'days'        => (int)$days,
            'nutrition'   => $daily,
            'totals'      => $totals,
            'score'       => $score,
            'score_level' => $this->scoreLevel($score),
        ];
    }

    // -------------------------------------------------------------------------
    // 私有方法
    // -------------------------------------------------------------------------

    /**
     * 根据时间段返回 [开始日期, 结束日期]（date 字符串）
     */
    private function getDateRange(string $period): array
    {
        $today = date('Y-m-d');

        return match ($period) {
            'week' => [date('Y-m-d', strtotime('monday this week')), $today],
            'month' => [date('Y-m-01'), $today],
            'quarter' => [$this->quarterStart(), $today],
            'year' => [date('Y-01-01'), $today],
            default => [date('Y-m-d', strtotime('-6 days')), $today],
        };
    }

    /**
     * 当前季度开始日期
     */
    private function quarterStart(): string
    {
        $month  = (int)date('n');
        $qMonth = (int)ceil($month / 3) * 3 - 2; // 1、4、7、10
        return date('Y') . '-' . str_pad($qMonth, 2, '0', STR_PAD_LEFT) . '-01';
    }

    /**
     * 用 JSON_EXTRACT + SUM 聚合指定区间内用户所有食物记录的营养总量
     *
     * 注意：meal_record_foods.nutrition 存储的是已按分量折算的营养值，
     *       因此直接 SUM 即为区间总摄入量。
     *
     * 用 selectRaw 一次性传入纯字符串表达式，避免 Db::raw() 返回
     * Expression 对象后无法被 implode 的问题。
     */
    private function sumNutrition(int $userId, string $startTime, string $endTime): array
    {
        $exprs = [];
        foreach (self::NUTRITION_KEYS as $outKey) {
            $exprs[] = "ROUND(SUM(CAST(`nutrition`->>'$.{$outKey}' AS DECIMAL(10,2))), 2) AS `{$outKey}`";
        }

        $row = Db::table('meal_record_foods')
            ->selectRaw(implode(', ', $exprs))
            ->where('user_id', $userId)
            ->whereBetween('created_at', [$startTime, $endTime]) // 利用索引
            ->first();

        if (!$row) {
            return array_fill_keys(self::NUTRITION_KEYS, 0.0);
        }

        // 显式转换 stdClass 为数组并处理 float
        return array_map('floatval', (array)$row);
    }

    /**
     * 计算综合健康得分（0~100）
     *
     * 规则（与前端 NutritionAnalyzer 对称）：
     *   - 60%~100% DRI → 满分 100
     *   - < 60% DRI    → 按比例线性扣分
     *   - > 100% DRI   → 超出部分按 1.5 倍系数扣分
     *
     * 最终取各维度平均值。
     */
    private function calcScore(array $daily): int
    {
        $scores = [];
        foreach (self::DRI as $key => $dri) {
            $val = $daily[$key] ?? 0;
            $pct = $dri > 0 ? $val / $dri : 0;

            if ($pct >= 0.6 && $pct <= 1.0) {
                $scores[] = 100;
            } elseif ($pct < 0.6) {
                $scores[] = (int)round($pct / 0.6 * 100);
            } else {
                $scores[] = max(0, (int)round((1 - ($pct - 1) * 1.5) * 100));
            }
        }

        return (int)round(array_sum($scores) / count($scores));
    }

    /**
     * 得分等级文字
     */
    private function scoreLevel(int $score): string
    {
        return match (true) {
            $score >= 85 => '优秀',
            $score >= 65 => '良好',
            default => '待改善',
        };
    }
}
