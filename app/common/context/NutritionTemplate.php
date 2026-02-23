<?php

namespace app\common\context;

use app\common\exception\DataNotFoundException;
use app\common\exception\ParamException;
use app\model\FoodUnitModel;
use plugin\admin\app\model\Dict;
use plugin\admin\app\model\Food;
use support\Cache;

class NutritionTemplate
{
    const KEY_NAME = 'nutrition';
    static $instance;

    private function __construct()
    {

    }

    static function instance()
    {
        if (!self::$instance instanceof self) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function template(): array
    {
        if (!Cache::has(self::KEY_NAME)) {
            $nutritionTemplate = Dict::get(self::KEY_NAME);
            foreach ($nutritionTemplate as $k => $v) {
                unset($nutritionTemplate[$k]);
                $nutritionTemplate[$v['value']] = 0.00;
            }
            Cache::set(self::KEY_NAME, $nutritionTemplate);
        } else {
            $nutritionTemplate = Cache::get(self::KEY_NAME);
        }
        return $nutritionTemplate;
    }

    public function format(array $nutrition, bool $formatJson = false)
    {
        $nutrition = array_merge($this->template(), $nutrition);
        if (!$formatJson) {
            return $nutrition;
        }
        return json_encode($nutrition, JSON_UNESCAPED_UNICODE);
    }

    public function calcute(int $foodId, int $unitId, $number)
    {
        if (bccomp((string)$number, '0', 4) <= 0) {
            throw new ParamException('数量必须大于0');
        }

        $foodUnitInfo = FoodUnitModel::query()
            ->where('food_id', $foodId)
            ->where('unit_id', $unitId)
            ->first();

        if (!$foodUnitInfo) {
            throw new DataNotFoundException('不存在该单位的食品');
        }

        $foodNutrition = Food::query()
            ->where('id', $foodId)
            ->value('nutrition');

        if (!$foodNutrition) {
            throw new DataNotFoundException('食品营养数据不存在');
        }

        $nutritionTemplate = $this->format($foodNutrition);

        // 高精度计算
        $totalWeight = bcmul((string)$foodUnitInfo->weight, (string)$number, 4);
        $ratio       = bcdiv($totalWeight, '100', 4);

        foreach ($nutritionTemplate as $key => $value) {
            $nutritionTemplate[$key] = bcmul((string)$value, $ratio, 2);
        }

        return $nutritionTemplate;
    }
}
