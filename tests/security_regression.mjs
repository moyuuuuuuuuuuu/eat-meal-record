import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = dirname(dirname(fileURLToPath(import.meta.url)));
const failures = [];

const read = (path) => readFileSync(join(root, path), "utf8");
const expectContains = (label, haystack, needle) => {
  if (!haystack.includes(needle)) failures.push(`${label}: expected to contain ${needle}`);
};
const expectNotContains = (label, haystack, needle) => {
  if (haystack.includes(needle)) failures.push(`${label}: expected not to contain ${needle}`);
};
const sms = read("app/business/SmsBusiness.php");
expectNotContains("SMS debug gate", sms, "getenv('APP_DEBUG') && $code == 123123");
expectContains("SMS debug gate", sms, "config('app.debug') === true");

const taskController = read("app/controller/TaskController.php");
expectContains("Task ownership status query", taskController, "where('user_id', $request->userInfo->id)");
expectContains("Task ownership response query", taskController, "where('user_id', $request->userInfo->id)");
expectContains("Task query exposes interaction stage", taskController, "'stage' => $stage");
expectContains("Task failure exposes stable error code", taskController, "'errorCode'");
expectContains("Task failure exposes retryability", taskController, "'retryable'");

const taskModel = read("app/model/TaskModel.php");
expectContains("Task model user ownership", taskModel, "'user_id'");

const schema = read("eat_clear.sql");
expectContains("Task schema user ownership", schema, "`user_id` BIGINT NOT NULL");
expectContains("Task schema ownership index", schema, "INDEX `idx_user_task`");

const foodBusiness = read("app/business/FoodBusiness.php");
expectNotContains("AI quota should not be checked before enqueue", foodBusiness, "TokenLimit::instance()->hasQuota()");
expectContains("Task creation stores user_id", foodBusiness, "'user_id'    => $request->userInfo->id");
expectNotContains("Food API must not echo SQL", foodBusiness, "echo TaskModel::printSql");
expectNotContains("Food search must not echo queue status", foodBusiness, "echo '食品'");
expectContains("Tasks start in waiting state", foodBusiness, "'run_status' => TaskRunStatus::Waiting->value");

const taskConsumer = read("app/queue/TaskConsumeJob.php");
expectContains("AI quota consumed before workflow call", taskConsumer, "TokenLimit::instance()->consumeQuota()");
expectContains("Task is claimed conditionally", taskConsumer, "where('run_status', TaskRunStatus::Waiting->value)");
expectContains("Task retries are bounded", taskConsumer, "private const MAX_ATTEMPTS = 3");
expectContains("Stale running tasks are recoverable", taskConsumer, "private const RUNNING_TIMEOUT_MINUTES = 10");
expectContains("Exhausted stale tasks are finalized", taskConsumer, "任务执行超时且已达最大重试次数");
expectContains("Exhausted stale task cache is finalized", taskConsumer, "TaskCompleteStatus::Failed->value");
expectContains("Quota exhaustion has a stable error code", taskConsumer, "AI_QUOTA_EXHAUSTED");

const cozeWorkflow = read("app/service/coze/WorkFlow.php");
expectContains("Coze call leaves time before task lease expires", cozeWorkflow, "'timeout' => 480");

const foodController = read("app/controller/FoodController.php");
expectContains("AI quota can be shown before submit", foodController, "getQuotaInfo()");

const routes = read("config/route.php");
expectContains("AI quota route is available", routes, "Route::get('/recognize/quota'");

const feedBusiness = read("app/business/FeedBusiness.php");
expectNotContains("Feed detail must not bypass visibility", feedBusiness, "BlogModel::find($blogId)");
expectContains("Feed visibility helper", feedBusiness, "visibleBlogQuery");
expectContains("Feed record attachments require ownership", feedBusiness, "->where('user_id', $userId)");
expectContains("Feed visibility requires reverse follow", feedBusiness, "whereColumn($followTable . '.user_id', $blogTable . '.user_id')");
expectNotContains("Video poster must not replace attachment", feedBusiness, "$item['attach'] = '/' . ltrim($item['poster'], '/')");

const feedValidator = read("app/common/validate/FeedValidator.php");
expectContains("Topic input is validated with the API field name", feedValidator, "'topic.*'");
expectContains("Visibility participates in create validation", feedValidator, "'create' => ['content', 'visibility'");

const blogAttachFormat = read("app/format/BlogAttachFormat.php");
expectContains("Record attachment read is owner scoped", blogAttachFormat, "where('user_id', $this->blogOwnerId)");

const accessLog = read("app/middleware/AccessLog.php");
expectContains("Access log runs for successful and failed requests", accessLog, "finally {");
expectContains("Access log is written", accessLog, "Log::channel('access')->info");

const userInfo = read("app/common/context/UserInfo.php");
expectContains("Step cache uses relative TTL", userInfo, "Helper::todayEndTimestamp() - time()");

const baseBusiness = read("app/common/base/BaseBusiness.php");
expectContains("Base business model class property is declared", baseBusiness, "protected ?string $staticModelClass = null;");

const uploadController = read("app/controller/UploadController.php");
expectContains("Upload extension whitelist", uploadController, "$allowedExtensions");
expectContains("Upload size limit", uploadController, "getSize()");

const userInfoData = read("app/common/context/UserInfoData.php");
expectContains("Disabled users rejected from token context", userInfoData, "账号已被禁用");

if (failures.length) {
  console.error(failures.join("\n"));
  process.exit(1);
}

console.log("security regression checks passed");
