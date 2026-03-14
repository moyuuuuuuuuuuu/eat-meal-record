<?php

namespace app\service\recommendation;

/**
 * 营养分析器 —— 纯计算，零数据库依赖
 *
 * 职责：对照 DRI 参考值，分析营养数据的缺失/超标维度，
 *       输出结构化的 DeficiencyReport，供下游 TagResolver 使用。
 */
class NutritionAnalyzer
{
    /**
     * 成人每日营养参考摄入量（DRI）
     * 单位见注释，所有阈值均基于 2023 中国居民膳食营养素参考摄入量
     */
    private const DRI = [
        'kcal'  => 2000,   // kcal 总热量
        'pro'   => 60,     // g    蛋白质
        'fat'   => 60,     // g    脂肪（约占总能量 30%）
        'carb'  => 300,    // g    碳水化合物
        'fiber' => 25,     // g    膳食纤维
        'sugar' => 50,     // g    添加糖上限
        'chol'  => 300,    // mg   胆固醇上限
        'na'    => 2000,   // mg   钠上限
        'cal'   => 800,    // mg   钙
        'iron'  => 12,     // mg   铁
        'vit_c' => 100,    // mg   维生素 C
        'vit_a' => 800,    // μg   维生素 A
    ];

    /**
     * 分析营养数据，返回缺失报告
     *
     * @param array $n 营养键值对，键名与 DRI 一致（允许部分字段缺失）
     */
    public function analyze(array $n): DeficiencyReport
    {
        $n   = $this->normalize($n);
        $dri = self::DRI;

        $keywords = [];
        $reasons  = [];
        $scores   = $this->buildScores($n);

        foreach ($this->rules($n, $dri) as $rule) {
            if ($rule['hit']) {
                foreach ($rule['keywords'] as $kw) {
                    $keywords[] = $kw;
                }
                $reasons[] = $rule['reason'];
            }
        }

        $keywords = array_values(array_unique($keywords));

        return new DeficiencyReport(
            keywords: $keywords,
            reasons: $reasons,
            scores: $scores,
            balanced: empty($keywords),
        );
    }

    // -------------------------------------------------------------------------
    // 私有方法
    // -------------------------------------------------------------------------

    /**
     * 将输入数据统一转为 float，防止字符串类型导致比较错误
     */
    private function normalize(array $n): array
    {
        $nTemplate = [
            'kcal'  => 0.00,
            'fat'   => 0.00,
            'carb'  => 0.00,
            'fiber' => 0.00,
            'pro'   => 0.00,
            'sugar' => 0.00,
            'chol'  => 0.00,
            'na'    => 0.00,
            'cal'   => 0.00,
            'iron'  => 0.00,
            'vit_c' => 0.00,
            'vit_a' => 0.00,
        ];
        $n         = array_merge($nTemplate, $n);
        return array_map('floatval', $n);
    }

    /**
     * 规则表 —— 每条规则独立，新增规则只需在此追加
     *
     * 结构：[ 'hit' => bool, 'keywords' => string[], 'reason' => string ]
     */
    private function rules(array $n, array $dri): array
    {
        $kcal      = max($n['kcal'] ?? 1, 1);   // 防除零
        $fatRatio  = ($n['fat'] ?? 0 * 9) / $kcal;
        $carbRatio = ($n['carb'] ?? 0 * 4) / $kcal;
        $proRatio  = ($n['pro'] ?? 0 * 4) / $kcal;

        return [
            // ── 热量 ──────────────────────────────────────────────────────────
            [
                'hit'      => $n['kcal'] < $dri['kcal'] * 0.5,
                'keywords' => ['高热量', '能量补充'],
                'reason'   => sprintf('今日热量仅 %.0f kcal，不足推荐量的 50%%', $n['kcal']),
            ],

            // ── 脂肪 ──────────────────────────────────────────────────────────
            [
                'hit'      => $fatRatio > 0.35,
                'keywords' => ['低脂', '清淡', '轻食'],
                'reason'   => sprintf('脂肪供能占比 %.0f%%，超过 35%% 阈值', $fatRatio * 100),
            ],

            // ── 蛋白质 ────────────────────────────────────────────────────────
            [
                'hit'      => $n['pro'] < $dri['pro'] * 0.6,
                'keywords' => ['高蛋白', '健身', '增肌'],
                'reason'   => sprintf('蛋白质仅 %.1f g，不足推荐量的 60%%', $n['pro']),
            ],

            // ── 碳水 ──────────────────────────────────────────────────────────
            [
                'hit'      => $carbRatio > 0.65,
                'keywords' => ['低碳', '低糖', '控糖'],
                'reason'   => sprintf('碳水供能占比 %.0f%%，超过 65%% 阈值', $carbRatio * 100),
            ],

            // ── 膳食纤维 ──────────────────────────────────────────────────────
            [
                'hit'      => $n['fiber'] < $dri['fiber'] * 0.4,
                'keywords' => ['高纤维', '蔬果', '粗粮'],
                'reason'   => sprintf('膳食纤维仅 %.1f g，严重不足（推荐 %d g）', $n['fiber'], $dri['fiber']),
            ],

            // ── 添加糖 ────────────────────────────────────────────────────────
            [
                'hit'      => isset($n['sugar']) && $n['sugar'] > $dri['sugar'],
                'keywords' => ['低糖', '无糖', '控糖'],
                'reason'   => sprintf('添加糖 %.1f g，超过上限 %d g', $n['sugar'] ?? 0, $dri['sugar']),
            ],

            // ── 胆固醇 ────────────────────────────────────────────────────────
            [
                'hit'      => isset($n['chol']) && $n['chol'] > $dri['chol'],
                'keywords' => ['低胆固醇', '清淡', '低脂'],
                'reason'   => sprintf('胆固醇 %.0f mg，超过上限 %d mg', $n['chol'] ?? 0, $dri['chol']),
            ],

            // ── 钠 ────────────────────────────────────────────────────────────
            [
                'hit'      => isset($n['na']) && $n['na'] > $dri['na'],
                'keywords' => ['低钠', '少盐', '清淡'],
                'reason'   => sprintf('钠 %.0f mg，超过上限 %d mg', $n['na'] ?? 0, $dri['na']),
            ],

            // ── 维生素 C ──────────────────────────────────────────────────────
            [
                'hit'      => isset($n['vit_c']) && $n['vit_c'] < $dri['vit_c'] * 0.3,
                'keywords' => ['蔬果', '高维C'],
                'reason'   => sprintf('维生素 C 仅 %.1f mg，建议多吃新鲜蔬果', $n['vit_c'] ?? 0),
            ],
        ];
    }

    /**
     * 构建各维度百分比得分（相对 DRI），用于前端图表展示
     */
    private function buildScores(array $n): array
    {
        $dri = self::DRI;
        $map = [
            'kcal'  => '总热量',
            'pro'   => '蛋白质',
            'fat'   => '脂肪',
            'carb'  => '碳水',
            'fiber' => '膳食纤维',
        ];

        $result = [];
        foreach ($map as $key => $label) {
            $result[] = [
                'key'   => $key,
                'name'  => $label,
                'value' => $n[$key] ?? 0,
                'dri'   => $dri[$key],
                'pct'   => $dri[$key] > 0
                    ? round(min(($n[$key] ?? 0) / $dri[$key] * 100, 200))
                    : 0,
            ];
        }

        return $result;
    }
}
