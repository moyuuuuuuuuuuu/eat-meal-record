<?php

namespace app\common\context;

use app\common\exception\DataNotFoundException;
use app\common\exception\ParamException;
use app\model\FoodNutrient;
use app\model\FoodUnitModel;
use app\util\Calculate;
use plugin\admin\app\model\Dict;
use plugin\admin\app\model\Food;
use support\Cache;
use support\Log;

class NutritionTemplate
{
    const KEY_NAME = 'nutrition';
    static $instance;
    protected $showKey = [];
    private function __construct()
    {
        $this->showKey = explode(',',getenv('NUTRITION_TEMPLATE_SHOW_KEY'));
    }

    static function instance()
    {
        if (!self::$instance instanceof self) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * @param bool $witChinesehKey 是否携带中文键名
     *  为true时返回[{name:"碳水"，value:"carbs}]
     *  false时返回{carbs:0.00}}
     * @return array
     */
    public function template(bool $witChinesehKey = false): array
    {
        $cacheKey = self::KEY_NAME . (int)$witChinesehKey;
        if (!$nutritionTemplate = Cache::get($cacheKey)) {
            $nutritionTemplate = Dict::get(self::KEY_NAME);
            if (!$witChinesehKey) {
                foreach ($nutritionTemplate as $k => $v) {
                    unset($nutritionTemplate[$k]);
                    $nutritionTemplate[$v['value']] = 0.00;
                }
            }
            Cache::set($cacheKey, $nutritionTemplate);
        }
        return $nutritionTemplate;
    }


    public function fill(array $nutrition, bool $formatJson = false)
    {
        $nutrition = array_merge($this->template(), $nutrition);
        if (!$formatJson) {
            return $nutrition;
        }
        return json_encode($nutrition, JSON_UNESCAPED_UNICODE);
    }

    public function calculate(int $foodId, int $unitId, $number)
    {
        if (Calculate::comp($number, '0', 4) <= 0) {
            throw new ParamException('数量必须大于0');
        }

        $foodUnitInfo = FoodUnitModel::query()
            ->where('food_id', $foodId)
            ->where('unit_id', $unitId)
            ->first();

        if (!$foodUnitInfo) {
            throw new DataNotFoundException('不存在该单位的食品');
        }

        $foodNutrition = FoodNutrient::query()
            ->select(explode(',',getenv('NUTRITION_TEMPLATE_SHOW_KEY')))
            ->where('food_id', $foodId)

            ->first();

        if (!$foodNutrition) {
            throw new DataNotFoundException('食品营养数据不存在');
        }

        $nutritionTemplate = $this->fill($foodNutrition->toArray());

        // 使用通用工具类进行高精度计算
        $totalWeight = Calculate::mul($foodUnitInfo->weight, $number, 4);
        $ratio       = Calculate::div($totalWeight, '100', 4);

        return Calculate::mapMul($nutritionTemplate, $ratio, 2);
    }

    public function format(array $nutrition): array
    {
        $template = $this->template(true);
        foreach ($template as $key=> &$value) {
            $field            = $value['value'];
            if(!in_array($field, $this->showKey)){
                unset($template[$key]);
                continue;
            }
            $value['value'] = $nutrition[$field] ?? 0.00;
            $value['key']   = $field;
        }
        unset($value);
        return $template;
    }
}
