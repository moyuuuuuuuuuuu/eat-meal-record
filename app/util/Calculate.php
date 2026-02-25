<?php

namespace app\util;

class Calculate
{
    /**
     * 加法
     * @param string|float|int $num1
     * @param string|float|int $num2
     * @param int $scale 计算精度
     * @param int $formatScale 格式化保留小数位
     * @return string
     */
    public static function add($num1, $num2, int $scale = 4, int $formatScale = 2): string
    {
        return self::format(bcadd((string)$num1, (string)$num2, $scale), $formatScale);
    }

    /**
     * 减法
     * @param string|float|int $num1
     * @param string|float|int $num2
     * @param int $scale 计算精度
     * @param int $formatScale 格式化保留小数位
     * @return string
     */
    public static function sub($num1, $num2, int $scale = 4, int $formatScale = 2): string
    {
        return self::format(bcsub((string)$num1, (string)$num2, $scale), $formatScale);
    }

    /**
     * 乘法
     * @param string|float|int $num1
     * @param string|float|int $num2
     * @param int $scale 计算精度
     * @param int $formatScale 格式化保留小数位
     * @return string
     */
    public static function mul($num1, $num2, int $scale = 4, int $formatScale = 2): string
    {
        return self::format(bcmul((string)$num1, (string)$num2, $scale), $formatScale);
    }

    /**
     * 除法
     * @param string|float|int $num1
     * @param string|float|int $num2
     * @param int $scale 计算精度
     * @param int $formatScale 格式化保留小数位
     * @return string
     */
    public static function div($num1, $num2, int $scale = 4, int $formatScale = 2): string
    {
        if (bccomp((string)$num2, '0', $scale) === 0) {
            return self::format('0', $formatScale);
        }
        return self::format(bcdiv((string)$num1, (string)$num2, $scale), $formatScale);
    }

    /**
     * 取模
     * @param string|float|int $num1
     * @param string|float|int $num2
     * @param int $scale 计算精度
     * @param int $formatScale 格式化保留小数位
     * @return string
     */
    public static function mod($num1, $num2, int $scale = 4, int $formatScale = 2): string
    {
        if (bccomp((string)$num2, '0', $scale) === 0) {
            return self::format('0', $formatScale);
        }
        return self::format(bcmod((string)$num1, (string)$num2, $scale), $formatScale);
    }

    /**
     * 比较
     * @param string|float|int $num1
     * @param string|float|int $num2
     * @param int $scale 精度
     * @return int 0:相等, 1:num1>num2, -1:num1<num2
     */
    public static function comp($num1, $num2, int $scale = 4): int
    {
        return bccomp((string)$num1, (string)$num2, $scale);
    }

    /**
     * 格式化数字（四舍五入）
     * @param string|float|int $number
     * @param int $scale
     * @return string
     */
    public static function format($number, int $scale = 2): string
    {
        return sprintf("%." . $scale . "f", $number);
    }

    /**
     * 批量乘以比例并格式化
     * @param array $items
     * @param string|float|int $ratio
     * @param int $formatScale
     * @return array
     */
    public static function mapMul(array $items, $ratio, int $formatScale = 2): array
    {
        return array_map(function ($value) use ($ratio, $formatScale) {
            return is_numeric($value) ? self::mul($value, $ratio, 4, $formatScale) : $value;
        }, $items);
    }
}
