<?php

namespace app\util;

class Energy
{
    /**
     * 计算 BMR (Mifflin-St Jeor 公式)
     */
    public static function bmr(mixed $gender, $weight, $height, int $age): string
    {
        $p1 = Calculate::mul('10', $weight);
        $p2 = Calculate::mul('6.25', $height);
        $p3 = Calculate::mul('5', $age);

        $base = Calculate::sub(Calculate::add($p1, $p2), $p3);

        // 1=男, 2=女
        if ($gender == 1 || $gender === 'male') {
            return Calculate::add($base, '5');
        }

        return Calculate::sub($base, '161');
    }

    /**
     * 计算 BMI
     */
    public static function bmi($weight, $height): string
    {
        $heightM = Calculate::div($height, '100', 4);
        $heightSq = Calculate::mul($heightM, $heightM, 4);
        return Calculate::div($weight, $heightSq, 4, 2);
    }

    /**
     * 计算跑步/步行步数消耗
     */
    public static function runningBurn(mixed $gender, $weight, $height, int $steps): string
    {
        if ($steps <= 0) {
            return '0.00';
        }

        $strideRate = ($gender == 1 || $gender === 'male') ? '0.415' : '0.413';
        $stride = Calculate::mul($height, $strideRate, 4);
        $distance = Calculate::div(Calculate::mul($steps, $stride, 4), '100000', 8);

        return Calculate::mul(Calculate::mul($weight, $distance, 4), '1.036', 4, 2);
    }

    /**
     * 获取每日能量概览
     */
    public static function dailyStats(array $data): array
    {
        $gender = $data['gender'] ?? 1;
        $weight = $data['weight'] ?? 0;
        $height = $data['height'] ?? 0;
        $age    = $data['age'] ?? 0;
        $steps  = $data['steps'] ?? 0;
        $intake = $data['intake'] ?? 0;
        $target = $data['target'] ?? Calculate::mul($weight, '7');

        $bmr = self::bmr($gender, $weight, $height, $age);
        $runningBurn = self::runningBurn($gender, $weight, $height, $steps);
        $neat = Calculate::mul($bmr, '0.1');
        $totalBurn = Calculate::add(Calculate::add($bmr, $runningBurn), $neat);
        
        $deficit = Calculate::sub($totalBurn, $intake);
        $completionRate = Calculate::comp($target, '0') > 0
            ? Calculate::div($deficit, $target, 4, 2)
            : '0.00';

        return [
            'bmr'             => $bmr,
            'runningBurn'     => $runningBurn,
            'neat'            => $neat,
            'totalBurn'       => $totalBurn,
            'intake'          => Calculate::format($intake),
            'deficit'         => $deficit,
            'target'          => Calculate::format($target),
            'completionRate'  => $completionRate,
            'bmi'             => self::bmi($weight, $height),
            'status'          => self::resolveStatus((float)$completionRate)
        ];
    }

    private static function resolveStatus(float $rate): string
    {
        if ($rate >= 1) return '极佳';
        if ($rate >= 0.8) return '优秀';
        if ($rate >= 0.5) return '良好';
        if ($rate > 0) return '进行中';
        return '需努力';
    }
}
