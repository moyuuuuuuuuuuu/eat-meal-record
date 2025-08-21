<?php

namespace app\controller;

class BaseController
{

    public function success($message = '', $data = [], int $code = 1, int $httpCode = 200)
    {
        return json([
            'code'    => $code,
            'message' => $message,
            'data'    => $data,
        ])->withStatus($httpCode);
    }

    public function error(int $code = 0, $message = '', $data = [], $httpCode = 200)
    {
        if ($code == 1) {
            return $this->success($code, $message, $data);
        }
        return json([
            'code'    => $code,
            'message' => $message,
            'data'    => $data,
        ])->withStatus($httpCode);
    }
}
