<?php

namespace app\service\coze;

use GuzzleHttp\Client;
use Coze\Auth\OAuthClient;
use Coze\Workflow\Run;
use app\service\BaseGuzzleHttpClient;
use Illuminate\Support\Facades\Cache;

class WorkFlow extends BaseGuzzleHttpClient
{

    protected string $appId;
    protected string $publicKey;

    protected string $privateKey;
    protected        $client = null;

    protected ?OAuthClient $oauth = null;

    protected string $accessToken;

    protected function __construct()
    {
        $this->appId      = getenv('COZE_APPID'); // 应用ID
        $this->publicKey  = getenv('COZE_PUBLIC_KEY'); // 公钥指纹
        $this->privateKey = file_get_contents(runtime_path() . getenv('COZE_PRIVATE_KEY_PATH')); // 私钥
        $this->client     = new Client([
            'base_uri' => 'https://api.coze.cn',
            'timeout'  => 5,
        ]);
    }

    protected function getAccessToken(): string
    {
        $accessToken = Cache::get('access_token');
        if ($accessToken) {
            return $accessToken;
        }
        $this->oauth = new OAuthClient($this->appId, $this->publicKey, $this->privateKey, $this->client);
        $result      = $this->oauth->getAccessToken();
        $accessToken = $result['access_token'];
        Cache::set('access_token', $this->accessToken, $result['expires_in'] - 100);
        return $accessToken;
    }

    /**
     * @param array{
     *     text:string,
     *     image:string,
     *     audio:string
     * } $params
     * @return array
     * @throws \Exception
     */
    public function run(array $params)
    {
        $run = new Run($this->client, $this->getAccessToken(), getenv('COZE_WORKFLOW_ID'));
        return $run->handle($params);
    }
}
