<?php

namespace app\util;

class Jwt
{
    /**
     * @var string
     */
    protected static $key;

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
        
        if ($exp) {
            $payload['exp'] = time() + $exp;
        }
        $payload['iat'] = time();
        
        $base64UrlHeader = static::base64UrlEncode($header);
        $base64UrlPayload = static::base64UrlEncode(json_encode($payload));
        
        $signature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, static::getKey(), true);
        $base64UrlSignature = static::base64UrlEncode($signature);
        
        return $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;
    }

    /**
     * 解码 JWT Token
     *
     * @param string $token
     * @return array|null
     */
    public static function decode(string $token): ?array
    {
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            return null;
        }
        
        list($base64UrlHeader, $base64UrlPayload, $base64UrlSignature) = $parts;
        
        $signature = static::base64UrlDecode($base64UrlSignature);
        $expectedSignature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, static::getKey(), true);
        
        if (!hash_equals($signature, $expectedSignature)) {
            return null;
        }
        
        $payload = json_decode(static::base64UrlDecode($base64UrlPayload), true);
        
        if (isset($payload['exp']) && $payload['exp'] < time()) {
            return null;
        }
        
        return $payload;
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

    protected static function base64UrlEncode(string $data): string
    {
        return str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($data));
    }

    protected static function base64UrlDecode(string $data): string
    {
        return base64_decode(str_replace(['-', '_'], ['+', '/'], $data));
    }
}
