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

const taskModel = read("app/model/TaskModel.php");
expectContains("Task model user ownership", taskModel, "'user_id'");

const schema = read("eat_clear.sql");
expectContains("Task schema user ownership", schema, "`user_id` BIGINT NOT NULL");
expectContains("Task schema ownership index", schema, "INDEX `idx_user_task`");

const foodBusiness = read("app/business/FoodBusiness.php");
expectNotContains("AI quota should not be checked before enqueue", foodBusiness, "TokenLimit::instance()->hasQuota()");
expectContains("Task creation stores user_id", foodBusiness, "'user_id'    => $request->userInfo->id");

const taskConsumer = read("app/queue/TaskConsumeJob.php");
expectContains("AI quota checked when task starts", taskConsumer, "TokenLimit::instance()->hasQuota()");
expectContains("AI quota consumed before workflow call", taskConsumer, "TokenLimit::instance()->consumeQuota()");

const feedBusiness = read("app/business/FeedBusiness.php");
expectNotContains("Feed detail must not bypass visibility", feedBusiness, "BlogModel::find($blogId)");
expectContains("Feed visibility helper", feedBusiness, "visibleBlogQuery");

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
