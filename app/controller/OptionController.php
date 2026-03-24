<?php

namespace app\controller;

use app\common\base\BaseController;
use app\model\OptionModel;

class OptionController extends BaseController
{
    protected $noNeedLogin = ['*'];

    public function tabbar()
    {
        $tabbarList = [
            [
                'name'        => 'home',
                'title'       => '首页',
                'icon'        => 'home',
                'activeColor' => '#10b981',
                'color'       => '#6b7280',
                'page'        => '/pages/index/index',
                'active'      => true
            ],
            /*[
                'name'        => 'feed',
                'title'       => '动态',
                'icon'        => 'layers',
                'activeColor' => '#10b981',
                'color'       => '#6b7280',
                'page'        => '/pages/feed/index',
            ],*/
            [
                'name'        => 'profile',
                'title'       => '我的',
                'icon'        => 'user',
                'activeColor' => '#10b981',
                'color'       => '#6b7280',
                'page'        => '/pages/profile/index',
            ],
        ];
        /*$isAudit    = OptionModel::isAudit();
        if ($isAudit) {
            unset($tabbarList[1]);
            $tabbarList = array_values($tabbarList);
        }*/
        return $this->success('', $tabbarList);
    }
}
