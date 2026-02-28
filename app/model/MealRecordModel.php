<?php

namespace app\model;


use app\business\FoodBusiness;
use app\common\base\BaseModel;
use app\common\enum\MealRecordType;
use app\util\Calculate;
use Illuminate\Database\Eloquent\Casts\Attribute;

class MealRecordModel extends BaseModel
{
    protected $table      = 'meal_records';
    protected $primaryKey = 'id';
    protected $fillable   = [
        'user_id',
        'type',
        'nutrition',
        'meal_date',
        'latitude',
        'longitude',
        'address',
    ];
    protected $casts      = [
        'nutrition' => 'json',
        'user_id'   => 'integer',
        'type'      => 'integer',
        'meal_date' => 'date',
        'latitude'  => 'float',
        'longitude' => 'float',
        'address'   => 'string',
    ];

    public function foods()
    {
        return $this->hasMany(MealRecordFoodModel::class, 'meal_id', 'id')->with(['food','unit']);
    }

    public function meals()
    {
        return $this->hasMany(MealRecordFoodModel::class, 'meal_id', 'id')->with(['food','unit']);
    }

    /**
     * 获取用户今日摄入的卡路里总计
     * @param int|string $userId
     * @return string
     */
    public static function getTodayIntake($userId): string
    {
        if (!$userId) {
            return '0.00';
        }

        $records = self::query()
            ->where('user_id', $userId)
            ->where('meal_date', date('Y-m-d'))
            ->get(['nutrition']);

        $totalKcal = '0.00';
        foreach ($records as $record) {
            $kcal = $record->nutrition['kcal'] ?? 0;
            $totalKcal = Calculate::add($totalKcal, (string)$kcal, 2);
        }

        return $totalKcal;
    }

    protected function type(): Attribute
    {
        return Attribute::make(
            get: function ($value) {
                return MealRecordType::tryFrom($value)->label();
            });
    }
}
