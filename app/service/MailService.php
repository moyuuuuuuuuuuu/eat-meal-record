<?php

namespace app\service;

use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mailer\Transport;
use Symfony\Component\Mime\Email;

class MailService
{
    /**
     * 发送文本邮件
     *
     * @param string $subject
     * @param string $content
     * @param string|null $to
     * @return void
     * @throws \Symfony\Component\Mailer\Exception\TransportExceptionInterface
     */
    public static function sendText(string $subject, string $content, string $to = null)
    {
        $host = getenv('SMTP_HOST');
        if (!$host) {
            return;
        }

        $port     = getenv('SMTP_PORT') ?: 465;
        $username = getenv('SMTP_USERNAME');
        $password = getenv('SMTP_PASSWORD');
        $from     = getenv('SMTP_FROM_ADDRESS');
        $to       = $to ?: getenv('SMTP_TO_ADDRESS');

        $dsn = sprintf(
            'smtps://%s:%s@%s:%s',
            urlencode($username),
            urlencode($password),
            $host,
            $port
        );

        $transport = Transport::fromDsn($dsn);
        $mailer    = new Mailer($transport);

        $email      = (new Email())
            ->from($from)
            ->to($to)
            ->subject($subject);
        $hasHtmlTag = self::hasHtmlTags($content);
        if (!$hasHtmlTag) {
            $email->text($content);
        } else {
            $email->html($content);
        }

        $mailer->send($email);
    }

    protected static function hasHtmlTags($string): bool
    {
        return $string !== strip_tags($string);
    }
}
