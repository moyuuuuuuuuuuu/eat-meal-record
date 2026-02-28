<?php

namespace app\controller;

use app\common\base\BaseController;
use app\common\enum\BusinessCode;
use app\service\baidu\Bos;
use support\exception\BusinessException;
use support\Request;

class UploadController extends BaseController
{
    public function upload(Request $request)
    {
        $file = $request->file('file');
        if (!$file) {
            throw new BusinessException('请选择要上传的文件', BusinessCode::PARAM_ERROR->value);
        } else if (!$file->isValid()) {
            throw new BusinessException('请选择要上传的文件', BusinessCode::BUSINESS_ERROR->value);
        }

        $year = date('Y');
        $monthDay = date('md');
        $extension = $file->getUploadExtension();
        if ($extension) {
            $extension = '.' . $extension;
        }
        $filename = 'sv' . bin2hex(random_bytes(8)) . $extension;
        $relativeDir = "/uploads/$year/$monthDay";
        $absolutePath = public_path() . $relativeDir . '/' . $filename;

        $file->move($absolutePath);

        return $this->success('ok', [
            'path' => $relativeDir . '/' . $filename,
            'url'  => 'http://'.$request->host() . $relativeDir . '/' . $filename,
        ]);
    }
    public function uploadForBos(Request $request)
    {
        $file = $request->file('file');
        if (!$file) {
            throw new BusinessException('请选择要上传的文件', BusinessCode::PARAM_ERROR->value);
        } else if (!$file->isValid()) {
            throw new BusinessException('请选择要上传的文件', BusinessCode::BUSINESS_ERROR->value);
        }

        $filename = Bos::instance()->putObj($file);
        return $this->success('ok', [
            'path' => $filename,
            'url'  => getenv('BOS_DOMAIN') . $filename,
        ]);
    }
}
