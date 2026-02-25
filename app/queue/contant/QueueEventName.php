<?php

namespace app\queue\contant;

enum QueueEventName: string
{
    /**
     * ai识别结果同步
     */
    case REMOTE_FOOD_SYNC = 'remote_food_sync';

    /**
     * 文件上传同步
     */
    case UPLOAD_SYNC = 'upload_sync';

    /**
     * 登陆后操作
     */
    case AFTER_LOGIN = 'after_login';
}
