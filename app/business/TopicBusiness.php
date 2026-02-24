<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\enum\NormalStatus;
use app\model\TopicModel;
use support\Request;

class TopicBusiness extends BaseBusiness
{
    public function search(Request $request)
    {
        $title    = $request->get('title');
        $page     = $request->get('page', 1);
        $pageSize = $request->get('pageSize', 10);
        $query    = TopicModel::query()->select('id', 'title', 'join', 'thumb', 'description');
        $query->when($title, function ($query) use ($title) {
            $query->where('title', 'like', "%{$title}%");
        })->where('status', NormalStatus::YES->value);
        $query->orderBy('join', 'desc');
        return $query->paginate($pageSize, ['*'], 'page', $page)->toArray();
    }
}
