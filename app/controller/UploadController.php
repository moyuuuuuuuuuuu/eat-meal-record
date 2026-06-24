<?php

namespace app\controller;

use app\common\base\BaseController;
use app\common\enum\BusinessCode;
use app\service\baidu\Bos;
use app\common\exception\BusinessException;
use support\Request;
use Webman\Http\UploadFile;

class UploadController extends BaseController
{
    protected $noNeedLogin = [];

    public function upload(Request $request)
    {
        $file = $request->file('file');
        if (!$file) {
            throw new BusinessException('请选择要上传的文件', BusinessCode::PARAM_ERROR->value);
        } else if (!$file->isValid()) {
            throw new BusinessException('请选择要上传的文件', BusinessCode::BUSINESS_ERROR->value);
        }
        $this->validateUploadFile($file);

        $year      = date('Y');
        $monthDay  = date('md');
        $extension = $file->getUploadExtension();
        if ($extension) {
            $extension = '.' . $extension;
        }
        $filename     = 'sv' . bin2hex(random_bytes(8)) . $extension;
        $relativeDir  = "/uploads/$year/$monthDay";
        $absolutePath = public_path() . $relativeDir . '/' . $filename;

        $file->move($absolutePath);

        return $this->success('ok', [
            'path' => $relativeDir . '/' . $filename,
            'url'  => 'http://' . $request->host() . $relativeDir . '/' . $filename,
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
        $this->validateUploadFile($file);

        $filename = Bos::instance()->putObj($file);
        return $this->success('ok', [
            'path' => $filename,
            'url'  => source($filename),
        ]);
    }

    private function validateUploadFile(UploadFile $file): void
    {
        $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'mp3', 'aac', 'm4a', 'mp4', 'wav', 'txt'];
        $allowedMimes      = [
            'image/jpeg',
            'image/png',
            'image/gif',
            'audio/mpeg',
            'audio/aac',
            'audio/mp4',
            'video/mp4',
            'audio/wav',
            'text/plain',
        ];
        $maxSize = 10 * 1024 * 1024;

        $extension = strtolower((string)$file->getUploadExtension());
        $mime      = strtolower((string)$file->getUploadMimeType());
        if (!in_array($extension, $allowedExtensions, true) || !in_array($mime, $allowedMimes, true)) {
            throw new BusinessException('不支持的文件类型', BusinessCode::PARAM_ERROR->value);
        }
        if ($file->getSize() > $maxSize) {
            throw new BusinessException('文件大小不能超过10MB', BusinessCode::PARAM_ERROR->value);
        }
    }
}
