ALTER TABLE `tasks`
    ADD COLUMN `user_id` BIGINT NULL COMMENT '用户ID' AFTER `task_id`;

UPDATE `tasks`
SET `user_id` = CAST(JSON_UNQUOTE(JSON_EXTRACT(`additional`, '$.userId')) AS UNSIGNED)
WHERE `user_id` IS NULL
  AND JSON_EXTRACT(`additional`, '$.userId') IS NOT NULL;

UPDATE `tasks`
SET `user_id` = 0
WHERE `user_id` IS NULL;

ALTER TABLE `tasks`
    MODIFY COLUMN `user_id` BIGINT NOT NULL COMMENT '用户ID' AFTER `task_id`,
    ADD INDEX `idx_user_task` (`user_id`, `task_id`);
