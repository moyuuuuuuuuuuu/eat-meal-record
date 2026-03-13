<?php

namespace app\common\enum;

enum QueueEventName: string
{
    /**
     * ai识别结果同步
     */
    case RemoteFoodSync = 'remoteFoodSync';

    /**
     * 文件上传同步
     */
    case UploadSync = 'uploadSync';

    /**
     * 登陆后操作
     */
    case AfterLogin       = 'afterLogin';
    case FeedViewIncrease = 'feedViewIncrease';

    case SyncLLMResponse = 'syncLLMResponse';
}
