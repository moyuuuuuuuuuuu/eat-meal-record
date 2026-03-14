<?php

namespace app\service\recommendation;

/**
 * 推荐门面 —— 对外唯一入口
 *
 * 职责：编排 NutritionAnalyzer → TagResolver → FoodRepository → TipGenerator，
 *       将各层结果组装成最终响应。自身不含任何业务逻辑。
 *
 * 使用示例：
 *   $result = (new Recommendation())->getSuggestions($nutritionArray);
 *   $health = (new Recommendation())->evaluateHealth($nutritionArray);
 */
class Recommendation
{
    private NutritionAnalyzer $analyzer;
    private TagResolver       $tagResolver;
    private FoodRepository    $foodRepo;
    private TipGenerator      $tipGenerator;

    public function __construct(
        ?NutritionAnalyzer $analyzer = null,
        ?TagResolver       $tagResolver = null,
        ?FoodRepository    $foodRepo = null,
        ?TipGenerator      $tipGenerator = null,
    )
    {
        // 支持依赖注入（测试时传 Mock），默认自动实例化
        $this->analyzer     = $analyzer ?? new NutritionAnalyzer();
        $this->tagResolver  = $tagResolver ?? new TagResolver();
        $this->foodRepo     = $foodRepo ?? new FoodRepository();
        $this->tipGenerator = $tipGenerator ?? new TipGenerator();
    }

    // -------------------------------------------------------------------------
    // 对外接口
    // -------------------------------------------------------------------------

    /**
     * 获取单条食物推荐
     *
     * 返回结构与前端约定一致：食物字段平铺，tag 为标签名数组，
     * recommend_reason 为人性化建议文字。
     * 无可推荐食物时返回 null，调用方自行处理降级。
     *
     * @param array $nutrition 当日累计营养数据，键值对格式
     * @return array|null {
     *   id:               int,
     *   name:             string,
     *   kcal:             float,
     *   pro:              float,
     *   fat:              float,
     *   fiber:            float,
     *   tag:              string[],   命中的标签名列表
     *   recommend_reason: string,     人性化建议文字
     * }
     */
    public function getSuggestions(array $nutrition): ?array
    {
        // 1. 营养分析
        $report = $this->analyzer->analyze($nutrition);

        // 2. 关键词 → 真实标签
        $tags = $this->tagResolver->resolve($report->keywords);

        // 3. 标签 → 单条食物
        $tagIds = array_column($tags, 'id');
        $food   = $this->foodRepo->findOneByTagIds($tagIds);

        if ($food === null) {
            return null;
        }

        // 4. 生成提示语
        $tagNames = array_column($tags, 'name');
        $tip      = $this->tipGenerator->generate($tagNames);

        // 5. 平铺输出，与前端约定结构一致
        return [
            'id'               => $food['id'],
            'name'             => $food['name'],
            'kcal'             => round((float)$food['kcal'], 2),
            'pro'              => round((float)$food['pro'], 2),
            'fat'              => round((float)$food['fat'], 2),
            'fiber'            => round((float)$food['fiber'], 2),
            'tag'              => $tagNames,
            'recommend_reason' => $tip,
        ];
    }

    /**
     * 健康评分
     *
     * @param array $nutrition 当日累计营养数据
     * @return array {
     *   score:  int,            0~100 综合得分
     *   level:  string,         优秀 / 良好 / 较差
     *   advice: string[],       问题列表（为空则代表健康均衡）
     *   charts: array[],        图表数据：各维度值 + DRI + 百分比
     * }
     */
    public function evaluateHealth(array $nutrition): array
    {
        $report = $this->analyzer->analyze($nutrition);

        // 从分析报告中扣分
        $deductMap = [
            '脂肪'     => 30,
            '碳水'     => 15,
            '蛋白质'   => 15,
            '膳食纤维' => 20,
            '添加糖'   => 10,
            '胆固醇'   => 10,
            '钠'       => 10,
        ];

        $score  = 100;
        $advice = $report->reasons;

        // 根据 reasons 中包含的维度名称扣分
        foreach ($deductMap as $dim => $points) {
            foreach ($report->reasons as $reason) {
                if (mb_strpos($reason, $dim) !== false) {
                    $score -= $points;
                    break;
                }
            }
        }

        return [
            'score'  => max(0, $score),
            'level'  => match (true) {
                $score > 80 => '优秀',
                $score > 60 => '良好',
                default => '较差',
            },
            'advice' => $advice,
            'charts' => $report->scores,
        ];
    }
}
