<?php

namespace app\service\recommendation;

use support\Db;

/**
 * 标签解析器 —— 唯一知道 tags 表的类
 *
 * 职责：将关键词列表转换为数据库中真实存在的 Tag 记录。
 *       如果关键词无法命中任何标签，自动降级到时段兜底逻辑。
 *
 * tags 表结构假设：
 *   id   int
 *   name varchar   标签名，如"低脂餐""高蛋白健身套餐"
 *   type tinyint   3 = 营养特点标签（本类只查 type=3）
 */
class TagResolver
{
    /**
     * 时段 → 兜底关键词映射
     * 覆盖全天 24 小时，确保任何时刻都有兜底
     */
    private const MEAL_SCHEDULE = [
        ['from' => 5,  'to' => 10, 'keyword' => '早餐'],
        ['from' => 11, 'to' => 14, 'keyword' => '午餐'],
        ['from' => 17, 'to' => 21, 'keyword' => '晚餐'],
        ['from' => 0,  'to' => 24, 'keyword' => '加餐'],   // 兜底兜底
    ];

    /**
     * 根据关键词从 tags 表解析出匹配的标签列表
     *
     * @param  string[] $keywords  来自 DeficiencyReport 的关键词
     * @return array               [['id'=>1,'name'=>'低脂餐'], ...]
     */
    public function resolve(array $keywords): array
    {
        $tags = [];

        if (!empty($keywords)) {
            $tags = $this->queryByKeywords($keywords);
        }
        if (empty($tags)) {
            $tags = $this->fallbackByTime();
        }

        return $tags;
    }

    // -------------------------------------------------------------------------
    // 私有方法
    // -------------------------------------------------------------------------

    /**
     * 用 LIKE 模糊匹配查 tags 表
     * 任一关键词命中即纳入结果，支持"有机低脂沙拉"这类复合标签名
     */
    private function queryByKeywords(array $keywords): array
    {
        $rows = Db::table('tags')
            ->where('type', 3)
            ->where(function ($q) use ($keywords) {
                foreach ($keywords as $kw) {
                    $q->orWhere('name', 'like', "%{$kw}%");
                }
            })
            ->get(['id', 'name']);

        return $rows ? $rows->toArray() : [];
    }

    /**
     * 按当前小时匹配餐次标签，作为最终兜底
     */
    private function fallbackByTime(): array
    {
        $hour    = (int) date('H');
        $keyword = '加餐';

        foreach (self::MEAL_SCHEDULE as $slot) {
            if ($hour >= $slot['from'] && $hour < $slot['to']) {
                $keyword = $slot['keyword'];
                break;
            }
        }

        $rows = Db::table('tags')
            ->where('type', 1)
            ->where('name', 'like', "%{$keyword}%")
            ->get(['id', 'name']);

        return $rows ? $rows->toArray() : [];
    }
}
