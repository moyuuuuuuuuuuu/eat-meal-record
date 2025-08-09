<?php

namespace app\service;

use Elastic\Elasticsearch\Client;
use Elastic\Elasticsearch\ClientBuilder;

class ElasticSearch
{
    private static ?Client $client = null;

    // 初始化 client 单例
    public static function getClient(): Client
    {
        if (!self::$client) {
            self::$client = ClientBuilder::create()
                ->setHosts(['localhost:9200']) // 可换成你的 ES 地址数组
                ->build();
        }
        return self::$client;
    }

    // 普通查询
    public static function search(string $index, array $body): array
    {
        return self::getClient()->search([
            'index' => $index,
            'body'  => $body
        ]);
    }

    // 获取数量
    public static function count(string $index, array $body): int
    {
        $res = self::getClient()->count([
            'index' => $index,
            'body'  => $body
        ]);
        return $res['count'] ?? 0;
    }

    // 单条索引插入或更新
    public static function index(string $index, string $id, array $doc): array
    {
        return self::getClient()->index([
            'index' => $index,
            'id'    => $id,
            'body'  => $doc
        ]);
    }

    // 批量写入（插入或更新）
    public static function bulkIndex(string $index, array $docs, string $idField = 'id'): array
    {
        $params = ['body' => []];
        foreach ($docs as $doc) {
            $params['body'][] = [
                'index' => [
                    '_index' => $index,
                    '_id'    => $doc[$idField] ?? null,
                ]
            ];
            $params['body'][] = $doc;
        }

        return self::getClient()->bulk($params);
    }

    // 删除
    public static function delete(string $index, string $id): array
    {
        return self::getClient()->delete([
            'index' => $index,
            'id'    => $id
        ]);
    }
}
