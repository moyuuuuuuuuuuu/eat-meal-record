<?php

namespace app\controller;

use support\Cache;
use support\Request;

class UploadController extends BaseController
{
    public function upload(Request $request)
    {
        $remoteIp  = $request->getRemoteIp();
        $blackKey  = 'uploadIpBlack' . $remoteIp;
        $recordKey = 'uploadIpRecord' . $remoteIp;

        if (Cache::has($blackKey)) {
            return $this->error(1006, '短时间内上传过多，已被禁止上传30分钟');
        }

        $record = Cache::get($recordKey, [0, 0]);
        list($times, $lastUploadTime) = $record;

        $currentTime = time();
        if ($currentTime - $lastUploadTime < 60) {
            // 1分钟内，次数累加
            if ($times >= 10) {
                // 超过限制，拉黑30分钟（1800秒）
                Cache::set($blackKey, true, 1800);
                Cache::delete($recordKey);
                return $this->error(1006, '短时间内上传过多，已被禁止上传30分钟');
            }
            $times++;
        } else {
            $times = 1;
        }
        Cache::set($recordKey, [$times, $currentTime], 3600);

        $name = $request->post('name', 'file');
        $file = $request->file($name);
        if (!$file || !$file->isValid()) {
            return $this->error(1005, '文件未上传或非法文件');
        }

        $mime = $file->getUploadMimeType() ?: 'application/octet-stream';
        $ext  = $file->getUploadExtension();
        //TODO:检测ext和mime是否匹配
        $fileSize = $file->getSize();
        //TODO:检测文件大小
        $filePath = '/uploads/' . date('Ymd') . '/' . uniqid() . '.' . $ext;
        $file->move(public_path($filePath));

        return $this->success('上传成功', ['path' => $filePath, 'fullPath' => $request->domain() . $filePath]);
    }
}
