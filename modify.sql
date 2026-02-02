ALTER TABLE `wa_users` ADD COLUMN `openid` VARCHAR(64) NULL COMMENT '微信小程序openid' AFTER `id`;
ALTER TABLE `wa_users` ADD COLUMN `unionid` VARCHAR(64) NULL COMMENT '微信unionid' AFTER `openid`;
ALTER TABLE `wa_users` ADD INDEX `idx_openid` (`openid`);
ALTER TABLE `wa_users` ADD INDEX `idx_unionid` (`unionid`);



-- 初始化一些常用标签
INSERT INTO `tags` (`name`, `type`) VALUES ('早餐', 1), ('午餐', 1), ('晚餐', 1), ('加餐', 1);
INSERT INTO `tags` (`name`, `type`) VALUES ('低糖', 3), ('少油', 3), ('高蛋白', 3), ('健康脂肪', 3);
