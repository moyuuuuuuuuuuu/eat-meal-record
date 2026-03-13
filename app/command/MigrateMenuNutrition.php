<?php

namespace app\command;

use support\Db;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class MigrateMenuNutrition extends Command
{
    protected static $defaultName = 'migrate:menu-nutrition-full';

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln("开始完整迁移（含分类）");

        $pageSize = 500;
        $page     = 0;

        try {
            while (true) {
                $offset = $page * $pageSize;

                // 原始 SQL 保持不变，但在末尾动态注入分页
                $sql  = $this->getMigrationSql() . " LIMIT {$pageSize} OFFSET {$offset}";
                $list = Db::select($sql);

                // 必须检查是否还有数据，否则会死循环
                if (empty($list)) {
                    break;
                }

                Db::beginTransaction();
                try {
                    $now = date('Y-m-d H:i:s');
                    foreach ($list as $item) {
                        // 1. 插入 foods 主表
                        $foodId = Db::table('foods')->insertGetId([
                            'name'          => $item->dish_name,
                            'is_ingredient' => 2,
                            'cat_id'        => 0,
                            'user_id'       => null,
                            'status'        => 1,
                            'created_at'    => $now,
                            'updated_at'    => $now,
                        ]);

                        // 2. 插入 food_nutrients 详情表 (映射 calc_ 别名)
                        Db::table('food_nutrients')->insert([
                            'food_id'    => $foodId,

                            // 1. 基础宏量营养素 (映射 calc_ 别名)
                            'water'      => $item->calc_water ?? 0,
                            'kcal'       => $item->calc_calories_kcal ?? 0,
                            'pro'        => $item->calc_protein_g ?? 0,
                            'fat'        => $item->calc_fat_g ?? 0,
                            'carb'       => $item->calc_carbs_g ?? 0,
                            'sugar'      => $item->calc_sugar ?? 0, // 如果SQL没算则默认为0
                            'fiber'      => $item->calc_fiber_g ?? 0,

                            // 2. 脂类与特殊指标
                            'chol'       => $item->calc_cholesterol_mg ?? 0,
                            'purine'     => $item->calc_purine_mg ?? 0,

                            // 3. 维生素类 (vit_ 缩写)
                            'vit_a'      => $item->calc_vitamin_a_ug ?? 0,
                            'vit_c'      => $item->calc_vitamin_c_mg ?? 0,
                            'vit_d'      => $item->calc_vitamin_d_ug ?? 0,
                            'vit_e'      => $item->calc_vitamin_e_mg ?? 0,
                            'folic'      => $item->calc_folic_mg ?? 0,

                            // 4. 矿物质类 (na, cal, mag 等简写)
                            'na'         => $item->calc_sodium_mg ?? 0,
                            'cal'        => $item->calc_calcium_mg ?? 0,
                            'iron'       => $item->calc_iron_mg ?? 0,
                            'kal'        => $item->calc_kalium_mg ?? 0,
                            'mag'        => $item->calc_magnesium_mg ?? 0,
                            'zinc'       => $item->calc_zinc_mg ?? 0,
                            'sel'        => $item->calc_selenium_ug ?? 0,
                            'cup'        => $item->calc_cuprum_mg ?? 0,
                            'mang'       => $item->calc_manganese_mg ?? 0,
                            'iod'        => $item->calc_iodine_ug ?? 0,

                            // 5. 脂肪酸类 (fa, sfa, mufa, pufa)
                            'fa'         => $item->calc_fatty_acid ?? 0,
                            'sfa'        => $item->calc_saturated_fatty_acid ?? 0,
                            'mufa'       => $item->calc_monounsaturated_fatty_acid ?? 0,
                            'pufa'       => $item->calc_polyunsaturated_fatty_acid ?? 0,

                            // 6. 其他
                            'origin'     => $item->origin_place ?? '',
                        ]);
                    }
                    Db::commit();
                    $output->writeln("已处理第 " . ($page + 1) . " 页数据");
                    $page++;
                } catch (\Throwable $e) {
                    Db::rollBack();
                    throw $e; // 抛出异常让外层 catch 捕获
                }
            }
            $output->writeln("迁移完成 ✔");

        } catch (\Throwable $e) {
            $output->writeln("迁移失败 ❌");
            $output->writeln($e->getMessage());
            return self::FAILURE;
        }

        return self::SUCCESS;
    }

    /**
     * 将你的长 SQL 抽离，保持逻辑整洁
     */
    private function getMigrationSql(): string
    {
        return <<<SQL
SELECT
    d.id                                            AS dish_id,
    d.dishes_name                                   AS dish_name,
    d.weight                                        AS dish_weight_per_serving,

    ROUND(SUM(n.calories      * md.weight / 100), 2)  AS calc_calories_kcal,
    ROUND(SUM(n.protein       * md.weight / 100), 2)  AS calc_protein_g,
    ROUND(SUM(n.fat           * md.weight / 100), 2)  AS calc_fat_g,
    ROUND(SUM(n.carbohydrate  * md.weight / 100), 2)  AS calc_carbs_g,
    ROUND(SUM(n.dietary_fiber * md.weight / 100), 2)  AS calc_fiber_g,
    ROUND(SUM(n.cholesterol   * md.weight / 100), 2)  AS calc_cholesterol_mg,

    ROUND(SUM(n.calcium       * md.weight / 100), 2)  AS calc_calcium_mg,
    ROUND(SUM(n.sodium        * md.weight / 100), 2)  AS calc_sodium_mg,
    ROUND(SUM(n.kalium        * md.weight / 100), 2)  AS calc_kalium_mg,
    ROUND(SUM(n.iron          * md.weight / 100), 2)  AS calc_iron_mg,
    ROUND(SUM(n.zinc          * md.weight / 100), 2)  AS calc_zinc_mg,
    ROUND(SUM(n.magnesium     * md.weight / 100), 2)  AS calc_magnesium_mg,
    ROUND(SUM(n.phosphorus    * md.weight / 100), 2)  AS calc_phosphorus_mg,
    ROUND(SUM(n.selenium      * md.weight / 100), 2)  AS calc_selenium_ug,
    ROUND(SUM(n.iodine        * md.weight / 100), 2)  AS calc_iodine_ug,

    ROUND(SUM(n.vitamin_a     * md.weight / 100), 2)  AS calc_vitamin_a_ug,
    ROUND(SUM(n.vitamin_c     * md.weight / 100), 2)  AS calc_vitamin_c_mg,
    ROUND(SUM(n.vitamin_d     * md.weight / 100), 2)  AS calc_vitamin_d_ug,
    ROUND(SUM(n.vitamin_e     * md.weight / 100), 2)  AS calc_vitamin_e_mg,
    ROUND(SUM(n.folic         * md.weight / 100), 2)  AS calc_folic_mg,

    ROUND(SUM(n.purine        * md.weight / 100), 2)  AS calc_purine_mg,
    ROUND(
            SUM(n.glycemic_index * md.weight) /
            NULLIF(SUM(CASE WHEN n.glycemic_index > 0 THEN md.weight ELSE 0 END), 0)
        , 2)                                               AS calc_gi_weighted

FROM menu_dishes d
INNER JOIN menu_material_dishes md ON md.dishes_id = d.dishes_id AND md.del_flag = 2
INNER JOIN menu_material m ON m.material_id = md.material_id AND m.del_flag = 2
INNER JOIN menu_nutrition n ON n.nutrition_id = m.nutrition_id AND n.del_flag = 2
WHERE d.del_flag = 2 AND d.hide_flag = 2
GROUP BY d.id, d.dishes_id, d.dishes_name, d.weight
ORDER BY d.id ASC
SQL;
    }
}
