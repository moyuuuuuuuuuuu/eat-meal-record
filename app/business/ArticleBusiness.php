<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\common\enum\ArticleStatus;
use app\common\enum\ArticleType;
use app\common\enum\BusinessCode;
use app\common\exception\DataNotFoundException;
use app\model\ArticleModel;
use support\Log;
use support\Request;
use app\common\exception\BusinessException;

class ArticleBusiness extends BaseBusiness
{
    public function notice(Request $request): array
    {
        try {

            return ArticleModel::query()
                ->where('type', ArticleType::Notice->value)
                ->where('status', ArticleStatus::Publish->value)
                ->inShowTime()
                ->orderByRaw('is_top = 1 DESC')
                ->orderBy('sort', 'desc')
                ->pluck('brief')->toArray();
        } catch (\Exception $e) {
            Log::error('获取公告列表异常', ['exception' => $e->getMessage()]);
            return [];
        }
    }

    public function userAgreement()
    {
        return ArticleModel::query()->where('type', ArticleType::UserAgreement->value)->select(['title', 'brief', 'content'])->first()->toArray();
    }

    public function info(Request $request): array
    {
        $type = $request->get('type', null);
        $id   = $request->get('id', null);
        if (!$type && !$id) {
            throw new DataNotFoundException('文章未找到');
        }
        $articleType = ArticleType::tryFrom($type);
        if (!$articleType) {
            throw new BusinessException('错误的文章类型', BusinessCode::PARAM_ERROR);
        } else if ($articleType != ArticleType::UserAgreement && !$id) {
            throw new BusinessException('参数缺失', BusinessCode::PARAM_ERROR);
        }
        $query = ArticleModel::query()->select(['id', 'title', 'brief', 'content', 'created_at']);
        if ($id) {
            $query->where('id', $id);
        }
        if ($type) {
            $query->where('type', $type);
        }
        $query->where('status', ArticleStatus::Publish->value);
        $info = $query->first();
        if (!$info) {
            throw new DataNotFoundException('文章未找到');
        }
        return $info->toArray();

    }
}
