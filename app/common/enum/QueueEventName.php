<?php
namespace  app\common\enum;

enum QueueEventName: string
{
    /**
     * ai识别结果同步
     */
    case REMOTE_FOOD_SYNC = 'remoteFoodSync';

    /**
     * 文件上传同步
     */
    case UPLOAD_SYNC = 'uploadSync';

    /**
     * 登陆后操作
     */
    case AFTER_LOGIN        = 'afterLogin';
    case FEED_VIEW_INCREASE = 'feedViewIncrease';
}
