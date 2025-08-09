<?php

namespace app\service;

use app\model\UserModel;
use Firebase\JWT\Key;
use function DI\string;

class Jwt
{
    /**
     * @param int $userId
     * @return array
     */
    static function encode(int $userId)
    {
        $key              = strval(env('JWT_KEY'));
        $payload          = [
            "iat"            => time(),
            "exp"            => time() + 7200,
            'user_id'        => $userId,
            'isRefreshToken' => false
        ];
        $token            = \Firebase\JWT\JWT::encode($payload, $key, 'HS256');
        $tokenInfo        = [
            'token'      => $token,
            'expireTime' => $payload['exp'],
        ];
        $payload['exp']   = time() + 86400 * 7;
        $refreshToken     = \Firebase\JWT\JWT::encode($payload, $key, 'HS256');
        $refreshTokenInfo = [
            'token'      => $refreshToken,
            'expireTime' => $payload['exp'],
        ];
        return [$tokenInfo, $refreshTokenInfo];
    }

    static function decode(string $token)
    {
        try {
            $key     = env('JWT_KEY');
            $decoded = \Firebase\JWT\JWT::decode($token, new Key((string)$key, 'HS256'));
            return $decoded;
        } catch (\Firebase\JWT\SignatureInvalidException $e) {
            throw new \Exception('token签名错误', 10005);
        } catch (\Firebase\JWT\ExpiredException $e) {
            throw new \Exception('token已过期', 10006);
        } catch (\Exception $e) {
            throw new \Exception($e->getMessage(), 10007);
        }
    }
}
