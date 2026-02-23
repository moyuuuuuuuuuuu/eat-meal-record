<?php

namespace app\queue;

use app\common\base\BaseConsumer;

/**
 * {
 * "code": 0,
 * "msg": "ok",
 * "count": 1,
 * "data": [
 * {
 * "id": 1,
 * "name": "default.png",
 * "url": "/app/admin/upload/files/20260223/699c1fcfd390.png",
 * "admin_id": 1,
 * "file_size": 5930,
 * "mime_type": "image/png",
 * "image_width": 108,
 * "image_height": 108,
 * "ext": "png",
 * "storage": "local",
 * "created_at": "2026-02-23 00:00:00",
 * "category": "",
 * "updated_at": "2026-02-23 00:00:00"
 * }
 * ]
 * }
 */
class UploadSyncJob extends BaseConsumer
{
    public $queue = 'upload_sync';

    public function consume($data)
    {

    }
}
