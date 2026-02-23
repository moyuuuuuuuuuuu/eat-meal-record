<?php

namespace app\business;

use app\common\base\BaseBusiness;
use support\Request;

class PetBusiness extends BaseBusiness
{
    /**
     * 根据状态查找宠物
     */
    public function findByStatus(Request $request): array
    {
        // 模拟 mock 结构
        return [
            [
                'id' => 1,
                'name' => '旺财',
                'status' => 'available',
                'photoUrls' => ['https://example.com/pet1.jpg'],
                'tags' => [['id' => 1, 'name' => '可爱']]
            ]
        ];
    }

    public function detail(int $id)
    {
        return [
            'id' => $id,
            'name' => '旺财',
            'category' => ['id' => 1, 'name' => '狗'],
            'status' => 'available'
        ];
    }

    public function add(array $data)
    {
        return array_merge(['id' => time()], $data);
    }
}
