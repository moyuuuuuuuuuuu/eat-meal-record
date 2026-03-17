<?php

namespace app\common\enum;

enum QueueEventName: string
{
    /**
     * ai识别结果同步
     */
    case RemoteFoodSync = 'remoteFoodSync';

    /**
     * 登陆后操作
     */
    case AfterLogin       = 'afterLogin';
    case FeedViewIncrease = 'feedViewIncrease';
}
