<?php

namespace app\service\recommendation;

class DeficiencyReport
{
    /**
     * @param string[] $keywords 触发的标签搜索关键词，如 ['低脂', '高蛋白']
     * @param string[] $reasons 人类可读的触发原因，可透传给前端展示
     * @param array $scores 各维度得分明细，用于 evaluateHealth
     * @param bool $balanced 是否营养均衡（无任何规则命中）
     */
    public function __construct(
        public readonly array $keywords,
        public readonly array $reasons,
        public readonly array $scores,
        public readonly bool  $balanced,
    )
    {
    }
}
