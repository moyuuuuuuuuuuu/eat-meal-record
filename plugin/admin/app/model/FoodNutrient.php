<?php

namespace plugin\admin\app\model;

class FoodNutrient extends Base
{

    /**
     * 该模型可被批量赋值的属性
     *
     * @var array
     */
    protected $fillable = [
        'food_id',

        // 基础宏量
        'water',
        'kcal',
        'pro',
        'fat',
        'carb',
        'sugar',
        'fiber',

        // 脂类与特殊指标
        'chol',
        'purine',

        // 维生素类
        'vit_a',
        'vit_c',
        'vit_d',
        'vit_e',
        'folic',

        // 矿物质类
        'na',
        'cal',
        'iron',
        'kal',
        'mag',
        'zinc',
        'sel',
        'cup',
        'mang',
        'iod',

        // 脂肪酸类
        'fa',
        'sfa',
        'mufa',
        'pufa',

        // 备注/原产地
        'origin'
    ];
}
