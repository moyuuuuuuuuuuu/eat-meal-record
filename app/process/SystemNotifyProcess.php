<?php

namespace app\process;

use app\common\enum\ChannelEventName;
use app\service\MailService;
use Channel\Client;
use support\Log;
use Workerman\Worker;

class SystemNotifyProcess
{
    public function onWorkerStart(Worker $worker): void
    {
        Client::connect('127.0.0.1', 2206);
        Client::on(ChannelEventName::SystemErrorNotify->value, fn($data) => $this->run($data));
    }

    private function run($data)
    {
        try {
            if (!$data) {
                Log::error('异常告警通知失败,为空的异常参数', []);
                return false;
            }

            $color   = '#ff4d4f';
            $bgColor = '#fff1f0';

            $stackTrace = htmlspecialchars($data['stack_trace'] ?? '无堆栈信息');

            $markdown = <<<HTML
<div style="font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding: 20px; border: 1px solid #ffccc7; border-radius: 8px; background-color: #fffafb; max-width: 900px; color: #333; margin: 0 auto;">
    <h3 style="margin-top: 0; color: {$color}; border-bottom: 2px solid #ffccc7; padding-bottom: 10px;">
        🚨 Eat Clear 系统异常告警
    </h3>
    
    <div style="margin: 15px 0; padding: 15px; background-color: {$bgColor}; border-left: 4px solid {$color}; border-radius: 4px;">
        <div style="margin-bottom: 5px;"><strong style="color: #851d19;">环境:</strong> {$data['env']}</div>
        <div style="font-size: 16px;"><strong style="color: #851d19;">描述:</strong> <span style="color: {$color}; font-weight: bold;">{$data['msg']}</span></div>
    </div>

    <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 14px;">
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 10px 0; color: #888; width: 120px;">发生时间</td>
            <td style="padding: 10px 0; font-family: monospace;">{$data['time']}</td>
        </tr>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 10px 0; color: #888;">追踪 ID</td>
            <td style="padding: 10px 0; font-family: monospace;">{$data['trace_id']}</td>
        </tr>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 10px 0; color: #888;">异常位置</td>
            <td style="padding: 10px 0;"><code>{$data['file']}</code> <span style="color: #cf1322; font-weight: bold;">(L{$data['line']})</span></td>
        </tr>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 10px 0; color: #888;">接口/环境</td>
            <td style="padding: 10px 0; color: #1890ff;">{$data['url']}</td>
        </tr>
        <tr style="border-bottom: 1px solid #eee;">
            <td style="padding: 10px 0; color: #888;">上下文</td>
            <td style="padding: 10px 0;">用户ID: <strong>{$data['user_id']}</strong> | IP: {$data['ip']} | 耗时: <span style="color: #fa8c16;">{$data['duration']}</span></td>
        </tr>
    </table>

    <h4 style="margin-bottom: 8px; font-size: 15px; color: #555; display: flex; align-items: center;">📥 请求参数 (Request Params):</h4>
    <pre style="background-color: #272822; color: #f8f8f2; padding: 15px; border-radius: 5px; font-size: 12px; overflow-x: auto; overflow-y: auto; max-height: 400px; line-height: 1.5; margin-bottom: 20px; white-space: pre-wrap; word-break: break-all;">{$data['clientParams']}</pre>
    
    <h4 style="margin-bottom: 8px; font-size: 15px; color: #555;">🔍 堆栈详情 (Stack Trace):</h4>
    <div style="background-color: #f0f0f0; border: 1px solid #d9d9d9; padding: 15px; border-radius: 5px; font-size: 11px; color: #666; font-family: 'Courier New', Courier, monospace; white-space: pre-wrap; word-break: break-all; max-height: 400px; overflow-y: auto; line-height: 1.4;">{$stackTrace}</div>
    
    <p style="font-size: 12px; color: #999; margin-top: 30px; text-align: center; border-top: 1px dashed #eee; padding-top: 15px;">
        此邮件由 Eat Clear 异常监控系统自动发出
    </p>
</div>
HTML;
            MailService::sendText('Eat Clear 系统异常告警', $markdown);
        } catch (\Exception $e) {
            Log::error('SystemNotifyProcess:error:' . $e->getMessage(), ['html' => $markdown]);
        }
    }
}
