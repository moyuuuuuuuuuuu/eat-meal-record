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
}
