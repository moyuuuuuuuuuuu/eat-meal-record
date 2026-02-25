<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\enum\NormalStatus;
use app\format\TopicFormat;
use app\model\TopicModel;
use support\Request;

class TopicBusiness extends BaseBusiness
{
    public function search(Request $request)
    {
        $title    = $request->get('title');
        $page     = (int)$request->get('page', 1);
        $pageSize = $request->get('pageSize', 10);
        $query    = TopicModel::query()->select('id', 'title', 'join', 'thumb', 'description', 'post');
        $query->when($title, function ($query) use ($title) {
            $query->where('title', 'like', "%{$title}%");
        })->where('status', NormalStatus::YES->value);
        $query->orderBy('join', 'desc');

        $paginate = $query->paginate($pageSize, ['*'], 'page', $page);
        $format   = new TopicFormat($request);
        $paginate->getCollection()->transform(fn($item) => $format->format($item));

        return $paginate->toArray();
    }
}
