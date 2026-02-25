<?php

namespace app\process;

use Workerman\Crontab\Crontab;

class MealTargetDetection
{
    public function onWorkerStart($worker)
    {
        new Crontab('00 00 * * *', function () {
            $this->done();
        });
    }

    public function done()
    {

    }
}
