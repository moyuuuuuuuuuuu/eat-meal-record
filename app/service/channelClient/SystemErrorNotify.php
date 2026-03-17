<?php

namespace app\service\channelClient;

use app\service\MailService;
use support\Log;

/**
 * @deprecated
 */
class SystemErrorNotify extends BaseChannelClient
{
    public function run($message)
    {
        try {

            $data = json_decode($message, true);
            if (!$data) {
                Log::error('异常告警通知失败,为空的异常参数', []);
                return false;
            }
            // 3. 构建 HTML 内容
            $color = '#ff4d4f'; // 异常红色
            $bgColor = '#fff1f0';
            $currentDate = date('Y-m-d H:i:s');
            $markdown = <<<HTML
<div style="font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding: 20px; border: 1px solid #ffccc7; border-radius: 8px; background-color: #fffafb; max-width: 800px; color: #333;">
    <h3 style="margin-top: 0; color: {$color}; border-bottom: 2px solid #ffccc7; padding-bottom: 10px;">
        🚨 系统异常告警
    </h3>
    
    <div style="margin: 15px 0; padding: 10px; background-color: {$bgColor}; border-left: 4px solid {$color}; border-radius: 4px;">
        <strong style="color: #851d19;">环境:</strong> {$data['env']}<br/>
        <strong style="color: #851d19;">描述:</strong> <span style="color: {$color}; font-weight: bold;">{$data['msg']}</span>
    </div>

    <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 14px;">
     <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 8px 0; color: #888; width: 100px;">发生时间</td>
            <td style="padding: 8px 0;"><code>{$currentDate}</code></td>
        </tr>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 8px 0; color: #888; width: 100px;">追踪 ID</td>
            <td style="padding: 8px 0;"><code>{$data['trace_id']}</code></td>
        </tr>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 8px 0; color: #888;">异常位置</td>
            <td style="padding: 8px 0;"><code>{$data['file']}</code> (第 {$data['line']} 行)</td>
        </tr>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 8px 0; color: #888;">接口地址</td>
            <td style="padding: 8px 0; color: #1890ff;">{$data['url']}</td>
        </tr>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 8px 0; color: #888;">用户信息</td>
            <td style="padding: 8px 0;">ID: <strong>{$data['user_id']}</strong> | IP: {$data['ip']}</td>
        </tr>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 8px 0; color: #888;">处理耗时</td>
            <td style="padding: 8px 0;"><span style="color: #fa8c16;">{$data['duration']}</span></td>
        </tr>
    </table>

    <h4 style="margin-bottom: 8px; font-size: 15px; color: #555;">📥 请求参数:</h4>
    <pre style="background-color: #272822; color: #f8f8f2; padding: 15px; border-radius: 5px; font-size: 12px; overflow-x: auto; line-height: 1.5;">{$data['clientParams']}</pre>
    
    <p style="font-size: 12px; color: #999; margin-top: 20px; text-align: center;">
        此邮件由 Eat Clear 异常监控系统自动发出
    </p>
</div>
HTML;
            MailService::sendText('Eat Clear 系统异常告警', $markdown);
        } catch (\Exception $e) {
            Log::error('RedisSubscribe:dispatch:error:' . $e->getMessage(), $e->getTrace());
        }
    }
}
