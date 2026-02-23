<?php

namespace app\util;

use app\common\context\UserInfoData;

class Jwt
{
    /**
     * @var string
     */
    protected static $key;

    /**
     * @var string
     */
    protected static $aesKey;

    /**
     * @var string
     */
    protected static $aesIv;

    /**
     * 生成 JWT Token
     *
     * @param array $payload
     * @param int|null $exp
     * @return string
     */
    public static function encode(array $payload, int $exp = null): string
    {
        $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);

        $jwtPayload = [
            'iat' => time(),
        ];

        if ($exp) {
            $jwtPayload['exp'] = time() + $exp;
        }

        // 加密原始数据部分
        $payloadJson        = json_encode($payload);
        $jwtPayload['data'] = openssl_encrypt($payloadJson, 'AES-256-CBC', static::getAesKey(), 0, static::getAesIv());

        $base64UrlHeader  = static::base64UrlEncode($header);
        $base64UrlPayload = static::base64UrlEncode(json_encode($jwtPayload));

        $signature          = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, static::getKey(), true);
        $base64UrlSignature = static::base64UrlEncode($signature);

        return $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;
    }

    /**
     * 解码 JWT Token
     *
     * @param string $token
     * @return UserInfoData
     */
    public static function decode(string $token): UserInfoData|null
    {
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            return null;
        }

        list($base64UrlHeader, $base64UrlPayload, $base64UrlSignature) = $parts;

        $signature         = static::base64UrlDecode($base64UrlSignature);
        $expectedSignature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, static::getKey(), true);

        if (!hash_equals($signature, $expectedSignature)) {
            return null;
        }

        $jwtPayloadJson = static::base64UrlDecode($base64UrlPayload);
        $jwtPayload     = json_decode($jwtPayloadJson, true);

        if (!$jwtPayload || !isset($jwtPayload['data'])) {
            return null;
        }

        // 先检查过期时间（无需 AES 解密）
        if (isset($jwtPayload['exp']) && $jwtPayload['exp'] < time()) {
            return null;
        }

        // 解密数据部分
        $payloadJson = openssl_decrypt($jwtPayload['data'], 'AES-256-CBC', static::getAesKey(), 0, static::getAesIv());

        if ($payloadJson === false) {
            return null;
        }

        $payload = json_decode($payloadJson,true);
        if (!$payload) {
            return null;
        }

        // 合并 metadata 以保持兼容性
        $payload['iat'] = $jwtPayload['iat'];
        if (isset($jwtPayload['exp'])) {
            $payload['exp'] = $jwtPayload['exp'];
        }

        return new UserInfoData($payload);
    }

    /**
     * 获取密钥
     *
     * @return string
     */
    protected static function getKey(): string
    {
        if (!static::$key) {
            static::$key = getenv('JWT_KEY') ?: 'default_key_123456';
        }
        return static::$key;
    }

    /**
     * 获取 AES 密钥
     *
     * @return string
     */
    protected static function getAesKey(): string
    {
        if (!static::$aesKey) {
            $key            = getenv('JWT_AES_KEY') ?: 'default_aes_key_654321_098765432';
            static::$aesKey = substr(hash('sha256', $key), 0, 32);
        }
        return static::$aesKey;
    }

    /**
     * 获取 AES IV
     *
     * @return string
     */
    protected static function getAesIv(): string
    {
        if (!static::$aesIv) {
            $iv            = getenv('JWT_AES_IV') ?: 'default_iv_123456';
            static::$aesIv = substr(hash('sha256', $iv), 0, 16);
        }
        return static::$aesIv;
    }

    protected static function base64UrlEncode(string $data): string
    {
        return str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($data));
    }

    protected static function base64UrlDecode(string $data): string
    {
        return base64_decode(str_replace(['-', '_'], ['+', '/'], $data));
    }
}
