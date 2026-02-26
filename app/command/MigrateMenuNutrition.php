<?php

namespace app\command;

use support\Db;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class MigrateMenuNutrition extends Command
{
    protected static $defaultName = 'migrate:menu-nutrition-full';

    protected function execute(InputInterface $input, OutputInterface $output):int
    {
        $output->writeln("开始完整迁移（含分类）");

        Db::beginTransaction();

        try {

            /*
             |--------------------------------------------------------------------------
             | 1. 生成一级分类 big_type
             |--------------------------------------------------------------------------
             */
            $bigTypes = Db::table('menu_nutrition')
                ->distinct()
                ->pluck('big_type')
                ->toArray();

            foreach ($bigTypes as $big) {
                Db::table('cats')->updateOrInsert(
                    ['name' => $big],
                    ['pid' => 0]
                );
            }

            /*
             |--------------------------------------------------------------------------
             | 2. 生成二级分类 little_type
             |--------------------------------------------------------------------------
             */
            $rows = Db::table('menu_nutrition')
                ->select('big_type', 'little_type')
                ->distinct()
                ->get();

            foreach ($rows as $row) {

                $parentId = Db::table('cats')
                    ->where('name', $row->big_type)
                    ->value('id');

                Db::table('cats')->updateOrInsert(
                    ['name' => $row->little_type],
                    ['pid' => $parentId]
                );
            }

            /*
             |--------------------------------------------------------------------------
             | 3. 建立 little_type → id 映射
             |--------------------------------------------------------------------------
             */
            $catMap = Db::table('cats')
                ->pluck('id', 'name')
                ->toArray();

            /*
             |--------------------------------------------------------------------------
             | 4. 迁移 foods + food_nutrients
             |--------------------------------------------------------------------------
             */
            $pageSize = 500;
            $page = 1;

            while (true) {

                $list = Db::table('menu_nutrition')
                    ->where('del_flag', 2)
                    ->forPage($page, $pageSize)
                    ->get();

                if ($list->isEmpty()) {
                    break;
                }

                foreach ($list as $item) {

                    $catId = $catMap[$item->little_type] ?? null;

                    $foodId = Db::table('foods')->insertGetId([
                        'name'       => $item->nutrition_name,
                        'cat_id'     => $catId,
                        'user_id'    => null,
                        'status'     => 1,
                        'created_at' => $item->crtime,
                        'updated_at' => $item->uptime,
                    ]);

                    Db::table('food_nutrients')->insert([
                        'food_id'                    => $foodId,
                        'water'                      => $item->water,
                        'kcal'                       => $item->calories,
                        'protein'                    => $item->protein,
                        'fat'                        => $item->fat,
                        'carbohydrate'               => $item->carbohydrate,
                        'fiber'                      => $item->dietary_fiber,
                        'sodium'                     => $item->sodium,
                        'cholesterol'                => $item->cholesterol,
                        'vitamin_a'                  => $item->vitamin_a,
                        'calcium'                    => $item->calcium,
                        'iron'                       => $item->iron,
                        'kalium'                     => $item->kalium,
                        'magnesium'                  => $item->magnesium,
                        'zinc'                       => $item->zinc,
                        'selenium'                   => $item->selenium,
                        'cuprum'                     => $item->cuprum,
                        'manganese'                  => $item->manganese,
                        'iodine'                     => $item->iodine,
                        'folic'                      => $item->folic,
                        'fatty_acid'                 => $item->fatty_acid,
                        'saturated_fatty_acid'       => $item->saturated_fatty_acid,
                        'monounsaturated_fatty_acid' => $item->monounsaturated_fatty_acid,
                        'polyunsaturated_fatty_acid' => $item->polyunsaturated_fatty_acid,
                        'origin_place'               => $item->origin_place,
                    ]);
                }

                $output->writeln("已处理第 {$page} 页");
                $page++;
            }

            Db::commit();
            $output->writeln("迁移完成 ✔");

        } catch (\Throwable $e) {

            Db::rollBack();
            $output->writeln("迁移失败 ❌");
            $output->writeln($e->getMessage());

            return self::FAILURE;
        }

        return self::SUCCESS;
    }
}
