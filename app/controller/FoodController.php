<?php

namespace app\controller;

use app\model\FoodModel;
use app\model\MealRecordFoodModel;
use app\service\nutrition\Nutrition;
use Illuminate\Database\Query\Builder;
use support\Request;

class FoodController extends BaseController
{
    public function index(Request $request, int $type = 0)
    {
        $keyword = $request->getParam('keyword', '');
        $page    = $request->getParam('page', 1, 'i');
        $limit   = $request->getParam('limit', 20, 'i');
        $where   = [
            ['status', '=', FoodModel::STATUS_NORMAL]
        ];
        if ($keyword) {
            $where[] = ['name', 'like', "%$keyword%"];
        }
        $model    = FoodModel::where($where);
        $foodList = $model->with(['nutrition'])->offset(($page - 1) * $limit)->limit($limit)->get();
        if ($foodList->isEmpty() && !empty($keyword) && $type == 0) {
            //从第三方获取
            if (FoodModel::searchRemoteFoodByName($keyword)) {
                $foodList = $model->with(['nutrition'])->offset(($page - 1) * $limit)->limit($limit)->get();
            } else {
                return $this->error(10005, '未查询到相关食物，请与我们联系。');
            }
        }
        $maxPage = 0;
        if ($page === 1) {
            $total   = $model->count();
            $maxPage = ceil($total / $limit);
        }
        return $this->success('', ['list' => $foodList->toArray(), 'maxPage' => $maxPage, 'currentPage' => $page]);
    }

    public function history(Request $request)
    {
        $keyword = $request->getParam('keyword', '');
        $page    = $request->getParam('page', 1);
        $limit   = $request->getParam('limit', 20);
        $where   = [
            ['status', '=', FoodModel::STATUS_NORMAL]
        ];
        if ($keyword) {
            $where[] = ['name', 'like', "%$keyword%"];
        }
        $query    = FoodModel::whereIn('id', function (Builder $query) use ($request) {
            $query->from('meal_record_food')->select(['food_id'])->where('user_id', $request->userId)->groupBy('food_id');
        })
            ->where($where)
            ->with(['nutrition'])
            ->offset(($page - 1) * $limit)
            ->limit($limit)
            ->orderBy('id', 'desc');
        $foodList = $query->get();
        if ($foodList->isEmpty()) {
            return $this->success('', ['list' => [], 'currentPage' => $page, 'maxPage' => 0]);
        }
        $maxPage = 0;
        if ($page === 1) {
            $total   = $query->count();
            $maxPage = ceil($total / $limit);
        }
        return $this->success('', ['list' => $foodList->toArray(), 'maxPage' => $maxPage, 'currentPage' => $page]);
    }

    public function analysis(Request $request)
    {
        $filePath = $request->getParam('path', '');
        if (str_contains($filePath, 'http://') || str_contains($filePath, 'https://')) {
            $fileContent = file_get_contents($filePath);
            if (!$fileContent) {
                return $this->error(1005, '文件内容为空');
            }
        } else {
            if (!file_exists(public_path($filePath))) {
                return $this->error(1005, '文件不存在');
            }
            $fileContent = file_get_contents(public_path($filePath));
        }
        $foodIdList = FoodModel::searchRemoteFoodByImageContent($fileContent);
        if (empty($foodIdList)) {
            return $this->error(1005, '未识别到任何食物');
        }
        sort($foodIdList);
        $foodList = FoodModel::whereIn('id', $foodIdList)->with(['nutrition'])->get();
        return $this->success('已找到以下结果', ['list' => $foodList->toArray()]);
    }
}
