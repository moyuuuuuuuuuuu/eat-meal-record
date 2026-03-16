<?php

namespace app\controller;

use app\common\base\BaseController;
use app\model\OptionModel;
use support\Request;

class OptionController extends BaseController
{
    protected $noNeedLogin = [
        '*'
    ];

    public function tabbar()
    {
        $tabbarList = [
            [
                'name'        => 'home',
                'title'       => '首页',
                'icon'        => 'IconHouse',
                'activeColor' => '#10b981',
                'color'       => '#6b7280',
                'page'        => '/pages/index/index',
                'active'      => true
            ],
            [
                'name'        => 'feed',
                'title'       => '动态',
                'icon'        => 'IconList',
                'activeColor' => '#10b981',
                'color'       => '#6b7280',
                'page'        => '/pages/feed/index',
            ],
            [
                'name'        => 'profile',
                'title'       => '我的',
                'icon'        => 'IconUser',
                'activeColor' => '#10b981',
                'color'       => '#6b7280',
                'page'        => '/pages/profile/index',
            ],
        ];
        $isAudit    = OptionModel::getConfig('system_config', 'logo.audit');
        if ($isAudit === 'on') {
            unset($tabbarList[1]);
            $tabbarList = array_values($tabbarList);
        }
        return $this->success('', $tabbarList);
    }
}
