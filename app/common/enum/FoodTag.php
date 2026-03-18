<?php

namespace app\common\enum;

enum FoodTag: int
{
    case MEAL_TIME    = 1;  // 餐次
    case TASTE        = 2;  // 口味
    case NUTRITION    = 3;  // 营养 / 营养特点
    case COOKING      = 4;  // 烹饪方式
    case TARGET_USER  = 5;  // 适用人群
    case STATUS       = 6;  // 食材状态
    case ALLERGEN     = 7;  // 过敏原
    case BRAND_ORIGIN = 8;  // 品牌产地
    case SEASON       = 9;  // 时令季节
    case SCENE        = 10; // 特殊场景
    case STORAGE      = 11; // 存储方式

    /**
     * 数字 -> 文字 (获取中文描述)
     */
    public function label(): string
    {
        return match ($this) {
            self::MEAL_TIME => '餐次',
            self::TASTE => '口味',
            self::NUTRITION => '营养', // 这里定义主名称
            self::COOKING => '烹饪方式',
            self::TARGET_USER => '适用人群',
            self::STATUS => '食材状态',
            self::ALLERGEN => '过敏原',
            self::BRAND_ORIGIN => '品牌产地',
            self::SEASON => '时令季节',
            self::SCENE => '特殊场景',
            self::STORAGE => '存储方式',
        };
    }

    public static function fromLabel(string $label): ?int
    {
        return match ($label) {
            '餐次' => self::MEAL_TIME->value,
            '口味' => self::TASTE->value,
            '营养', '营养特点' => self::NUTRITION->value, // 多个文字对应一个数字
            '烹饪方式' => self::COOKING->value,
            '适用人群' => self::TARGET_USER->value,
            '食材状态' => self::STATUS->value,
            '过敏原' => self::ALLERGEN->value,
            '品牌产地' => self::BRAND_ORIGIN->value,
            '时令季节' => self::SEASON->value,
            '特殊场景' => self::SCENE->value,
            '存储方式' => self::STORAGE->value,
            default => null,
        };
    }

    /**
     * 数字 -> 文字
     */
    public static function getLabelByValue(int $value): string|null
    {
        $case = self::tryFrom($value);
        return $case ? $case->label() : null;
    }
}
