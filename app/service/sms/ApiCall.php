<?php

namespace app\service\sms;

class ApiCall
{

    // 加密算法
    private $ALGORITHM;
    // Access Key ID
    private $AccessKeyId;
    // Access Key Secret
    private $AccessKeySecret;

    private $action;
    private $version;
    private $params;

    public function __construct($accessKeyId, $accessKeySecret)
    {
        date_default_timezone_set('UTC'); // 设置时区为GMT
        $this->AccessKeyId     = $accessKeyId;
        $this->AccessKeySecret = $accessKeySecret;
        $this->ALGORITHM       = 'ACS3-HMAC-SHA256'; // 设置加密算法
    }

    public function setParams(array $params)
    {
        $this->params = $params;
        return $this;
    }

    public function setAction($action)
    {
        $this->action = $action;
        return $this;
    }

    public function setVersion($version = '2017-05-25')
    {
        $this->version = $version;
        return $this;
    }

    /**
     * @return array
     */
    public function call($method = 'POST', $uri = '/')
    {
        $request               = $this->createRequest($method, $uri, 'dysmsapi.aliyuncs.com', $this->action, $this->version);
        $request['queryParam'] = $this->params;
        $this->getAuthorization($request);
        // 调用API
        $result = $this->callApi($request);
        return $result;
    }

    private function createRequest($httpMethod, $canonicalUri, $host, $xAcsAction, $xAcsVersion)
    {
        $headers = [
            'host'                  => $host,
            'x-acs-action'          => $xAcsAction,
            'x-acs-version'         => $xAcsVersion,
            'x-acs-date'            => gmdate('Y-m-d\TH:i:s\Z'),
            'x-acs-signature-nonce' => bin2hex(random_bytes(16)),
        ];
        return [
            'httpMethod'   => $httpMethod,
            'canonicalUri' => $canonicalUri,
            'host'         => $host,
            'headers'      => $headers,
            'queryParam'   => [],
            'body'         => null,
        ];
    }

    private function getAuthorization(&$request)
    {
        $request['queryParam']                      = $this->processObject($request['queryParam']);
        $canonicalQueryString                       = $this->buildCanonicalQueryString($request['queryParam']);
        $hashedRequestPayload                       = hash('sha256', $request['body'] ?? '');
        $request['headers']['x-acs-content-sha256'] = $hashedRequestPayload;

        $canonicalHeaders = $this->buildCanonicalHeaders($request['headers']);
        $signedHeaders    = $this->buildSignedHeaders($request['headers']);

        $canonicalRequest = implode("\n", [
            $request['httpMethod'],
            $request['canonicalUri'],
            $canonicalQueryString,
            $canonicalHeaders,
            $signedHeaders,
            $hashedRequestPayload,
        ]);

        $hashedCanonicalRequest = hash('sha256', $canonicalRequest);
        $stringToSign           = "{$this->ALGORITHM}\n$hashedCanonicalRequest";

        $signature     = strtolower(bin2hex(hash_hmac('sha256', $stringToSign, $this->AccessKeySecret, true)));
        $authorization = "{$this->ALGORITHM} Credential={$this->AccessKeyId},SignedHeaders=$signedHeaders,Signature=$signature";

        $request['headers']['Authorization'] = $authorization;
    }

    /**
     * @param $request
     * @return false|array
     * @throws \Exception
     */
    private function callApi($request)
    {
        try {
            // 通过cURL发送请求
            $url = "https://" . $request['host'] . $request['canonicalUri'];

            // 添加请求参数到URL
            if (!empty($request['queryParam'])) {
                $url .= '?' . http_build_query($request['queryParam']);
            }

            // 初始化cURL会话
            $ch = curl_init();

            // 设置cURL选项
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false); // 禁用SSL证书验证，请注意，这会降低安全性，不应在生产环境中使用（不推荐！！！）
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // 返回而不是输出内容
            curl_setopt($ch, CURLOPT_HTTPHEADER, $this->convertHeadersToArray($request['headers'])); // 添加请求头

            // 根据请求类型设置cURL选项
            switch ($request['httpMethod']) {
                case "GET":
                    break;
                case "POST":
                    curl_setopt($ch, CURLOPT_POST, true);
                    curl_setopt($ch, CURLOPT_POSTFIELDS, $request['body']);
                    break;
                case "DELETE":
                    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE");
                    break;
                default:
                    throw new Exception("Unsupported HTTP method");
            }

            // 发送请求
            $result = curl_exec($ch);
            if (!$result) {
                throw new \Exception('请求失败');
            }
            $response = json_decode($result, true);
            if (!$response) {
                // 检查是否有错误发生
                if (curl_errno($ch)) {
                    throw new Exception("Failed to send request: " . curl_error($ch));
                }
                curl_close($ch);
            }
            curl_close($ch);
            return $response;
        } catch (Exception $e) {
            throw new \Exception($e->getMessage());
        }
    }

    function formDataToString($formData)
    {
        $res = self::processObject($formData);
        return http_build_query($res);
    }

    function processObject($value)
    {
        // 如果值为空，则无需进一步处理
        if ($value === null) {
            return;
        }
        $tmp = [];
        foreach ($value as $k => $v) {
            if (0 !== strpos($k, '_')) {
                $tmp[$k] = $v;
            }
        }
        return self::flatten($tmp);
    }

    private static function flatten($items = [], $delimiter = '.', $prepend = '')
    {
        $flatten = [];
        foreach ($items as $key => $value) {
            $pos = \is_int($key) ? $key + 1 : $key;

            if (\is_object($value)) {
                $value = get_object_vars($value);
            }

            if (\is_array($value) && !empty($value)) {
                $flatten = array_merge(
                    $flatten,
                    self::flatten($value, $delimiter, $prepend . $pos . $delimiter)
                );
            } else {
                if (\is_bool($value)) {
                    $value = true === $value ? 'true' : 'false';
                }
                $flatten["$prepend$pos"] = $value;
            }
        }
        return $flatten;
    }


    private function convertHeadersToArray($headers)
    {
        $headerArray = [];
        foreach ($headers as $key => $value) {
            $headerArray[] = "$key: $value";
        }
        return $headerArray;
    }


    private function buildCanonicalQueryString($queryParams)
    {

        ksort($queryParams);
        // Build and encode query parameters
        $params = [];
        foreach ($queryParams as $k => $v) {
            if (null === $v) {
                continue;
            }
            $str = rawurlencode($k);
            if ('' !== $v && null !== $v) {
                $str .= '=' . rawurlencode($v);
            } else {
                $str .= '=';
            }
            $params[] = $str;
        }
        return implode('&', $params);
    }

    private function buildCanonicalHeaders($headers)
    {
        // Sort headers by key and concatenate them
        uksort($headers, 'strcasecmp');
        $canonicalHeaders = '';
        foreach ($headers as $key => $value) {
            $canonicalHeaders .= strtolower($key) . ':' . trim($value) . "\n";
        }
        return $canonicalHeaders;
    }

    private function buildSignedHeaders($headers)
    {
        // Build the signed headers string
        $signedHeaders = array_keys($headers);
        sort($signedHeaders, SORT_STRING | SORT_FLAG_CASE);
        return implode(';', array_map('strtolower', $signedHeaders));
    }
}
