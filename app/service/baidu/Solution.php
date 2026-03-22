<?php

namespace app\service\baidu;

use app\common\enum\BusinessCode;
use app\common\exception\BusinessException;
use app\service\Alarm;
use app\service\BaseGuzzleHttpClient;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;
use GuzzleHttp\RequestOptions;
use support\Log;
use support\Redis;

class Solution extends BaseGuzzleHttpClient
{

    public function __construct()
    {
        $this->client = new Client([
            'base_uri' => 'https://aip.baidubce.com/rest/2.0/solution/v1/',
            'timeout'  => 10.0,
        ]);
    }

    public function text(string $content)
    {
        try {
            $response = $this->client->post('text_censor/v2/user_defined', [
                RequestOptions::HEADERS     => [
                    'Content-Type' => 'application/x-www-form-urlencoded',
                ],
                RequestOptions::QUERY       => [
                    'access_token' => $this->getAccessToken()
                ],
                RequestOptions::FORM_PARAMS => [
                    'text' => $content,
                ],
            ]);
            return $this->handleResponse($response);
        } catch (RequestException $e) {
            $response = $e->getResponse();
            $result   = $response->getBody()?->getContents();
            $result   = json_decode($result, true);
            Log::error('百度文本审核异常', $result);
            throw new BusinessException($e->getMessage(), BusinessCode::PARAM_ERROR);
        }
    }

    public function image(string $content)
    {
        try {
            $response = $this->client->post('img_censor/v2/user_defined', [
                RequestOptions::HEADERS     => [
                    'Content-Type' => 'application/x-www-form-urlencoded',
                ],
                RequestOptions::QUERY       => [
                    'access_token' => $this->getAccessToken()
                ],
                RequestOptions::FORM_PARAMS => [
                    'imgUrl' => $content,
                ],
            ]);
            return $this->handleResponse($response);
        } catch (RequestException $e) {
            $response = $e->getResponse();
            $result   = $response->getBody()?->getContents();
            $result   = json_decode($result, true);
            Log::error('百度文本审核异常', $result);
            throw new BusinessException($e->getMessage(), BusinessCode::PARAM_ERROR);
        }
    }

    public function video(string $content)
    {
        try {
            $response = $this->client->post('video_censor/v2/user_defined', [
                RequestOptions::HEADERS     => [
                    'Content-Type' => 'application/x-www-form-urlencoded',
                ],
                RequestOptions::QUERY       => [
                    'access_token' => $this->getAccessToken()
                ],
                RequestOptions::FORM_PARAMS => [
                    'imgUrl' => $content,
                ],
            ]);
            return $this->handleResponse($response);
        } catch (RequestException $e) {
            $response = $e->getResponse();
            $result   = $response->getBody()?->getContents();
            $result   = json_decode($result, true);
            Log::error('百度文本审核异常', $result);
            throw new BusinessException($e->getMessage(), BusinessCode::PARAM_ERROR);
        }
    }

    protected function getAccessToken()
    {
        $accessToken = Redis::get('baidu:access_token');
        if ($accessToken) {
            return $accessToken;
        }
        try {

            $response    = (new Client())->post('https://aip.baidubce.com/oauth/2.0/token', [
                RequestOptions::QUERY => [
                    'grant_type'    => 'client_credentials',
                    'client_id'     => getenv('BAIDU_API_KEY'),
                    'client_secret' => getenv('BAIDU_APP_SECRET_KEY')
                ]
            ]);
            $result      = json_decode($response->getBody()?->getContents(), true);
            $accessToken = $result['access_token'];
            Redis::set('baidu:access_token', $accessToken);
            Redis::expire('baidu:access_token', $result['expires_in'] - 100);
            return $accessToken;
        } catch (RequestException $exception) {
            $response = $exception->getResponse();
            $result   = json_decode($response->getBody()?->getContents(), true);
            Alarm::notify($exception);
            throw new BusinessException('服务器异常请稍后重试', BusinessCode::THREE_PART_ERROR);
        }
    }

    protected function handleResponse($response): array
    {
        $result = json_decode($response->getBody()->getContents(), true);
        if (isset($result['error_code'])) {
            throw new BusinessException('三方审核失败，请稍后重试', BusinessCode::PARAM_ERROR);
        }
        $conclusion     = $result['conclusion'] ?? '';
        $conclusionType = $result['conclusion_type'] ?? null;
        if (!$conclusionType) {
            throw new BusinessException('文本审核未通过，请更改后再发布', BusinessCode::PARAM_ERROR);
        }
        if ($conclusionType !== 1) {
            $data    = $result['data'] ?? [];
            $first   = array_shift($data);
            $message = $first['msg'] ?? '';
            $message = str_replace('百度官方', '', $message);
            throw new BusinessException($conclusion . ':' . $message, BusinessCode::PARAM_ERROR);
        }
        return $result;
    }
}
