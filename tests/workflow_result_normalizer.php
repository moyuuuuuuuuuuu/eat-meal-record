<?php

require dirname(__DIR__) . '/vendor/autoload.php';

use app\service\coze\WorkflowResultNormalizer;

function expectSame(mixed $expected, mixed $actual, string $message): void
{
    if ($expected !== $actual) {
        throw new RuntimeException($message . PHP_EOL
            . 'expected: ' . var_export($expected, true) . PHP_EOL
            . 'actual: ' . var_export($actual, true));
    }
}

$names = WorkflowResultNormalizer::normalizeNames([' 八宝粥 ', '八宝粥', '', '水煮鸡蛋']);
expectSame(['八宝粥', '水煮鸡蛋'], $names, '食物名称应去空、去重并保序');

$decoded = WorkflowResultNormalizer::decode([
    'output' => "```json\n{\"data\":[{\"food\":\"八宝粥\"}]}\n```",
], ['output']);
expectSame([['food' => '八宝粥']], $decoded, '应兼容 Markdown 和 data 包装');

$units = WorkflowResultNormalizer::units([[
    'food' => '八宝粥',
    'unit' => [
        ['name' => '碗', 'weight' => '250', 'is_default' => 1, 'type' => 'service'],
        ['name' => '克', 'weight' => 1, 'is_default' => 1, 'type' => 'weight'],
        ['name' => '错误', 'weight' => 0, 'is_default' => 0, 'type' => 'unknown'],
    ],
]], ['八宝粥']);
expectSame(1, $units[0]['unit'][0]['is_default'], '第一个默认单位应保留');
expectSame(0, $units[0]['unit'][1]['is_default'], '多余默认单位应被清除');
expectSame(2, count($units[0]['unit']), '非法单位应被过滤');

$tags = WorkflowResultNormalizer::tags([[
    'food' => '水煮鸡蛋',
    'cate' => '肉蛋',
    'isCommon' => true,
    'tags' => [
        '餐次' => ['早餐', '早餐'],
        '推荐餐次' => ['加餐'],
        '营养' => '高蛋白、低碳水',
    ],
]], ['水煮鸡蛋']);
expectSame(['早餐'], $tags[0]['tags']['餐次'], '标签值应去重');
expectSame(['高蛋白', '低碳水'], $tags[0]['tags']['营养'], '字符串标签应拆分');
expectSame(false, isset($tags[0]['tags']['推荐餐次']), '非标准标签类型应被过滤');

$nutritionRows = [];
foreach (['kcal', 'pro', 'fat', 'carb', 'fiber', 'vit_c', 'mag', 'folic', 'cal', 'iron', 'vit_e'] as $key) {
    $nutritionRows[] = ['name' => $key, 'value' => 1];
}
$nutrition = WorkflowResultNormalizer::nutrition([[
    'name' => '八宝粥',
    'cat' => '五谷',
    'is_common' => 1,
    'is_ingredient' => 2,
    'tags' => ['餐次' => ['早餐']],
    'units' => [['name' => '碗', 'weight' => 250, 'is_default' => 1, 'type' => 'service']],
    'nutrition' => $nutritionRows,
]], ['八宝粥']);
expectSame(1, count($nutrition), '完整营养数据应通过校验');
expectSame(11, count($nutrition[0]['nutrition']), '营养字段必须完整');

echo "workflow result normalizer regression passed\n";
