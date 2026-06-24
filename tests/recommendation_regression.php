<?php

require_once dirname(__DIR__) . '/vendor/autoload.php';

use app\service\recommendation\NutritionAnalyzer;
use app\service\recommendation\NutritionContextBuilder;

$failures = [];

function expect_same(string $label, mixed $actual, mixed $expected): void
{
    global $failures;
    if ($actual !== $expected) {
        $failures[] = "{$label}: expected " . var_export($expected, true) . ', got ' . var_export($actual, true);
    }
}

function expect_contains_value(string $label, array $values, string $needle): void
{
    global $failures;
    foreach ($values as $value) {
        if (str_contains($value, $needle)) {
            return;
        }
    }
    $failures[] = "{$label}: expected one value containing {$needle}, got " . json_encode($values, JSON_UNESCAPED_UNICODE);
}

function expect_contains_text(string $label, string $haystack, string $needle): void
{
    global $failures;
    if (!str_contains($haystack, $needle)) {
        $failures[] = "{$label}: expected source to contain {$needle}";
    }
}

$builder = new NutritionContextBuilder();

$todayContext = $builder->build([
    ['meal_date' => '2026-06-24', 'nutrition' => ['kcal' => 500, 'pro' => 20]],
    ['meal_date' => '2026-06-23', 'nutrition' => ['kcal' => 3000, 'pro' => 120]],
], '2026-06-24');
expect_same('today mode ignores older records', $todayContext['mode'], 'today');
expect_same('today mode analysis days', $todayContext['analysis_days'], 1);
expect_same('today kcal only', $todayContext['nutrition']['kcal'], 500.0);
expect_same('today protein only', $todayContext['nutrition']['pro'], 20.0);

$recentContext = $builder->build([
    ['meal_date' => '2026-06-23', 'nutrition' => ['kcal' => 1000, 'pro' => 40]],
    ['meal_date' => '2026-06-22', 'nutrition' => ['kcal' => 800, 'pro' => 20]],
    ['meal_date' => '2026-06-22', 'nutrition' => ['kcal' => 200, 'pro' => 20]],
], '2026-06-24');
expect_same('recent mode when today has no records', $recentContext['mode'], 'recent_average');
expect_same('recent mode averages effective days', $recentContext['analysis_days'], 2);
expect_same('recent kcal average', $recentContext['nutrition']['kcal'], 1000.0);
expect_same('recent protein average', $recentContext['nutrition']['pro'], 40.0);

$fallbackContext = $builder->build([], '2026-06-24');
expect_same('fallback mode without records', $fallbackContext['mode'], 'fallback');
expect_same('fallback nutrition empty', $fallbackContext['nutrition'], []);
expect_same('fallback analysis days', $fallbackContext['analysis_days'], 0);

$foodBusiness = file_get_contents(dirname(__DIR__) . '/app/business/FoodBusiness.php');
expect_contains_text('recommendation record days are queried live', $foodBusiness, '$totalRecordDays = $this->countUserRecordDays($userId);');
expect_contains_text('recommendation record days use distinct meal dates', $foodBusiness, "->distinct()->count('meal_date')");
expect_contains_text('recommendation response uses total record days', $foodBusiness, "'record_days'         => \$totalRecordDays");

$analyzer = new NutritionAnalyzer();
$fatReport = $analyzer->analyze([
    'kcal' => 2000,
    'fat' => 100,
    'carb' => 200,
    'pro' => 60,
    'fiber' => 25,
    'vit_c' => 100,
]);
expect_contains_value('fat energy ratio uses grams * 9', $fatReport->reasons, '脂肪供能占比 45%');

$carbReport = $analyzer->analyze([
    'kcal' => 2000,
    'fat' => 40,
    'carb' => 400,
    'pro' => 80,
    'fiber' => 25,
    'vit_c' => 100,
]);
expect_contains_value('carb energy ratio uses grams * 4', $carbReport->reasons, '碳水供能占比 80%');

if ($failures) {
    fwrite(STDERR, implode(PHP_EOL, $failures) . PHP_EOL);
    exit(1);
}

echo "recommendation regression checks passed" . PHP_EOL;
