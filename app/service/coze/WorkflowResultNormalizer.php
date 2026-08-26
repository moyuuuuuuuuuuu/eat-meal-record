<?php

namespace app\service\coze;

use app\common\exception\DataNotFoundException;

final class WorkflowResultNormalizer
{
    private const MAX_BATCH_SIZE = 35;

    private const NUTRIENT_KEYS = [
        'kcal', 'pro', 'fat', 'carb', 'fiber', 'vit_c',
        'mag', 'folic', 'cal', 'iron', 'vit_e',
    ];

    private const UNIT_TYPES = [
        'weight', 'count', 'volume', 'package', 'service', 'length',
    ];

    private const TAG_TYPES = [
        '餐次', '口味', '营养', '烹饪方式', '适用人群', '食材状态',
        '过敏原', '品牌产地', '时令季节', '特殊场景', '存储方式',
    ];

    /**
     * @param string[] $names
     * @return string[]
     */
    public static function normalizeNames(array $names): array
    {
        $result = [];
        foreach ($names as $name) {
            if (!is_scalar($name)) {
                continue;
            }
            $name = trim((string)$name);
            if ($name !== '') {
                $result[$name] = $name;
            }
        }

        $result = array_values($result);
        if (!$result) {
            throw new DataNotFoundException('食物名称不能为空');
        }
        if (count($result) > self::MAX_BATCH_SIZE) {
            throw new DataNotFoundException('单次食物数量不得超过' . self::MAX_BATCH_SIZE . '个');
        }
        return $result;
    }

    /**
     * @param array<string,mixed> $response
     * @param string[] $outputKeys
     */
    public static function decode(mixed $response, array $outputKeys): array
    {
        if (!is_array($response)) {
            throw new DataNotFoundException('工作流未返回有效响应');
        }
        $raw = null;
        foreach ($outputKeys as $key) {
            if (array_key_exists($key, $response)) {
                $raw = $response[$key];
                break;
            }
        }
        if (is_string($raw)) {
            $raw = trim($raw);
            $raw = preg_replace('/^```(?:json)?\s*|\s*```$/iu', '', $raw) ?? $raw;
            try {
                $raw = json_decode($raw, true, 512, JSON_THROW_ON_ERROR);
            } catch (\JsonException) {
                throw new DataNotFoundException('工作流返回的JSON格式非法');
            }
        }
        if (!is_array($raw)) {
            throw new DataNotFoundException('工作流未返回有效数组');
        }
        foreach (['data', 'foods'] as $wrapper) {
            if (isset($raw[$wrapper]) && is_array($raw[$wrapper])) {
                $raw = $raw[$wrapper];
                break;
            }
        }
        if (!array_is_list($raw)) {
            throw new DataNotFoundException('工作流返回的数据结构非法');
        }
        return $raw;
    }

    /**
     * @param string[] $requestedNames
     */
    public static function nutrition(array $items, array $requestedNames): array
    {
        $allowedNames = array_fill_keys($requestedNames, true);
        $result = [];
        foreach ($items as $item) {
            if (!is_array($item)) {
                continue;
            }
            $name = trim((string)($item['name'] ?? ''));
            if (!isset($allowedNames[$name]) || isset($result[$name])) {
                continue;
            }

            $nutrientMap = [];
            foreach (($item['nutrition'] ?? []) as $nutrient) {
                if (!is_array($nutrient)) {
                    continue;
                }
                $key = (string)($nutrient['name'] ?? '');
                $value = $nutrient['value'] ?? null;
                if (in_array($key, self::NUTRIENT_KEYS, true) && is_numeric($value) && (float)$value >= 0) {
                    $nutrientMap[$key] = round((float)$value, 2);
                }
            }
            if (array_diff(self::NUTRIENT_KEYS, array_keys($nutrientMap))) {
                continue;
            }

            $units = self::unitsForItem($item['units'] ?? $item['unit'] ?? []);
            $tags = self::tagsForItem($item['tags'] ?? []);
            if (!$units || !$tags) {
                continue;
            }

            $result[$name] = [
                'name' => $name,
                'cat' => self::text($item['cat'] ?? '其他', '其他'),
                'is_common' => in_array($item['is_common'] ?? null, [1, '1', true], true) ? 1 : 2,
                'is_ingredient' => in_array($item['is_ingredient'] ?? null, [1, '1', true], true) ? 1 : 2,
                'tags' => $tags,
                'units' => $units,
                'nutrition' => array_map(
                    fn(string $key) => ['name' => $key, 'value' => $nutrientMap[$key]],
                    self::NUTRIENT_KEYS
                ),
            ];
        }
        return array_values($result);
    }

    /**
     * @param string[] $requestedNames
     */
    public static function units(array $items, array $requestedNames): array
    {
        $allowedNames = array_fill_keys($requestedNames, true);
        $result = [];
        foreach ($items as $item) {
            if (!is_array($item)) {
                continue;
            }
            $food = trim((string)($item['food'] ?? ''));
            if (!isset($allowedNames[$food]) || isset($result[$food])) {
                continue;
            }
            $units = self::unitsForItem($item['unit'] ?? $item['units'] ?? []);
            if ($units) {
                $result[$food] = ['food' => $food, 'unit' => $units];
            }
        }
        return array_values($result);
    }

    /**
     * @param string[] $requestedNames
     */
    public static function tags(array $items, array $requestedNames): array
    {
        $allowedNames = array_fill_keys($requestedNames, true);
        $result = [];
        foreach ($items as $item) {
            if (!is_array($item)) {
                continue;
            }
            $food = trim((string)($item['food'] ?? ''));
            if (!isset($allowedNames[$food]) || isset($result[$food])) {
                continue;
            }
            $tags = self::tagsForItem($item['tags'] ?? []);
            if (!$tags) {
                continue;
            }
            $result[$food] = [
                'food' => $food,
                'tags' => $tags,
                'cate' => self::text($item['cate'] ?? '其他', '其他'),
                'isCommon' => in_array($item['isCommon'] ?? null, [1, '1', true, 'true'], true),
            ];
        }
        return array_values($result);
    }

    private static function unitsForItem(mixed $rawUnits): array
    {
        if (!is_array($rawUnits)) {
            return [];
        }
        $units = [];
        foreach ($rawUnits as $unit) {
            if (!is_array($unit)) {
                continue;
            }
            $name = trim((string)($unit['name'] ?? ''));
            $type = (string)($unit['type'] ?? '');
            $weight = $unit['weight'] ?? null;
            if ($name === '' || !in_array($type, self::UNIT_TYPES, true) || !is_numeric($weight) || (float)$weight <= 0) {
                continue;
            }
            $key = $name . "\0" . $type;
            $units[$key] = [
                'name' => $name,
                'type' => $type,
                'weight' => round((float)$weight, 2),
                'is_default' => in_array($unit['is_default'] ?? null, [1, '1', true], true) ? 1 : 0,
            ];
        }
        $units = array_values($units);
        if (!$units) {
            return [];
        }
        $defaultIndex = 0;
        foreach ($units as $index => $unit) {
            if ($unit['is_default'] === 1) {
                $defaultIndex = $index;
                break;
            }
        }
        foreach ($units as $index => &$unit) {
            $unit['is_default'] = $index === $defaultIndex ? 1 : 0;
        }
        unset($unit);
        return $units;
    }

    private static function tagsForItem(mixed $rawTags): array
    {
        if (!is_array($rawTags)) {
            return [];
        }
        $tags = [];
        foreach ($rawTags as $type => $names) {
            $type = trim((string)$type);
            if (!in_array($type, self::TAG_TYPES, true)) {
                continue;
            }
            if (!is_array($names)) {
                $names = preg_split('/[、,，\/|]+/u', (string)$names) ?: [];
            }
            $names = array_values(array_unique(array_filter(
                array_map(fn($name) => trim((string)$name), $names),
                fn(string $name) => $name !== ''
            )));
            if ($names) {
                $tags[$type] = $names;
            }
        }
        return $tags;
    }

    private static function text(mixed $value, string $default): string
    {
        $value = trim((string)$value);
        return $value !== '' ? mb_substr($value, 0, 255) : $default;
    }
}
