<?php
/**
 * This file is part of webman.
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the MIT-LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author    walkor<walkor@workerman.net>
 * @copyright walkor<walkor@workerman.net>
 * @link      http://www.workerman.net/
 * @license   http://www.opensource.org/licenses/mit-license.php MIT License
 */

namespace support;

/**
 * Class Request
 * @package support
 */
class Request extends \Webman\Http\Request
{
    public $userId;

    public function isJson()
    {
        return $this->header('content-type') == 'application/json';
    }

    public function domain($withPort = false)
    {
        $host = $this->host($withPort);
        //获取http还是https
        $fullUri = $this->fullUrl();

        $scheme = "http";
        if (str_contains($fullUri, "https://")) {
            $scheme = "https";
        }
        return $scheme . '://' . $host;
    }

    /**
     * 获取参数
     * @param string $name 参数名
     * @param mixed|null $default 默认值
     * @param string $type 参数类型
     * @return array|bool|float|int|mixed|object|string|null
     */
    public function getParam(string $name, mixed $default = null, string $type = 'string')
    {
        $data = $this->all();
        if (!isset($data[$name])) {
            return $default ?? null;
        }
        return match ($type) {
                   'string', 's' => (string)$data[$name],
                   'int', 'i' => (int)$data[$name],
                   'float', 'f' => (float)$data[$name],
                   'bool', 'b' => (bool)$data[$name],
                   'array', 'a' => (array)$data[$name],
                   'object', 'o' => (object)$data[$name],
                   'datetime', 'd' => date('Y-m-d H:i:s', (int)$data[$name]),
                   'timestamp', 't' => (int)$data[$name],
                   'null', 'n' => null,
                   default => $default,
               } ?? $default;
    }

    public function getPlatform(): string
    {
        return $this->header('user-agent') ?? '';
    }
}
