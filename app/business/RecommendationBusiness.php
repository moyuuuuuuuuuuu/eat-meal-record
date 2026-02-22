<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\model\FoodModel as Food;
use app\model\MealRecordModel as MealRecord;
use support\Request;

class RecommendationBusiness extends BaseBusiness
{
    /**
     * 今日吃什么推荐
     *
     * @return array
     */
    public function today(Request $request): array
    {
        $user = $request->userInfo;

        if (!$user) {
            // 未登录：根据当前时间推荐
            return $this->recommendByTime();
        }

        // 已登录：根据近期营养摄入推荐
        return $this->recommendByUserContext($user['id']);
    }

    /**
     * 根据当前时间段推荐 (早餐/午餐/晚餐/加餐)
     */
    public function recommendByTime(): array
    {
        $config = config('recommendation');
        $hour = (int)date('H');
        $tagName = $config['time_tags']['snack'];
        $ranges = $config['time_ranges'];
        if ($hour >= $ranges['breakfast'][0] && $hour < $ranges['breakfast'][1]) {
            $tagName = $config['time_tags']['breakfast'];
        } elseif ($hour >= $ranges['lunch'][0] && $hour < $ranges['lunch'][1]) {
            $tagName = $config['time_tags']['lunch'];
        } elseif ($hour >= $ranges['dinner'][0] && $hour < $ranges['dinner'][1]) {
            $tagName = $config['time_tags']['dinner'];
        }

        // 定义非整餐（单一食材）的分类ID
        $rawMaterialCatIds = $config['raw_material_cat_ids'];

        $query = Food::whereHas('tags', function ($query) use ($tagName) {
            $query->where('name', $tagName);
        })
        ->whereNotIn('cat_id', $rawMaterialCatIds)
        ->where('status', 1);

        $food = $query->inRandomOrder()->first();

        // 如果没有符合分类的，放宽限制，但依然要求有标签
        if (!$food) {
            $food = Food::whereHas('tags', function ($query) use ($tagName) {
                $query->where('name', $tagName);
            })->where('status', 1)->inRandomOrder()->first();
        }

        // 最后的兜底：随机给一个非食材分类的
        if (!$food) {
            $food = Food::whereNotIn('cat_id', $rawMaterialCatIds)
                ->where('status', 1)
                ->inRandomOrder()
                ->first();
        }

        if (!$food) {
            throw new \RuntimeException('暂无食物推荐');
        }

        $data = $food->toArray();
        $data['unit_list'] = $food->getUnits();
        $data['recommend_reason'] = "适合现在的" . $tagName;

        return $data;
    }

    /**
     * 根据用户近期摄入分析推荐 (低糖/少油/高蛋白)
     */
    public function recommendByUserContext(int $userId): array
    {
        $config = config('recommendation');
        // 获取最近3天的记录
        $recentRecords = MealRecord::where('user_id', $userId)
            ->where('meal_date', '>=', date('Y-m-d', strtotime('-3 days')))
            ->get();

        $totalCarbs = $recentRecords->sum('carbo');
        $totalFat = $recentRecords->sum('fat');
        $count = $recentRecords->count();

        $recommendTags = [];
        $reason = $config['reason_prefix'];

        if ($count > 0) {
            $avgCarbs = $totalCarbs / $count;
            $avgFat = $totalFat / $count;

            // 简单的逻辑判断：如果平均碳水较高，推荐低糖；如果平均脂肪较高，推荐少油
            if ($avgCarbs > $config['nutrition_thresholds']['carbs']) {
                $recommendTags[] = $config['nutrition_tags']['carbs'];
            }
            if ($avgFat > $config['nutrition_thresholds']['fat']) {
                $recommendTags[] = $config['nutrition_tags']['fat'];
            }
        }

        if (empty($recommendTags)) {
            // 默认推荐健康标签
            $recommendTags = $config['default_recommend_tags'];
            $reason = $config['default_reason'];
        } else {
            $reason .= implode('、', $recommendTags) . $config['reason_suffix'];
        }

        // 定义非整餐（单一食材）的分类ID
        $rawMaterialCatIds = $config['raw_material_cat_ids'];

        $query = Food::where('status', 1)
            ->whereNotIn('cat_id', $rawMaterialCatIds);

        $query->whereHas('tags', function ($q) use ($recommendTags) {
            $q->whereIn('name', $recommendTags);
        });

        $food = $query->inRandomOrder()->first();

        // 兜底逻辑
        if (!$food) {
            return $this->recommendByTime();
        }

        $data = $food->toArray();
        $data['unit_list'] = $food->getUnits();
        $data['recommend_reason'] = $reason;

        return $data;
    }
}
