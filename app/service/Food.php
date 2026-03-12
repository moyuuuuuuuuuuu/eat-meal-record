<?php

namespace app\service;

use app\common\enum\NutritionInputType;
use app\common\exception\DataNotFoundException;
use app\service\coze\WorkFlow;

class Food
{
    /**
     * @param array{
     *      text:string,
     *      image:string,
     *      audio:string
     *  } $params
     * @return array
     * @throws \Exception
     */
    static function nutrition(string $content, NutritionInputType $type)
    {
        if (!$content) {
            throw new DataNotFoundException('无数据');
        }
        $result = WorkFlow::instance()->run(getenv('COZE_NUTRITION_WORKFLOW_ID'), [$type->value => $content]);
        if (!isset($result)) {
            throw new DataNotFoundException('无数据');
        }
        return json_decode($result['result'], true);
    }

    /**
     * @param string[] $params
     * @return array
     * @throws \Exception
     */
    static function tag(array $params)
    {
        $params = [
            'input' => implode(',', $params),
        ];
        $result = WorkFlow::instance()->run(getenv('COZE_TAG_WORKFLOW_ID'), $params);
        var_dump($result);
        return json_decode($result['result'], true);
    }
}
