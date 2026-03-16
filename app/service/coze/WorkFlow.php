<?php

namespace app\service\coze;

use app\common\context\TokenLimit;
use app\service\BaseGuzzleHttpClient;
use Coze\Auth\OAuthClient;
use Coze\Workflow\Run;
use GuzzleHttp\Client;
use support\Redis;

class WorkFlow extends BaseGuzzleHttpClient
{

    protected string $appId;
    protected string $publicKey;

    protected string $privateKey;
    protected        $client = null;

    protected ?OAuthClient $oauth = null;

    protected string $accessTokenCacheKey = 'coze_access_token';

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
        Redis::set($this->accessTokenCacheKey, $accessToken, $result['expires_in'] - 100);
        return $accessToken;
    }

    /**
     * @param  $params
     * @return array
     * @throws \Exception
     */
    public function run($workFlowId, array $params)
    {
        $run    = new Run($this->client, $this->getAccessToken(), $workFlowId);
        $result = $run->handle($params);
        $usage  = $result['usage'] ?? [];
        $data   = json_decode($result['data'], true);
        unset($run);
        TokenLimit::instance()->consume($usage['token_count'] ?? []);
        return $data;
    }
}
