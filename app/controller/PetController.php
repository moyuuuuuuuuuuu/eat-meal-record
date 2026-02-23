<?php

namespace app\controller;

use app\business\PetBusiness;
use app\common\base\BaseController;
use support\Request;

class PetController extends BaseController
{
    public function findByStatus(Request $request)
    {
        return $this->success('ok', PetBusiness::instance()->findByStatus($request));
    }

    public function detail(Request $request, $petId)
    {
        return $this->success('ok', PetBusiness::instance()->detail((int)$petId));
    }

    public function add(Request $request)
    {
        return $this->success('添加成功', PetBusiness::instance()->add($request->post()));
    }

    public function update(Request $request)
    {
        return $this->success('更新成功');
    }

    public function updateWithForm(Request $request, $petId)
    {
        return $this->success('更新成功');
    }

    public function delete(Request $request, $petId)
    {
        return $this->success('删除成功');
    }

    public function uploadImage(Request $request, $petId)
    {
        return $this->success('上传成功', ['url' => 'https://example.com/upload.jpg']);
    }
}
