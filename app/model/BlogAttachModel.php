<?php

namespace app\model;

use app\model\BaseModel;

class BlogAttachModel extends BaseModel
{
    const TYPE_OTHER       = 0;
    const TYPE_IMAGE       = 1;
    const TYPE_VIDEO       = 2;
    const TYPE_FOOD        = 3;
    const TYPE_RECIPE      = 4;
    const TYPE_MEAL_RECORD = 5;
    const TYPE_LIST        = [
        'attach',
        'attach',
        'attach',
        'food',
        'recipe',
        'records',
    ];
    protected $table    = 'blog_attach';
    protected $fillable = [
        'blog_id',
        'poster',
        'type',
        'attach',
        'sort',
    ];

    static function getType(string $type)
    {
        switch ($type) {
            case 'image':
                return self::TYPE_IMAGE;
            case 'video':
                return self::TYPE_VIDEO;
            case 'food':
                return self::TYPE_FOOD;
            case 'recipe':
                return self::TYPE_RECIPE;
            case 'meal':
                return self::TYPE_MEAL_RECORD;
            default:
                return 0;
        }
    }

    static function handle(array $attachList, string $type, int $blogId)
    {
        $newAttachList = [];
        foreach ($attachList as $key => $attach) {
            if ($type === 'file') {
                $ext = substr($attach, strrpos($attach, '.') + 1);
                if (in_array($ext, ['jpg', 'jpeg', 'png', 'gif'])) {
                    $attachType = self::TYPE_IMAGE;
                } else if (in_array($ext, ['mp4', 'avi', 'mov'])) {
                    $attachType = self::TYPE_VIDEO;
                } else {
                    $attachType = self::TYPE_OTHER;
                }
            } else {
                $attachType = self::getType($type);
            }
            $newAttachList[] = [
                'blog_id' => $blogId,
                'type'    => $attachType,
                'attach'  => $attach,
                'poster'  => '',
                'sort'    => $key,
            ];
        }
        return $newAttachList;
    }

    static function getAttachList($attachList = null)
    {
        if (!($attachList)) {
            return [];
        }
        if ($attachList instanceof BlogAttachModel) {
            $attachList = $attachList->toArray();
        }
        $newAttachList = [];
        foreach (self::TYPE_LIST as $type) {
            $newAttachList[$type] = [];
        }
        foreach ($attachList as $item) {
            if ($item['type'] == self::TYPE_OTHER) {
                $item['attach'] = self::getAttacheUrl($item['attach']);
            } else if ($item['type'] == self::TYPE_IMAGE) {
                $item['attach'] = self::getAttacheUrl($item['attach']);
            } else if ($item['type'] == self::TYPE_VIDEO) {
                $item['attach'] = self::getAttacheUrl($item['attach']);
                $item['poster'] = self::getAttacheUrl($item['poster']);
            } else if ($item['type'] == self::TYPE_FOOD) {
                $item['attach_data'] = FoodModel::query()->selectRaw('*,' . $item['type'] . ' as attach_type')->with('nutrition')->where('id', $item['attach'])->first()->toArray();
            } else if ($item['type'] == self::TYPE_RECIPE) {
                $item['attach_data'] = [];
            } else if ($item['type'] == self::TYPE_MEAL_RECORD) {
                $item['attach_data'] = MealRecordModel::query()->selectRaw('*,' . $item['type'] . ' as attach_type')->with('foods')->where('id', $item['attach'])->first()->toArray();
            }
            if (isset($item['attach_data'])) {
                $newAttachList[BlogAttachModel::TYPE_LIST[$item['type']]][] = $item['attach_data'];
                continue;
            }
            $item['attach_type']                                        = $item['type'];
            $newAttachList[BlogAttachModel::TYPE_LIST[$item['type']]][] = $item;
        }
        return $newAttachList;
    }

    /**
     * 视频附件
     * @param $item
     */
    protected static function buildVideoAttach($item)
    {
        $item['attach'] = self::getAttacheUrl($item['attach']);
        $item['poster'] = self::getAttacheUrl($item['poster']);
        return $item;
    }

    /**
     * 食物附件
     * @param $item
     */
    protected static function buildFoodAttach($item)
    {
        $item['attach_data'] = FoodModel::query()->with('nutrition')->where('id', $item['attach'])->first()->toArray();
        return $item;
    }

    /**
     * 菜谱附件
     * @param $item
     */
    protected static function buildRecipeAttach($item)
    {
        return $item;
    }

    /**
     * 饮食记录附件
     * @param $item
     */
    protected static function buildMealRecordAttach($item)
    {
        $item['attach_data'] = MealRecordModel::where('id', $item['attach'])->with([
            'foods' => function ($query) {
                $query->select(['id', 'name', 'address', 'image', 'latitude', 'longitude', 'number', 'meal_id', 'food_id', 'unit_id', 'user_id', 'kal', 'protein', 'fat', 'carbo', 'sugar', 'fiber']);
            }
        ])->first()->toArray();
        return $item;
    }


}
