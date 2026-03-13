<?php

namespace app\service;

use app\common\enum\BusinessCode;
use app\common\enum\NutritionInputType;
use app\common\enum\QueueEventName;
use app\common\exception\DataNotFoundException;
use app\service\coze\WorkFlow;
use support\exception\BusinessException;
use support\Log;
use Webman\RedisQueue\Client;

class FoodService
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
    static function nutrition(NutritionInputType $type, string $content)
    {
        if (!$content) {
            throw new DataNotFoundException('无数据');
        }
        $result = WorkFlow::instance()->run(getenv('COZE_NUTRITION_WORKFLOW_ID'), [$type->value => $content]);
        $result = $result['result'] ?? null;
        if (!$result) {
            throw new DataNotFoundException('无数据');
        }
        Log::channel('llm')->info('sync nutrition', [[$type->value => $content], $result]);
        return $result;
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
        $result = $result['result'] ?? null;
        if (!$result) {
            throw new DataNotFoundException('无数据');
        }
        $data = json_decode($result, true);

        Log::channel('llm')->info('sync tag', [$params, $data]);
        return $data;
    }

    static function unit(array $params)
    {
        if (count($params) > 35) {
            throw new BusinessException('单次视频数量不得超过35个', BusinessCode::THREE_PART_ERROR->value);
        }
        $params = [
            'input' => implode(',', $params),
        ];
        $result = WorkFlow::instance()->run(getenv('COZE_UNIT_WORKFLOW_ID'), $params);
        $result = $result['output'] ?? null;
        if (!$result) {
            throw new DataNotFoundException('无数据');
        }
        $data = json_decode($result, true);
        Log::channel('llm')->info('sync unti', [$params, $data]);
        return $data;
    }
}
