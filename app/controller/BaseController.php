<?php

namespace app\controller;

class BaseController
{

    public function success($message = '', $data = [], int $code = 1)
    {
        return json([
            'code'    => $code,
            'message' => $message,
            'data'    => $data,
        ]);
    }

    public function error(int $code = 0, $message = '', $data = [])
    {
        if ($code == 1) {
            return $this->success($code, $message, $data);
        }
        return json([
            'code'    => $code,
            'message' => $message,
            'data'    => $data,
        ]);
    }
}
