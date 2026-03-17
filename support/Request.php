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

use app\common\context\UserInfoData;

/**
 * Class Request
 * @package support
 */
class Request extends \Webman\Http\Request
{
    /**
     * @var UserInfoData|null
     */
    protected UserInfoData|null $userInfo;

    /**
     * 全局id
     * @var string
     */
    protected string|null $traceId = null;


    protected float|null $startTime = null;

    public function getTraceId(): string|null
    {
        return $this->traceId;
    }

    public function setTraceId(string $traceId): void
    {
        $this->traceId = $traceId;
    }

    public function getStartTime(): float|null
    {
        return $this->startTime;
    }

    public function setStartTime(float $startTime): void
    {
        $this->startTime = $startTime;
    }
}
