<?php

namespace app\business;

use app\common\base\BaseBusiness;
use app\format\CatFormat;
use app\model\CatModel;
use support\Request;

class CatBusiness extends BaseBusiness
{
    public function list(Request $request): array
    {
        if(!$this->isLoadedModel()){
            $this->loadModel(new CatModel());
        }
        $list = $this->model::query()
            ->orderBy('sort')
            ->orderBy('id')
            ->get(['id', 'name', 'pid', 'sort']);
        
        $format = new CatFormat($request);
        return $list->map(fn($item) => $format->format($item))->toArray();
    }
}
