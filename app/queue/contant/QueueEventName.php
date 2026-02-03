<?php

namespace app\queue\contant;

enum QueueEventName:string
{
    /**
     * ai识别结果同步
     */
    case REMOTE_FOOD_SYNC = 'remote_food_sync';
}
