<?php

namespace app\model;

use support\Redis;

class TopicModel extends BaseModel
{
    const STATUS_NORMAL = 1;
    protected $table    = 'topic';
    protected $fillable = ['title', 'description', 'join_count', 'post_count', 'cover_image', 'creator_id', 'status'];

    /**
     * 获取热门话题列表
     * @param $limit
     * @return array|mixed[]
     */
    static function getHotTopicList($limit)
    {
        $topicIdList = [];
        $redisKey    = 'topic:hotList';
        if (Redis::exists($redisKey)) {
            $topicIdListArray = Redis::zRange($redisKey, 0, $limit, true);
            $topicIdList      = array_keys($topicIdListArray);
        }
        $topicList = [];
        if (!empty($topicIdList)) {
            foreach ($topicIdList as $topicId) {
                $topicList[] = self::getTopicInfoById($topicId, true);
            }
        }

        if (empty($topicList) || count($topicList) < $limit) {
            $existsTopicIdList = [];
            if ($topicList) {
                $existsTopicIdList = array_map(function ($item) {
                    return $item['id'];
                }, $topicList);
            }
            $where = [
                ['status', '=', self::STATUS_NORMAL],
            ];
            if ($existsTopicIdList) {
                $where[] = ['id', 'not in', $existsTopicIdList];
            }
            $reduceTopicList = self::query()->select(['title', 'id', 'description', 'join_count', 'post_count', 'created_at'])->where($where)->orderBy('join_count', 'desc')->limit($limit - count($topicList))->get();
            if ($reduceTopicList->isEmpty()) {
                return $topicList;
            }
            foreach ($reduceTopicList as $topic) {
                self::setHotTopic($topic->id, $topic->join_count);
            }
            $topicList = array_merge($topicList, $reduceTopicList->toArray());
        }

        return $topicList;
    }

    static function getTopicInfoById(int $topicId, $isHot = false)
    {
        $redisKey = 'topic:info:' . $topicId;
        if (Redis::exists($redisKey)) {
            return Redis::hGetAll($redisKey);
        }
        $topicInfo = self::select(['title', 'id', 'description', 'join_count', 'post_count', 'created_at'])->find($topicId);
        if (!$topicInfo) {
            return [];
        }
        Redis::hMSet($redisKey, $topicInfo->toArray());
        if ($isHot) {
            self::setHotTopic($topicId, $topicInfo->join_count);
        }
        return $topicInfo->toArray();
    }

    /**
     * @param int $topicId 话题ID
     * @param int $score 热度
     * @return
     */
    static function setHotTopic(int $topicId, int $score, $isIncrBy = false)
    {
        $redisKey = 'topic:hotList';
        if ($isIncrBy) {
            return Redis::zIncrBy($redisKey, $topicId, $score);
        }
        return Redis::zAdd($redisKey, $score, $topicId);
    }

    /**
     * @param int $topicId 话题ID
     * @return int
     */
    static function getHotTopicScore(int $topicId): int
    {
        $redisKey = 'topic:hotList';
        return Redis::zScore($redisKey, $topicId);
    }
}
