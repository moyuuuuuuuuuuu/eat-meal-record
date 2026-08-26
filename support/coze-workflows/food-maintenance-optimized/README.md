# 食品维护工作流优化包

本目录包含三个独立的扣子工作流。扣子每次导入一个工作流 ZIP，请不要直接导入汇总包。

## 工作流与项目配置

| ZIP | 工作流名称 | 项目环境变量 | 对外输出 |
| --- | --- | --- | --- |
| `Workflow-food_nutrition-optimized.zip` | `food_nutrition` | `COZE_FOOD_NUTRITION_WORKFLOW_ID` | `output` |
| `Workflow-food_unit-optimized.zip` | `food_unit` | `COZE_UNIT_WORKFLOW_ID` | `output` |
| `Workflow-food_tag-optimized.zip` | `food_tag` | `COZE_TAG_WORKFLOW_ID` | `result` |

三个工作流均保留原始名称、开始节点 `input` 参数和既有输出字段，避免破坏 `FoodService` 调用契约。导入会生成新的工作流 ID；发布后应分别更新对应环境变量。

## 输入格式

优化后的项目代码会把批量食物名称编码为 JSON 数组字符串，例如：

```json
["八宝粥","水煮鸡蛋"]
```

工作流要求返回的 `food` 或 `name` 必须与输入字符串完全一致，项目端也会再次按原始请求名称过滤，防止模型改名后更新错误食品。

## 关键优化

- 结构化任务温度由 `0.5` 调低至 `0.2`。
- 每个工作流增加末端 JSON 清洗与业务字段校验代码节点。
- 营养统一为每 100g 可食部数据，与 `food_nutrients` 和 `NutritionTemplate::calculate()` 一致。
- 单位强制合法枚举、正克重和唯一默认单位；不可靠份量回退为“克 = 1g”。
- 标签只允许项目 `FoodTag` 对应的 11 种标准类型，并统一为“类型 => 标签数组”。
- 项目端增加第二层校验，兼容 Markdown、`data/foods` 包装和 `result/output` 字段差异。

## 导入顺序

1. 分别导入三个独立 ZIP。
2. 检查导入后的模型节点可用性。
3. 使用两个以上食物名称试运行，确认输出名称与输入完全一致。
4. 发布三个工作流。
5. 更新三个环境变量并重启相关 Webman/队列进程。
6. 先用少量缺失数据执行健康检查，确认单位、标签及营养均正确后再批量运行。
