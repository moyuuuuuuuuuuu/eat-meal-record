<?php

namespace app\controller;

use app\model\MealRecordFoodModel;
use app\model\MealRecordModel;
use app\model\UserModel;
use app\service\wechat\WxMini;
use support\Db;
use support\Log;
use support\Request;
use support\Response;
use Webman\RedisQueue\Client;

class MealController extends BaseController
{

    /**
     * 获取当前用户的饮食统计
     * @param Request $request
     * @return Response
     */
    public function currentStatistics(Request $request)
    {

        $userId = $request->userId;
        $target = 1500;
        $data   = [
            'target'     => [
                'kal'     => $target,
                'protein' => ceil($target * 0.15 / 4),
                'fat'     => ceil($target * 0.25 / 9),
                'carbo'   => ceil($target * 0.6 / 4),
            ],
            'reduceKcal' => $target,
            'inKcal'     => 0,
            'outKcal'    => 0,
            'current'    => [
                'kal'     => 0,
                'protein' => 0,
                'fat'     => 0,
                'carbo'   => 0,
            ],
        ];

        if (!$userId) {
            return $this->success('', $data);
        }
        $code          = $request->post('code', '');
        $encryptedData = $request->post('encryptedData', '');
        $iv            = $request->post('iv', '');

        try {
            $userInfo = UserModel::getUserInfo($userId);
            if ($encryptedData && $iv && $code && $userInfo) {
                $jscode2Session = WxMini::getInstance()->jsCode2Session($code);
                $sessionKey     = $jscode2Session['sessionKey'];
                $stepInfoList   = WxMini::getInstance()->parseEncryptData($encryptedData, $sessionKey, $iv);
                if ($stepInfoList) {
                    $stepInfo        = $stepInfoList['stepInfoList'];
                    $stepInfo        = end($stepInfo);
                    $data['outKcal'] = ceil(UserModel::calcKcalWithStepNumber($userInfo['tall'], $userInfo['weight'], $userInfo['gender'], $stepInfo['step']));
                }
            }
        } catch (\Exception $e) {
            Log::error($e->getMessage(), $e->getTrace());
        }
        $currentList = MealRecordFoodModel::selectRaw('sum(kal) as kal,sum(fat) as fat,sum(protein) as protein,sum(carbo) as carbo')
            ->where('user_id', $userId)
            ->whereDate('created_at', date('Y-m-d'))
            ->first();
        if (!$currentList) {
            $currentList = [
                'kal'     => 0,
                'protein' => 0,
                'fat'     => 0,
                'carbo'   => 0,
            ];
        } else {
            $currentList = $currentList->toArray();
        }

        foreach ($currentList as &$v) {
            $v = $v ?? 0;
        }

        $target = $userInfo->target;
        $data   = [
            'target'     => [
                'kal'     => $target,
                'protein' => ceil($target * 0.15 / 4),
                'fat'     => ceil($target * 0.25 / 9),
                'carbo'   => ceil($target * 0.6 / 4),
            ],
            'reduceKcal' => $target - $currentList['kal'],
            'inKcal'     => $currentList['kal'] ?? 0,
            'current'    => $currentList,
        ];
        return $this->success('', $data);
    }

    /**
     * 获取当前用户今日的饮食记录
     * @param Request $request
     * @return Response
     */
    public function today(Request $request)
    {
        $userId = $request->userId;
        if (!$userId) {
            return $this->success('用户信息不存在', []);
        }
        $today          = date("Y-m-d");
        $mealRecordList = MealRecordModel::with('foods')
            ->where('user_id', $userId)
            ->whereDate('created_at', $today)
            ->get();
        $recordList     = [];
        foreach ($mealRecordList as $record) {
            $recordList[] = [
                'id'    => $record->id,
                'type'  => $record->type,
                'kal'   => $record->kal,
                'foods' => $record->foods,
            ];
        }
        return $this->success('', $recordList);
    }

    /**
     * 创建饮食记录
     * @param Request $request
     * @return Response
     */
    public function create(Request $request)
    {
        $type       = $request->post('type');
        $recordList = $request->post('record', []);
        $location   = $request->post('location', []);
        Db::beginTransaction();
        try {
            $today       = date("Y-m-d");
            $currentDate = date('Y-m-d H:i:s');

            $recordInfo = MealRecordModel::where('user_id', $request->userId)
                ->where('type', $type)
                ->whereDate('created_at', $today)
                ->first();

            $recordFoodList = [];
            $recordData     = [
                'kal'     => 0,
                'protein' => 0,
                'fat'     => 0,
                'carbo'   => 0,
                'sugar'   => 0,
                'fiber'   => 0,
            ];
            $foodIdList     = [];
            foreach ($recordList as $item) {
                if (!$item['food_id']) {
                    throw new \Exception('请选择食物');
                }
                $foodIdList[] = $item['food_id'];
                if (!$item['unit_id']) {
                    throw new \Exception('请选择单位');
                }
                if (!$item['number']) {
                    throw new \Exception('请输入数量');
                }
                $recordData['kal']     += $item['kal'];
                $recordData['protein'] += $item['protein'];
                $recordData['fat']     += $item['fat'];
                $recordData['carbo']   += $item['carbo'];
                $recordData['sugar']   += $item['sugar'];
                $recordData['fiber']   += $item['fiber'];
                $item['created_at']    = $currentDate;
                $item['updated_at']    = $currentDate;
                $item['user_id']       = $request->userId;
                $item                  = array_merge($item, $location);
                $recordFoodList[]      = $item;
            }
            if (!$recordInfo) {
                $recordData = array_merge($recordData, [
                    'type'      => $type,
                    'user_id'   => $request->userId,
                    'meal_date' => date('Y-m-d'),
                ]);
                $recordInfo = MealRecordModel::create($recordData);
                if (!$recordInfo) {
                    throw new \Exception('添加饮食记录失败');
                }
            } else {
                $recordInfo->updated_at = $currentDate;
                $recordInfo->kal        += $recordData['kal'];
                $recordInfo->protein    += $recordData['protein'];
                $recordInfo->fat        += $recordData['fat'];
                $recordInfo->carbo      += $recordData['carbo'];
                $recordInfo->sugar      += $recordData['sugar'];
                $recordInfo->fiber      += $recordData['fiber'];
                $recordInfo->save();
                $recordInfo->refresh();
            }

            foreach ($recordFoodList as &$item) {
                $item['meal_id'] = $recordInfo->id;
                if (isset($item['id'])) {
                    $where = [['id' => $item['id']]];
                } else {
                    $where = [
                        ['meal_id', '=', $item['meal_id']],
                        ['food_id', '=', $item['food_id']],
                        ['unit_id', '=', $item['unit_id']],
                        ['user_id', '=', $item['user_id']],
                        ['created_at', 'between', [$today . ' 00:00:00', $currentDate]],
                    ];
                }
                $recordFoodInfo = MealRecordFoodModel::where($where)->first();
                if ($recordFoodInfo) {
                    if ($recordFoodInfo->save($item)) {
                        unset($item);
                    }
                }
            }
            if (!MealRecordFoodModel::insert($recordFoodList)) {
                throw new \Exception('创建饮食记录明细失败');
            }
            #TODO:计算今日卡路里、脂肪、碳水、蛋白质等值
            Db::commit();
            return $this->success('已记录');
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('创建失败饮食记录失败：' . $e->getMessage(), ['trace' => $e->getTrace()]);
            return $this->error(1004, $e->getMessage());
        }
    }
}
