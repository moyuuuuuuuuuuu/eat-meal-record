<?php

require_once __DIR__ . '/../vendor/autoload.php';

use app\util\FoodSyncByRemote;

$cases = [
    [
        'name' => 'category_to_single_tag',
        'input' => ['口味' => '甜'],
        'expected' => [
            ['name' => '甜', 'type' => 2, 'meta_type' => '口味'],
        ],
    ],
    [
        'name' => 'category_to_multiple_tags',
        'input' => ['推荐餐次' => '早餐、加餐', '特性' => '易消化,中等热量'],
        'expected' => [
            ['name' => '早餐', 'type' => 1, 'meta_type' => '推荐餐次'],
            ['name' => '加餐', 'type' => 1, 'meta_type' => '推荐餐次'],
            ['name' => '易消化', 'type' => 10, 'meta_type' => '特性'],
            ['name' => '中等热量', 'type' => 10, 'meta_type' => '特性'],
        ],
    ],
    [
        'name' => 'tag_to_category',
        'input' => ['麻辣' => '口味', '高糖' => '营养'],
        'expected' => [
            ['name' => '麻辣', 'type' => 2, 'meta_type' => '口味'],
            ['name' => '高糖', 'type' => 3, 'meta_type' => '营养'],
        ],
    ],
];

$failures = [];
foreach ($cases as $case) {
    $actual = FoodSyncByRemote::normalizeTags($case['input']);
    if ($actual !== $case['expected']) {
        $failures[] = $case['name'] . PHP_EOL
            . 'expected: ' . json_encode($case['expected'], JSON_UNESCAPED_UNICODE) . PHP_EOL
            . 'actual:   ' . json_encode($actual, JSON_UNESCAPED_UNICODE);
    }
}

if ($failures) {
    fwrite(STDERR, implode(PHP_EOL . PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo "tag normalization checks passed" . PHP_EOL;
