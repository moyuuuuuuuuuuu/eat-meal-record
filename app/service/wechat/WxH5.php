<?php

namespace app\service\wechat;


class WxH5 extends BaseWechatClient
{

    protected static $instance;
    protected function loadAppid()
    {
        $this->appId     = env('WECHAT_APP_ID');
        $this->appSecret = env('WECHAT_APP_SECRET');
    }

}
