<?php

namespace app\service;

use app\common\enum\NutritionInputType;
use app\common\exception\DataNotFoundException;
use app\service\coze\WorkFlow;
use app\service\coze\WorkflowResultNormalizer;
use app\common\exception\BusinessException;
use support\Log;

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
    static function nutrition(string $type, string $content)
    {
        $type = NutritionInputType::tryFrom($type);
        if (!$type) {
            throw new BusinessException('不支持的输入类型');
        }
        if (!$content) {
            throw new DataNotFoundException('无数据');
        }
        $result = WorkFlow::instance()->run(getenv('COZE_NUTRITION_WORKFLOW_ID'), [$type->value => $content]);
        $result = $result['result'] ?? null;
        if (!$result) {
            throw new DataNotFoundException('无数据');
        }
        Log::channel('llm')->info('sync nutrition', [[$type->value => $content], $result]);
        return json_decode($result, true);
    }

    /**
     * @param string[] $params
     * @return array
     * @throws \Exception
     */
    static function tag(array $params)
    {
        $names = WorkflowResultNormalizer::normalizeNames($params);
        $request = ['input' => json_encode($names, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR)];
        $response = WorkFlow::instance()->run(getenv('COZE_TAG_WORKFLOW_ID'), $request);
        $data = WorkflowResultNormalizer::tags(
            WorkflowResultNormalizer::decode($response, ['result', 'output']),
            $names
        );
        Log::channel('llm')->info('sync tag', [$request, $data]);
        return $data;
    }

    static function unit(array $params)
    {
        $names = WorkflowResultNormalizer::normalizeNames($params);
        $request = ['input' => json_encode($names, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR)];
        $response = WorkFlow::instance()->run(getenv('COZE_UNIT_WORKFLOW_ID'), $request);
        $data = WorkflowResultNormalizer::units(
            WorkflowResultNormalizer::decode($response, ['output', 'result']),
            $names
        );
        Log::channel('llm')->info('sync unit', [$request, $data]);
        return $data;
    }

    static function nutritionForFood(array $params)
    {
        $names = WorkflowResultNormalizer::normalizeNames($params);
        $request = ['input' => json_encode($names, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR)];
        $response = WorkFlow::instance()->run(getenv('COZE_FOOD_NUTRITION_WORKFLOW_ID'), $request);
        $data = WorkflowResultNormalizer::nutrition(
            WorkflowResultNormalizer::decode($response, ['output', 'result']),
            $names
        );
        Log::channel('llm')->info('sync nutrition-for-food', [$request, $data]);
        return $data;
    }
}
