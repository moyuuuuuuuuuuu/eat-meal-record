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
        $hour = (int)date('H');
        $tagName = '加餐';
        if ($hour >= 5 && $hour < 10) {
            $tagName = '早餐';
        } elseif ($hour >= 10 && $hour < 14) {
            $tagName = '午餐';
        } elseif ($hour >= 17 && $hour < 21) {
            $tagName = '晚餐';
        }

        // 定义非整餐（单一食材）的分类ID
        $rawMaterialCatIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 17];

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
        // 获取最近3天的记录
        $recentRecords = MealRecord::where('user_id', $userId)
            ->where('meal_date', '>=', date('Y-m-d', strtotime('-3 days')))
            ->get();

        $totalCarbs = $recentRecords->sum('carbo');
        $totalFat = $recentRecords->sum('fat');
        $count = $recentRecords->count();

        $recommendTags = [];
        $reason = "根据您近期的饮食分析，为您推荐：";

        if ($count > 0) {
            $avgCarbs = $totalCarbs / $count;
            $avgFat = $totalFat / $count;

            // 简单的逻辑判断：如果平均碳水较高，推荐低糖；如果平均脂肪较高，推荐少油
            if ($avgCarbs > 50) { // 阈值假设
                $recommendTags[] = '低糖';
            }
            if ($avgFat > 20) {
                $recommendTags[] = '少油';
            }
        }

        if (empty($recommendTags)) {
            // 默认推荐健康标签
            $recommendTags = ['高蛋白', '健康脂肪', '健康'];
            $reason = "开启健康的一天";
        } else {
            $reason .= implode('、', $recommendTags) . "餐食";
        }

        // 定义非整餐（单一食材）的分类ID
        $rawMaterialCatIds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 17];

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
