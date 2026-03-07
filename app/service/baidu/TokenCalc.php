<?php

namespace app\service\baidu;

use app\service\BaseGuzzleHttpClient;
use GuzzleHttp\Client;
use GuzzleHttp\RequestOptions;
use support\Cache;
use Throwable;

class TokenCalc extends BaseGuzzleHttpClient
{
    protected string $clientId;
    protected string $clientSecret;

    // 常量定义，方便维护
    const CACHE_KEY = 'baidu_access_token';
    const BASE_URL  = 'https://aip.baidubce.com/';

    protected function __construct()
    {
        $this->clientId     = env('BCE_CLIENT_ID');
        $this->clientSecret = env('BCE_CLIENT_SECRET');

        $this->client = new Client([
            'base_uri' => self::BASE_URL,
            'timeout'  => 5.0,
            'verify'   => false, // 生产环境建议开启并配置证书
        ]);
    }

    /**
     * 获取并缓存 AccessToken
     */
    protected function getAccessToken(): string
    {
        $token = Cache::get(self::CACHE_KEY);
        if ($token) {
            return $token;
        }

        try {
            $response = $this->client->get('oauth/2.0/token', [
                RequestOptions::QUERY => [
                    'grant_type'    => 'client_credentials',
                    'client_id'     => $this->clientId,
                    'client_secret' => $this->clientSecret
                ]
            ]);

            $result      = json_decode($response->getBody()->getContents(), true);
            $accessToken = $result['access_token'] ?? null;

            if (!$accessToken) {
                throw new \Exception('Baidu API Token missing in response');
            }

            // 百度 Token 默认 30 天，提前 1 小时过期较安全
            $expiresIn = ($result['expires_in'] ?? 2592000) - 3600;
            Cache::set(self::CACHE_KEY, $accessToken, $expiresIn);

            return $accessToken;
        } catch (Throwable $e) {
            throw new \Exception('百度授权失败: ' . $e->getMessage());
        }
    }

    /**
     * 执行 Token 计算
     * @param string $prompt
     * @param string|null $model 默认为空，API 将使用默认分词器
     */
    public function run(string $prompt, string $model = null): array
    {
        $token = $this->getAccessToken();

        // 简化后的 payload
        $payload = [
            RequestOptions::QUERY => ['access_token' => $token],
            RequestOptions::JSON  => ['prompt' => $prompt] + ($model ? ['model' => $model] : []),
        ];

        try {
            // 注意：erniebot 是通用路径，特定模型可能需要调整后缀
            $response = $this->client->post('/rpc/2.0/ai_custom/v1/wenxinworkshop/tokenizer/erniebot', $payload);
            return $this->handleResponse($response);
        } catch (Throwable $e) {
            // 记录日志或处理错误
            throw new \Exception('Token计算接口请求失败: ' . $e->getMessage());
        }
    }

    protected function handleResponse($response): array
    {
        // 兼容处理 Guzzle Response 对象或字符串
        $content = is_string($response) ? $response : $response->getBody()->getContents();
        $data    = json_decode($content, true);

        if (isset($data['error_code'])) {
            throw new \Exception("百度API报错({$data['error_code']}): {$data['error_msg']}");
        }

        return $data;
    }
}
