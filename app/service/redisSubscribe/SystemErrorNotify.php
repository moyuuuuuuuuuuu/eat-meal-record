<?php

namespace app\service\redisSubscribe;

use app\service\MailService;
use support\Log;

class SystemErrorNotify extends BaseRedisSubscribe
{
    public function run($message)
    {
        try {

            $data = json_decode($message, true);
            if (!$data) {
                Log::error('异常告警通知失败,为空的异常参数', []);
                return false;
            }
            // 3. 构建 Markdown 内容 (以钉钉/企业微信为例)
            $markdown = "### 🚨 系统异常告警\n" .
                        "> **{$data['env']}**\n\n" .
                        "**描述**: <font color=\"#ff0000\">{$data['msg']}</font>\n\n" .
                        "--- \n" .
                        "- **追踪 ID**: `{$data['trace_id']}`\n" .
                        "- **位置**: `{$data['file']}` 第 `{$data['line']}` 行\n" .
                        "- **接口**: {$data['url']}\n" .
                        "- **用户**: ID(`{$data['user_id']}`) | IP(`{$data['ip']}`)\n" .
                        "- **耗时**: `{$data['duration']}`\n" .
                        "--- \n" .
                        "#### 📥 请求参数\n" .
                        "```json\n" . $data['clientParams'] . "\n```";
            echo '异常来喽' . PHP_EOL;
            echo $markdown;
            MailService::sendText('Eat Clear 系统异常告警', $markdown);
        } catch (\Exception $e) {
            Log::error('RedisSubscribe:dispatch:error:' . $e->getMessage(), $e->getTrace());
        }
    }
}
