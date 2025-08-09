<?php

namespace app\controller;

use app\controller\BaseController;
use app\model\MealRecordFoodModel;
use app\model\MealRecordModel;
use Illuminate\Database\Query\Builder;
use support\Request;

class UserController extends BaseController
{
    public function mealRecord(Request $request)
    {
        $userId         = $request->userId;
        $page           = $request->get('page', 1);
        $limit          = $request->get('limit', 10);
        $mealRecordList = MealRecordModel::where('user_id', $userId)->with([
            'foods' => function ($query) {
                $query->select(['id', 'name', 'address', 'image', 'latitude', 'longitude', 'number', 'meal_id', 'food_id', 'unit_id', 'user_id', 'kal', 'protein', 'fat', 'carbo', 'sugar', 'fiber']);
            }
        ])->offset(($page - 1) * $limit)->limit($limit)->get();
        if ($mealRecordList->isEmpty()) {
            return $this->success('', ['list' => []]);
        }

        $mealRecordList->each(function (&$item) {
            $item->foods->each(function (&$food) {
                $food->image = MealRecordModel::getImageUrl($food->image);
            });
        });
        $maxPage = 0;
        if ((int)$page === 1) {
            $total   = MealRecordModel::where('user_id', $userId)->count();
            $maxPage = ceil($total / $limit);
        }
        return $this->success('', ['list' => $mealRecordList->toArray(), 'maxPage' => $maxPage, 'currentPage' => $page]);
    }
}
