<?php

namespace app\model;

use app\model\BaseModel;
use app\model\interfaces\TargetModelInterface;

class FavoriteModel extends BaseModel implements interfaces\TargetModelInterface
{
    use traits\InteractiveTrait;

    protected $table    = 'favorite';
    protected $fillable = [
        'user_id',
        'type',
        'target',
    ];

    static function getTargetModel(int $type): string|null
    {
        return match ($type) {
            self::TYPE_BLOG => BlogModel::class,
            self::TYPE_FOOD => FoodModel::class,
            self::TYPE_RECIPE => null,
            self::TYPE_COMMENT => null,
            self::TYPE_USER => UserModel::class,
            default => null,
        };
    }

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
}
