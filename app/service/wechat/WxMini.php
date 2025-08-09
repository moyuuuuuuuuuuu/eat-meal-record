<?php
/**
 * 小程序api服务
 */

namespace app\service\wechat;

use GuzzleHttp\Client;
use support\Cache;

class WxMini extends BaseWechatClient
{

    protected static $instance;
    protected function loadAppid()
    {
        $this->appId     = env('MP_APPID');
        $this->appSecret = env('MP_SECRET');
    }

    public function getAccessToken()
    {
        if (Cache::has('access_token')) {
            return Cache::get('access_token');
        }
        $response = $this->client->get('cgi-bin/token', [
            'query' => [
                'grant_type' => 'client_credential',
                'appid'      => $this->appId,
                'secret'     => $this->appSecret,
            ]
        ]);
        $data     = $this->handleResponse($response);
        if (!isset($data['access_token'])) {
            throw new \Exception('获取access_token失败');
        }
        Cache::set('access_token', $data['access_token'], intval($data['expires_in']) - 200);
        return $data['access_token'];
    }

    /**
     * 小程序登录
     * @param string $code
     * @return array
     * @throws \GuzzleHttp\Exception\GuzzleException
     */
    public function jsCode2Session(string $code)
    {
        $query      = [
            'appid'      => $this->appId,
            'secret'     => $this->appSecret,
            'js_code'    => $code,
            'grant_type' => 'authorization_code',
        ];
        $response   = $this->client->get('sns/jscode2session', [
            'query' => $query
        ]);
        $data       = $this->handleResponse($response);
        $openId     = $data['openid'];
        $sessionKey = $data['session_key'];
        $unionId    = $data['unionid'] ?? '';
        return [
            'openId'     => $openId,
            'sessionKey' => $sessionKey,
            'unionId'    => $unionId,
        ];
    }

    public function getPhoneNumber(string $code, string $openid = '')
    {
        $params = [
            'code' => $code,
        ];
        if ($openid) {
            $params['openid'] = $openid;
        }
        $response = $this->client->post('wxa/business/getuserphonenumber', [
            'query'       => [
                'access_token' => $this->getAccessToken(),
            ],
            'form_params' => $params,
        ]);
        $data     = $this->handleResponse($response);

        return $data['phone_info'] ?? [];
    }


    /**
     * 解密用户信息
     * @param string $encryptedData
     * @param string $sessionKey
     * @param string $iv
     * @return mixed
     * @throws \Exception
     */
    public function parseEncryptData(string $encryptedData, string $sessionKey, string $iv)
    {
        if (strlen($sessionKey) != 24) {
            throw new \Exception('sessionKey非法', 41001);
        }
        $aesKey = base64_decode($sessionKey);


        if (strlen($iv) != 24) {
            throw new \Exception('iv 非法', 41002);
        }
        $aesIV = base64_decode($iv);

        $aesCipher = base64_decode($encryptedData);

        $result = openssl_decrypt($aesCipher, "AES-128-CBC", $aesKey, 1, $aesIV);

        $data = json_decode($result, true);
        if ($data == NULL) {
            throw new \Exception('解密失败', 41003);
        }
        if ($data ['watermark']['appid'] != $this->appId) {
            throw new \Exception('解密失败', 41003);
        }
        return $data;
    }
}
