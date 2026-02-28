<?php

namespace app\service\baidu;

use GuzzleHttp\Client;
use support\Log;
use Webman\Http\UploadFile;
use app\common\enum\BusinessCode;
use app\service\BaseGuzzleHttpClient;
use support\exception\BusinessException;
use GuzzleHttp\Exception\{GuzzleException, RequestException};

class Bos extends BaseGuzzleHttpClient
{
    protected        $needSignHeaderField = [
        'host',
        'content-length',
        'content-type',
        'content-md5',
        'x-bce-date',
        'x-bce-acl'
    ];

    protected function __construct()
    {
        $this->client = new Client([
            'base_uri' => sprintf('https://%s.bcebos.com/', getenv('BOS_REGION')),
            'timeout'  => 10.0,
            'verify'   => false,
        ]);
    }

    public function putObj(UploadFile $uploadFile): string
    {
        Log::debug(sprintf('https://%s.bcebos.com/', getenv('BOS_REGION')));
        $filename = $this->getFileName($uploadFile);
        $now = time();
        $iso8601Zulu = gmdate('Y-m-d\TH:i:s\Z', $now);
        $headers  = [
            'Host'           => sprintf('%s.%s.bcebos.com', getenv('BOS_BUCKET'), getenv('BOS_REGION')),
            'Content-Type'   => $uploadFile->getUploadMimeType(),
            'x-bce-date'     => $iso8601Zulu,
            'x-bce-acl'      => 'public-read',
            'Content-Length' => $uploadFile->getSize(),
        ];
        Log::debug('putObj', [$filename, $headers, $iso8601Zulu]);
        list($canonicalRequest, $signedHeaders) = $this->canonicalRequest('PUT', $filename, '', $headers);
        $authorization            = $this->authorization($canonicalRequest, $signedHeaders, $now);
        $headers['Authorization'] = $authorization;
        Log::debug('putObj headers', [$headers]);
        $filePath                 = $uploadFile->getRealPath();
        $handle                   = fopen($filePath, 'r');
        try {
            $response = $this->client->put($filename, [
                'headers' => $headers,
                'body'    => $handle, // 传入资源句柄
                'timeout' => 30.0,    // 建议加上超时设置
            ]);

            $statusCode = $response->getStatusCode();
            $result     = $response->getBody()->getContents();
            Log::debug('putObj', [$filename, $statusCode, $response->getHeaders(), $result]);
            if ($statusCode != 200) {
                throw new BusinessException("上传失败，状态码：" . $statusCode, BusinessCode::BUSINESS_ERROR->value);
            }
            Log::debug('putObj result', [$result]);
            return $filename;
        } catch (RequestException $e) {
            $message = "网络请求错误：" . $e->getMessage();
            if ($e->hasResponse()) {
                $errorBody = $e->getResponse()->getBody()->getContents();
                $message = json_decode($errorBody, true);
                $message = $message['message'] ?? '网络请求错误：未知错误';
            }
            Log::error($message);
            throw new BusinessException($message, BusinessCode::BUSINESS_ERROR->value);
        } catch (GuzzleException $e) {
            $message = "Guzzle 通用错误：" . $e->getMessage();
            throw new BusinessException($message, BusinessCode::BUSINESS_ERROR->value);
        } finally {
            if (is_resource($handle)) {
                fclose($handle);
            }
        }
    }


    protected function getFileName(UploadFile $uploadFile): string
    {
        $extension = $uploadFile->getUploadExtension();
        $date      = date('Y/md');
        return sprintf('uploads/%s/%s.%s', $date, uniqid(), $extension);
    }

    protected function authorization(string $canonicalRequest, string $signedHeader, $now = null)
    {
        $authStringPrefix = $this->authStringPrefix($now);
        Log::debug('authStringPrefix', [$canonicalRequest, $authStringPrefix]);
        $signedKey        = hash_hmac('sha256', $authStringPrefix, getenv('BOS_ACCESS_KEY_SECRET'));
        $signature        = hash_hmac('sha256', $canonicalRequest, $signedKey);
        return sprintf('%s/%s/%s', $authStringPrefix, $signedHeader, $signature);
    }

    protected function authStringPrefix($now = null):string
    {
        $now              = $now ?: time();
        $iso8601Zulu      = gmdate('Y-m-d\TH:i:s\Z', $now);
        $expirationPeriodInSeconds = 10800; // 3 hours
        return sprintf('bce-auth-v1/%s/%s/%d', getenv('BOS_ACCESS_KEY_ID'), $iso8601Zulu, $expirationPeriodInSeconds);
    }

    protected function canonicalRequest(string $httpMethod, string $canonicalUri, string $canonicalQueryString, array $canonicalHeaders)
    {
        if (!in_array($httpMethod, ['GET', 'POST', 'PUT', 'DELETE'])) {
            throw new BusinessException('不支持的请求方式', BusinessCode::BUSINESS_ERROR->value);
        }
        $canonicalUri = '/' . ltrim($canonicalUri, '/');
        // 百度云 BOS 要求 URI 编码，但斜杠 / 不编码
        $canonicalUri = str_replace('%2F', '/', rawurlencode($canonicalUri));
        $httpMethod   = strtoupper($httpMethod);
        parse_str($canonicalQueryString, $queryString);
        $canonicalQueryString = [];
        foreach ($queryString as $k => $v) {
            if ($k === '') {
                continue;
            }
            if ($v === null || $v === '') {
                $canonicalQueryString[rawurlencode($k)] = '';
                continue;
            }
            $canonicalQueryString[rawurlencode($k)] = rawurlencode($v);
        }
        ksort($canonicalQueryString);
        $queryStrings = [];
        foreach ($canonicalQueryString as $k => $v) {
            $queryStrings[] = $k . '=' . $v;
        }
        $canonicalQueryString = implode('&', $queryStrings);
        $signedHeaders        = [];
        foreach ($canonicalHeaders as $key => $value) {
            $key = strtolower($key);
            if (str_starts_with($key, 'x-bce-') || in_array($key, $this->needSignHeaderField)) {
                $signedHeaders[] = rawurlencode($key);
            } else {
                unset($canonicalHeaders[$key]);
            }
        }
        $canonicalHeaders = array_change_key_case($canonicalHeaders, CASE_LOWER);
        ksort($canonicalHeaders);

        sort($signedHeaders);
        $signedHeaderString = implode(';', $signedHeaders);
        $signedHeaderData   = [];
        foreach ($canonicalHeaders as $key => $value) {
            $value              = trim($value);
            $signedHeaderData[] = rawurlencode($key) . ':' . rawurlencode($value);
        }
        $signedHeaderDataString = implode("\n", $signedHeaderData);
        return [$httpMethod . "\n" . $canonicalUri . "\n" . $canonicalQueryString . "\n" . $signedHeaderDataString, $signedHeaderString];
    }
}
