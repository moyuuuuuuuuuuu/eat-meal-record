<?php

namespace app\controller;

use support\Request;

class UploadController extends BaseController
{
    public function upload(Request $request)
    {
        // 获取上传的文件
        $file = $request->file('file');
        if (!$file) {
            return $this->fail('请选择要上传的文件');
        } else if (!$file->isValid()) {
            return $this->fail('文件异常，不可上传');
        }

        // 获取文件名和扩展名
        $filename = $file->getUploadName();
        $fileExt  = $file->getUploadExtension();
        $fileSize = $file->getSize();
        $filename = md5($filename) . '.' . $fileExt;
        // 指定文件保存路径
        $baseDir   = public_path();
        $uploadDir = 'upload/' . date('Ymd');
        $filepath  = $baseDir . '/' . $uploadDir . $filename;

        // 移动文件到指定目录
        if (!$file->move($filepath)) {
            return $this->fail('文件上传失败');
        }
        $visitPath = $uploadDir . $filename;
        return $this->success('', [
            'path'     => $visitPath,
            'fullpath' => $request->host() . $visitPath,
        ]);
    }
}
