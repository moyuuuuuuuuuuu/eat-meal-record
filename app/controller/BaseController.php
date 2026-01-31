<?php

namespace app\controller;

use support\Response;

class BaseController
{
    /**
     * 返回格式化json数据
     *
     * @param int $code
     * @param string $msg
     * @param array $data
     * @return Response
     */
    protected function json(int $code, string $msg = 'ok', array $data = []): Response
    {
        return json(['code' => $code, 'data' => $data, 'msg' => $msg]);
    }

    protected function success(string $msg = '成功', array $data = []): Response
    {
        return $this->json(0, $msg, $data);
    }

    protected function fail(string $msg = '失败', array $data = []): Response
    {
        return $this->json(1, $msg, $data);
    }
}
