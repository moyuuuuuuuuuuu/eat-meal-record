<?php

namespace app\model;


use app\model\interfaces\TargetModelInterface;

class LikeModel extends BaseModel implements TargetModelInterface
{
    protected $table = 'likes';

    protected $fillable = [
        'user_id',
        'type',
        'target',
        'type'
    ];

    /**
     * 获取指定用户的点赞数量
     * @param int $userId
     * @return int
     */
    static function getCount(int $userId, int $type = 1): int
    {
        if (!in_array($type, [self::TYPE_BLOG, self::TYPE_FOOD, self::TYPE_RECIPE, self::TYPE_COMMENT, self::TYPE_USER])) {
            throw new \Exception('参数错误');
        }
        return self::query()->where('user_id', $userId)->where('type', $type)->count();
    }


    /**
     * 获取点赞目标模型
     * @param int $type
     * @return string|null
     */
    static function getTargetModel(int $type): string|null
    {
        return match ($type) {
            self::TYPE_TOPIC => TopicModel::class,
            self::TYPE_BLOG => BlogModel::class,
            self::TYPE_FOOD => FoodModel::class,
            self::TYPE_RECIPE => null,
            self::TYPE_COMMENT => null,
            self::TYPE_USER => UserModel::class,
        };
    }

    static function getTargetIdList(int $userId, int $id, int $type, $isBuildSql = false)
    {
        $query = self::query()->where('user_id', $userId)->where('type', $type);
        if ($isBuildSql) {
            return $query->where('target', $id)->pluck('target');
        }
        return $query->where('target', $id)->get()->pluck('target')->toArray();
    }
}
