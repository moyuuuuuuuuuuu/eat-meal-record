# 换设备交接记录

记录时间：2026-09-21（Asia/Shanghai）。用户要求“做记录，准备更换设备”。本次只整理交接，不发布扣子、不提交推送、不迁移数据库。

## 后续更新：Git换机保存

用户随后明确要求“推送到远端吧”，已授权把两仓库的既有代码修复、测试、设计图和文档分别提交到`origin/main`、`origin/uni`。本文件下方关于“未提交”的描述及两份status文件是**推送前历史快照**；新设备应以这两个远端分支最新提交为准，不停留在下表旧HEAD。扣子发布仍未获确认，Git推送不代表发布工作流或部署应用。

本轮提交前重新执行：用户端12项Node测试通过；服务端9项隔离测试通过（旧设备PHP 8.3 WASM临时运行时，不是线上Webman验收）；扣子Python校验8项通过。`.env`、私钥、依赖安装目录、上传数据与本机CodeGraph/DS_Store缓存不随此次项目提交保存。新设备仍需配置环境与安装依赖。

本轮另执行`pnpm build:h5`和`pnpm build:mp-weixin`，两者均构建成功。构建产生的三个临时声明/页面配置文件变动已恢复，未混入提交。已有mp-html类型检查问题并未因此修复，也尚未进行真机、线上接口或数据库验收。

## 先读这里

当前有两条工作线：个人版用户端改版已完成设计与实施拆分，业务改版尚未按清单落地；扣子四个工作流已完成优化草稿与小样本回归，**均未发布到线上**。上一轮询问是否发布，用户尚未确认；换设备请求不是发布授权。

## 仓库与本地文件

| 仓库 | 当前设备路径 | 分支 | HEAD |
|---|---|---|---|
| 服务端 | `/Users/moyuu/projects/dnmp/www/eat-meal-record` | `main` | `534fdf372e73dfcbb4f52f4ecbbf73fbe801ec1a` |
| 用户端 | `/Users/moyuu/projects/dnmp/www/eat-meal-record-ui` | `uni` | `1ccb218547c58556b6be95a72ff42732f312b081` |

两个仓库均有既有修改。完整状态快照见同目录 `backend-status.txt` 和 `frontend-status.txt`，这是交接时的清单，不是备份或补丁。不要覆盖、清理、reset或把既有修改都归为扣子优化所做。

**仅在新设备clone/pull无法取得当前未提交内容。** 同步时需要保留两个项目的工作目录，尤其未跟踪文件；也可以后续明确整理提交推送，但本次没有执行。本文和状态快照本身同样尚未提交。实际换机复制、远端同步均未执行。

重点保留：

- 服务端 `docs/performance/`、`docs/handoff/`、`tests/coze_validator_test.py`，以及原有未提交源码、`tests/run.php`、`tests/config/`。
- 用户端 `docs/product/`、`output/ui-study-2026-09-20/` 全部设计资源、`tests/`、`src/utils/aiRecognitionTask.ts`，以及原有未提交源码与package配置。
- `.env`、私钥等环境配置不包含在交接文档里，不应复制进文档或提交到Git；新设备的本地环境单独配置。
- `/tmp/eat-meal-review-php/` 是旧设备临时运行时，不能假设新设备存在；浏览器标签ID、工具会话变量、localhost服务也不可跨设备复用。

## UI决策与交付位置

用户选定03自然有机风，绿色、暖白、留白。食品信息不带缩略图、食品装饰图标或缺图占位；AI上传图、头像与文章媒体仍按业务需要使用。

个人资质小程序，当前以个人记录为主，底部“首页 / 我的”。社区、会员、支付留档后续实现，不纳入本期。食谱先留构思文档，暂不开发。

用户端的权威文档：

1. `docs/product/personal-record-roadmap.md`：当前范围与延期功能。
2. `docs/product/recipe-concept.md`：食谱构思。
3. `docs/product/personal-record-implementation-plan.md`：逐页面落地、D0—D4批次和验收矩阵。
4. `docs/product/personal-record-api-contract.md`：接口及数据约定。

最新20张个人版页面设计在 `output/ui-study-2026-09-20/personal-v1/`，风格参考在 `round-2/03-natural-organic.png`。旧 `organic-pages/` 中仍有社区设计，不能据此扩大本期范围。

恢复本地设计预览，在用户端目录运行：

```sh
python3 -m http.server 8128 --bind 127.0.0.1 --directory output/ui-study-2026-09-20
```

打开 `http://127.0.0.1:8128/personal-v1/#23-food-source`。8128只是旧设备预览端口，若冲突可换端口。

UI后续从D0开始：保护既有修改、复现类型检查问题、核对API与数据库基线，然后D1做主题和记餐主流程。不得把20张效果图当作已经上线的功能或20个独立路由。既有AI任务恢复、账号隔离和验证器修复要保留。

此前验证记录：用户端12项Node测试通过；`pnpm type-check`在mp-html的node.vue报TS1005等错误，未解决；未完成本轮H5/微信构建、真机或线上接口验收。换设备后需重新建立运行环境，不能直接沿用“当前通过”的表述。

## 扣子优化的最终状态

详情与失败候选记录见 [coze-workflows.md](../performance/coze-workflows.md)。以下是上一轮扣子后台真实试运行结果，不是本次换机记录时重新运行，也不是长期P95保证。

| 工作流 | 同组3种食品：优化前 → 草稿 | 补充回归 |
|---|---|---|
| food_nutrition | 54秒 → 18秒 | 10条连续两次47秒、46秒；均10/10、11项营养完整 |
| food_unit | 19秒 → 2秒 | 10条4秒 |
| food_tag | 16秒 → 2秒 | 10条5秒 |
| nutrition的文字节点 | 22秒 → 13秒 | 另一段4种食品17秒 |

工作空间 `7501669478888325132`，同一扣子账号登录后从编辑链接恢复：

- [food_nutrition](https://www.coze.cn/work_flow?workflow_id=7678227370758701056&space_id=7501669478888325132)
- [food_unit](https://www.coze.cn/work_flow?workflow_id=7678228107732975659&space_id=7501669478888325132)
- [food_tag](https://www.coze.cn/work_flow?workflow_id=7678227858040389667&space_id=7501669478888325132)
- [nutrition](https://www.coze.cn/work_flow?workflow_id=7678222288558637065&space_id=7501669478888325132)

四个草稿均已自动保存，最终模型未更换。单位、标签和文字节点关闭深度思考。nutrition的图片、音频分支未改、未测，不得宣称这两条已优化。

food_nutrition仍用Pro、回复4096、续写关闭、不重试，关闭深度思考；内部输出改为原生食品数组、紧凑11字段nutrition对象、tags的type/values数组。JSON校验节点统一转换回原后端契约：`output`是JSON字符串、nutrition是name/value数组、tags是中文类型字典。接口未改，11字段不能为了速度删减。

配套恢复资产必须一起使用：

- `docs/performance/food-nutrition-prompt.txt`：系统提示词；用户提示词仍为`{{input}}`。
- `docs/performance/food-nutrition-schema-example.json`：仅用于JSON导入生成结构，不是营养数据源；nutrition各字段和weight应为Number。
- `docs/performance/food-nutrition-validator.py`：最终Python校验代码。
- `tests/coze_validator_test.py`：离线回归，运行`python3 tests/coze_validator_test.py`，上一轮8项通过。

原先非法JSON会返回`[]`伪装成成功，现改为明确异常。不要恢复“关闭思考+旧String长JSON”的失败候选，虽然个别跑到12—14秒，但批量出现格式错误。合法空数组仍保留原契约，字段不全条目仍按原规则过滤。

限制：35条上限未验；目前已验10条。营养数值没有经过权威数据校准；原校验器两位小数可能将极小mg值舍为0，这一数据质量问题已记录，未在本轮扩改。服务端debug_url、分阶段耗时日志、重复调用治理只是已审查的后续事项，尚未实现，不得记为完成。

## 下一台设备继续顺序

1. 确认两个工作目录含上述未提交/未跟踪文件，对照分支、HEAD和状态快照；不假设Git远端已同步。
2. 阅读本交接和UI实施清单，恢复设计预览与基本测试环境。
3. 登录同一扣子账号，核对四个草稿的保存状态与当前发布版本。不要依赖旧设备标签或重新做一遍已通过的探索。
4. 若用户确认发布四个草稿，再执行发布并记下版本/时间；随后验证真实后端接口和小程序的结果、错误状态与耗时。此前未确认发布，不能将换机请求视为批准。
5. UI按D0→D1继续；社区/会员/支付/食谱保持已定边界。新增任务或用户改变优先级时以用户最新要求为准。

可直接交给新设备助手的继续提示：

> 继续eat-meal-record项目。先读服务端docs/handoff/2026-09-21-device-switch.md和用户端docs/product/personal-record-implementation-plan.md，保护两个仓库的既有未提交修改。UI是绿色自然有机风、食品无缩略图，社区会员支付与食谱不进入本期。扣子四个优化草稿已保存但未发布，先核对当前状态；发布尚待我的明确确认。不要重复试验失败的旧JSON字符串方案。
