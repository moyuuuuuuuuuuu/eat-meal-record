<?php

return [
    'raw_material_cat_ids' => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 17],
    'time_tags' => [
        'breakfast' => '早餐',
        'lunch' => '午餐',
        'dinner' => '晚餐',
        'snack' => '加餐',
    ],
    'time_ranges' => [
        'breakfast' => [5, 10],
        'lunch' => [10, 14],
        'dinner' => [17, 21],
    ],
    'nutrition_thresholds' => [
        'carbs' => 50,
        'fat' => 20,
    ],
    'nutrition_tags' => [
        'carbs' => '低糖',
        'fat' => '少油',
    ],
    'default_recommend_tags' => ['高蛋白', '健康脂肪', '健康'],
    'default_reason' => '开启健康的一天',
    'reason_prefix' => '根据您近期的饮食分析，为您推荐：',
    'reason_suffix' => '餐食',
];
