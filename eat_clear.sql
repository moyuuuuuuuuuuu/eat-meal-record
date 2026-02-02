SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;
-- eat_clear DDL
CREATE DATABASE `eat_clear`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;;
use `eat_clear`;
-- eat_clear.cats DDL
CREATE TABLE `eat_clear`.`cats`
(
    `id`         BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `name`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "分类名称",
    `pid`        BIGINT                                                        NULL DEFAULT 0 Comment "上级分类",
    `sort`       INT                                                           NULL Comment "排序",
    `created_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) Comment "编辑时间",
    UNIQUE INDEX `name` (`name` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 39
  ROW_FORMAT = Dynamic COMMENT = "食品分类";
-- eat_clear.food_units DDL
CREATE TABLE `eat_clear`.`food_units`
(
    `id`         INT UNSIGNED                                                  NOT NULL AUTO_INCREMENT Comment "主键ID",
    `food_id`    INT UNSIGNED                                                  NOT NULL Comment "食物ID",
    `unit_id`    INT UNSIGNED                                                  NOT NULL Comment "单位ID",
    `weight`     DECIMAL(10, 2)                                                NOT NULL Comment "换算重量 (1单位 ≈ ? g)",
    `is_default` TINYINT(1)                                                    NOT NULL DEFAULT 0 Comment "是否为默认单位",
    `remark`     VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL Comment "备注 (如: 杯(约250ml))",
    INDEX `fk_foodunit_unit` (`unit_id` ASC) USING BTREE,
    UNIQUE INDEX `uk_food_unit` (`food_id` ASC, `unit_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = Dynamic COMMENT = "食物单位换算关系表";
-- eat_clear.foods DDL
CREATE TABLE `eat_clear`.`foods`
(
    `id`         INT UNSIGNED                                                  NOT NULL AUTO_INCREMENT Comment "食物ID",
    `name`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL Comment "食物名称",
    `cat_id`     INT UNSIGNED                                                  NULL Comment "食物分类",
    `user_id`    INT UNSIGNED                                                  NULL Comment "所属用户",
    `status`     TINYINT                                                       NOT NULL DEFAULT 1 Comment "状态",
    `nutrition`  JSON                                                          NULL Comment "每100g的营养信息",
    `created_at` TIMESTAMP                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` TIMESTAMP                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) Comment "更新时间",
    `delete_at`  TIMESTAMP                                                     NULL,
    INDEX `idx_cat_id` (`cat_id` ASC) USING BTREE,
    INDEX `idx_name` (`name` ASC, `status` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = Dynamic COMMENT = "食物基础信息与营养表";
-- eat_clear.units DDL
CREATE TABLE `eat_clear`.`units`
(
    `id`         INT UNSIGNED                                                                                                   NOT NULL AUTO_INCREMENT Comment "单位ID",
    `name`       VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci                                                   NOT NULL Comment "单位名称",
    `type`       ENUM ("weight","count","volume","package","service","length") CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL Comment "单位类型 ",
    `desc`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci                                                  NULL Comment "描述",
    `created_at` TIMESTAMP                                                                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` TIMESTAMP                                                                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) Comment "更新时间",
    `delete_at`  TIMESTAMP                                                                                                      NULL,
    INDEX `idx_type` (`type` ASC) USING BTREE,
    UNIQUE INDEX `uk_name` (`name` ASC, `type` ASC, `delete_at` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = Dynamic COMMENT = "计量单位表";
-- eat_clear.wa_admin_roles DDL
CREATE TABLE `eat_clear`.`wa_admin_roles`
(
    `id`       INT NOT NULL AUTO_INCREMENT Comment "主键",
    `role_id`  INT NOT NULL Comment "角色id",
    `admin_id` INT NOT NULL Comment "管理员id",
    UNIQUE INDEX `role_admin_id` (`role_id` ASC, `admin_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 2
  ROW_FORMAT = Dynamic COMMENT = "管理员角色表";
-- eat_clear.wa_admins DDL
CREATE TABLE `eat_clear`.`wa_admins`
(
    `id`         INT UNSIGNED                                                  NOT NULL AUTO_INCREMENT Comment "ID",
    `username`   VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL Comment "用户名",
    `nickname`   VARCHAR(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL Comment "昵称",
    `password`   VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL Comment "密码",
    `avatar`     VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/app/admin/avatar.png' Comment "头像",
    `email`      VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL Comment "邮箱",
    `mobile`     VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NULL Comment "手机",
    `created_at` DATETIME                                                      NULL Comment "创建时间",
    `updated_at` DATETIME                                                      NULL Comment "更新时间",
    `login_at`   DATETIME                                                      NULL Comment "登录时间",
    `status`     TINYINT                                                       NULL Comment "禁用",
    UNIQUE INDEX `username` (`username` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 2
  ROW_FORMAT = Dynamic COMMENT = "管理员表";
-- eat_clear.wa_options DDL
CREATE TABLE `eat_clear`.`wa_options`
(
    `id`         INT UNSIGNED                                                  NOT NULL AUTO_INCREMENT,
    `name`       VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL Comment "键",
    `value`      LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci     NOT NULL Comment "值",
    `created_at` DATETIME                                                      NOT NULL DEFAULT '2022-08-15 00:00:00' Comment "创建时间",
    `updated_at` DATETIME                                                      NOT NULL DEFAULT '2022-08-15 00:00:00' Comment "更新时间",
    UNIQUE INDEX `name` (`name` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 13
  ROW_FORMAT = Dynamic COMMENT = "选项表";
-- eat_clear.wa_roles DDL
CREATE TABLE `eat_clear`.`wa_roles`
(
    `id`         INT UNSIGNED                                                 NOT NULL AUTO_INCREMENT Comment "主键",
    `name`       VARCHAR(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL Comment "角色组",
    `rules`      TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci        NULL Comment "权限",
    `created_at` DATETIME                                                     NOT NULL Comment "创建时间",
    `updated_at` DATETIME                                                     NOT NULL Comment "更新时间",
    `pid`        INT UNSIGNED                                                 NULL Comment "父级",
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 2
  ROW_FORMAT = Dynamic COMMENT = "管理员角色";
-- eat_clear.wa_rules DDL
CREATE TABLE `eat_clear`.`wa_rules`
(
    `id`         INT UNSIGNED                                                  NOT NULL AUTO_INCREMENT Comment "主键",
    `title`      VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL Comment "标题",
    `icon`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL Comment "图标",
    `key`        VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL Comment "标识",
    `pid`        INT UNSIGNED                                                  NULL     DEFAULT 0 Comment "上级菜单",
    `created_at` DATETIME                                                      NOT NULL Comment "创建时间",
    `updated_at` DATETIME                                                      NOT NULL Comment "更新时间",
    `href`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL Comment "url",
    `type`       INT                                                           NOT NULL DEFAULT 1 Comment "类型",
    `weight`     INT                                                           NULL     DEFAULT 0 Comment "排序",
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 63
  ROW_FORMAT = Dynamic COMMENT = "权限规则";
-- eat_clear.wa_uploads DDL
CREATE TABLE `eat_clear`.`wa_uploads`
(
    `id`           INT                                                           NOT NULL AUTO_INCREMENT Comment "主键",
    `name`         VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL Comment "名称",
    `url`          VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL Comment "文件",
    `admin_id`     INT                                                           NULL Comment "管理员",
    `file_size`    INT                                                           NOT NULL Comment "文件大小",
    `mime_type`    VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL Comment "mime类型",
    `image_width`  INT                                                           NULL Comment "图片宽度",
    `image_height` INT                                                           NULL Comment "图片高度",
    `ext`          VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL Comment "扩展名",
    `storage`      VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'local' Comment "存储位置",
    `created_at`   DATE                                                          NULL Comment "上传时间",
    `category`     VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL Comment "类别",
    `updated_at`   DATE                                                          NULL Comment "更新时间",
    INDEX `admin_id` (`admin_id` ASC) USING BTREE,
    INDEX `category` (`category` ASC) USING BTREE,
    INDEX `ext` (`ext` ASC) USING BTREE,
    INDEX `name` (`name` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  ROW_FORMAT = Dynamic COMMENT = "附件";
-- eat_clear.wa_users DDL
CREATE TABLE `eat_clear`.`wa_users`
(
    `id`         INT UNSIGNED                                                    NOT NULL AUTO_INCREMENT Comment "主键",
    `username`   VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NOT NULL Comment "用户名",
    `nickname`   VARCHAR(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NOT NULL Comment "昵称",
    `password`   VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL Comment "密码",
    `sex`        ENUM ("0","1") CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' Comment "性别",
    `avatar`     VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NULL Comment "头像",
    `email`      VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NULL Comment "邮箱",
    `mobile`     VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NULL Comment "手机",
    `level`      TINYINT                                                         NOT NULL DEFAULT 0 Comment "等级",
    `birthday`   DATE                                                            NULL Comment "生日",
    `money`      DECIMAL(10, 2)                                                  NOT NULL DEFAULT 0.00 Comment "余额(元)",
    `score`      INT                                                             NOT NULL DEFAULT 0 Comment "积分",
    `last_time`  DATETIME                                                        NULL Comment "登录时间",
    `last_ip`    VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NULL Comment "登录ip",
    `join_time`  DATETIME                                                        NULL Comment "注册时间",
    `join_ip`    VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NULL Comment "注册ip",
    `token`      VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NULL Comment "token",
    `created_at` DATETIME                                                        NULL Comment "创建时间",
    `updated_at` DATETIME                                                        NULL Comment "更新时间",
    `role`       INT                                                             NOT NULL DEFAULT 1 Comment "角色",
    `status`     TINYINT                                                         NOT NULL DEFAULT 0 Comment "禁用",
    INDEX `email` (`email` ASC) USING BTREE,
    INDEX `join_time` (`join_time` ASC) USING BTREE,
    INDEX `mobile` (`mobile` ASC) USING BTREE,
    UNIQUE INDEX `username` (`username` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci
  AUTO_INCREMENT = 1
  ROW_FORMAT = Dynamic COMMENT = "用户表";
-- eat_clear.food_units Constraints
ALTER TABLE `eat_clear`.`food_units`
    ADD CONSTRAINT `fk_foodunit_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_foodunit_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
-- eat_clear.cats DML
INSERT INTO `eat_clear`.`cats` (`id`, `name`, `pid`, `sort`, `created_at`, `updated_at`)
VALUES (39, '水果', NULL, 0, '2026-01-30 13:49:55', '2026-01-30 13:49:55');
-- eat_clear.foods DML
INSERT INTO `eat_clear`.`foods` (`id`, `name`, `cat_id`, `user_id`, `status`, `nutrition`, `created_at`, `updated_at`,
                                 `delete_at`)
VALUES (1, '苹果', 39, NULL, 1, '{
  "fat": "0",
  "iron": "",
  "kcal": "100",
  "zinc": "",
  "fiber": "0",
  "sugar": "0",
  "folate": "",
  "iodine": "",
  "sodium": "0",
  "calcium": "",
  "protein": "0",
  "selenium": "",
  "vitaminA": "",
  "vitaminC": "",
  "vitaminD": "",
  "vitaminE": "",
  "vitaminK": "",
  "magnesium": "",
  "potassium": "",
  "vitaminB1": "",
  "vitaminB6": "",
  "vitaminB12": "",
  "cholesterol": "",
  "carbohydrate": "0"
}', '2026-01-30 14:51:38', '2026-01-30 14:51:38', NULL);
-- eat_clear.wa_admin_roles DML
INSERT INTO `eat_clear`.`wa_admin_roles` (`id`, `role_id`, `admin_id`)
VALUES (1, 1, 1);
-- eat_clear.wa_admins DML
INSERT INTO `eat_clear`.`wa_admins` (`id`, `username`, `nickname`, `password`, `avatar`, `email`, `mobile`,
                                     `created_at`, `updated_at`, `login_at`, `status`)
VALUES (1, 'root', '超级管理员', '$2y$10$XY8TsUeBsoT2NTRv5xfHJ.mlGd7haTZl5hd8U5Mo0NtyhQSyXk6Gq',
        '/app/admin/avatar.png', NULL, NULL, '2026-01-29 18:10:38', '2026-01-29 18:10:50', '2026-01-29 18:10:50', NULL);
-- eat_clear.wa_options DML
INSERT INTO `eat_clear`.`wa_options` (`id`, `name`, `value`, `created_at`, `updated_at`)
VALUES (1, 'system_config',
        '{"logo":{"title":"\\u98df\\u523b\\u8f7b\\u5361","image":"\\/app\\/admin\\/admin\\/images\\/logo.png","icp":"","beian":"","footer_txt":""},"menu":{"data":"\\/app\\/admin\\/rule\\/get","accordion":true,"collapse":false,"control":false,"controlWidth":2000,"select":0,"async":true},"tab":{"enable":true,"keepState":true,"preload":true,"session":true,"max":"30","index":{"id":"0","href":"\\/app\\/admin\\/index\\/dashboard","title":"\\u4eea\\u8868\\u76d8"}},"theme":{"defaultColor":"2","defaultMenu":"light-theme","defaultHeader":"light-theme","allowCustom":true,"banner":false},"colors":[{"id":"1","color":"#36b368","second":"#f0f9eb"},{"id":"2","color":"#2d8cf0","second":"#ecf5ff"},{"id":"3","color":"#f6ad55","second":"#fdf6ec"},{"id":"4","color":"#f56c6c","second":"#fef0f0"},{"id":"5","color":"#3963bc","second":"#ecf5ff"}],"other":{"keepLoad":"500","autoHead":false,"footer":false},"header":{"message":false}}',
        '2022-12-05 14:49:01', '2026-01-30 14:24:50'),
       (2, 'table_form_schema_wa_users',
        '{"id":{"field":"id","_field_id":"0","comment":"主键","control":"inputNumber","control_args":"","list_show":true,"enable_sort":true,"searchable":true,"search_type":"normal","form_show":false},"username":{"field":"username","_field_id":"1","comment":"用户名","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"nickname":{"field":"nickname","_field_id":"2","comment":"昵称","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"password":{"field":"password","_field_id":"3","comment":"密码","control":"input","control_args":"","form_show":true,"search_type":"normal","list_show":false,"enable_sort":false,"searchable":false},"sex":{"field":"sex","_field_id":"4","comment":"性别","control":"select","control_args":"url:\\/app\\/admin\\/dict\\/get\\/sex","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"avatar":{"field":"avatar","_field_id":"5","comment":"头像","control":"uploadImage","control_args":"url:\\/app\\/admin\\/upload\\/avatar","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"email":{"field":"email","_field_id":"6","comment":"邮箱","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"mobile":{"field":"mobile","_field_id":"7","comment":"手机","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"level":{"field":"level","_field_id":"8","comment":"等级","control":"inputNumber","control_args":"","form_show":true,"searchable":true,"search_type":"normal","list_show":false,"enable_sort":false},"birthday":{"field":"birthday","_field_id":"9","comment":"生日","control":"datePicker","control_args":"","form_show":true,"searchable":true,"search_type":"between","list_show":false,"enable_sort":false},"money":{"field":"money","_field_id":"10","comment":"余额(元)","control":"inputNumber","control_args":"","form_show":true,"searchable":true,"search_type":"normal","list_show":false,"enable_sort":false},"score":{"field":"score","_field_id":"11","comment":"积分","control":"inputNumber","control_args":"","form_show":true,"searchable":true,"search_type":"normal","list_show":false,"enable_sort":false},"last_time":{"field":"last_time","_field_id":"12","comment":"登录时间","control":"dateTimePicker","control_args":"","form_show":true,"searchable":true,"search_type":"between","list_show":false,"enable_sort":false},"last_ip":{"field":"last_ip","_field_id":"13","comment":"登录ip","control":"input","control_args":"","form_show":true,"searchable":true,"search_type":"normal","list_show":false,"enable_sort":false},"join_time":{"field":"join_time","_field_id":"14","comment":"注册时间","control":"dateTimePicker","control_args":"","form_show":true,"searchable":true,"search_type":"between","list_show":false,"enable_sort":false},"join_ip":{"field":"join_ip","_field_id":"15","comment":"注册ip","control":"input","control_args":"","form_show":true,"searchable":true,"search_type":"normal","list_show":false,"enable_sort":false},"token":{"field":"token","_field_id":"16","comment":"token","control":"input","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"17","comment":"创建时间","control":"dateTimePicker","control_args":"","form_show":true,"search_type":"between","list_show":false,"enable_sort":false,"searchable":false},"updated_at":{"field":"updated_at","_field_id":"18","comment":"更新时间","control":"dateTimePicker","control_args":"","search_type":"between","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"role":{"field":"role","_field_id":"19","comment":"角色","control":"inputNumber","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"status":{"field":"status","_field_id":"20","comment":"禁用","control":"switch","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-12-23 15:28:13'),
       (3, 'table_form_schema_wa_roles',
        '{"id":{"field":"id","_field_id":"0","comment":"主键","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"name":{"field":"name","_field_id":"1","comment":"角色组","control":"input","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"rules":{"field":"rules","_field_id":"2","comment":"权限","control":"treeSelectMulti","control_args":"url:\\/app\\/admin\\/rule\\/get?type=0,1,2","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"3","comment":"创建时间","control":"dateTimePicker","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"updated_at":{"field":"updated_at","_field_id":"4","comment":"更新时间","control":"dateTimePicker","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"pid":{"field":"pid","_field_id":"5","comment":"父级","control":"select","control_args":"url:\\/app\\/admin\\/role\\/select?format=tree","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-12-19 14:24:25'),
       (4, 'table_form_schema_wa_rules',
        '{"id":{"field":"id","_field_id":"0","comment":"主键","control":"inputNumber","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"title":{"field":"title","_field_id":"1","comment":"标题","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"icon":{"field":"icon","_field_id":"2","comment":"图标","control":"iconPicker","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"key":{"field":"key","_field_id":"3","comment":"标识","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"pid":{"field":"pid","_field_id":"4","comment":"上级菜单","control":"treeSelect","control_args":"\\/app\\/admin\\/rule\\/select?format=tree&type=0,1","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"5","comment":"创建时间","control":"dateTimePicker","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"updated_at":{"field":"updated_at","_field_id":"6","comment":"更新时间","control":"dateTimePicker","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"href":{"field":"href","_field_id":"7","comment":"url","control":"input","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"type":{"field":"type","_field_id":"8","comment":"类型","control":"select","control_args":"data:0:目录,1:菜单,2:权限","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"weight":{"field":"weight","_field_id":"9","comment":"排序","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-12-08 11:44:45'),
       (5, 'table_form_schema_wa_admins',
        '{"id":{"field":"id","_field_id":"0","comment":"ID","control":"inputNumber","control_args":"","list_show":true,"enable_sort":true,"search_type":"between","form_show":false,"searchable":false},"username":{"field":"username","_field_id":"1","comment":"用户名","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"nickname":{"field":"nickname","_field_id":"2","comment":"昵称","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"password":{"field":"password","_field_id":"3","comment":"密码","control":"input","control_args":"","form_show":true,"search_type":"normal","list_show":false,"enable_sort":false,"searchable":false},"avatar":{"field":"avatar","_field_id":"4","comment":"头像","control":"uploadImage","control_args":"url:\\/app\\/admin\\/upload\\/avatar","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"email":{"field":"email","_field_id":"5","comment":"邮箱","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"mobile":{"field":"mobile","_field_id":"6","comment":"手机","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"created_at":{"field":"created_at","_field_id":"7","comment":"创建时间","control":"dateTimePicker","control_args":"","form_show":true,"searchable":true,"search_type":"between","list_show":false,"enable_sort":false},"updated_at":{"field":"updated_at","_field_id":"8","comment":"更新时间","control":"dateTimePicker","control_args":"","form_show":true,"search_type":"normal","list_show":false,"enable_sort":false,"searchable":false},"login_at":{"field":"login_at","_field_id":"9","comment":"登录时间","control":"dateTimePicker","control_args":"","form_show":true,"list_show":true,"search_type":"between","enable_sort":false,"searchable":false},"status":{"field":"status","_field_id":"10","comment":"禁用","control":"switch","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-12-23 15:36:48'),
       (6, 'table_form_schema_wa_options',
        '{"id":{"field":"id","_field_id":"0","comment":"","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"name":{"field":"name","_field_id":"1","comment":"键","control":"input","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"value":{"field":"value","_field_id":"2","comment":"值","control":"textArea","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"3","comment":"创建时间","control":"dateTimePicker","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"updated_at":{"field":"updated_at","_field_id":"4","comment":"更新时间","control":"dateTimePicker","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-12-08 11:36:57'),
       (7, 'table_form_schema_wa_uploads',
        '{"id":{"field":"id","_field_id":"0","comment":"主键","control":"inputNumber","control_args":"","list_show":true,"enable_sort":true,"search_type":"normal","form_show":false,"searchable":false},"name":{"field":"name","_field_id":"1","comment":"名称","control":"input","control_args":"","list_show":true,"searchable":true,"search_type":"normal","form_show":false,"enable_sort":false},"url":{"field":"url","_field_id":"2","comment":"文件","control":"upload","control_args":"url:\\/app\\/admin\\/upload\\/file","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"admin_id":{"field":"admin_id","_field_id":"3","comment":"管理员","control":"select","control_args":"url:\\/app\\/admin\\/admin\\/select?format=select","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"file_size":{"field":"file_size","_field_id":"4","comment":"文件大小","control":"inputNumber","control_args":"","list_show":true,"search_type":"between","form_show":false,"enable_sort":false,"searchable":false},"mime_type":{"field":"mime_type","_field_id":"5","comment":"mime类型","control":"input","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"image_width":{"field":"image_width","_field_id":"6","comment":"图片宽度","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"image_height":{"field":"image_height","_field_id":"7","comment":"图片高度","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"ext":{"field":"ext","_field_id":"8","comment":"扩展名","control":"input","control_args":"","list_show":true,"searchable":true,"search_type":"normal","form_show":false,"enable_sort":false},"storage":{"field":"storage","_field_id":"9","comment":"存储位置","control":"input","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"10","comment":"上传时间","control":"dateTimePicker","control_args":"","searchable":true,"search_type":"between","form_show":false,"list_show":false,"enable_sort":false},"category":{"field":"category","_field_id":"11","comment":"类别","control":"select","control_args":"url:\\/app\\/admin\\/dict\\/get\\/upload","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"updated_at":{"field":"updated_at","_field_id":"12","comment":"更新时间","control":"dateTimePicker","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-12-08 11:47:45'),
       (8, 'dict_upload', '[{"value":"1","name":"分类1"},{"value":"2","name":"分类2"},{"value":"3","name":"分类3"}]',
        '2022-12-04 16:24:13', '2022-12-04 16:24:13'),
       (9, 'dict_sex', '[{"value":"0","name":"女"},{"value":"1","name":"男"},{"value":"2","name":"保密"}]',
        '2022-12-04 15:04:40', '2026-01-30 14:24:01'),
       (10, 'dict_status', '[{"value":"0","name":"正常"},{"value":"1","name":"禁用"}]', '2022-12-04 15:05:09',
        '2022-12-04 15:05:09'),
       (11, 'table_form_schema_wa_admin_roles',
        '{"id":{"field":"id","_field_id":"0","comment":"主键","control":"inputNumber","control_args":"","list_show":true,"enable_sort":true,"searchable":true,"search_type":"normal","form_show":false},"role_id":{"field":"role_id","_field_id":"1","comment":"角色id","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"admin_id":{"field":"admin_id","_field_id":"2","comment":"管理员id","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-12-20 19:42:51'),
       (12, 'dict_dict_name',
        '[{"value":"dict_name","name":"字典名称"},{"value":"status","name":"启禁用状态"},{"value":"sex","name":"性别"},{"value":"upload","name":"附件分类"}]',
        '2022-08-15 00:00:00', '2022-12-20 19:42:51'),
       (13, 'table_form_schema_foods',
        '{"id":{"field":"id","_field_id":"0","comment":"食物ID","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"name":{"field":"name","_field_id":"1","comment":"食物名称","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"like","enable_sort":false},"cat_id":{"field":"cat_id","_field_id":"2","comment":"食物分类","control":"select","control_args":"url:\\/app\\/admin\\/cat\\/select?format=select","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"user_id":{"field":"user_id","_field_id":"3","comment":"所属用户","control":"select","control_args":"url:\\/app\\/admin\\/user\\/select?format=select","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"status":{"field":"status","_field_id":"4","comment":"状态","control":"switch","control_args":"url:\\/app\\/admin\\/dict\\/get\\/status","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"nutrition":{"field":"nutrition","_field_id":"5","comment":"每100g的营养信息","control":"jsonEditor","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"6","comment":"创建时间","control":"dateTimePicker","control_args":"","list_show":true,"searchable":true,"search_type":"between","form_show":false,"enable_sort":false},"updated_at":{"field":"updated_at","_field_id":"7","comment":"更新时间","control":"dateTimePicker","control_args":"","list_show":true,"searchable":true,"search_type":"between","form_show":false,"enable_sort":false},"delete_at":{"field":"delete_at","_field_id":"8","comment":"","control":"dateTimePicker","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2026-01-30 13:44:53'),
       (14, 'dict_unit_type',
        '[{"value":"weight","name":"重量单位"},{"value":"count","name":"数量单位"},{"value":"volume","name":"体积单位"},{"value":"package","name":"商业预包装"},{"value":"length","name":"长度单位"}]',
        '2026-01-30 13:36:17', '2026-01-30 13:36:17'),
       (15, 'table_form_schema_units',
        '{"id":{"field":"id","_field_id":"0","comment":"单位ID","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"name":{"field":"name","_field_id":"1","comment":"单位名称","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"like","enable_sort":false},"type":{"field":"type","_field_id":"2","comment":"单位类型 ","control":"select","control_args":"url:\\/app\\/admin\\/dict\\/get\\/unit_type","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"desc":{"field":"desc","_field_id":"3","comment":"描述","control":"textArea","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"4","comment":"创建时间","control":"dateTimePicker","control_args":"","list_show":true,"searchable":true,"search_type":"between","form_show":false,"enable_sort":false},"updated_at":{"field":"updated_at","_field_id":"5","comment":"更新时间","control":"dateTimePicker","control_args":"","list_show":true,"searchable":true,"search_type":"between","form_show":false,"enable_sort":false},"delete_at":{"field":"delete_at","_field_id":"6","comment":"","control":"dateTimePicker","control_args":"","search_type":"normal","form_show":false,"list_show":false,"enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2026-01-30 13:43:52'),
       (16, 'table_form_schema_cats',
        '{"id":{"field":"id","_field_id":"0","comment":"","control":"inputNumber","control_args":"","list_show":true,"enable_sort":true,"searchable":true,"search_type":"normal","form_show":false},"name":{"field":"name","_field_id":"1","comment":"分类名称","control":"input","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"like","enable_sort":false},"pid":{"field":"pid","_field_id":"2","comment":"上级分类","control":"treeSelect","control_args":"url:\\/app\\/admin\\/cat\\/select?format=tree","form_show":true,"list_show":true,"enable_sort":true,"searchable":true,"search_type":"normal"},"sort":{"field":"sort","_field_id":"3","comment":"排序","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"enable_sort":true,"searchable":true,"search_type":"normal"},"created_at":{"field":"created_at","_field_id":"4","comment":"创建时间","control":"dateTimePicker","control_args":"","list_show":true,"searchable":true,"search_type":"between","form_show":false,"enable_sort":false},"updated_at":{"field":"updated_at","_field_id":"5","comment":"编辑时间","control":"dateTimePicker","control_args":"","list_show":true,"searchable":true,"search_type":"between","form_show":false,"enable_sort":false}}',
        '2022-08-15 00:00:00', '2026-01-30 13:48:28'),
       (17, 'dict_nutrition',
        '[{"value":"kcal","name":"卡路里"},{"value":"protein","name":"蛋白质"},{"value":"fat","name":"脂肪"},{"value":"carbohydrate","name":"碳水化合物"},{"value":"sugar","name":"糖"},{"value":"fiber","name":"膳食纤维"},{"value":"sodium","name":"钠"},{"value":"cholesterol","name":"胆固醇"},{"value":"vitaminA","name":"维生素A"},{"value":"vitaminB1","name":"维生素B1（硫胺素）"},{"value":"vitaminB6","name":"维生素B6"},{"value":"vitaminB12","name":"维生素B12"},{"value":"vitaminC","name":"维生素C"},{"value":"vitaminD","name":"维生素D"},{"value":"vitaminE","name":"维生素E"},{"value":"vitaminK","name":"维生素K"},{"value":"folate","name":"叶酸"},{"value":"calcium","name":"钙"},{"value":"iron","name":"铁"},{"value":"potassium","name":"钾"},{"value":"magnesium","name":"镁"},{"value":"iodine","name":"碘"},{"value":"zinc","name":"锌"},{"value":"selenium","name":"硒"}]',
        '2026-01-30 14:18:53', '2026-01-30 14:18:53');
-- eat_clear.wa_roles DML
INSERT INTO `eat_clear`.`wa_roles` (`id`, `name`, `rules`, `created_at`, `updated_at`, `pid`)
VALUES (1, '超级管理员', '*', '2022-08-13 16:15:01', '2022-12-23 12:05:07', NULL);
-- eat_clear.wa_rules DML
INSERT INTO `eat_clear`.`wa_rules` (`id`, `title`, `icon`, `key`, `pid`, `created_at`, `updated_at`, `href`, `type`,
                                    `weight`)
VALUES (1, '数据库', 'layui-icon-template-1', 'database', 0, '2026-01-29 18:10:04', '2026-01-29 18:10:04', NULL, 0,
        1000),
       (2, '所有表', NULL, 'plugin\\admin\\app\\controller\\TableController', 1, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/table/index', 1, 800),
       (3, '权限管理', 'layui-icon-vercode', 'auth', 0, '2026-01-29 18:10:04', '2026-01-29 18:10:04', NULL, 0, 900),
       (4, '账户管理', NULL, 'plugin\\admin\\app\\controller\\AdminController', 3, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/admin/index', 1, 1000),
       (5, '角色管理', NULL, 'plugin\\admin\\app\\controller\\RoleController', 3, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/role/index', 1, 900),
       (6, '菜单管理', NULL, 'plugin\\admin\\app\\controller\\RuleController', 3, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/rule/index', 1, 800),
       (7, '会员管理', 'layui-icon-username', 'user', 0, '2026-01-29 18:10:04', '2026-01-29 18:10:04', NULL, 0, 800),
       (8, '用户', NULL, 'plugin\\admin\\app\\controller\\UserController', 7, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/user/index', 1, 800),
       (9, '通用设置', 'layui-icon-set', 'common', 0, '2026-01-29 18:10:04', '2026-01-29 18:10:04', NULL, 0, 700),
       (10, '个人资料', NULL, 'plugin\\admin\\app\\controller\\AccountController', 9, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/account/index', 1, 800),
       (11, '附件管理', NULL, 'plugin\\admin\\app\\controller\\UploadController', 9, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/upload/index', 1, 700),
       (12, '字典设置', NULL, 'plugin\\admin\\app\\controller\\DictController', 9, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/dict/index', 1, 600),
       (13, '系统设置', NULL, 'plugin\\admin\\app\\controller\\ConfigController', 9, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/config/index', 1, 500),
       (14, '插件管理', 'layui-icon-app', 'plugin', 0, '2026-01-29 18:10:04', '2026-01-29 18:10:04', NULL, 0, 600),
       (15, '应用插件', NULL, 'plugin\\admin\\app\\controller\\PluginController', 14, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/plugin/index', 1, 800),
       (16, '开发辅助', 'layui-icon-fonts-code', 'dev', 0, '2026-01-29 18:10:04', '2026-01-29 18:10:04', NULL, 0, 500),
       (17, '表单构建', NULL, 'plugin\\admin\\app\\controller\\DevController', 16, '2026-01-29 18:10:04',
        '2026-01-29 18:10:04', '/app/admin/dev/form-build', 1, 800),
       (18, '示例页面', 'layui-icon-templeate-1', 'demos', 0, '2026-01-29 18:10:04', '2026-01-29 18:10:04', NULL, 0,
        400),
       (19, '工作空间', 'layui-icon-console', 'demo1', 18, '2026-01-29 18:10:04', '2026-01-29 18:10:04', '', 0, 0),
       (20, '控制后台', 'layui-icon-console', 'demo10', 19, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/console/console1.html', 1, 0),
       (21, '数据分析', 'layui-icon-console', 'demo13', 19, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/console/console2.html', 1, 0),
       (22, '百度一下', 'layui-icon-console', 'demo14', 19, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        'http://www.baidu.com', 1, 0),
       (23, '主题预览', 'layui-icon-console', 'demo15', 19, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/system/theme.html', 1, 0),
       (24, '常用组件', 'layui-icon-component', 'demo20', 18, '2026-01-29 18:10:04', '2026-01-29 18:10:04', '', 0, 0),
       (25, '功能按钮', 'layui-icon-face-smile', 'demo2011', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/button.html', 1, 0),
       (26, '表单集合', 'layui-icon-face-cry', 'demo2014', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/form.html', 1, 0),
       (27, '字体图标', 'layui-icon-face-cry', 'demo2010', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/icon.html', 1, 0),
       (28, '多选下拉', 'layui-icon-face-cry', 'demo2012', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/select.html', 1, 0),
       (29, '动态标签', 'layui-icon-face-cry', 'demo2013', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/tag.html', 1, 0),
       (30, '数据表格', 'layui-icon-face-cry', 'demo2031', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/table.html', 1, 0),
       (31, '分布表单', 'layui-icon-face-cry', 'demo2032', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/step.html', 1, 0),
       (32, '树形表格', 'layui-icon-face-cry', 'demo2033', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/treetable.html', 1, 0),
       (33, '树状结构', 'layui-icon-face-cry', 'demo2034', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/dtree.html', 1, 0),
       (34, '文本编辑', 'layui-icon-face-cry', 'demo2035', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/tinymce.html', 1, 0),
       (35, '卡片组件', 'layui-icon-face-cry', 'demo2036', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/card.html', 1, 0),
       (36, '抽屉组件', 'layui-icon-face-cry', 'demo2021', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/drawer.html', 1, 0),
       (37, '消息通知', 'layui-icon-face-cry', 'demo2022', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/notice.html', 1, 0),
       (38, '加载组件', 'layui-icon-face-cry', 'demo2024', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/loading.html', 1, 0),
       (39, '弹层组件', 'layui-icon-face-cry', 'demo2023', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/popup.html', 1, 0),
       (40, '多选项卡', 'layui-icon-face-cry', 'demo60131', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/tab.html', 1, 0),
       (41, '数据菜单', 'layui-icon-face-cry', 'demo60132', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/menu.html', 1, 0),
       (42, '哈希加密', 'layui-icon-face-cry', 'demo2041', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/encrypt.html', 1, 0),
       (43, '图标选择', 'layui-icon-face-cry', 'demo2042', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/iconPicker.html', 1, 0),
       (44, '省市级联', 'layui-icon-face-cry', 'demo2043', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/area.html', 1, 0),
       (45, '数字滚动', 'layui-icon-face-cry', 'demo2044', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/count.html', 1, 0),
       (46, '顶部返回', 'layui-icon-face-cry', 'demo2045', 24, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/document/topBar.html', 1, 0),
       (47, '结果页面', 'layui-icon-auz', 'demo666', 18, '2026-01-29 18:10:04', '2026-01-29 18:10:04', '', 0, 0),
       (48, '成功', 'layui-icon-face-smile', 'demo667', 47, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/result/success.html', 1, 0),
       (49, '失败', 'layui-icon-face-cry', 'demo668', 47, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/result/error.html', 1, 0),
       (50, '错误页面', 'layui-icon-face-cry', 'demo-error', 18, '2026-01-29 18:10:04', '2026-01-29 18:10:04', '', 0,
        0),
       (51, '403', 'layui-icon-face-smile', 'demo403', 50, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/error/403.html', 1, 0),
       (52, '404', 'layui-icon-face-cry', 'demo404', 50, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/error/404.html', 1, 0),
       (53, '500', 'layui-icon-face-cry', 'demo500', 50, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/error/500.html', 1, 0),
       (54, '系统管理', 'layui-icon-set-fill', 'demo-system', 18, '2026-01-29 18:10:04', '2026-01-29 18:10:04', '', 0,
        0),
       (55, '用户管理', 'layui-icon-face-smile', 'demo601', 54, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/system/user.html', 1, 0),
       (56, '角色管理', 'layui-icon-face-cry', 'demo602', 54, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/system/role.html', 1, 0),
       (57, '权限管理', 'layui-icon-face-cry', 'demo603', 54, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/system/power.html', 1, 0),
       (58, '部门管理', 'layui-icon-face-cry', 'demo604', 54, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/system/deptment.html', 1, 0),
       (59, '行为日志', 'layui-icon-face-cry', 'demo605', 54, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/system/log.html', 1, 0),
       (60, '数据字典', 'layui-icon-face-cry', 'demo606', 54, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/system/dict.html', 1, 0),
       (61, '常用页面', 'layui-icon-template-1', 'demo-common', 18, '2026-01-29 18:10:04', '2026-01-29 18:10:04', '', 0,
        0),
       (62, '空白页面', 'layui-icon-face-smile', 'demo702', 61, '2026-01-29 18:10:04', '2026-01-29 18:10:04',
        '/app/admin/demos/system/space.html', 1, 0),
       (63, '查看表', NULL, 'plugin\\admin\\app\\controller\\TableController@view', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (64, '查询表', NULL, 'plugin\\admin\\app\\controller\\TableController@show', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (65, '创建表', NULL, 'plugin\\admin\\app\\controller\\TableController@create', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (66, '修改表', NULL, 'plugin\\admin\\app\\controller\\TableController@modify', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (67, '一键菜单', NULL, 'plugin\\admin\\app\\controller\\TableController@crud', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (68, '查询记录', NULL, 'plugin\\admin\\app\\controller\\TableController@select', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (69, '插入记录', NULL, 'plugin\\admin\\app\\controller\\TableController@insert', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (70, '更新记录', NULL, 'plugin\\admin\\app\\controller\\TableController@update', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (71, '删除记录', NULL, 'plugin\\admin\\app\\controller\\TableController@delete', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (72, '删除表', NULL, 'plugin\\admin\\app\\controller\\TableController@drop', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (73, '表摘要', NULL, 'plugin\\admin\\app\\controller\\TableController@schema', 2, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (74, '插入', NULL, 'plugin\\admin\\app\\controller\\AdminController@insert', 4, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (75, '更新', NULL, 'plugin\\admin\\app\\controller\\AdminController@update', 4, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (76, '删除', NULL, 'plugin\\admin\\app\\controller\\AdminController@delete', 4, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (77, '插入', NULL, 'plugin\\admin\\app\\controller\\RoleController@insert', 5, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (78, '更新', NULL, 'plugin\\admin\\app\\controller\\RoleController@update', 5, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (79, '删除', NULL, 'plugin\\admin\\app\\controller\\RoleController@delete', 5, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (80, '获取角色权限', NULL, 'plugin\\admin\\app\\controller\\RoleController@rules', 5, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (81, '查询', NULL, 'plugin\\admin\\app\\controller\\RuleController@select', 6, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (82, '添加', NULL, 'plugin\\admin\\app\\controller\\RuleController@insert', 6, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (83, '更新', NULL, 'plugin\\admin\\app\\controller\\RuleController@update', 6, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (84, '删除', NULL, 'plugin\\admin\\app\\controller\\RuleController@delete', 6, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (85, '插入', NULL, 'plugin\\admin\\app\\controller\\UserController@insert', 8, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (86, '更新', NULL, 'plugin\\admin\\app\\controller\\UserController@update', 8, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (87, '查询', NULL, 'plugin\\admin\\app\\controller\\UserController@select', 8, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (88, '删除', NULL, 'plugin\\admin\\app\\controller\\UserController@delete', 8, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (89, '更新', NULL, 'plugin\\admin\\app\\controller\\AccountController@update', 10, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (90, '修改密码', NULL, 'plugin\\admin\\app\\controller\\AccountController@password', 10, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (91, '查询', NULL, 'plugin\\admin\\app\\controller\\AccountController@select', 10, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (92, '添加', NULL, 'plugin\\admin\\app\\controller\\AccountController@insert', 10, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (93, '删除', NULL, 'plugin\\admin\\app\\controller\\AccountController@delete', 10, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (94, '浏览附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@attachment', 11, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (95, '查询附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@select', 11, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (96, '更新附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@update', 11, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (97, '添加附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@insert', 11, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (98, '上传文件', NULL, 'plugin\\admin\\app\\controller\\UploadController@file', 11, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (99, '上传图片', NULL, 'plugin\\admin\\app\\controller\\UploadController@image', 11, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (100, '上传头像', NULL, 'plugin\\admin\\app\\controller\\UploadController@avatar', 11, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (101, '删除附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@delete', 11, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (102, '查询', NULL, 'plugin\\admin\\app\\controller\\DictController@select', 12, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (103, '插入', NULL, 'plugin\\admin\\app\\controller\\DictController@insert', 12, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (104, '更新', NULL, 'plugin\\admin\\app\\controller\\DictController@update', 12, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (105, '删除', NULL, 'plugin\\admin\\app\\controller\\DictController@delete', 12, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (106, '更改', NULL, 'plugin\\admin\\app\\controller\\ConfigController@update', 13, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (107, '列表', NULL, 'plugin\\admin\\app\\controller\\PluginController@list', 15, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (108, '安装', NULL, 'plugin\\admin\\app\\controller\\PluginController@install', 15, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (109, '卸载', NULL, 'plugin\\admin\\app\\controller\\PluginController@uninstall', 15, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (110, '支付', NULL, 'plugin\\admin\\app\\controller\\PluginController@pay', 15, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (111, '登录官网', NULL, 'plugin\\admin\\app\\controller\\PluginController@login', 15, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (112, '获取已安装的插件列表', NULL, 'plugin\\admin\\app\\controller\\PluginController@getInstalledPlugins', 15,
        '2026-01-29 18:12:09', '2026-01-29 18:12:09', NULL, 2, 0),
       (113, '表单构建', NULL, 'plugin\\admin\\app\\controller\\DevController@formBuild', 17, '2026-01-29 18:12:09',
        '2026-01-29 18:12:09', NULL, 2, 0),
       (114, '食品列表', '', 'plugin\\admin\\app\\controller\\FoodController', 119, '2026-01-30 13:21:23',
        '2026-01-30 13:45:07', '/app/admin/food/index', 1, 0),
       (115, '插入', NULL, 'plugin\\admin\\app\\controller\\FoodController@insert', 114, '2026-01-30 13:21:33',
        '2026-01-30 13:21:33', NULL, 2, 0),
       (116, '更新', NULL, 'plugin\\admin\\app\\controller\\FoodController@update', 114, '2026-01-30 13:21:33',
        '2026-01-30 13:21:33', NULL, 2, 0),
       (117, '查询', NULL, 'plugin\\admin\\app\\controller\\FoodController@select', 114, '2026-01-30 13:21:33',
        '2026-01-30 13:21:33', NULL, 2, 0),
       (118, '删除', NULL, 'plugin\\admin\\app\\controller\\FoodController@delete', 114, '2026-01-30 13:21:33',
        '2026-01-30 13:21:33', NULL, 2, 0),
       (119, '食品管理', 'layui-icon-app', 'food_manager', NULL, '2026-01-30 13:21:51', '2026-01-30 13:23:11', '', 0,
        0),
       (120, '食品单位', '', 'plugin\\admin\\app\\controller\\UnitController', 119, '2026-01-30 13:24:29',
        '2026-01-30 13:42:54', '/app/admin/unit/index', 1, 0),
       (121, '插入', NULL, 'plugin\\admin\\app\\controller\\UnitController@insert', 120, '2026-01-30 13:24:44',
        '2026-01-30 13:24:44', NULL, 2, 0),
       (122, '更新', NULL, 'plugin\\admin\\app\\controller\\UnitController@update', 120, '2026-01-30 13:24:44',
        '2026-01-30 13:24:44', NULL, 2, 0),
       (123, '查询', NULL, 'plugin\\admin\\app\\controller\\UnitController@select', 120, '2026-01-30 13:24:44',
        '2026-01-30 13:24:44', NULL, 2, 0),
       (124, '删除', NULL, 'plugin\\admin\\app\\controller\\UnitController@delete', 120, '2026-01-30 13:24:44',
        '2026-01-30 13:24:44', NULL, 2, 0),
       (125, '食品分类', '', 'plugin\\admin\\app\\controller\\CatController', 119, '2026-01-30 13:26:21',
        '2026-01-30 13:47:28', '/app/admin/cat/index', 1, 0),
       (126, '插入', NULL, 'plugin\\admin\\app\\controller\\CatController@insert', 125, '2026-01-30 13:26:33',
        '2026-01-30 13:26:33', NULL, 2, 0),
       (127, '更新', NULL, 'plugin\\admin\\app\\controller\\CatController@update', 125, '2026-01-30 13:26:33',
        '2026-01-30 13:26:33', NULL, 2, 0),
       (128, '查询', NULL, 'plugin\\admin\\app\\controller\\CatController@select', 125, '2026-01-30 13:26:33',
        '2026-01-30 13:26:33', NULL, 2, 0),
       (129, '删除', NULL, 'plugin\\admin\\app\\controller\\CatController@delete', 125, '2026-01-30 13:26:33',
        '2026-01-30 13:26:33', NULL, 2, 0);
SET FOREIGN_KEY_CHECKS = 1;
