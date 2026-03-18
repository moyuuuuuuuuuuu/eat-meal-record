<?php

namespace app\service\coze;

use app\common\context\TokenLimit;
use app\common\enum\BusinessCode;
use app\common\exception\BusinessException;
use app\service\BaseGuzzleHttpClient;
use Coze\Auth\OAuthClient;
use Coze\Workflow\Run;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use GuzzleHttp\Exception\RequestException;
use GuzzleHttp\RequestOptions;
use support\Log;
use support\Redis;

class WorkFlow extends BaseGuzzleHttpClient
{

    protected string $appId;
    protected string $publicKey;

    protected string $privateKey;
    protected        $client = null;

    protected ?OAuthClient $oauth = null;

    protected string $accessTokenCacheKey = 'coze:access_token';

    protected function __construct()
    {
        if (!file_exists(runtime_path() . getenv('COZE_PRIVATE_KEY_PATH'))) {
            throw new \Exception('Private key file not found');
        }
        $this->appId      = getenv('COZE_APPID'); // 应用ID
        $this->publicKey  = getenv('COZE_PUBLIC_KEY'); // 公钥指纹
        $this->privateKey = file_get_contents(runtime_path() . getenv('COZE_PRIVATE_KEY_PATH')); // 私钥
        $this->client     = new Client([
            'base_uri' => 'https://api.coze.cn',
            'timeout'  => 1200,
        ]);
    }

    protected function getAccessToken(): string
    {
        $accessToken = Redis::get($this->accessTokenCacheKey);
        if ($accessToken) {
            return $accessToken;
        }
        $this->oauth = new OAuthClient($this->appId, $this->publicKey, $this->privateKey, $this->client);
        $result      = $this->oauth->getAccessToken();
        $accessToken = $result['access_token'];
        Redis::set($this->accessTokenCacheKey, $accessToken);
        Redis::expire($this->accessTokenCacheKey, $result['expires_in'] - time());
        return $accessToken;
    }

    protected function clearAccessToken(): void
    {
        Redis::del($this->accessTokenCacheKey);
    }

    /**
     * @param $workFlowId
     * @param array $params
     * @param int $retryCount
     * @return array
     * @throws \Exception
     */
    public function run($workFlowId, array $params, int $retryCount = 0)
    {
        if (!$workFlowId) {
            throw new BusinessException('缺少三方id', BusinessCode::PARAM_ERROR);
        }

        try {
            $run    = new Run($this->client, $this->getAccessToken(), $workFlowId);
            $result = $run->handle($params);
            $usage  = $result['usage'] ?? [];
            $data   = json_decode($result['data'], true);

            unset($run);
            TokenLimit::instance()->consume($usage['token_count'] ?? []);
            return $data;

        } catch (RequestException $e) {
            if ($e->getCode() == 401 && $retryCount < 1) {
                $this->clearAccessToken();
                return $this->run($workFlowId, $params, $retryCount + 1);
            }
            throw $e;
        }
    }
}
