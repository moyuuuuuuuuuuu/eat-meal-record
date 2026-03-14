<?php

namespace app\controller;

use app\business\NutritionStatsBusiness;
use app\common\base\BaseController;
use app\service\NutritionStatsService;
use support\Request;
use support\Response;

/**
 * 营养统计控制器
 *
 * 路由建议（config/route.php）：
 *   Route::group('/api/nutrition', function () {
 *       Route::get('/stats', [NutritionStatsController::class, 'stats']);
 *   })->middleware([AuthMiddleware::class]);
 */
class NutritionStatsController extends BaseController
{

    /**
     * 获取营养统计数据
     *
     * GET /api/nutrition/stats?period=week
     *
     * @param period  string  week | month | quarter | year
     *
     * 响应示例：
     * {
     *   "code": 0,
     *   "data": {
     *     "period": "week",
     *     "date_range": { "start": "2025-03-08", "end": "2025-03-14" },
     *     "nutrition": { "kcal": 1720.5, "pro": 48.2, ... },
     *     "score": 82,
     *     "score_level": "良好"
     *   },
     *   "msg": "ok"
     * }
     */
    public function stats(Request $request): Response
    {
        $userId = $request->userInfo->id;

        $period = $request->get('period', 'week');
        if (!in_array($period, ['week', 'month', 'quarter', 'year'])) {
            return json(['code' => 400, 'msg' => 'period 参数无效', 'data' => null]);
        }

        $result = NutritionStatsBusiness::instance()->getStats($period);

        return json(['code' => 0, 'data' => $result, 'msg' => 'ok']);
    }
}
