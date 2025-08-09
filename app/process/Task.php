<?php

namespace app\process;

use app\model\UserModel;
use Workerman\Crontab\Crontab;

class Task
{
    public function onWorkStart()
    {
        // 每天的7点50执行，注意这里省略了秒位
        new Crontab('00 00 * * *', function () {
            //查询用户就餐记录并计算是否超过用户设置的目标及是否未完成目标的一半
            UserModel::calcUserTarget();
        });
    }
}
