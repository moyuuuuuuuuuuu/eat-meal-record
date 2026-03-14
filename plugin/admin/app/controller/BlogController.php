<?php

namespace plugin\admin\app\controller;

use app\model\BlogAttachModel;
use plugin\admin\app\model\Blog;
use plugin\admin\app\model\Food;
use plugin\admin\app\model\MealRecord;
use plugin\admin\app\model\User;
use support\Db;
use support\exception\BusinessException;
use support\Request;
use support\Response;

/**
 * 动态列表
 */
class BlogController extends Crud
{

    /**
     * @var Blog
     */
    protected $model = null;

    /**
     * 构造函数
     * @return void
     */
    public function __construct()
    {
        $this->model = new Blog;
    }

    /**
     * 浏览
     * @return Response
     */
    public function index(): Response
    {
        return view('blog/index');
    }

    public function detail(Request $request)
    {
    }

    /**
     * 插入
     * @param Request $request
     * @return Response
     * @throws BusinessException
     */
    public function insert(Request $request): Response
    {
        if ($request->method() === 'POST') {
            return parent::insert($request);
        }
        return view('blog/insert');
    }

    /**
     * 更新
     * @param Request $request
     * @return Response
     * @throws BusinessException
     */
    public function update(Request $request): Response
    {
        if ($request->method() === 'POST') {

            $id   = $request->post('id');
            $blog = Blog::find($id);

            if (!$blog) return json(['code' => 1, 'msg' => '博客不存在']);

            // 加载关联数据
            $blog->attaches = BlogAttachModel::where('blog_id', $id)->orderBy('sort', 'asc')->get()->map(function ($item) {
                // 动态加载关联实体详情
                if ($item->type == 3) {
                    $item->food_info = Food::query()->where('id', $item->attach)->first();
                } elseif ($item->type == 5) {
                    $item->meal_info = MealRecord::query()->where('id', $item->attach)->first();
                }
                return $item;
            });

            $blog->location = Db::table('blog_locations')->where('blog_id', $id)->first();
            $blog->topics   = Db::table('blog_topics as bt')
                ->join('topics as t', 'bt.topic_id', '=', 't.id')
                ->where('bt.blog_id', $id)
                ->select('t.name', 't.id')
                ->get();

            return json(['code' => 0, 'data' => $blog]);
        }
        return view('blog/update');
    }

    protected function afterQuery($items)
    {
        $userInfoList = User::query()->whereIn('id', array_column($items, 'user_id'))->get(['avatar', 'id', 'nickname', 'username'])->transform(function ($item) {
            $item->avatar = source($item->avatar);
            return $item;
        })->keyBy('id')->toArray();
        foreach ($items as &$item) {
            $item['visibility_info'] = Blog::getVisibility($item['visibility']);
            $item['userInfo']        = $userInfoList[$item['user_id']];
        }
        return $items;
    }
}
