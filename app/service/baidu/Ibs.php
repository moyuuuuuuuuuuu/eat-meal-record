<?php

namespace app\service\baidu;

use app\service\BaseGuzzleHttpClient;
use GuzzleHttp\Client;

class Ibs extends BaseGuzzleHttpClient
{
    protected string $ak;

    public function __construct()
    {
        $this->client = new Client([
            'base_uri' => 'https://api.map.baidu.com/',
            'timeout'  => 10.0,
            'verify'   => false,
        ]);
        $this->ak     = getenv('IBS_AK');
    }

    public function getAddress(float $lat, float $lng)
    {
        $response = $this->client->get('reverse_geocoding/v3/', [
            'query' => [
                'ak'              => $this->ak,
                'location'        => "$lat,$lng",
                'output'          => 'json',
                'extensions_town' => 'true', // 是否需要镇/街道级别
            ]
        ]);

        $data = $this->handleResponse($response);
        if ($data['status'] === 0) {
            return $data['result'];
        }

        return null;
    }
}
