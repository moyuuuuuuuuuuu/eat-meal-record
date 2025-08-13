<?php

namespace app\controller;

use app\controller\BaseController;
use app\model\FollowModel;
use app\model\MealRecordFoodModel;
use app\model\MealRecordModel;
use app\model\UserBodyHistoryModel;
use app\model\UserModel;
use Illuminate\Database\Query\Builder;
use support\Db;
use support\Log;
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
        ])->offset(($page - 1) * $limit)->limit($limit)->orderBy('created_at', 'desc')->get();
        if ($mealRecordList->isEmpty()) {
            return $this->success('', ['list' => []]);
        }

        $mealRecordList->each(function (&$item) {
            if (!$item->foods) {
                $item->foods = collect([]);
            } else {
                $item->foods->each(function (&$food) {
                    $food->image = MealRecordModel::getImageUrl($food->image);
                });
            }
        });
        $maxPage = 0;
        if ((int)$page === 1) {
            $total   = MealRecordModel::where('user_id', $userId)->count();
            $maxPage = ceil($total / $limit);
        }
        return $this->success('', ['list' => $mealRecordList->toArray(), 'maxPage' => $maxPage, 'currentPage' => $page]);
    }

    public function body(Request $request)
    {
        $userId   = $request->userId;
        $bodyData = $request->input('body', []);
        if (!$bodyData) {
            return $this->error('请填写信息');
        }
        $userBodyInfo = UserModel::where('id', $userId)->select(['tall', 'weight', 'bmi', 'bust', 'waist', 'hip'])->first();
        $historyData  = [];
        if ($userBodyInfo->tall) {
            $historyData = [
                'tall'    => $userBodyInfo->tall,
                'weight'  => $userBodyInfo->weight,
                'bmi'     => $userBodyInfo->bmi,
                'bust'    => $userBodyInfo->bust,
                'waist'   => $userBodyInfo->waist,
                'hip'     => $userBodyInfo->hip,
                'user_id' => $userId
            ];
        }
        Db::beginTransaction();
        try {

            $res = $userBodyInfo->save([
                'tall'   => $bodyData['tall'],
                'weight' => $bodyData['weight'],
                'bmi'    => $bodyData['bmi'],
                'bust'   => $bodyData['bust'],
                'waist'  => $bodyData['waist'],
                'hip'    => $bodyData['hip'],
            ]);
            if (!$res) {
                throw new \Exception('保存身材信息失败');
            }
            if ($historyData) {
                $historyRes = UserBodyHistoryModel::create($historyData);
                if (!$historyRes) {
                    throw new \Exception('保存身材信息失败');
                }
            }
            Db::commit();
            return $this->success('已保存');
        } catch (\Exception $e) {
            Db::rollback();
            Log::error('用户体信息保存失败', ['userId' => $userId, 'bodyData' => $bodyData, 'error' => $e->getMessage(), 'tarce' => $e->getTrace()]);
            return $this->error('保存信息失败');
        }
    }


    public function fans(Request $request)
    {
        $userId   = $request->userId;
        $fansList = FollowModel::geFansList($userId);
        return $this->success('', ['list' => $fansList->toArray()]);
    }

    public function follow(Request $request)
    {
        $userId     = $request->userId;
        $followList = FollowModel::getFollowerList($userId);
        return $this->success('', ['list' => $followList->toArray()]);
    }

    public function friend(Request $request)
    {
        $userId     = $request->userId;
        $friendList = FollowModel::geFansList($userId, true);
        return $this->success('', ['list' => $friendList->toArray()]);
    }
}
