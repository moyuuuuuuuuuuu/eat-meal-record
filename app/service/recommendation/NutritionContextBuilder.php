<?php

namespace app\service\recommendation;

use DateTimeInterface;

class NutritionContextBuilder
{
    public const MODE_TODAY = 'today';
    public const MODE_RECENT_AVERAGE = 'recent_average';
    public const MODE_FALLBACK = 'fallback';

    /**
     * @param array $records [['meal_date' => 'Y-m-d', 'nutrition' => [...]], ...]
     */
    public function build(array $records, ?string $today = null): array
    {
        $today ??= date('Y-m-d');
        $normalizedRecords = $this->normalizeRecords($records);
        $todayRecords = array_filter(
            $normalizedRecords,
            static fn (array $record): bool => $record['meal_date'] === $today
        );

        if ($todayRecords) {
            return [
                'mode' => self::MODE_TODAY,
                'nutrition' => $this->sumNutrition($todayRecords),
                'analysis_days' => 1,
            ];
        }

        if (!$normalizedRecords) {
            return [
                'mode' => self::MODE_FALLBACK,
                'nutrition' => [],
                'analysis_days' => 0,
            ];
        }

        $dailyNutrition = [];
        foreach ($normalizedRecords as $record) {
            $date = $record['meal_date'];
            $dailyNutrition[$date] ??= [];
            $dailyNutrition[$date] = $this->sumNutrition([
                ['nutrition' => $dailyNutrition[$date]],
                $record,
            ]);
        }

        $recordDays = count($dailyNutrition);
        return [
            'mode' => self::MODE_RECENT_AVERAGE,
            'nutrition' => $this->averageNutrition(array_values($dailyNutrition), $recordDays),
            'analysis_days' => $recordDays,
        ];
    }

    private function normalizeRecords(array $records): array
    {
        $normalized = [];

        foreach ($records as $record) {
            $date = $this->readValue($record, 'meal_date');
            $nutrition = $this->readValue($record, 'nutrition');

            if (!$date || !is_array($nutrition)) {
                continue;
            }

            $date = $this->normalizeDate($date);
            if (!$date) {
                continue;
            }

            $normalized[] = [
                'meal_date' => $date,
                'nutrition' => $nutrition,
            ];
        }

        return $normalized;
    }

    private function readValue(mixed $record, string $key): mixed
    {
        if (is_array($record)) {
            return $record[$key] ?? null;
        }

        if (is_object($record)) {
            return $record->{$key} ?? null;
        }

        return null;
    }

    private function normalizeDate(mixed $date): ?string
    {
        if ($date instanceof DateTimeInterface) {
            return $date->format('Y-m-d');
        }

        if (is_string($date) && $date !== '') {
            return substr($date, 0, 10);
        }

        return null;
    }

    private function sumNutrition(array $records): array
    {
        $sum = [];

        foreach ($records as $record) {
            $nutrition = $record['nutrition'] ?? [];
            foreach ($nutrition as $key => $value) {
                if (!is_numeric($value)) {
                    continue;
                }
                $sum[$key] = ($sum[$key] ?? 0.0) + (float)$value;
            }
        }

        return $sum;
    }

    private function averageNutrition(array $dailyNutrition, int $days): array
    {
        if ($days <= 0) {
            return [];
        }

        $sum = $this->sumNutrition(array_map(
            static fn (array $nutrition): array => ['nutrition' => $nutrition],
            $dailyNutrition
        ));

        foreach ($sum as $key => $value) {
            $sum[$key] = round($value / $days, 4);
        }

        return $sum;
    }
}
