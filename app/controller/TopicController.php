<?php

namespace app\controller;

use app\model\TopicModel;
use support\Request;

class TopicController extends BaseController
{
    public function list(Request $request)
    {
        $orderByField = $request->getParam('orderBy', 'join_count');
        $orderByMode  = $request->getParam('orderType', 'desc');
        $keyword      = $request->getParam('keyword', '');
        $page         = $request->getParam('page', 1);
        $limit        = $request->getParam('limit', 10);
        if (!in_array($orderByField, ['created_at', 'updated_at', 'join_count'])) {
            $orderByField = 'join_count';
        }
        if (!in_array($orderByMode, ['asc', 'desc'])) {
            $orderByMode = 'desc';
        }
        $where   = [];
        $where[] = ['status', '=', TopicModel::STATUS_NORMAL];
        if ($keyword) {
            $where[] = ['name', 'like', '%' . $keyword . '%'];
        }
        $topicList = TopicModel::query()->where($where)->orderBy($orderByField, $orderByMode)->offset(($page - 1) * $limit)->limit($limit)->get();
        if ($topicList->isEmpty()) {
            return $this->success('', ['list' => []]);
        }
        $maxPage = 0;
        if ($page == 1) {
            $total   = TopicModel::query()->where($where)->count();
            $maxPage = ceil($total / $limit);
        }
        return $this->success('', ['list' => $topicList->toArray(), 'maxPage' => $maxPage, 'currentPage' => $page]);
    }

    public function create(Request $request)
    {

    }
}
