<?php

namespace app\common\enum;

enum QueueEventName: string
{
    /**
     * ai识别结果同步
     */
    case FoodSync          = 'FoodSync';
    case FoodNutritionSync = 'foodNutritionSync';

    /**
     * 登陆后操作
     */
    case AfterLogin       = 'afterLogin';
    case FeedViewIncrease = 'feedViewIncrease';

    /**
     * 任务消费
     */
    case TaskConsume = 'taskConsume';
}
