<?php

namespace app\controller;

use Illuminate\Http\Request;

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
        $filename = $file->getOriginalName();
        $fileExt  = $file->getExtension();

        // 指定文件保存路径
        $uploadDir = public_path() . '/upload/';
        $filepath  = $uploadDir . $filename;

        // 移动文件到指定目录
        if (!$file->move($uploadDir, $filename)) {
            return $this->fail($file->getError());
        }
        return $this->success('', [
            'path'     => $filepath,
            'fullpath' => $request->host() . $filepath,
        ]);
    }
}
