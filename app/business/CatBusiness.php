<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\model\CatModel;
use support\Request;

class CatBusiness extends BaseBusiness
{
    public function list(Request $request): array
    {
        if(!$this->isLoadedModel()){
            $this->loadModel(new CatModel());
        }
        return $this->model::query()
            ->orderBy('sort')
            ->orderBy('id')
            ->get(['id', 'name', 'pid', 'sort'])->toArray();
    }
}
