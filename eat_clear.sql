SET
    FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;
-- eat_clear DDL
CREATE
    DATABASE `eat_clear`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;;
use
    `eat_clear`;
-- eat_clear.cats DDL
DROP TABLE IF EXISTS `eat_clear`.`cats`;
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
  AUTO_INCREMENT = 18
  ROW_FORMAT = Dynamic COMMENT = "食品分类";
-- eat_clear.food_units DDL
DROP TABLE IF EXISTS `eat_clear`.`food_units`;
CREATE TABLE `eat_clear`.`food_units`
(
    `id`         INT UNSIGNED                                                  NOT NULL AUTO_INCREMENT Comment "ID",
    `food_id`    INT UNSIGNED                                                  NOT NULL Comment "食物",
    `unit_id`    INT UNSIGNED                                                  NOT NULL Comment "所属单位",
    `weight`     DECIMAL(10, 2)                                                NOT NULL Comment "换算重量 (1单位 ≈ ? g)",
    `is_default` TINYINT                                                       NOT NULL DEFAULT 0 Comment "是否为默认",
    `remark`     VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL Comment "备注",
    INDEX `fk_foodunit_unit` (`unit_id` ASC) USING BTREE,
    UNIQUE INDEX `uk_food_unit` (`food_id` ASC, `unit_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  AUTO_INCREMENT = 1858
  ROW_FORMAT = Dynamic COMMENT = "食物单位换算关系表";
-- eat_clear.foods DDL
DROP TABLE IF EXISTS `eat_clear`.`foods`;
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
  AUTO_INCREMENT = 1058
  ROW_FORMAT = Dynamic COMMENT = "食物基础信息与营养表";
-- eat_clear.units DDL
DROP TABLE IF EXISTS `eat_clear`.`units`;
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
  AUTO_INCREMENT = 8
  ROW_FORMAT = Dynamic COMMENT = "计量单位表";
-- eat_clear.wa_admin_roles DDL
DROP TABLE IF EXISTS `eat_clear`.`wa_admin_roles`;
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
  AUTO_INCREMENT = 1
  ROW_FORMAT = Dynamic COMMENT = "管理员角色表";
-- eat_clear.wa_admins DDL
DROP TABLE IF EXISTS `eat_clear`.`wa_admins`;
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
  AUTO_INCREMENT = 1
  ROW_FORMAT = Dynamic COMMENT = "管理员表";
-- eat_clear.wa_options DDL
DROP TABLE IF EXISTS `eat_clear`.`wa_options`;
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
  AUTO_INCREMENT = 18
  ROW_FORMAT = Dynamic COMMENT = "选项表";
-- eat_clear.wa_roles DDL
DROP TABLE IF EXISTS `eat_clear`.`wa_roles`;
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
  AUTO_INCREMENT = 1
  ROW_FORMAT = Dynamic COMMENT = "管理员角色";
-- eat_clear.wa_rules DDL
DROP TABLE IF EXISTS `eat_clear`.`wa_rules`;
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
  AUTO_INCREMENT = 134
  ROW_FORMAT = Dynamic COMMENT = "权限规则";
-- eat_clear.wa_uploads DDL
DROP TABLE IF EXISTS `eat_clear`.`wa_uploads`;
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
DROP TABLE IF EXISTS `eat_clear`.`wa_users`;
CREATE TABLE `eat_clear`.`wa_users`
(
    `id`         INT UNSIGNED                                                    NOT NULL AUTO_INCREMENT Comment "主键",
    `username`   VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NOT NULL Comment "用户名",
    `nickname`   VARCHAR(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NOT NULL Comment "昵称",
    `password`   VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NOT NULL Comment "密码",
    `sex`        ENUM ("1","2","3") CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' Comment "性别1男2女3保密",
    `avatar`     VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NULL Comment "头像",
    `email`      VARCHAR(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci   NULL Comment "邮箱",
    `mobile`     VARCHAR(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci    NULL Comment "手机",
    `openid`     varchar(255) character set utf8mb4 collate utf8mb4_general_ci   null comment "微信openid",
    `unionid`    varchar(255) character set utf8mb4 collate utf8mb4_general_ci   null comment "微信unionid",
    `signature`  varchar(255) character set utf8mb4 collate utf8mb4_general_ci   null comment "个性签名",
    `background` varchar(255) character set utf8mb4 collate utf8mb4_general_ci   null comment "背景图",
    `age`        int                                                             null default 0 comment "年龄",
    `tall`       int                                                             null default null comment "身高 cm",
    `weight`     decimal(10, 2)                                                  null default null comment "体重 kg",
    `bmi`        decimal(10, 2)                                                  null default null comment "bmi",
    `bust`       decimal(10, 2)                                                  null default null comment "胸围 cm",
    `waist`      decimal(10, 2)                                                  null default null comment "腰围 cm",
    `hip`        decimal(10, 2)                                                  null default null comment "臀围 cm",
    `target`     int                                                             null default null comment "卡路里目标",
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
  ROW_FORMAT = Dynamic COMMENT = "用户表";
-- eat_clear.food_units Constraints
ALTER TABLE `eat_clear`.`food_units`
    ADD CONSTRAINT `fk_foodunit_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `fk_foodunit_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON
        DELETE
        CASCADE ON UPDATE CASCADE;
-- eat_clear.cats DML
INSERT INTO `eat_clear`.`cats` (`id`, `name`, `pid`, `sort`, `created_at`, `updated_at`)
VALUES (1, '谷薯类', 0, 10, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (2, '豆类及其制品', 0, 20, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (3, '蔬菜类', 0, 30, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (4, '菌藻类', 0, 40, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (5, '水果类', 0, 50, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (6, '坚果种子类', 0, 60, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (7, '畜肉类', 0, 70, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (8, '禽肉类', 0, 80, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (9, '乳类及其制品', 0, 90, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (10, '蛋类', 0, 100, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (11, '鱼虾蟹贝类', 0, 110, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (12, '婴幼儿食品', 0, 120, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (13, '小吃甜品', 0, 130, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (14, '速食食品', 0, 140, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (15, '饮料', 0, 150, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (16, '调味品', 0, 160, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (17, '油脂类', 0, 170, '2026-02-03 21:33:43', '2026-02-03 21:33:43'),
       (18, '其他', 0, 180, '2026-02-03 21:33:43', '2026-02-03 21:33:43');
-- eat_clear.food_units DML
INSERT INTO `eat_clear`.`food_units` (`id`, `food_id`, `unit_id`, `weight`, `is_default`, `remark`)
VALUES (1, 1, 1, 1.00, 1, NULL),
       (2, 1, 5, 79.22, 0, NULL),
       (3, 2, 1, 1.00, 1, NULL),
       (4, 2, 3, 59.95, 0, NULL),
       (5, 3, 1, 1.00, 1, NULL),
       (6, 4, 1, 1.00, 1, NULL),
       (7, 5, 1, 1.00, 1, NULL),
       (8, 6, 1, 1.00, 1, NULL),
       (9, 6, 4, 55.00, 0, NULL),
       (10, 7, 1, 1.00, 1, NULL),
       (11, 7, 5, 97.05, 0, NULL),
       (12, 8, 1, 1.00, 1, NULL),
       (13, 8, 5, 157.42, 0, NULL),
       (14, 9, 1, 1.00, 1, NULL),
       (15, 9, 4, 463.27, 0, NULL),
       (16, 10, 1, 1.00, 1, NULL),
       (17, 10, 5, 17.92, 0, NULL),
       (18, 11, 1, 1.00, 1, NULL),
       (19, 11, 8, 396.73, 0, NULL),
       (20, 12, 1, 1.00, 1, NULL),
       (21, 13, 1, 1.00, 1, NULL),
       (22, 13, 2, 201.78, 0, NULL),
       (23, 14, 1, 1.00, 1, NULL),
       (24, 14, 2, 234.49, 0, NULL),
       (25, 15, 1, 1.00, 1, NULL),
       (26, 15, 2, 385.84, 0, NULL),
       (27, 16, 1, 1.00, 1, NULL),
       (28, 16, 3, 328.24, 0, NULL),
       (29, 17, 1, 1.00, 1, NULL),
       (30, 17, 4, 187.64, 0, NULL),
       (31, 18, 1, 1.00, 1, NULL),
       (32, 18, 5, 173.61, 0, NULL),
       (33, 19, 1, 1.00, 1, NULL),
       (34, 20, 1, 1.00, 1, NULL),
       (35, 20, 5, 121.02, 0, NULL),
       (36, 21, 1, 1.00, 1, NULL),
       (37, 22, 1, 1.00, 1, NULL),
       (38, 23, 1, 1.00, 1, NULL),
       (39, 23, 5, 308.03, 0, NULL),
       (40, 24, 1, 1.00, 1, NULL),
       (41, 24, 4, 269.90, 0, NULL),
       (42, 25, 1, 1.00, 1, NULL),
       (43, 26, 1, 1.00, 1, NULL),
       (44, 26, 4, 376.19, 0, NULL),
       (45, 27, 1, 1.00, 1, NULL),
       (46, 27, 5, 395.98, 0, NULL),
       (47, 28, 1, 1.00, 1, NULL),
       (48, 29, 1, 1.00, 1, NULL),
       (49, 29, 8, 157.62, 0, NULL),
       (50, 30, 1, 1.00, 1, NULL),
       (51, 31, 1, 1.00, 1, NULL),
       (52, 31, 3, 199.69, 0, NULL),
       (53, 32, 1, 1.00, 1, NULL),
       (54, 32, 3, 413.37, 0, NULL),
       (55, 33, 1, 1.00, 1, NULL),
       (56, 34, 1, 1.00, 1, NULL),
       (57, 34, 3, 412.79, 0, NULL),
       (58, 35, 1, 1.00, 1, NULL),
       (59, 36, 1, 1.00, 1, NULL),
       (60, 36, 8, 143.75, 0, NULL),
       (61, 37, 1, 1.00, 1, NULL),
       (62, 37, 8, 347.70, 0, NULL),
       (63, 38, 1, 1.00, 1, NULL),
       (64, 39, 1, 1.00, 1, NULL),
       (65, 39, 2, 313.53, 0, NULL),
       (66, 40, 1, 1.00, 1, NULL),
       (67, 40, 3, 286.99, 0, NULL),
       (68, 41, 1, 1.00, 1, NULL),
       (69, 42, 1, 1.00, 1, NULL),
       (70, 42, 5, 182.28, 0, NULL),
       (71, 43, 1, 1.00, 1, NULL),
       (72, 43, 2, 18.13, 0, NULL),
       (73, 44, 1, 1.00, 1, NULL),
       (74, 44, 8, 281.78, 0, NULL),
       (75, 45, 1, 1.00, 1, NULL),
       (76, 46, 1, 1.00, 1, NULL),
       (77, 46, 2, 52.49, 0, NULL),
       (78, 47, 1, 1.00, 1, NULL),
       (79, 48, 1, 1.00, 1, NULL),
       (80, 49, 1, 1.00, 1, NULL),
       (81, 50, 1, 1.00, 1, NULL),
       (82, 50, 2, 311.81, 0, NULL),
       (83, 51, 1, 1.00, 1, NULL),
       (84, 52, 1, 1.00, 1, NULL),
       (85, 53, 1, 1.00, 1, NULL),
       (86, 53, 4, 22.46, 0, NULL),
       (87, 54, 1, 1.00, 1, NULL),
       (88, 54, 3, 301.22, 0, NULL),
       (89, 55, 1, 1.00, 1, NULL),
       (90, 56, 1, 1.00, 1, NULL),
       (91, 56, 3, 91.67, 0, NULL),
       (92, 57, 1, 1.00, 1, NULL),
       (93, 57, 5, 436.64, 0, NULL),
       (94, 58, 1, 1.00, 1, NULL),
       (95, 59, 1, 1.00, 1, NULL),
       (96, 59, 2, 146.91, 0, NULL),
       (97, 60, 1, 1.00, 1, NULL),
       (98, 61, 1, 1.00, 1, NULL),
       (99, 61, 8, 290.79, 0, NULL),
       (100, 62, 1, 1.00, 1, NULL),
       (101, 62, 4, 400.31, 0, NULL),
       (102, 63, 1, 1.00, 1, NULL),
       (103, 63, 8, 378.24, 0, NULL),
       (104, 64, 1, 1.00, 1, NULL),
       (105, 64, 6, 95.14, 0, NULL),
       (106, 65, 1, 1.00, 1, NULL),
       (107, 65, 2, 23.98, 0, NULL),
       (108, 66, 1, 1.00, 1, NULL),
       (109, 66, 6, 468.67, 0, NULL),
       (110, 67, 1, 1.00, 1, NULL),
       (111, 67, 4, 352.36, 0, NULL),
       (112, 68, 1, 1.00, 1, NULL),
       (113, 68, 5, 15.84, 0, NULL),
       (114, 69, 1, 1.00, 1, NULL),
       (115, 69, 5, 285.47, 0, NULL),
       (116, 70, 1, 1.00, 1, NULL),
       (117, 70, 4, 356.90, 0, NULL),
       (118, 71, 1, 1.00, 1, NULL),
       (119, 71, 8, 343.39, 0, NULL),
       (120, 72, 1, 1.00, 1, NULL),
       (121, 72, 8, 286.65, 0, NULL),
       (122, 73, 1, 1.00, 1, NULL),
       (123, 73, 8, 368.04, 0, NULL),
       (124, 74, 1, 1.00, 1, NULL),
       (125, 75, 1, 1.00, 1, NULL),
       (126, 76, 1, 1.00, 1, NULL),
       (127, 76, 4, 149.57, 0, NULL),
       (128, 77, 1, 1.00, 1, NULL),
       (129, 77, 8, 103.61, 0, NULL),
       (130, 78, 1, 1.00, 1, NULL),
       (131, 78, 8, 443.39, 0, NULL),
       (132, 79, 1, 1.00, 1, NULL),
       (133, 80, 1, 1.00, 1, NULL),
       (134, 80, 2, 145.93, 0, NULL),
       (135, 81, 1, 1.00, 1, NULL),
       (136, 82, 1, 1.00, 1, NULL),
       (137, 83, 1, 1.00, 1, NULL),
       (138, 83, 2, 161.41, 0, NULL),
       (139, 84, 1, 1.00, 1, NULL),
       (140, 84, 5, 31.57, 0, NULL),
       (141, 85, 1, 1.00, 1, NULL),
       (142, 86, 1, 1.00, 1, NULL),
       (143, 86, 2, 196.39, 0, NULL),
       (144, 87, 1, 1.00, 1, NULL),
       (145, 87, 7, 248.48, 0, NULL),
       (146, 88, 1, 1.00, 1, NULL),
       (147, 88, 2, 54.23, 0, NULL),
       (148, 89, 1, 1.00, 1, NULL),
       (149, 89, 8, 441.71, 0, NULL),
       (150, 90, 1, 1.00, 1, NULL),
       (151, 90, 7, 118.80, 0, NULL),
       (152, 91, 1, 1.00, 1, NULL),
       (153, 91, 2, 188.06, 0, NULL),
       (154, 92, 1, 1.00, 1, NULL),
       (155, 92, 5, 62.17, 0, NULL),
       (156, 93, 1, 1.00, 1, NULL),
       (157, 93, 5, 127.35, 0, NULL),
       (158, 94, 1, 1.00, 1, NULL),
       (159, 94, 2, 461.96, 0, NULL),
       (160, 95, 1, 1.00, 1, NULL),
       (161, 95, 3, 406.45, 0, NULL),
       (162, 96, 1, 1.00, 1, NULL),
       (163, 97, 1, 1.00, 1, NULL),
       (164, 97, 6, 486.29, 0, NULL),
       (165, 98, 1, 1.00, 1, NULL),
       (166, 98, 4, 234.25, 0, NULL),
       (167, 99, 1, 1.00, 1, NULL),
       (168, 99, 6, 220.87, 0, NULL),
       (169, 100, 1, 1.00, 1, NULL),
       (170, 100, 5, 32.83, 0, NULL),
       (171, 101, 1, 1.00, 1, NULL),
       (172, 101, 6, 315.95, 0, NULL),
       (173, 1, 2, 105.46, 0, NULL),
       (174, 3, 3, 403.48, 0, NULL),
       (175, 4, 2, 414.33, 0, NULL),
       (176, 5, 3, 391.20, 0, NULL),
       (177, 7, 2, 214.50, 0, NULL),
       (178, 8, 4, 291.90, 0, NULL),
       (179, 9, 5, 65.77, 0, NULL),
       (180, 12, 5, 424.79, 0, NULL),
       (181, 14, 5, 373.93, 0, NULL),
       (182, 15, 5, 288.22, 0, NULL),
       (183, 17, 8, 192.72, 0, NULL),
       (184, 18, 3, 455.11, 0, NULL),
       (185, 19, 4, 204.92, 0, NULL),
       (186, 20, 2, 93.10, 0, NULL),
       (187, 21, 5, 338.93, 0, NULL),
       (188, 22, 5, 157.06, 0, NULL),
       (189, 25, 2, 391.72, 0, NULL),
       (190, 27, 2, 289.49, 0, NULL),
       (191, 28, 4, 74.37, 0, NULL),
       (192, 29, 4, 497.77, 0, NULL),
       (193, 30, 3, 304.09, 0, NULL),
       (194, 31, 2, 421.39, 0, NULL),
       (195, 32, 2, 171.95, 0, NULL),
       (196, 33, 2, 60.00, 0, NULL),
       (197, 34, 5, 228.68, 0, NULL),
       (198, 35, 4, 59.61, 0, NULL),
       (199, 36, 4, 67.52, 0, NULL),
       (200, 37, 4, 97.57, 0, NULL),
       (201, 38, 8, 310.62, 0, NULL),
       (202, 40, 5, 491.38, 0, NULL),
       (203, 41, 4, 122.78, 0, NULL),
       (204, 43, 5, 76.23, 0, NULL),
       (205, 44, 2, 440.64, 0, NULL),
       (206, 45, 5, 135.32, 0, NULL),
       (207, 46, 5, 477.33, 0, NULL),
       (208, 49, 5, 127.96, 0, NULL),
       (209, 51, 8, 209.43, 0, NULL),
       (210, 52, 2, 25.59, 0, NULL),
       (211, 53, 5, 437.24, 0, NULL),
       (212, 54, 5, 12.14, 0, NULL),
       (213, 56, 8, 314.18, 0, NULL),
       (214, 58, 3, 315.66, 0, NULL),
       (215, 59, 3, 316.25, 0, NULL),
       (216, 61, 3, 146.91, 0, NULL),
       (217, 64, 7, 229.88, 0, NULL),
       (218, 65, 6, 73.05, 0, NULL),
       (219, 66, 8, 365.59, 0, NULL),
       (220, 69, 8, 297.51, 0, NULL),
       (221, 71, 4, 98.34, 0, NULL),
       (222, 72, 4, 189.77, 0, NULL),
       (223, 73, 5, 140.10, 0, NULL),
       (224, 75, 8, 299.84, 0, NULL),
       (225, 77, 5, 361.11, 0, NULL),
       (226, 80, 4, 468.23, 0, NULL),
       (227, 81, 8, 150.84, 0, NULL),
       (228, 85, 2, 431.02, 0, NULL),
       (229, 87, 2, 14.15, 0, NULL),
       (230, 88, 6, 326.24, 0, NULL),
       (231, 89, 5, 456.26, 0, NULL),
       (232, 90, 6, 134.20, 0, NULL),
       (233, 91, 7, 350.36, 0, NULL),
       (234, 92, 4, 347.51, 0, NULL),
       (235, 93, 4, 387.36, 0, NULL),
       (236, 96, 8, 196.31, 0, NULL),
       (237, 98, 5, 497.30, 0, NULL),
       (238, 99, 4, 177.66, 0, NULL),
       (239, 100, 7, 53.45, 0, NULL),
       (240, 101, 7, 82.23, 0, NULL),
       (241, 1, 4, 370.73, 0, NULL),
       (242, 2, 8, 341.28, 0, NULL),
       (243, 7, 3, 121.19, 0, NULL),
       (244, 8, 2, 386.76, 0, NULL),
       (245, 10, 2, 384.23, 0, NULL),
       (246, 11, 5, 222.42, 0, NULL),
       (247, 13, 4, 124.43, 0, NULL),
       (248, 18, 4, 434.50, 0, NULL),
       (249, 21, 2, 303.53, 0, NULL),
       (250, 22, 3, 202.08, 0, NULL),
       (251, 23, 2, 99.54, 0, NULL),
       (252, 26, 8, 334.29, 0, NULL),
       (253, 27, 4, 218.94, 0, NULL),
       (254, 29, 2, 321.33, 0, NULL),
       (255, 30, 5, 126.83, 0, NULL),
       (256, 33, 8, 33.58, 0, NULL),
       (257, 34, 4, 492.39, 0, NULL),
       (258, 36, 3, 281.06, 0, NULL),
       (259, 39, 5, 107.84, 0, NULL),
       (260, 41, 3, 224.99, 0, NULL),
       (261, 42, 3, 472.63, 0, NULL),
       (262, 43, 4, 455.89, 0, NULL),
       (263, 46, 4, 160.86, 0, NULL),
       (264, 47, 5, 38.83, 0, NULL),
       (265, 48, 5, 461.51, 0, NULL),
       (266, 49, 8, 189.84, 0, NULL),
       (267, 50, 3, 151.52, 0, NULL),
       (268, 52, 3, 481.11, 0, NULL),
       (269, 55, 4, 487.90, 0, NULL),
       (270, 57, 4, 223.42, 0, NULL),
       (271, 60, 8, 211.88, 0, NULL),
       (272, 62, 7, 225.82, 0, NULL),
       (273, 64, 5, 340.25, 0, NULL),
       (274, 65, 4, 315.72, 0, NULL),
       (275, 67, 5, 177.36, 0, NULL),
       (276, 68, 4, 167.86, 0, NULL),
       (277, 70, 8, 271.24, 0, NULL),
       (278, 72, 5, 224.46, 0, NULL),
       (279, 73, 3, 294.23, 0, NULL),
       (280, 74, 2, 378.71, 0, NULL),
       (281, 75, 3, 436.56, 0, NULL),
       (282, 76, 8, 408.21, 0, NULL),
       (283, 77, 2, 207.20, 0, NULL),
       (284, 79, 8, 130.13, 0, NULL),
       (285, 81, 4, 59.04, 0, NULL),
       (286, 82, 2, 156.54, 0, NULL),
       (287, 89, 2, 222.89, 0, NULL),
       (288, 93, 6, 88.67, 0, NULL),
       (289, 94, 6, 78.43, 0, NULL),
       (290, 96, 3, 88.70, 0, NULL),
       (291, 98, 2, 322.18, 0, NULL),
       (292, 100, 6, 457.20, 0, NULL),
       (293, 101, 4, 235.09, 0, NULL),
       (294, 1, 3, 178.40, 0, NULL),
       (295, 4, 5, 153.50, 0, NULL),
       (296, 5, 5, 392.07, 0, NULL),
       (297, 6, 2, 169.30, 0, NULL),
       (298, 9, 2, 331.15, 0, NULL),
       (299, 11, 2, 84.01, 0, NULL),
       (300, 12, 4, 118.14, 0, NULL),
       (301, 16, 2, 390.11, 0, NULL),
       (302, 17, 3, 332.61, 0, NULL),
       (303, 22, 8, 190.19, 0, NULL),
       (304, 24, 8, 317.80, 0, NULL),
       (305, 25, 8, 313.22, 0, NULL),
       (306, 26, 2, 50.51, 0, NULL),
       (307, 29, 5, 92.18, 0, NULL),
       (308, 37, 5, 389.85, 0, NULL),
       (309, 38, 4, 341.06, 0, NULL),
       (310, 39, 4, 351.24, 0, NULL),
       (311, 42, 8, 77.74, 0, NULL),
       (312, 45, 8, 422.22, 0, NULL),
       (313, 49, 2, 418.74, 0, NULL),
       (314, 52, 8, 46.84, 0, NULL),
       (315, 53, 8, 67.32, 0, NULL),
       (316, 55, 2, 415.30, 0, NULL),
       (317, 57, 3, 86.97, 0, NULL),
       (318, 58, 4, 457.37, 0, NULL),
       (319, 59, 4, 387.25, 0, NULL),
       (320, 60, 5, 225.69, 0, NULL),
       (321, 61, 2, 215.88, 0, NULL),
       (322, 64, 2, 63.99, 0, NULL),
       (323, 65, 5, 271.82, 0, NULL),
       (324, 66, 3, 84.30, 0, NULL),
       (325, 76, 5, 280.82, 0, NULL),
       (326, 79, 5, 441.87, 0, NULL),
       (327, 80, 3, 477.91, 0, NULL),
       (328, 82, 4, 99.22, 0, NULL),
       (329, 83, 5, 345.50, 0, NULL),
       (330, 84, 3, 177.80, 0, NULL),
       (331, 85, 8, 447.00, 0, NULL),
       (332, 86, 4, 256.69, 0, NULL),
       (333, 89, 7, 217.49, 0, NULL),
       (334, 90, 5, 38.71, 0, NULL),
       (335, 91, 5, 388.25, 0, NULL),
       (336, 94, 7, 29.25, 0, NULL),
       (337, 96, 5, 77.98, 0, NULL),
       (338, 97, 2, 325.91, 0, NULL),
       (339, 98, 6, 351.59, 0, NULL),
       (340, 1, 8, 315.58, 0, NULL),
       (341, 5, 2, 12.33, 0, NULL),
       (342, 7, 4, 267.35, 0, NULL),
       (343, 8, 8, 39.71, 0, NULL),
       (344, 9, 3, 483.91, 0, NULL),
       (345, 10, 4, 197.74, 0, NULL),
       (346, 15, 4, 266.56, 0, NULL),
       (347, 19, 3, 182.38, 0, NULL),
       (348, 20, 3, 147.93, 0, NULL),
       (349, 23, 4, 265.09, 0, NULL),
       (350, 24, 5, 343.36, 0, NULL),
       (351, 35, 8, 323.08, 0, NULL),
       (352, 37, 3, 50.93, 0, NULL),
       (353, 39, 3, 227.23, 0, NULL),
       (354, 41, 8, 348.13, 0, NULL),
       (355, 48, 4, 92.89, 0, NULL),
       (356, 49, 4, 195.75, 0, NULL),
       (357, 55, 5, 351.16, 0, NULL),
       (358, 60, 2, 424.36, 0, NULL),
       (359, 62, 2, 16.81, 0, NULL),
       (360, 63, 4, 221.61, 0, NULL),
       (361, 64, 8, 83.24, 0, NULL),
       (362, 66, 4, 339.29, 0, NULL),
       (363, 68, 2, 106.33, 0, NULL),
       (364, 78, 5, 98.17, 0, NULL),
       (365, 79, 3, 50.83, 0, NULL),
       (366, 87, 8, 333.06, 0, NULL),
       (367, 88, 4, 39.11, 0, NULL),
       (368, 89, 3, 65.27, 0, NULL),
       (369, 90, 3, 412.89, 0, NULL),
       (370, 92, 3, 303.51, 0, NULL),
       (371, 93, 7, 111.67, 0, NULL),
       (372, 94, 8, 331.28, 0, NULL),
       (373, 95, 5, 470.37, 0, NULL),
       (374, 97, 7, 18.28, 0, NULL),
       (375, 99, 2, 318.42, 0, NULL),
       (376, 100, 3, 441.16, 0, NULL),
       (377, 101, 2, 354.08, 0, NULL),
       (378, 2, 4, 319.24, 0, NULL),
       (379, 7, 8, 31.37, 0, NULL),
       (380, 10, 3, 468.27, 0, NULL),
       (381, 12, 3, 263.84, 0, NULL),
       (382, 13, 5, 272.29, 0, NULL),
       (383, 16, 4, 176.58, 0, NULL),
       (384, 18, 8, 350.28, 0, NULL),
       (385, 19, 8, 319.40, 0, NULL),
       (386, 21, 4, 313.70, 0, NULL),
       (387, 22, 4, 411.09, 0, NULL),
       (388, 23, 8, 446.25, 0, NULL),
       (389, 26, 3, 481.95, 0, NULL),
       (390, 27, 3, 394.48, 0, NULL),
       (391, 33, 3, 437.05, 0, NULL),
       (392, 35, 3, 74.33, 0, NULL),
       (393, 36, 2, 339.74, 0, NULL),
       (394, 41, 2, 415.55, 0, NULL),
       (395, 44, 5, 366.95, 0, NULL),
       (396, 48, 2, 65.96, 0, NULL),
       (397, 50, 8, 108.84, 0, NULL),
       (398, 52, 4, 346.02, 0, NULL),
       (399, 61, 4, 181.92, 0, NULL),
       (400, 63, 5, 168.75, 0, NULL),
       (401, 74, 4, 95.60, 0, NULL),
       (402, 78, 3, 171.86, 0, NULL),
       (403, 79, 2, 85.00, 0, NULL),
       (404, 85, 3, 100.75, 0, NULL),
       (405, 86, 8, 150.42, 0, NULL),
       (406, 87, 5, 92.60, 0, NULL),
       (407, 88, 8, 493.30, 0, NULL),
       (408, 90, 2, 179.29, 0, NULL),
       (409, 92, 8, 411.06, 0, NULL),
       (410, 93, 2, 360.69, 0, NULL),
       (411, 94, 4, 254.67, 0, NULL),
       (412, 99, 7, 491.29, 0, NULL),
       (413, 101, 3, 49.78, 0, NULL),
       (414, 14, 7, 68.21, 0, NULL),
       (415, 15, 3, 477.74, 0, NULL),
       (416, 18, 2, 454.18, 0, NULL),
       (417, 22, 2, 367.53, 0, NULL),
       (418, 23, 3, 118.71, 0, NULL),
       (419, 31, 4, 54.89, 0, NULL),
       (420, 40, 8, 129.92, 0, NULL),
       (421, 43, 3, 246.13, 0, NULL),
       (422, 45, 4, 478.65, 0, NULL),
       (423, 52, 5, 352.49, 0, NULL),
       (424, 54, 2, 487.84, 0, NULL),
       (425, 57, 8, 280.09, 0, NULL),
       (426, 58, 5, 447.34, 0, NULL),
       (427, 61, 5, 55.20, 0, NULL),
       (428, 62, 6, 230.59, 0, NULL),
       (429, 63, 3, 226.39, 0, NULL),
       (430, 67, 3, 344.45, 0, NULL),
       (431, 69, 3, 282.23, 0, NULL),
       (432, 70, 5, 234.36, 0, NULL),
       (433, 80, 8, 56.94, 0, NULL),
       (434, 82, 5, 493.52, 0, NULL),
       (435, 83, 8, 402.58, 0, NULL),
       (436, 87, 4, 115.77, 0, NULL),
       (437, 88, 3, 227.89, 0, NULL),
       (438, 89, 6, 487.43, 0, NULL),
       (439, 91, 8, 182.37, 0, NULL),
       (440, 92, 2, 220.79, 0, NULL),
       (441, 93, 3, 464.95, 0, NULL),
       (442, 94, 3, 125.81, 0, NULL),
       (443, 96, 4, 95.06, 0, NULL),
       (444, 97, 3, 46.93, 0, NULL),
       (445, 4, 3, 352.19, 0, NULL),
       (446, 6, 8, 175.35, 0, NULL),
       (447, 16, 5, 29.20, 0, NULL),
       (448, 19, 2, 182.29, 0, NULL),
       (449, 28, 8, 233.01, 0, NULL),
       (450, 32, 5, 244.96, 0, NULL),
       (451, 33, 4, 181.70, 0, NULL),
       (452, 38, 5, 214.04, 0, NULL),
       (453, 47, 8, 256.02, 0, NULL),
       (454, 48, 3, 81.93, 0, NULL),
       (455, 51, 3, 134.21, 0, NULL),
       (456, 53, 3, 232.04, 0, NULL),
       (457, 54, 8, 15.60, 0, NULL),
       (458, 56, 5, 266.90, 0, NULL),
       (459, 58, 2, 175.00, 0, NULL),
       (460, 59, 5, 210.71, 0, NULL),
       (461, 62, 5, 472.16, 0, NULL),
       (462, 68, 8, 399.61, 0, NULL),
       (463, 69, 2, 265.96, 0, NULL),
       (464, 71, 2, 479.25, 0, NULL),
       (465, 73, 4, 23.99, 0, NULL),
       (466, 74, 3, 438.85, 0, NULL),
       (467, 77, 3, 308.55, 0, NULL),
       (468, 81, 3, 125.65, 0, NULL),
       (469, 82, 8, 469.02, 0, NULL),
       (470, 86, 5, 49.38, 0, NULL),
       (471, 98, 7, 185.47, 0, NULL),
       (472, 100, 2, 255.47, 0, NULL),
       (473, 11, 3, 482.82, 0, NULL),
       (474, 13, 8, 473.82, 0, NULL),
       (475, 14, 4, 43.87, 0, NULL),
       (476, 17, 2, 110.94, 0, NULL),
       (477, 24, 2, 165.02, 0, NULL),
       (478, 28, 2, 451.00, 0, NULL),
       (479, 36, 5, 91.35, 0, NULL),
       (480, 44, 3, 200.67, 0, NULL),
       (481, 48, 8, 176.90, 0, NULL),
       (482, 49, 3, 301.86, 0, NULL),
       (483, 54, 4, 465.70, 0, NULL),
       (484, 56, 2, 397.36, 0, NULL),
       (485, 62, 8, 99.39, 0, NULL),
       (486, 63, 7, 420.13, 0, NULL),
       (487, 65, 8, 367.25, 0, NULL),
       (488, 80, 5, 290.53, 0, NULL),
       (489, 81, 2, 270.39, 0, NULL),
       (490, 82, 3, 105.82, 0, NULL),
       (491, 90, 8, 202.76, 0, NULL),
       (492, 96, 2, 322.53, 0, NULL),
       (493, 99, 5, 310.44, 0, NULL),
       (494, 100, 8, 85.77, 0, NULL),
       (495, 2, 5, 54.59, 0, NULL),
       (496, 3, 4, 426.64, 0, NULL),
       (497, 11, 4, 406.18, 0, NULL),
       (498, 14, 3, 67.55, 0, NULL),
       (499, 16, 8, 484.60, 0, NULL),
       (500, 18, 7, 101.16, 0, NULL),
       (501, 20, 4, 428.38, 0, NULL),
       (502, 25, 4, 164.49, 0, NULL),
       (503, 45, 3, 368.58, 0, NULL),
       (504, 47, 2, 238.19, 0, NULL),
       (505, 50, 4, 182.42, 0, NULL),
       (506, 63, 6, 13.69, 0, NULL),
       (507, 65, 7, 275.83, 0, NULL),
       (508, 68, 3, 14.86, 0, NULL),
       (509, 76, 2, 252.92, 0, NULL),
       (510, 78, 4, 35.78, 0, NULL),
       (511, 84, 8, 307.62, 0, NULL),
       (512, 85, 5, 299.02, 0, NULL),
       (513, 87, 6, 30.66, 0, NULL),
       (514, 89, 4, 58.28, 0, NULL),
       (515, 90, 4, 369.05, 0, NULL),
       (516, 91, 6, 220.58, 0, NULL),
       (517, 1001, 1, 1.00, 1, NULL),
       (518, 1001, 5, 200.00, 0, NULL),
       (519, 1002, 1, 1.00, 1, NULL),
       (520, 1002, 3, 100.00, 0, NULL),
       (521, 1003, 1, 1.00, 1, NULL),
       (522, 1004, 1, 1.00, 1, NULL),
       (523, 1004, 3, 150.00, 0, NULL),
       (524, 1005, 1, 1.00, 1, NULL),
       (525, 1005, 3, 150.00, 0, NULL),
       (526, 1006, 1, 1.00, 1, NULL),
       (527, 1007, 1, 1.00, 1, NULL),
       (528, 1008, 1, 1.00, 1, NULL),
       (529, 1009, 1, 1.00, 1, NULL),
       (530, 1010, 1, 1.00, 1, NULL),
       (531, 1010, 10, 100.00, 0, NULL),
       (532, 1011, 1, 1.00, 1, NULL),
       (533, 1011, 4, 20.00, 0, NULL),
       (534, 1012, 1, 1.00, 1, NULL),
       (535, 1013, 1, 1.00, 1, NULL),
       (536, 1014, 1, 1.00, 1, NULL),
       (537, 1015, 1, 1.00, 1, NULL),
       (538, 1016, 1, 1.00, 1, NULL),
       (539, 1016, 8, 100.00, 0, NULL),
       (540, 1017, 1, 1.00, 1, NULL),
       (541, 1017, 8, 100.00, 0, NULL),
       (542, 1018, 1, 1.00, 1, NULL),
       (543, 1018, 10, 200.00, 0, NULL),
       (544, 1019, 1, 1.00, 1, NULL),
       (545, 1019, 8, 100.00, 0, NULL),
       (546, 1020, 1, 1.00, 1, NULL),
       (547, 1020, 8, 100.00, 0, NULL),
       (548, 1021, 1, 1.00, 1, NULL),
       (549, 1021, 8, 100.00, 0, NULL),
       (550, 1022, 1, 1.00, 1, NULL),
       (551, 1022, 3, 200.00, 0, NULL),
       (552, 1023, 1, 1.00, 1, NULL),
       (553, 1023, 10, 300.00, 0, NULL),
       (554, 1024, 1, 1.00, 1, NULL),
       (555, 1024, 3, 200.00, 0, NULL),
       (556, 1025, 1, 1.00, 1, NULL),
       (557, 1025, 3, 200.00, 0, NULL),
       (558, 1026, 1, 1.00, 1, NULL),
       (559, 1027, 1, 1.00, 1, NULL),
       (560, 1028, 1, 1.00, 1, NULL),
       (561, 1028, 10, 300.00, 0, NULL),
       (562, 1029, 1, 1.00, 1, NULL),
       (563, 1030, 1, 1.00, 1, NULL),
       (564, 1031, 1, 1.00, 1, NULL),
       (565, 1032, 1, 1.00, 1, NULL),
       (566, 1033, 1, 1.00, 1, NULL),
       (567, 1034, 1, 1.00, 1, NULL),
       (568, 1035, 1, 1.00, 1, NULL),
       (569, 1036, 1, 1.00, 1, NULL),
       (570, 1036, 10, 100.00, 0, NULL),
       (571, 1037, 1, 1.00, 1, NULL),
       (572, 1038, 1, 1.00, 1, NULL),
       (573, 1039, 1, 1.00, 1, NULL),
       (574, 1039, 10, 100.00, 0, NULL),
       (575, 1040, 1, 1.00, 1, NULL),
       (576, 1041, 1, 1.00, 1, NULL),
       (577, 1042, 1, 1.00, 1, NULL),
       (578, 1042, 10, 100.00, 0, NULL),
       (579, 1043, 1, 1.00, 1, NULL),
       (580, 1044, 1, 1.00, 1, NULL),
       (581, 1044, 12, 250.00, 0, NULL),
       (582, 1045, 1, 1.00, 1, NULL),
       (583, 1045, 12, 250.00, 0, NULL),
       (584, 1046, 1, 1.00, 1, NULL),
       (585, 1046, 12, 250.00, 0, NULL),
       (586, 1047, 1, 1.00, 1, NULL),
       (587, 1047, 10, 100.00, 0, NULL),
       (588, 1048, 1, 1.00, 1, NULL),
       (589, 1048, 4, 5.00, 0, NULL),
       (590, 1049, 1, 1.00, 1, NULL),
       (591, 1049, 4, 5.00, 0, NULL),
       (592, 1050, 1, 1.00, 1, NULL),
       (593, 1051, 7, 1.00, 1, NULL),
       (594, 1051, 6, 250.00, 0, NULL),
       (595, 1052, 7, 1.00, 1, NULL),
       (596, 1052, 6, 250.00, 0, NULL),
       (597, 1053, 7, 1.00, 1, NULL),
       (598, 1053, 6, 250.00, 0, NULL),
       (599, 1054, 7, 1.00, 1, NULL),
       (600, 1054, 6, 250.00, 0, NULL),
       (601, 1055, 1, 1.00, 1, NULL),
       (602, 1056, 1, 1.00, 1, NULL),
       (603, 1057, 1, 1.00, 1, NULL),
       (604, 1058, 1, 1.00, 1, NULL),
       (605, 1059, 1, 1.00, 1, NULL),
       (606, 1059, 8, 450.00, 0, NULL),
       (607, 1060, 1, 1.00, 1, NULL),
       (608, 1060, 8, 450.00, 0, NULL),
       (609, 1061, 1, 1.00, 1, NULL),
       (610, 1061, 8, 450.00, 0, NULL),
       (611, 1062, 1, 1.00, 1, NULL),
       (612, 1062, 8, 450.00, 0, NULL),
       (613, 1063, 1, 1.00, 1, NULL),
       (614, 1063, 8, 450.00, 0, NULL),
       (615, 1064, 1, 1.00, 1, NULL),
       (616, 1064, 8, 450.00, 0, NULL),
       (617, 1065, 1, 1.00, 1, NULL),
       (618, 1065, 8, 450.00, 0, NULL),
       (619, 1066, 1, 1.00, 1, NULL),
       (620, 1066, 8, 450.00, 0, NULL),
       (621, 1067, 1, 1.00, 1, NULL),
       (622, 1067, 8, 450.00, 0, NULL),
       (623, 1068, 1, 1.00, 1, NULL),
       (624, 1068, 8, 450.00, 0, NULL),
       (625, 1069, 1, 1.00, 1, NULL),
       (626, 1069, 8, 450.00, 0, NULL),
       (627, 1070, 1, 1.00, 1, NULL),
       (628, 1070, 8, 450.00, 0, NULL),
       (629, 1071, 1, 1.00, 1, NULL),
       (630, 1071, 8, 450.00, 0, NULL),
       (631, 1072, 1, 1.00, 1, NULL),
       (632, 1072, 8, 450.00, 0, NULL),
       (633, 1073, 1, 1.00, 1, NULL),
       (634, 1073, 8, 450.00, 0, NULL),
       (635, 1074, 1, 1.00, 1, NULL),
       (636, 1074, 8, 450.00, 0, NULL),
       (637, 1075, 1, 1.00, 1, NULL),
       (638, 1075, 8, 450.00, 0, NULL),
       (639, 1076, 1, 1.00, 1, NULL),
       (640, 1076, 8, 450.00, 0, NULL),
       (641, 1077, 1, 1.00, 1, NULL),
       (642, 1077, 8, 450.00, 0, NULL),
       (643, 1078, 1, 1.00, 1, NULL),
       (644, 1078, 8, 450.00, 0, NULL),
       (645, 1079, 7, 1.00, 1, NULL),
       (646, 1079, 6, 250.00, 0, NULL),
       (647, 1080, 1, 1.00, 1, NULL),
       (648, 1080, 8, 450.00, 0, NULL),
       (649, 1081, 1, 1.00, 1, NULL),
       (650, 1081, 8, 450.00, 0, NULL),
       (651, 1082, 1, 1.00, 1, NULL),
       (652, 1082, 8, 450.00, 0, NULL),
       (653, 1083, 1, 1.00, 1, NULL),
       (654, 1083, 8, 450.00, 0, NULL),
       (655, 1084, 1, 1.00, 1, NULL),
       (656, 1084, 8, 450.00, 0, NULL),
       (657, 1085, 1, 1.00, 1, NULL),
       (658, 1085, 8, 450.00, 0, NULL),
       (659, 1086, 1, 1.00, 1, NULL),
       (660, 1086, 8, 450.00, 0, NULL),
       (661, 1087, 1, 1.00, 1, NULL),
       (662, 1087, 8, 450.00, 0, NULL),
       (663, 1088, 1, 1.00, 1, NULL),
       (664, 1088, 8, 450.00, 0, NULL),
       (665, 1089, 1, 1.00, 1, NULL),
       (666, 1089, 8, 450.00, 0, NULL),
       (667, 1090, 1, 1.00, 1, NULL),
       (668, 1090, 8, 450.00, 0, NULL),
       (669, 1091, 1, 1.00, 1, NULL),
       (670, 1091, 8, 450.00, 0, NULL),
       (671, 1092, 1, 1.00, 1, NULL),
       (672, 1092, 8, 450.00, 0, NULL),
       (673, 1093, 1, 1.00, 1, NULL),
       (674, 1093, 8, 450.00, 0, NULL),
       (675, 1094, 1, 1.00, 1, NULL),
       (676, 1094, 8, 450.00, 0, NULL),
       (677, 1095, 1, 1.00, 1, NULL),
       (678, 1095, 8, 450.00, 0, NULL),
       (679, 1096, 1, 1.00, 1, NULL),
       (680, 1096, 8, 450.00, 0, NULL),
       (681, 1097, 1, 1.00, 1, NULL),
       (682, 1097, 8, 450.00, 0, NULL),
       (683, 1098, 1, 1.00, 1, NULL),
       (684, 1098, 8, 450.00, 0, NULL),
       (685, 1099, 1, 1.00, 1, NULL),
       (686, 1099, 8, 450.00, 0, NULL),
       (687, 1100, 1, 1.00, 1, NULL),
       (688, 1100, 8, 450.00, 0, NULL),
       (689, 1101, 1, 1.00, 1, NULL),
       (690, 1101, 8, 450.00, 0, NULL),
       (691, 1102, 1, 1.00, 1, NULL),
       (692, 1102, 8, 450.00, 0, NULL),
       (693, 1103, 1, 1.00, 1, NULL),
       (694, 1103, 8, 450.00, 0, NULL),
       (695, 1104, 1, 1.00, 1, NULL),
       (696, 1104, 8, 450.00, 0, NULL),
       (697, 1105, 1, 1.00, 1, NULL),
       (698, 1105, 8, 450.00, 0, NULL),
       (699, 1106, 1, 1.00, 1, NULL),
       (700, 1106, 8, 450.00, 0, NULL),
       (701, 1107, 1, 1.00, 1, NULL),
       (702, 1107, 8, 450.00, 0, NULL),
       (703, 1108, 1, 1.00, 1, NULL),
       (704, 1108, 8, 450.00, 0, NULL),
       (705, 1109, 1, 1.00, 1, NULL),
       (706, 1109, 8, 450.00, 0, NULL),
       (707, 1110, 1, 1.00, 1, NULL),
       (708, 1110, 8, 450.00, 0, NULL),
       (709, 1111, 1, 1.00, 1, NULL),
       (710, 1111, 8, 450.00, 0, NULL),
       (711, 1112, 1, 1.00, 1, NULL),
       (712, 1112, 8, 450.00, 0, NULL),
       (713, 1113, 1, 1.00, 1, NULL),
       (714, 1113, 8, 450.00, 0, NULL),
       (715, 1114, 1, 1.00, 1, NULL),
       (716, 1114, 8, 450.00, 0, NULL),
       (717, 1115, 1, 1.00, 1, NULL),
       (718, 1115, 8, 450.00, 0, NULL),
       (719, 1116, 1, 1.00, 1, NULL),
       (720, 1116, 8, 450.00, 0, NULL),
       (721, 1117, 1, 1.00, 1, NULL),
       (722, 1117, 8, 450.00, 0, NULL),
       (723, 1118, 1, 1.00, 1, NULL),
       (724, 1118, 8, 450.00, 0, NULL),
       (725, 1119, 1, 1.00, 1, NULL),
       (726, 1119, 8, 450.00, 0, NULL),
       (727, 1120, 1, 1.00, 1, NULL),
       (728, 1120, 8, 450.00, 0, NULL),
       (729, 1121, 1, 1.00, 1, NULL),
       (730, 1121, 8, 450.00, 0, NULL),
       (731, 1122, 1, 1.00, 1, NULL),
       (732, 1122, 8, 450.00, 0, NULL),
       (733, 1123, 1, 1.00, 1, NULL),
       (734, 1123, 8, 450.00, 0, NULL),
       (735, 1007, 8, 450.00, 0, NULL),
       (736, 1125, 1, 1.00, 1, NULL),
       (737, 1125, 8, 450.00, 0, NULL),
       (738, 1126, 1, 1.00, 1, NULL),
       (739, 1126, 8, 450.00, 0, NULL),
       (740, 1127, 1, 1.00, 1, NULL),
       (741, 1127, 8, 450.00, 0, NULL),
       (742, 1128, 1, 1.00, 1, NULL),
       (743, 1128, 8, 450.00, 0, NULL),
       (744, 1129, 1, 1.00, 1, NULL),
       (745, 1129, 8, 450.00, 0, NULL),
       (746, 1130, 1, 1.00, 1, NULL),
       (747, 1130, 8, 450.00, 0, NULL),
       (748, 1131, 1, 1.00, 1, NULL),
       (749, 1131, 8, 450.00, 0, NULL),
       (750, 1132, 1, 1.00, 1, NULL),
       (751, 1132, 8, 450.00, 0, NULL),
       (752, 1133, 1, 1.00, 1, NULL),
       (753, 1133, 8, 450.00, 0, NULL),
       (754, 1134, 1, 1.00, 1, NULL),
       (755, 1134, 8, 450.00, 0, NULL),
       (756, 1135, 1, 1.00, 1, NULL),
       (757, 1135, 8, 450.00, 0, NULL),
       (758, 1136, 1, 1.00, 1, NULL),
       (759, 1136, 8, 450.00, 0, NULL),
       (760, 1137, 1, 1.00, 1, NULL),
       (761, 1137, 8, 450.00, 0, NULL),
       (762, 1138, 1, 1.00, 1, NULL),
       (763, 1138, 8, 450.00, 0, NULL),
       (764, 1139, 1, 1.00, 1, NULL),
       (765, 1139, 8, 450.00, 0, NULL),
       (766, 1140, 1, 1.00, 1, NULL),
       (767, 1140, 8, 450.00, 0, NULL),
       (768, 1141, 1, 1.00, 1, NULL),
       (769, 1141, 8, 450.00, 0, NULL),
       (770, 1142, 1, 1.00, 1, NULL),
       (771, 1142, 8, 450.00, 0, NULL),
       (772, 1143, 1, 1.00, 1, NULL),
       (773, 1143, 8, 450.00, 0, NULL),
       (774, 1144, 1, 1.00, 1, NULL),
       (775, 1144, 8, 450.00, 0, NULL),
       (776, 1145, 1, 1.00, 1, NULL),
       (777, 1145, 8, 450.00, 0, NULL),
       (778, 1146, 1, 1.00, 1, NULL),
       (779, 1146, 8, 450.00, 0, NULL),
       (780, 1147, 1, 1.00, 1, NULL),
       (781, 1147, 8, 450.00, 0, NULL),
       (782, 1148, 1, 1.00, 1, NULL),
       (783, 1148, 8, 450.00, 0, NULL),
       (784, 1149, 1, 1.00, 1, NULL),
       (785, 1149, 8, 450.00, 0, NULL),
       (786, 1150, 1, 1.00, 1, NULL),
       (787, 1150, 8, 450.00, 0, NULL),
       (788, 1151, 1, 1.00, 1, NULL),
       (789, 1151, 8, 450.00, 0, NULL),
       (790, 1152, 1, 1.00, 1, NULL),
       (791, 1152, 8, 450.00, 0, NULL),
       (792, 1153, 1, 1.00, 1, NULL),
       (793, 1153, 8, 450.00, 0, NULL),
       (794, 1154, 1, 1.00, 1, NULL),
       (795, 1154, 8, 450.00, 0, NULL),
       (796, 1155, 1, 1.00, 1, NULL),
       (797, 1155, 8, 450.00, 0, NULL),
       (798, 1156, 1, 1.00, 1, NULL),
       (799, 1156, 8, 450.00, 0, NULL),
       (800, 1157, 1, 1.00, 1, NULL),
       (801, 1157, 8, 450.00, 0, NULL),
       (802, 1158, 1, 1.00, 1, NULL),
       (803, 1158, 8, 450.00, 0, NULL),
       (804, 1159, 1, 1.00, 1, NULL),
       (805, 1159, 8, 450.00, 0, NULL),
       (806, 1160, 1, 1.00, 1, NULL),
       (807, 1160, 8, 450.00, 0, NULL),
       (808, 1161, 1, 1.00, 1, NULL),
       (809, 1161, 8, 450.00, 0, NULL),
       (810, 1162, 1, 1.00, 1, NULL),
       (811, 1162, 8, 450.00, 0, NULL),
       (812, 1163, 1, 1.00, 1, NULL),
       (813, 1163, 8, 450.00, 0, NULL),
       (814, 1164, 1, 1.00, 1, NULL),
       (815, 1164, 8, 450.00, 0, NULL),
       (816, 1165, 1, 1.00, 1, NULL),
       (817, 1165, 8, 450.00, 0, NULL),
       (818, 1166, 1, 1.00, 1, NULL),
       (819, 1166, 8, 450.00, 0, NULL),
       (820, 1167, 1, 1.00, 1, NULL),
       (821, 1167, 8, 450.00, 0, NULL),
       (822, 1168, 1, 1.00, 1, NULL),
       (823, 1168, 8, 450.00, 0, NULL),
       (824, 1169, 1, 1.00, 1, NULL),
       (825, 1169, 8, 450.00, 0, NULL),
       (826, 1170, 1, 1.00, 1, NULL),
       (827, 1170, 8, 450.00, 0, NULL),
       (828, 1171, 1, 1.00, 1, NULL),
       (829, 1171, 8, 450.00, 0, NULL),
       (830, 1172, 1, 1.00, 1, NULL),
       (831, 1172, 8, 450.00, 0, NULL),
       (832, 1173, 1, 1.00, 1, NULL),
       (833, 1173, 8, 450.00, 0, NULL),
       (834, 1174, 1, 1.00, 1, NULL),
       (835, 1174, 8, 450.00, 0, NULL),
       (836, 1175, 1, 1.00, 1, NULL),
       (837, 1175, 8, 450.00, 0, NULL),
       (838, 1176, 7, 1.00, 1, NULL),
       (839, 1176, 6, 250.00, 0, NULL),
       (840, 1177, 1, 1.00, 1, NULL),
       (841, 1177, 8, 450.00, 0, NULL),
       (842, 1178, 1, 1.00, 1, NULL),
       (843, 1178, 8, 450.00, 0, NULL),
       (844, 1179, 1, 1.00, 1, NULL),
       (845, 1179, 8, 450.00, 0, NULL),
       (846, 1180, 1, 1.00, 1, NULL),
       (847, 1180, 8, 450.00, 0, NULL),
       (848, 1181, 1, 1.00, 1, NULL),
       (849, 1181, 8, 450.00, 0, NULL),
       (850, 1182, 1, 1.00, 1, NULL),
       (851, 1182, 8, 450.00, 0, NULL),
       (852, 1183, 1, 1.00, 1, NULL),
       (853, 1183, 8, 450.00, 0, NULL),
       (854, 1184, 1, 1.00, 1, NULL),
       (855, 1184, 8, 450.00, 0, NULL),
       (856, 1185, 1, 1.00, 1, NULL),
       (857, 1185, 8, 450.00, 0, NULL),
       (858, 1186, 1, 1.00, 1, NULL),
       (859, 1186, 8, 450.00, 0, NULL),
       (860, 1187, 1, 1.00, 1, NULL),
       (861, 1187, 8, 450.00, 0, NULL),
       (862, 1188, 1, 1.00, 1, NULL),
       (863, 1188, 8, 450.00, 0, NULL),
       (864, 1189, 1, 1.00, 1, NULL),
       (865, 1189, 8, 450.00, 0, NULL),
       (866, 1190, 1, 1.00, 1, NULL),
       (867, 1190, 8, 450.00, 0, NULL),
       (868, 1191, 1, 1.00, 1, NULL),
       (869, 1191, 8, 450.00, 0, NULL),
       (870, 1192, 1, 1.00, 1, NULL),
       (871, 1192, 8, 450.00, 0, NULL),
       (872, 1193, 1, 1.00, 1, NULL),
       (873, 1193, 8, 450.00, 0, NULL),
       (874, 1194, 1, 1.00, 1, NULL),
       (875, 1194, 8, 450.00, 0, NULL),
       (876, 1195, 1, 1.00, 1, NULL),
       (877, 1195, 8, 450.00, 0, NULL),
       (878, 1196, 1, 1.00, 1, NULL),
       (879, 1196, 8, 450.00, 0, NULL),
       (880, 1197, 1, 1.00, 1, NULL),
       (881, 1197, 8, 450.00, 0, NULL),
       (882, 1198, 1, 1.00, 1, NULL),
       (883, 1198, 8, 450.00, 0, NULL),
       (884, 1199, 1, 1.00, 1, NULL),
       (885, 1199, 8, 450.00, 0, NULL),
       (886, 1200, 1, 1.00, 1, NULL),
       (887, 1200, 8, 450.00, 0, NULL),
       (888, 1201, 1, 1.00, 1, NULL),
       (889, 1201, 8, 450.00, 0, NULL),
       (890, 1202, 1, 1.00, 1, NULL),
       (891, 1202, 8, 450.00, 0, NULL),
       (892, 1203, 1, 1.00, 1, NULL),
       (893, 1203, 8, 450.00, 0, NULL),
       (894, 1204, 1, 1.00, 1, NULL),
       (895, 1204, 8, 450.00, 0, NULL),
       (896, 1205, 1, 1.00, 1, NULL),
       (897, 1205, 8, 450.00, 0, NULL),
       (898, 1206, 1, 1.00, 1, NULL),
       (899, 1206, 8, 450.00, 0, NULL),
       (900, 1207, 1, 1.00, 1, NULL),
       (901, 1207, 8, 450.00, 0, NULL),
       (902, 1208, 1, 1.00, 1, NULL),
       (903, 1208, 8, 450.00, 0, NULL),
       (904, 1209, 1, 1.00, 1, NULL),
       (905, 1209, 8, 450.00, 0, NULL),
       (906, 1210, 1, 1.00, 1, NULL),
       (907, 1210, 8, 450.00, 0, NULL),
       (908, 1211, 1, 1.00, 1, NULL),
       (909, 1211, 8, 450.00, 0, NULL),
       (910, 1212, 1, 1.00, 1, NULL),
       (911, 1212, 8, 450.00, 0, NULL),
       (912, 1213, 1, 1.00, 1, NULL),
       (913, 1213, 8, 450.00, 0, NULL),
       (914, 1214, 1, 1.00, 1, NULL),
       (915, 1214, 8, 450.00, 0, NULL),
       (916, 1215, 1, 1.00, 1, NULL),
       (917, 1215, 8, 450.00, 0, NULL),
       (918, 1216, 1, 1.00, 1, NULL),
       (919, 1216, 8, 450.00, 0, NULL),
       (920, 1217, 7, 1.00, 1, NULL),
       (921, 1217, 6, 250.00, 0, NULL),
       (922, 1218, 1, 1.00, 1, NULL),
       (923, 1218, 8, 450.00, 0, NULL),
       (924, 1219, 1, 1.00, 1, NULL),
       (925, 1219, 8, 450.00, 0, NULL),
       (926, 1220, 1, 1.00, 1, NULL),
       (927, 1220, 8, 450.00, 0, NULL),
       (928, 1221, 1, 1.00, 1, NULL),
       (929, 1221, 8, 450.00, 0, NULL),
       (930, 1222, 1, 1.00, 1, NULL),
       (931, 1222, 8, 450.00, 0, NULL),
       (932, 1223, 1, 1.00, 1, NULL),
       (933, 1223, 8, 450.00, 0, NULL),
       (934, 1224, 1, 1.00, 1, NULL),
       (935, 1224, 8, 450.00, 0, NULL),
       (936, 1225, 1, 1.00, 1, NULL),
       (937, 1225, 8, 450.00, 0, NULL),
       (938, 1226, 1, 1.00, 1, NULL),
       (939, 1226, 8, 450.00, 0, NULL),
       (940, 1227, 1, 1.00, 1, NULL),
       (941, 1227, 8, 450.00, 0, NULL),
       (942, 1228, 1, 1.00, 1, NULL),
       (943, 1228, 8, 450.00, 0, NULL),
       (944, 1229, 1, 1.00, 1, NULL),
       (945, 1229, 8, 450.00, 0, NULL),
       (946, 1230, 1, 1.00, 1, NULL),
       (947, 1230, 8, 450.00, 0, NULL),
       (948, 1231, 1, 1.00, 1, NULL),
       (949, 1231, 8, 450.00, 0, NULL),
       (950, 1232, 1, 1.00, 1, NULL),
       (951, 1232, 8, 450.00, 0, NULL),
       (952, 1233, 1, 1.00, 1, NULL),
       (953, 1233, 8, 450.00, 0, NULL),
       (954, 1234, 1, 1.00, 1, NULL),
       (955, 1234, 8, 450.00, 0, NULL),
       (956, 1235, 1, 1.00, 1, NULL),
       (957, 1235, 8, 450.00, 0, NULL),
       (958, 1236, 1, 1.00, 1, NULL),
       (959, 1236, 8, 450.00, 0, NULL),
       (960, 1237, 1, 1.00, 1, NULL),
       (961, 1237, 8, 450.00, 0, NULL),
       (962, 1238, 1, 1.00, 1, NULL),
       (963, 1238, 8, 450.00, 0, NULL),
       (964, 1239, 1, 1.00, 1, NULL),
       (965, 1239, 8, 450.00, 0, NULL),
       (966, 1240, 1, 1.00, 1, NULL),
       (967, 1240, 8, 450.00, 0, NULL),
       (968, 1241, 1, 1.00, 1, NULL),
       (969, 1241, 8, 450.00, 0, NULL),
       (970, 1242, 1, 1.00, 1, NULL),
       (971, 1242, 8, 450.00, 0, NULL),
       (972, 1243, 1, 1.00, 1, NULL),
       (973, 1243, 8, 450.00, 0, NULL),
       (974, 1244, 1, 1.00, 1, NULL),
       (975, 1244, 8, 450.00, 0, NULL),
       (976, 1245, 1, 1.00, 1, NULL),
       (977, 1245, 8, 450.00, 0, NULL),
       (978, 1246, 1, 1.00, 1, NULL),
       (979, 1246, 8, 450.00, 0, NULL),
       (980, 1247, 1, 1.00, 1, NULL),
       (981, 1247, 8, 450.00, 0, NULL),
       (982, 1248, 1, 1.00, 1, NULL),
       (983, 1248, 8, 450.00, 0, NULL),
       (984, 1249, 1, 1.00, 1, NULL),
       (985, 1249, 8, 450.00, 0, NULL),
       (986, 1250, 7, 1.00, 1, NULL),
       (987, 1250, 6, 250.00, 0, NULL),
       (988, 1251, 1, 1.00, 1, NULL),
       (989, 1251, 8, 450.00, 0, NULL),
       (990, 1252, 7, 1.00, 1, NULL),
       (991, 1252, 6, 250.00, 0, NULL),
       (992, 1253, 1, 1.00, 1, NULL),
       (993, 1253, 8, 450.00, 0, NULL),
       (994, 1254, 1, 1.00, 1, NULL),
       (995, 1254, 8, 450.00, 0, NULL),
       (996, 1255, 1, 1.00, 1, NULL),
       (997, 1255, 8, 450.00, 0, NULL),
       (998, 1256, 1, 1.00, 1, NULL),
       (999, 1256, 8, 450.00, 0, NULL),
       (1000, 1257, 1, 1.00, 1, NULL),
       (1001, 1257, 8, 450.00, 0, NULL),
       (1002, 1258, 1, 1.00, 1, NULL),
       (1003, 1258, 8, 450.00, 0, NULL),
       (1004, 1259, 1, 1.00, 1, NULL),
       (1005, 1259, 8, 450.00, 0, NULL),
       (1006, 1260, 1, 1.00, 1, NULL),
       (1007, 1260, 8, 450.00, 0, NULL),
       (1008, 1261, 7, 1.00, 1, NULL),
       (1009, 1261, 6, 250.00, 0, NULL),
       (1010, 1262, 1, 1.00, 1, NULL),
       (1011, 1262, 8, 450.00, 0, NULL),
       (1012, 1263, 1, 1.00, 1, NULL),
       (1013, 1263, 8, 450.00, 0, NULL),
       (1014, 1264, 1, 1.00, 1, NULL),
       (1015, 1264, 8, 450.00, 0, NULL),
       (1016, 1265, 1, 1.00, 1, NULL),
       (1017, 1265, 8, 450.00, 0, NULL),
       (1018, 1266, 1, 1.00, 1, NULL),
       (1019, 1266, 8, 450.00, 0, NULL),
       (1020, 1267, 1, 1.00, 1, NULL),
       (1021, 1267, 8, 450.00, 0, NULL),
       (1022, 1268, 7, 1.00, 1, NULL),
       (1023, 1268, 6, 250.00, 0, NULL),
       (1024, 1269, 1, 1.00, 1, NULL),
       (1025, 1269, 8, 450.00, 0, NULL),
       (1026, 1270, 1, 1.00, 1, NULL),
       (1027, 1270, 8, 450.00, 0, NULL),
       (1028, 1271, 1, 1.00, 1, NULL),
       (1029, 1271, 8, 450.00, 0, NULL),
       (1030, 1272, 1, 1.00, 1, NULL),
       (1031, 1272, 8, 450.00, 0, NULL),
       (1032, 1273, 1, 1.00, 1, NULL),
       (1033, 1273, 8, 450.00, 0, NULL),
       (1034, 1274, 1, 1.00, 1, NULL),
       (1035, 1274, 8, 450.00, 0, NULL),
       (1036, 1275, 1, 1.00, 1, NULL),
       (1037, 1275, 8, 450.00, 0, NULL),
       (1038, 1276, 1, 1.00, 1, NULL),
       (1039, 1276, 8, 450.00, 0, NULL),
       (1040, 1277, 1, 1.00, 1, NULL),
       (1041, 1277, 8, 450.00, 0, NULL),
       (1042, 1278, 1, 1.00, 1, NULL),
       (1043, 1278, 8, 450.00, 0, NULL),
       (1044, 1279, 1, 1.00, 1, NULL),
       (1045, 1279, 8, 450.00, 0, NULL),
       (1046, 1280, 1, 1.00, 1, NULL),
       (1047, 1280, 8, 450.00, 0, NULL),
       (1048, 1281, 1, 1.00, 1, NULL),
       (1049, 1281, 8, 450.00, 0, NULL),
       (1050, 1282, 1, 1.00, 1, NULL),
       (1051, 1282, 8, 450.00, 0, NULL),
       (1052, 1283, 1, 1.00, 1, NULL),
       (1053, 1283, 8, 450.00, 0, NULL),
       (1054, 1284, 1, 1.00, 1, NULL),
       (1055, 1284, 8, 450.00, 0, NULL),
       (1056, 1285, 1, 1.00, 1, NULL),
       (1057, 1285, 8, 450.00, 0, NULL),
       (1058, 1286, 1, 1.00, 1, NULL),
       (1059, 1286, 8, 450.00, 0, NULL),
       (1060, 1287, 1, 1.00, 1, NULL),
       (1061, 1287, 8, 450.00, 0, NULL),
       (1062, 1288, 1, 1.00, 1, NULL),
       (1063, 1288, 8, 450.00, 0, NULL),
       (1064, 1289, 1, 1.00, 1, NULL),
       (1065, 1289, 8, 450.00, 0, NULL),
       (1066, 1290, 1, 1.00, 1, NULL),
       (1067, 1290, 8, 450.00, 0, NULL),
       (1068, 1291, 1, 1.00, 1, NULL),
       (1069, 1291, 8, 450.00, 0, NULL),
       (1070, 1292, 1, 1.00, 1, NULL),
       (1071, 1292, 8, 450.00, 0, NULL),
       (1072, 1293, 1, 1.00, 1, NULL),
       (1073, 1293, 8, 450.00, 0, NULL),
       (1074, 1294, 1, 1.00, 1, NULL),
       (1075, 1294, 8, 450.00, 0, NULL),
       (1076, 1295, 1, 1.00, 1, NULL),
       (1077, 1295, 8, 450.00, 0, NULL),
       (1078, 1296, 1, 1.00, 1, NULL),
       (1079, 1296, 8, 450.00, 0, NULL),
       (1080, 1297, 1, 1.00, 1, NULL),
       (1081, 1297, 8, 450.00, 0, NULL),
       (1082, 1298, 1, 1.00, 1, NULL),
       (1083, 1298, 8, 450.00, 0, NULL),
       (1084, 1299, 1, 1.00, 1, NULL),
       (1085, 1299, 8, 450.00, 0, NULL),
       (1086, 1300, 1, 1.00, 1, NULL),
       (1087, 1300, 8, 450.00, 0, NULL),
       (1088, 1301, 1, 1.00, 1, NULL),
       (1089, 1301, 8, 450.00, 0, NULL),
       (1090, 1302, 1, 1.00, 1, NULL),
       (1091, 1302, 8, 450.00, 0, NULL),
       (1092, 1303, 1, 1.00, 1, NULL),
       (1093, 1303, 8, 450.00, 0, NULL),
       (1094, 1304, 1, 1.00, 1, NULL),
       (1095, 1304, 8, 450.00, 0, NULL),
       (1096, 1305, 1, 1.00, 1, NULL),
       (1097, 1305, 8, 450.00, 0, NULL),
       (1098, 1306, 1, 1.00, 1, NULL),
       (1099, 1306, 8, 450.00, 0, NULL),
       (1100, 1307, 1, 1.00, 1, NULL),
       (1101, 1307, 8, 450.00, 0, NULL),
       (1102, 1308, 1, 1.00, 1, NULL),
       (1103, 1308, 8, 450.00, 0, NULL),
       (1104, 1309, 1, 1.00, 1, NULL),
       (1105, 1309, 8, 450.00, 0, NULL),
       (1106, 1310, 1, 1.00, 1, NULL),
       (1107, 1310, 8, 450.00, 0, NULL),
       (1108, 1311, 1, 1.00, 1, NULL),
       (1109, 1311, 8, 450.00, 0, NULL),
       (1110, 1312, 1, 1.00, 1, NULL),
       (1111, 1312, 8, 450.00, 0, NULL),
       (1112, 1313, 1, 1.00, 1, NULL),
       (1113, 1313, 8, 450.00, 0, NULL),
       (1114, 1314, 1, 1.00, 1, NULL),
       (1115, 1314, 8, 450.00, 0, NULL),
       (1116, 1315, 1, 1.00, 1, NULL),
       (1117, 1315, 8, 450.00, 0, NULL),
       (1118, 1316, 1, 1.00, 1, NULL),
       (1119, 1316, 8, 450.00, 0, NULL),
       (1120, 1317, 1, 1.00, 1, NULL),
       (1121, 1317, 8, 450.00, 0, NULL),
       (1122, 1318, 1, 1.00, 1, NULL),
       (1123, 1318, 8, 450.00, 0, NULL),
       (1124, 1319, 1, 1.00, 1, NULL),
       (1125, 1319, 8, 450.00, 0, NULL),
       (1126, 1320, 1, 1.00, 1, NULL),
       (1127, 1320, 8, 450.00, 0, NULL),
       (1128, 1321, 1, 1.00, 1, NULL),
       (1129, 1321, 8, 450.00, 0, NULL),
       (1130, 1322, 1, 1.00, 1, NULL),
       (1131, 1322, 8, 450.00, 0, NULL),
       (1132, 1323, 1, 1.00, 1, NULL),
       (1133, 1323, 8, 450.00, 0, NULL),
       (1134, 1324, 1, 1.00, 1, NULL),
       (1135, 1324, 8, 450.00, 0, NULL),
       (1136, 1325, 1, 1.00, 1, NULL),
       (1137, 1325, 8, 450.00, 0, NULL),
       (1138, 1326, 1, 1.00, 1, NULL),
       (1139, 1326, 8, 450.00, 0, NULL),
       (1140, 1327, 1, 1.00, 1, NULL),
       (1141, 1327, 8, 450.00, 0, NULL),
       (1142, 1328, 1, 1.00, 1, NULL),
       (1143, 1328, 8, 450.00, 0, NULL),
       (1144, 1329, 1, 1.00, 1, NULL),
       (1145, 1329, 8, 450.00, 0, NULL),
       (1146, 1330, 1, 1.00, 1, NULL),
       (1147, 1330, 8, 450.00, 0, NULL),
       (1148, 1331, 1, 1.00, 1, NULL),
       (1149, 1331, 8, 450.00, 0, NULL),
       (1150, 1332, 1, 1.00, 1, NULL),
       (1151, 1332, 8, 450.00, 0, NULL),
       (1152, 1333, 1, 1.00, 1, NULL),
       (1153, 1333, 8, 450.00, 0, NULL),
       (1154, 1334, 1, 1.00, 1, NULL),
       (1155, 1334, 8, 450.00, 0, NULL),
       (1156, 1335, 1, 1.00, 1, NULL),
       (1157, 1335, 8, 450.00, 0, NULL),
       (1158, 1336, 1, 1.00, 1, NULL),
       (1159, 1336, 8, 450.00, 0, NULL),
       (1160, 1337, 1, 1.00, 1, NULL),
       (1161, 1337, 8, 450.00, 0, NULL),
       (1162, 1338, 1, 1.00, 1, NULL),
       (1163, 1338, 8, 450.00, 0, NULL),
       (1164, 1339, 1, 1.00, 1, NULL),
       (1165, 1339, 8, 450.00, 0, NULL),
       (1166, 1340, 1, 1.00, 1, NULL),
       (1167, 1340, 8, 450.00, 0, NULL),
       (1168, 1341, 1, 1.00, 1, NULL),
       (1169, 1341, 8, 450.00, 0, NULL),
       (1170, 1342, 1, 1.00, 1, NULL),
       (1171, 1342, 8, 450.00, 0, NULL),
       (1172, 1343, 1, 1.00, 1, NULL),
       (1173, 1343, 8, 450.00, 0, NULL),
       (1174, 1344, 1, 1.00, 1, NULL),
       (1175, 1344, 8, 450.00, 0, NULL),
       (1176, 1345, 1, 1.00, 1, NULL),
       (1177, 1345, 8, 450.00, 0, NULL),
       (1178, 1346, 1, 1.00, 1, NULL),
       (1179, 1346, 8, 450.00, 0, NULL),
       (1180, 1347, 1, 1.00, 1, NULL),
       (1181, 1347, 8, 450.00, 0, NULL),
       (1182, 1348, 1, 1.00, 1, NULL),
       (1183, 1348, 8, 450.00, 0, NULL),
       (1184, 1349, 1, 1.00, 1, NULL),
       (1185, 1349, 8, 450.00, 0, NULL),
       (1186, 1350, 1, 1.00, 1, NULL),
       (1187, 1350, 8, 450.00, 0, NULL),
       (1188, 1351, 1, 1.00, 1, NULL),
       (1189, 1351, 8, 450.00, 0, NULL),
       (1190, 1352, 1, 1.00, 1, NULL),
       (1191, 1352, 8, 450.00, 0, NULL),
       (1192, 1353, 1, 1.00, 1, NULL),
       (1193, 1353, 8, 450.00, 0, NULL),
       (1194, 1354, 1, 1.00, 1, NULL),
       (1195, 1354, 8, 450.00, 0, NULL),
       (1196, 1355, 1, 1.00, 1, NULL),
       (1197, 1355, 8, 450.00, 0, NULL),
       (1198, 1356, 1, 1.00, 1, NULL),
       (1199, 1356, 8, 450.00, 0, NULL),
       (1200, 1357, 1, 1.00, 1, NULL),
       (1201, 1357, 8, 450.00, 0, NULL),
       (1202, 1358, 1, 1.00, 1, NULL),
       (1203, 1358, 8, 450.00, 0, NULL),
       (1204, 1359, 1, 1.00, 1, NULL),
       (1205, 1359, 8, 450.00, 0, NULL),
       (1206, 1360, 1, 1.00, 1, NULL),
       (1207, 1360, 8, 450.00, 0, NULL),
       (1208, 1361, 1, 1.00, 1, NULL),
       (1209, 1361, 8, 450.00, 0, NULL),
       (1210, 1362, 1, 1.00, 1, NULL),
       (1211, 1362, 8, 450.00, 0, NULL),
       (1212, 1363, 1, 1.00, 1, NULL),
       (1213, 1363, 8, 450.00, 0, NULL),
       (1214, 1364, 1, 1.00, 1, NULL),
       (1215, 1364, 8, 450.00, 0, NULL),
       (1216, 1365, 1, 1.00, 1, NULL),
       (1217, 1365, 8, 450.00, 0, NULL),
       (1218, 1366, 1, 1.00, 1, NULL),
       (1219, 1366, 8, 450.00, 0, NULL),
       (1220, 1367, 1, 1.00, 1, NULL),
       (1221, 1367, 8, 450.00, 0, NULL),
       (1222, 1368, 1, 1.00, 1, NULL),
       (1223, 1368, 8, 450.00, 0, NULL),
       (1224, 1369, 1, 1.00, 1, NULL),
       (1225, 1369, 8, 450.00, 0, NULL),
       (1226, 1370, 1, 1.00, 1, NULL),
       (1227, 1370, 8, 450.00, 0, NULL),
       (1228, 1371, 1, 1.00, 1, NULL),
       (1229, 1371, 8, 450.00, 0, NULL),
       (1230, 1372, 1, 1.00, 1, NULL),
       (1231, 1372, 8, 450.00, 0, NULL),
       (1232, 1373, 1, 1.00, 1, NULL),
       (1233, 1373, 8, 450.00, 0, NULL),
       (1234, 1374, 1, 1.00, 1, NULL),
       (1235, 1374, 8, 450.00, 0, NULL),
       (1236, 1375, 1, 1.00, 1, NULL),
       (1237, 1375, 8, 450.00, 0, NULL),
       (1238, 1376, 1, 1.00, 1, NULL),
       (1239, 1376, 8, 450.00, 0, NULL),
       (1240, 1377, 1, 1.00, 1, NULL),
       (1241, 1377, 8, 450.00, 0, NULL),
       (1242, 1378, 1, 1.00, 1, NULL),
       (1243, 1378, 8, 450.00, 0, NULL),
       (1244, 1379, 1, 1.00, 1, NULL),
       (1245, 1379, 8, 450.00, 0, NULL),
       (1246, 1380, 1, 1.00, 1, NULL),
       (1247, 1380, 8, 450.00, 0, NULL),
       (1248, 1381, 1, 1.00, 1, NULL),
       (1249, 1381, 8, 450.00, 0, NULL),
       (1250, 1382, 1, 1.00, 1, NULL),
       (1251, 1382, 8, 450.00, 0, NULL),
       (1252, 1383, 1, 1.00, 1, NULL),
       (1253, 1383, 8, 450.00, 0, NULL),
       (1254, 1384, 1, 1.00, 1, NULL),
       (1255, 1384, 8, 450.00, 0, NULL),
       (1256, 1385, 1, 1.00, 1, NULL),
       (1257, 1385, 8, 450.00, 0, NULL),
       (1258, 1386, 1, 1.00, 1, NULL),
       (1259, 1386, 8, 450.00, 0, NULL),
       (1260, 1387, 1, 1.00, 1, NULL),
       (1261, 1387, 8, 450.00, 0, NULL),
       (1262, 1388, 1, 1.00, 1, NULL),
       (1263, 1388, 8, 450.00, 0, NULL),
       (1264, 1389, 1, 1.00, 1, NULL),
       (1265, 1389, 8, 450.00, 0, NULL),
       (1266, 1390, 1, 1.00, 1, NULL),
       (1267, 1390, 8, 450.00, 0, NULL),
       (1268, 1391, 1, 1.00, 1, NULL),
       (1269, 1391, 8, 450.00, 0, NULL),
       (1270, 1392, 1, 1.00, 1, NULL),
       (1271, 1392, 8, 450.00, 0, NULL),
       (1272, 1393, 1, 1.00, 1, NULL),
       (1273, 1393, 8, 450.00, 0, NULL),
       (1274, 1394, 1, 1.00, 1, NULL),
       (1275, 1394, 8, 450.00, 0, NULL),
       (1276, 1395, 1, 1.00, 1, NULL),
       (1277, 1395, 8, 450.00, 0, NULL),
       (1278, 1396, 1, 1.00, 1, NULL),
       (1279, 1396, 8, 450.00, 0, NULL),
       (1280, 1397, 1, 1.00, 1, NULL),
       (1281, 1397, 8, 450.00, 0, NULL),
       (1282, 1398, 1, 1.00, 1, NULL),
       (1283, 1398, 8, 450.00, 0, NULL),
       (1284, 1399, 1, 1.00, 1, NULL),
       (1285, 1399, 8, 450.00, 0, NULL),
       (1286, 1400, 1, 1.00, 1, NULL),
       (1287, 1400, 8, 450.00, 0, NULL),
       (1288, 1401, 1, 1.00, 1, NULL),
       (1289, 1401, 8, 450.00, 0, NULL),
       (1290, 1402, 1, 1.00, 1, NULL),
       (1291, 1402, 8, 450.00, 0, NULL),
       (1292, 1403, 1, 1.00, 1, NULL),
       (1293, 1403, 8, 450.00, 0, NULL),
       (1294, 1404, 1, 1.00, 1, NULL),
       (1295, 1404, 8, 450.00, 0, NULL),
       (1296, 1405, 1, 1.00, 1, NULL),
       (1297, 1405, 8, 450.00, 0, NULL),
       (1298, 1406, 1, 1.00, 1, NULL),
       (1299, 1406, 8, 450.00, 0, NULL),
       (1300, 1407, 1, 1.00, 1, NULL),
       (1301, 1407, 8, 450.00, 0, NULL),
       (1302, 1408, 1, 1.00, 1, NULL),
       (1303, 1408, 8, 450.00, 0, NULL),
       (1304, 1409, 1, 1.00, 1, NULL),
       (1305, 1409, 8, 450.00, 0, NULL),
       (1306, 1410, 1, 1.00, 1, NULL),
       (1307, 1410, 8, 450.00, 0, NULL),
       (1308, 1411, 1, 1.00, 1, NULL),
       (1309, 1411, 8, 450.00, 0, NULL),
       (1310, 1412, 1, 1.00, 1, NULL),
       (1311, 1412, 8, 450.00, 0, NULL),
       (1312, 1413, 1, 1.00, 1, NULL),
       (1313, 1413, 8, 450.00, 0, NULL),
       (1314, 1414, 1, 1.00, 1, NULL),
       (1315, 1414, 8, 450.00, 0, NULL),
       (1316, 1415, 1, 1.00, 1, NULL),
       (1317, 1415, 8, 450.00, 0, NULL),
       (1318, 1416, 1, 1.00, 1, NULL),
       (1319, 1416, 8, 450.00, 0, NULL),
       (1320, 1417, 1, 1.00, 1, NULL),
       (1321, 1417, 8, 450.00, 0, NULL),
       (1322, 1418, 1, 1.00, 1, NULL),
       (1323, 1418, 8, 450.00, 0, NULL),
       (1324, 14, 6, 250.00, 0, NULL),
       (1325, 1420, 1, 1.00, 1, NULL),
       (1326, 1420, 8, 450.00, 0, NULL),
       (1327, 1421, 1, 1.00, 1, NULL),
       (1328, 1421, 8, 450.00, 0, NULL),
       (1329, 1422, 1, 1.00, 1, NULL),
       (1330, 1422, 8, 450.00, 0, NULL),
       (1331, 1423, 1, 1.00, 1, NULL),
       (1332, 1423, 8, 450.00, 0, NULL),
       (1333, 1424, 1, 1.00, 1, NULL),
       (1334, 1424, 8, 450.00, 0, NULL),
       (1335, 1425, 1, 1.00, 1, NULL),
       (1336, 1425, 8, 450.00, 0, NULL),
       (1337, 1426, 1, 1.00, 1, NULL),
       (1338, 1426, 8, 450.00, 0, NULL),
       (1339, 1427, 1, 1.00, 1, NULL),
       (1340, 1427, 8, 450.00, 0, NULL),
       (1341, 1428, 1, 1.00, 1, NULL),
       (1342, 1428, 8, 450.00, 0, NULL),
       (1343, 1429, 1, 1.00, 1, NULL),
       (1344, 1429, 8, 450.00, 0, NULL),
       (1345, 1430, 1, 1.00, 1, NULL),
       (1346, 1430, 8, 450.00, 0, NULL),
       (1347, 1431, 1, 1.00, 1, NULL),
       (1348, 1431, 8, 450.00, 0, NULL),
       (1349, 1432, 1, 1.00, 1, NULL),
       (1350, 1432, 8, 450.00, 0, NULL),
       (1351, 1433, 1, 1.00, 1, NULL),
       (1352, 1433, 8, 450.00, 0, NULL),
       (1353, 1434, 1, 1.00, 1, NULL),
       (1354, 1434, 8, 450.00, 0, NULL),
       (1355, 1435, 1, 1.00, 1, NULL),
       (1356, 1435, 8, 450.00, 0, NULL),
       (1357, 1436, 1, 1.00, 1, NULL),
       (1358, 1436, 8, 450.00, 0, NULL),
       (1359, 1437, 1, 1.00, 1, NULL),
       (1360, 1437, 8, 450.00, 0, NULL),
       (1361, 1438, 1, 1.00, 1, NULL),
       (1362, 1438, 8, 450.00, 0, NULL),
       (1363, 1439, 1, 1.00, 1, NULL),
       (1364, 1439, 8, 450.00, 0, NULL),
       (1365, 1440, 1, 1.00, 1, NULL),
       (1366, 1440, 8, 450.00, 0, NULL),
       (1367, 1441, 1, 1.00, 1, NULL),
       (1368, 1441, 8, 450.00, 0, NULL),
       (1369, 1442, 1, 1.00, 1, NULL),
       (1370, 1442, 8, 450.00, 0, NULL),
       (1371, 1443, 1, 1.00, 1, NULL),
       (1372, 1443, 8, 450.00, 0, NULL),
       (1373, 1444, 1, 1.00, 1, NULL),
       (1374, 1444, 8, 450.00, 0, NULL),
       (1375, 1445, 1, 1.00, 1, NULL),
       (1376, 1445, 8, 450.00, 0, NULL),
       (1377, 1446, 7, 1.00, 1, NULL),
       (1378, 1446, 6, 250.00, 0, NULL),
       (1379, 1447, 1, 1.00, 1, NULL),
       (1380, 1447, 8, 450.00, 0, NULL),
       (1381, 1047, 8, 450.00, 0, NULL),
       (1382, 1449, 1, 1.00, 1, NULL),
       (1383, 1449, 8, 450.00, 0, NULL),
       (1384, 1450, 7, 1.00, 1, NULL),
       (1385, 1450, 6, 250.00, 0, NULL),
       (1386, 1451, 1, 1.00, 1, NULL),
       (1387, 1451, 8, 450.00, 0, NULL),
       (1388, 1452, 1, 1.00, 1, NULL),
       (1389, 1452, 8, 450.00, 0, NULL),
       (1390, 1453, 1, 1.00, 1, NULL),
       (1391, 1453, 8, 450.00, 0, NULL),
       (1392, 1454, 1, 1.00, 1, NULL),
       (1393, 1454, 8, 450.00, 0, NULL),
       (1394, 1455, 1, 1.00, 1, NULL),
       (1395, 1455, 8, 450.00, 0, NULL),
       (1396, 1456, 1, 1.00, 1, NULL),
       (1397, 1456, 8, 450.00, 0, NULL),
       (1398, 1457, 1, 1.00, 1, NULL),
       (1399, 1457, 8, 450.00, 0, NULL),
       (1400, 1458, 1, 1.00, 1, NULL),
       (1401, 1458, 8, 450.00, 0, NULL),
       (1402, 1459, 1, 1.00, 1, NULL),
       (1403, 1459, 8, 450.00, 0, NULL),
       (1404, 1049, 8, 450.00, 0, NULL),
       (1405, 1048, 8, 450.00, 0, NULL),
       (1406, 1462, 1, 1.00, 1, NULL),
       (1407, 1462, 8, 450.00, 0, NULL),
       (1408, 1463, 1, 1.00, 1, NULL),
       (1409, 1463, 8, 450.00, 0, NULL),
       (1410, 1464, 1, 1.00, 1, NULL),
       (1411, 1464, 8, 450.00, 0, NULL),
       (1412, 1465, 1, 1.00, 1, NULL),
       (1413, 1465, 8, 450.00, 0, NULL),
       (1414, 1466, 1, 1.00, 1, NULL),
       (1415, 1466, 8, 450.00, 0, NULL),
       (1416, 1467, 1, 1.00, 1, NULL),
       (1417, 1467, 8, 450.00, 0, NULL),
       (1418, 1468, 1, 1.00, 1, NULL),
       (1419, 1468, 8, 450.00, 0, NULL),
       (1420, 1469, 1, 1.00, 1, NULL),
       (1421, 1469, 8, 450.00, 0, NULL),
       (1422, 1470, 1, 1.00, 1, NULL),
       (1423, 1470, 8, 450.00, 0, NULL),
       (1424, 1471, 1, 1.00, 1, NULL),
       (1425, 1471, 8, 450.00, 0, NULL),
       (1426, 1472, 1, 1.00, 1, NULL),
       (1427, 1472, 8, 450.00, 0, NULL),
       (1428, 1473, 1, 1.00, 1, NULL),
       (1429, 1473, 8, 450.00, 0, NULL),
       (1430, 1474, 1, 1.00, 1, NULL),
       (1431, 1474, 8, 450.00, 0, NULL),
       (1432, 1475, 1, 1.00, 1, NULL),
       (1433, 1475, 8, 450.00, 0, NULL),
       (1434, 1476, 1, 1.00, 1, NULL),
       (1435, 1476, 8, 450.00, 0, NULL),
       (1436, 1477, 1, 1.00, 1, NULL),
       (1437, 1477, 8, 450.00, 0, NULL),
       (1438, 1478, 1, 1.00, 1, NULL),
       (1439, 1478, 8, 450.00, 0, NULL),
       (1440, 1479, 1, 1.00, 1, NULL),
       (1441, 1479, 8, 450.00, 0, NULL),
       (1442, 1480, 1, 1.00, 1, NULL),
       (1443, 1480, 8, 450.00, 0, NULL),
       (1444, 1481, 1, 1.00, 1, NULL),
       (1445, 1481, 8, 450.00, 0, NULL),
       (1446, 1482, 1, 1.00, 1, NULL),
       (1447, 1482, 8, 450.00, 0, NULL),
       (1448, 1483, 1, 1.00, 1, NULL),
       (1449, 1483, 8, 450.00, 0, NULL),
       (1450, 1484, 7, 1.00, 1, NULL),
       (1451, 1484, 6, 250.00, 0, NULL),
       (1452, 1485, 7, 1.00, 1, NULL),
       (1453, 1485, 6, 250.00, 0, NULL),
       (1454, 1486, 1, 1.00, 1, NULL),
       (1455, 1486, 8, 450.00, 0, NULL),
       (1456, 1487, 1, 1.00, 1, NULL),
       (1457, 1487, 8, 450.00, 0, NULL),
       (1458, 1488, 1, 1.00, 1, NULL),
       (1459, 1488, 8, 450.00, 0, NULL),
       (1460, 1489, 7, 1.00, 1, NULL),
       (1461, 1489, 6, 250.00, 0, NULL),
       (1462, 1490, 1, 1.00, 1, NULL),
       (1463, 1490, 8, 450.00, 0, NULL),
       (1464, 1491, 1, 1.00, 1, NULL),
       (1465, 1491, 8, 450.00, 0, NULL),
       (1466, 1492, 1, 1.00, 1, NULL),
       (1467, 1492, 8, 450.00, 0, NULL),
       (1468, 1050, 8, 450.00, 0, NULL),
       (1469, 1494, 1, 1.00, 1, NULL),
       (1470, 1494, 8, 450.00, 0, NULL),
       (1471, 1495, 1, 1.00, 1, NULL),
       (1472, 1495, 8, 450.00, 0, NULL),
       (1473, 1496, 1, 1.00, 1, NULL),
       (1474, 1496, 8, 450.00, 0, NULL),
       (1475, 1497, 1, 1.00, 1, NULL),
       (1476, 1497, 8, 450.00, 0, NULL),
       (1477, 1498, 1, 1.00, 1, NULL),
       (1478, 1498, 8, 450.00, 0, NULL),
       (1479, 1499, 1, 1.00, 1, NULL),
       (1480, 1499, 8, 450.00, 0, NULL),
       (1481, 1500, 1, 1.00, 1, NULL),
       (1482, 1500, 8, 450.00, 0, NULL),
       (1483, 1501, 1, 1.00, 1, NULL),
       (1484, 1501, 8, 450.00, 0, NULL),
       (1485, 1502, 1, 1.00, 1, NULL),
       (1486, 1502, 8, 450.00, 0, NULL),
       (1487, 1503, 1, 1.00, 1, NULL),
       (1488, 1503, 8, 450.00, 0, NULL),
       (1489, 1504, 1, 1.00, 1, NULL),
       (1490, 1504, 8, 450.00, 0, NULL),
       (1491, 1505, 1, 1.00, 1, NULL),
       (1492, 1505, 8, 450.00, 0, NULL),
       (1493, 1506, 1, 1.00, 1, NULL),
       (1494, 1506, 8, 450.00, 0, NULL),
       (1495, 1507, 1, 1.00, 1, NULL),
       (1496, 1507, 8, 450.00, 0, NULL),
       (1497, 1508, 1, 1.00, 1, NULL),
       (1498, 1508, 8, 450.00, 0, NULL),
       (1499, 1509, 1, 1.00, 1, NULL),
       (1500, 1509, 8, 450.00, 0, NULL),
       (1501, 1510, 1, 1.00, 1, NULL),
       (1502, 1510, 8, 450.00, 0, NULL),
       (1503, 1511, 1, 1.00, 1, NULL),
       (1504, 1511, 8, 450.00, 0, NULL),
       (1505, 1512, 7, 1.00, 1, NULL),
       (1506, 1512, 6, 250.00, 0, NULL),
       (1507, 1513, 7, 1.00, 1, NULL),
       (1508, 1513, 6, 250.00, 0, NULL),
       (1509, 1514, 7, 1.00, 1, NULL),
       (1510, 1514, 6, 250.00, 0, NULL),
       (1511, 1515, 7, 1.00, 1, NULL),
       (1512, 1515, 6, 250.00, 0, NULL),
       (1513, 1516, 7, 1.00, 1, NULL),
       (1514, 1516, 6, 250.00, 0, NULL),
       (1515, 1517, 7, 1.00, 1, NULL),
       (1516, 1517, 6, 250.00, 0, NULL),
       (1517, 1518, 7, 1.00, 1, NULL),
       (1518, 1518, 6, 250.00, 0, NULL),
       (1519, 1519, 7, 1.00, 1, NULL),
       (1520, 1519, 6, 250.00, 0, NULL),
       (1521, 1520, 7, 1.00, 1, NULL),
       (1522, 1520, 6, 250.00, 0, NULL),
       (1523, 1521, 7, 1.00, 1, NULL),
       (1524, 1521, 6, 250.00, 0, NULL),
       (1525, 1523, 7, 1.00, 1, NULL),
       (1526, 1523, 6, 250.00, 0, NULL),
       (1527, 1524, 1, 1.00, 1, NULL),
       (1528, 1524, 8, 450.00, 0, NULL),
       (1529, 1525, 1, 1.00, 1, NULL),
       (1530, 1525, 8, 450.00, 0, NULL),
       (1531, 1526, 1, 1.00, 1, NULL),
       (1532, 1526, 8, 450.00, 0, NULL),
       (1533, 1527, 1, 1.00, 1, NULL),
       (1534, 1527, 8, 450.00, 0, NULL),
       (1535, 1528, 1, 1.00, 1, NULL),
       (1536, 1528, 8, 450.00, 0, NULL),
       (1537, 1529, 1, 1.00, 1, NULL),
       (1538, 1529, 8, 450.00, 0, NULL),
       (1539, 1530, 1, 1.00, 1, NULL),
       (1540, 1530, 8, 450.00, 0, NULL),
       (1541, 1531, 7, 1.00, 1, NULL),
       (1542, 1531, 6, 250.00, 0, NULL),
       (1543, 1532, 7, 1.00, 1, NULL),
       (1544, 1532, 6, 250.00, 0, NULL),
       (1545, 1533, 7, 1.00, 1, NULL),
       (1546, 1533, 6, 250.00, 0, NULL),
       (1547, 1534, 1, 1.00, 1, NULL),
       (1548, 1534, 8, 450.00, 0, NULL),
       (1549, 1535, 1, 1.00, 1, NULL),
       (1550, 1535, 8, 450.00, 0, NULL),
       (1551, 1536, 7, 1.00, 1, NULL),
       (1552, 1536, 6, 250.00, 0, NULL),
       (1553, 1537, 7, 1.00, 1, NULL),
       (1554, 1537, 6, 250.00, 0, NULL),
       (1555, 1538, 1, 1.00, 1, NULL),
       (1556, 1538, 8, 450.00, 0, NULL),
       (1557, 1539, 7, 1.00, 1, NULL),
       (1558, 1539, 6, 250.00, 0, NULL),
       (1559, 1540, 1, 1.00, 1, NULL),
       (1560, 1540, 8, 450.00, 0, NULL),
       (1561, 1542, 7, 1.00, 1, NULL),
       (1562, 1542, 6, 250.00, 0, NULL),
       (1563, 1543, 7, 1.00, 1, NULL),
       (1564, 1543, 6, 250.00, 0, NULL),
       (1565, 1544, 7, 1.00, 1, NULL),
       (1566, 1544, 6, 250.00, 0, NULL),
       (1567, 1545, 7, 1.00, 1, NULL),
       (1568, 1545, 6, 250.00, 0, NULL),
       (1569, 1547, 7, 1.00, 1, NULL),
       (1570, 1547, 6, 250.00, 0, NULL),
       (1571, 1548, 7, 1.00, 1, NULL),
       (1572, 1548, 6, 250.00, 0, NULL),
       (1573, 1549, 7, 1.00, 1, NULL),
       (1574, 1549, 6, 250.00, 0, NULL),
       (1575, 1550, 1, 1.00, 1, NULL),
       (1576, 1550, 8, 450.00, 0, NULL),
       (1577, 1551, 7, 1.00, 1, NULL),
       (1578, 1551, 6, 250.00, 0, NULL),
       (1579, 1052, 1, 1.00, 1, NULL),
       (1580, 1052, 8, 450.00, 0, NULL),
       (1581, 1555, 1, 1.00, 1, NULL),
       (1582, 1555, 8, 450.00, 0, NULL),
       (1583, 1556, 7, 1.00, 1, NULL),
       (1584, 1556, 6, 250.00, 0, NULL),
       (1585, 1557, 7, 1.00, 1, NULL),
       (1586, 1557, 6, 250.00, 0, NULL),
       (1587, 1558, 1, 1.00, 1, NULL),
       (1588, 1558, 8, 450.00, 0, NULL),
       (1589, 1559, 1, 1.00, 1, NULL),
       (1590, 1559, 8, 450.00, 0, NULL),
       (1591, 1560, 7, 1.00, 1, NULL),
       (1592, 1560, 6, 250.00, 0, NULL),
       (1593, 1562, 7, 1.00, 1, NULL),
       (1594, 1562, 6, 250.00, 0, NULL),
       (1595, 1563, 7, 1.00, 1, NULL),
       (1596, 1563, 6, 250.00, 0, NULL),
       (1597, 1564, 7, 1.00, 1, NULL),
       (1598, 1564, 6, 250.00, 0, NULL),
       (1599, 1565, 7, 1.00, 1, NULL),
       (1600, 1565, 6, 250.00, 0, NULL),
       (1601, 1566, 7, 1.00, 1, NULL),
       (1602, 1566, 6, 250.00, 0, NULL),
       (1603, 1569, 7, 1.00, 1, NULL),
       (1604, 1569, 6, 250.00, 0, NULL),
       (1605, 1570, 7, 1.00, 1, NULL),
       (1606, 1570, 6, 250.00, 0, NULL),
       (1607, 1571, 1, 1.00, 1, NULL),
       (1608, 1571, 8, 450.00, 0, NULL),
       (1609, 1572, 7, 1.00, 1, NULL),
       (1610, 1572, 6, 250.00, 0, NULL),
       (1611, 1573, 1, 1.00, 1, NULL),
       (1612, 1573, 8, 450.00, 0, NULL),
       (1613, 1574, 1, 1.00, 1, NULL),
       (1614, 1574, 8, 450.00, 0, NULL),
       (1615, 1575, 7, 1.00, 1, NULL),
       (1616, 1575, 6, 250.00, 0, NULL),
       (1617, 1576, 7, 1.00, 1, NULL),
       (1618, 1576, 6, 250.00, 0, NULL),
       (1619, 1577, 7, 1.00, 1, NULL),
       (1620, 1577, 6, 250.00, 0, NULL),
       (1621, 1578, 7, 1.00, 1, NULL),
       (1622, 1578, 6, 250.00, 0, NULL),
       (1623, 1579, 7, 1.00, 1, NULL),
       (1624, 1579, 6, 250.00, 0, NULL),
       (1625, 1580, 7, 1.00, 1, NULL),
       (1626, 1580, 6, 250.00, 0, NULL),
       (1627, 1581, 7, 1.00, 1, NULL),
       (1628, 1581, 6, 250.00, 0, NULL),
       (1629, 1583, 7, 1.00, 1, NULL),
       (1630, 1583, 6, 250.00, 0, NULL),
       (1631, 1584, 1, 1.00, 1, NULL),
       (1632, 1584, 8, 450.00, 0, NULL),
       (1633, 1585, 1, 1.00, 1, NULL),
       (1634, 1585, 8, 450.00, 0, NULL),
       (1635, 1586, 1, 1.00, 1, NULL),
       (1636, 1586, 8, 450.00, 0, NULL),
       (1637, 1587, 7, 1.00, 1, NULL),
       (1638, 1587, 6, 250.00, 0, NULL),
       (1639, 1588, 7, 1.00, 1, NULL),
       (1640, 1588, 6, 250.00, 0, NULL),
       (1641, 1589, 7, 1.00, 1, NULL),
       (1642, 1589, 6, 250.00, 0, NULL),
       (1643, 1590, 7, 1.00, 1, NULL),
       (1644, 1590, 6, 250.00, 0, NULL),
       (1645, 1591, 1, 1.00, 1, NULL),
       (1646, 1591, 8, 450.00, 0, NULL),
       (1647, 1592, 1, 1.00, 1, NULL),
       (1648, 1592, 8, 450.00, 0, NULL),
       (1649, 1593, 1, 1.00, 1, NULL),
       (1650, 1593, 8, 450.00, 0, NULL),
       (1651, 1594, 1, 1.00, 1, NULL),
       (1652, 1594, 8, 450.00, 0, NULL),
       (1653, 1595, 1, 1.00, 1, NULL),
       (1654, 1595, 8, 450.00, 0, NULL),
       (1655, 1596, 7, 1.00, 1, NULL),
       (1656, 1596, 6, 250.00, 0, NULL),
       (1657, 1597, 7, 1.00, 1, NULL),
       (1658, 1597, 6, 250.00, 0, NULL),
       (1659, 1598, 7, 1.00, 1, NULL),
       (1660, 1598, 6, 250.00, 0, NULL),
       (1661, 1599, 1, 1.00, 1, NULL),
       (1662, 1599, 8, 450.00, 0, NULL),
       (1663, 1600, 1, 1.00, 1, NULL),
       (1664, 1600, 8, 450.00, 0, NULL),
       (1665, 1601, 1, 1.00, 1, NULL),
       (1666, 1601, 8, 450.00, 0, NULL),
       (1667, 1602, 1, 1.00, 1, NULL),
       (1668, 1602, 8, 450.00, 0, NULL),
       (1669, 1603, 1, 1.00, 1, NULL),
       (1670, 1603, 8, 450.00, 0, NULL),
       (1671, 1604, 1, 1.00, 1, NULL),
       (1672, 1604, 8, 450.00, 0, NULL),
       (1673, 1605, 1, 1.00, 1, NULL),
       (1674, 1605, 8, 450.00, 0, NULL),
       (1675, 1606, 1, 1.00, 1, NULL),
       (1676, 1606, 8, 450.00, 0, NULL),
       (1677, 1607, 1, 1.00, 1, NULL),
       (1678, 1607, 8, 450.00, 0, NULL),
       (1679, 1608, 1, 1.00, 1, NULL),
       (1680, 1608, 8, 450.00, 0, NULL),
       (1681, 1609, 7, 1.00, 1, NULL),
       (1682, 1609, 6, 250.00, 0, NULL),
       (1683, 1610, 7, 1.00, 1, NULL),
       (1684, 1610, 6, 250.00, 0, NULL),
       (1685, 1611, 1, 1.00, 1, NULL),
       (1686, 1611, 8, 450.00, 0, NULL),
       (1687, 1612, 1, 1.00, 1, NULL),
       (1688, 1612, 8, 450.00, 0, NULL),
       (1689, 1613, 1, 1.00, 1, NULL),
       (1690, 1613, 8, 450.00, 0, NULL),
       (1691, 1614, 1, 1.00, 1, NULL),
       (1692, 1614, 8, 450.00, 0, NULL),
       (1693, 1615, 1, 1.00, 1, NULL),
       (1694, 1615, 8, 450.00, 0, NULL),
       (1695, 1616, 1, 1.00, 1, NULL),
       (1696, 1616, 8, 450.00, 0, NULL),
       (1697, 1617, 1, 1.00, 1, NULL),
       (1698, 1617, 8, 450.00, 0, NULL),
       (1699, 1618, 1, 1.00, 1, NULL),
       (1700, 1618, 8, 450.00, 0, NULL),
       (1701, 1619, 1, 1.00, 1, NULL),
       (1702, 1619, 8, 450.00, 0, NULL),
       (1703, 1620, 1, 1.00, 1, NULL),
       (1704, 1620, 8, 450.00, 0, NULL),
       (1705, 1621, 1, 1.00, 1, NULL),
       (1706, 1621, 8, 450.00, 0, NULL),
       (1707, 1622, 1, 1.00, 1, NULL),
       (1708, 1622, 8, 450.00, 0, NULL),
       (1709, 1623, 1, 1.00, 1, NULL),
       (1710, 1623, 8, 450.00, 0, NULL),
       (1711, 1624, 1, 1.00, 1, NULL),
       (1712, 1624, 8, 450.00, 0, NULL),
       (1713, 1625, 1, 1.00, 1, NULL),
       (1714, 1625, 8, 450.00, 0, NULL),
       (1715, 1626, 1, 1.00, 1, NULL),
       (1716, 1626, 8, 450.00, 0, NULL),
       (1717, 1627, 1, 1.00, 1, NULL),
       (1718, 1627, 8, 450.00, 0, NULL),
       (1719, 1628, 1, 1.00, 1, NULL),
       (1720, 1628, 8, 450.00, 0, NULL),
       (1721, 1629, 7, 1.00, 1, NULL),
       (1722, 1629, 6, 250.00, 0, NULL),
       (1723, 1630, 1, 1.00, 1, NULL),
       (1724, 1630, 8, 450.00, 0, NULL),
       (1725, 1631, 1, 1.00, 1, NULL),
       (1726, 1631, 8, 450.00, 0, NULL),
       (1727, 1632, 7, 1.00, 1, NULL),
       (1728, 1632, 6, 250.00, 0, NULL),
       (1729, 1633, 1, 1.00, 1, NULL),
       (1730, 1633, 8, 450.00, 0, NULL),
       (1731, 1634, 1, 1.00, 1, NULL),
       (1732, 1634, 8, 450.00, 0, NULL),
       (1733, 1635, 1, 1.00, 1, NULL),
       (1734, 1635, 8, 450.00, 0, NULL),
       (1735, 1636, 1, 1.00, 1, NULL),
       (1736, 1636, 8, 450.00, 0, NULL),
       (1737, 1637, 1, 1.00, 1, NULL),
       (1738, 1637, 8, 450.00, 0, NULL),
       (1739, 1638, 1, 1.00, 1, NULL),
       (1740, 1638, 8, 450.00, 0, NULL),
       (1741, 1639, 1, 1.00, 1, NULL),
       (1742, 1639, 8, 450.00, 0, NULL),
       (1743, 1640, 1, 1.00, 1, NULL),
       (1744, 1640, 8, 450.00, 0, NULL),
       (1745, 1641, 1, 1.00, 1, NULL),
       (1746, 1641, 8, 450.00, 0, NULL),
       (1747, 1642, 1, 1.00, 1, NULL),
       (1748, 1642, 8, 450.00, 0, NULL),
       (1749, 1643, 1, 1.00, 1, NULL),
       (1750, 1643, 8, 450.00, 0, NULL),
       (1751, 1644, 1, 1.00, 1, NULL),
       (1752, 1644, 8, 450.00, 0, NULL),
       (1753, 1645, 1, 1.00, 1, NULL),
       (1754, 1645, 8, 450.00, 0, NULL),
       (1755, 1646, 1, 1.00, 1, NULL),
       (1756, 1646, 8, 450.00, 0, NULL),
       (1757, 1647, 1, 1.00, 1, NULL),
       (1758, 1647, 8, 450.00, 0, NULL),
       (1759, 1648, 1, 1.00, 1, NULL),
       (1760, 1648, 8, 450.00, 0, NULL),
       (1761, 1649, 1, 1.00, 1, NULL),
       (1762, 1649, 8, 450.00, 0, NULL),
       (1763, 1650, 1, 1.00, 1, NULL),
       (1764, 1650, 8, 450.00, 0, NULL),
       (1765, 1651, 1, 1.00, 1, NULL),
       (1766, 1651, 8, 450.00, 0, NULL),
       (1767, 1652, 1, 1.00, 1, NULL),
       (1768, 1652, 8, 450.00, 0, NULL),
       (1769, 1653, 1, 1.00, 1, NULL),
       (1770, 1653, 8, 450.00, 0, NULL),
       (1771, 1039, 8, 450.00, 0, NULL),
       (1772, 1655, 1, 1.00, 1, NULL),
       (1773, 1655, 8, 450.00, 0, NULL),
       (1774, 1656, 1, 1.00, 1, NULL),
       (1775, 1656, 8, 450.00, 0, NULL),
       (1776, 1657, 1, 1.00, 1, NULL),
       (1777, 1657, 8, 450.00, 0, NULL),
       (1778, 1658, 1, 1.00, 1, NULL),
       (1779, 1658, 8, 450.00, 0, NULL),
       (1780, 1659, 1, 1.00, 1, NULL),
       (1781, 1659, 8, 450.00, 0, NULL),
       (1782, 1660, 1, 1.00, 1, NULL),
       (1783, 1660, 8, 450.00, 0, NULL),
       (1784, 1661, 1, 1.00, 1, NULL),
       (1785, 1661, 8, 450.00, 0, NULL),
       (1786, 1662, 1, 1.00, 1, NULL),
       (1787, 1662, 8, 450.00, 0, NULL),
       (1788, 1663, 1, 1.00, 1, NULL),
       (1789, 1663, 8, 450.00, 0, NULL),
       (1790, 1664, 1, 1.00, 1, NULL),
       (1791, 1664, 8, 450.00, 0, NULL),
       (1792, 1665, 1, 1.00, 1, NULL),
       (1793, 1665, 8, 450.00, 0, NULL),
       (1794, 1666, 1, 1.00, 1, NULL),
       (1795, 1666, 8, 450.00, 0, NULL),
       (1796, 1667, 1, 1.00, 1, NULL),
       (1797, 1667, 8, 450.00, 0, NULL),
       (1798, 1668, 1, 1.00, 1, NULL),
       (1799, 1668, 8, 450.00, 0, NULL),
       (1800, 1669, 1, 1.00, 1, NULL),
       (1801, 1669, 8, 450.00, 0, NULL),
       (1802, 1670, 1, 1.00, 1, NULL),
       (1803, 1670, 8, 450.00, 0, NULL),
       (1804, 1671, 1, 1.00, 1, NULL),
       (1805, 1671, 8, 450.00, 0, NULL),
       (1806, 1672, 1, 1.00, 1, NULL),
       (1807, 1672, 8, 450.00, 0, NULL),
       (1808, 1673, 7, 1.00, 1, NULL),
       (1809, 1673, 6, 250.00, 0, NULL),
       (1810, 1674, 1, 1.00, 1, NULL),
       (1811, 1674, 8, 450.00, 0, NULL),
       (1812, 1675, 1, 1.00, 1, NULL),
       (1813, 1675, 8, 450.00, 0, NULL),
       (1814, 1676, 1, 1.00, 1, NULL),
       (1815, 1676, 8, 450.00, 0, NULL),
       (1816, 1677, 1, 1.00, 1, NULL),
       (1817, 1677, 8, 450.00, 0, NULL),
       (1818, 1678, 1, 1.00, 1, NULL),
       (1819, 1678, 8, 450.00, 0, NULL),
       (1820, 1679, 1, 1.00, 1, NULL),
       (1821, 1679, 8, 450.00, 0, NULL),
       (1822, 1680, 1, 1.00, 1, NULL),
       (1823, 1680, 8, 450.00, 0, NULL),
       (1824, 1681, 1, 1.00, 1, NULL),
       (1825, 1681, 8, 450.00, 0, NULL),
       (1826, 1682, 1, 1.00, 1, NULL),
       (1827, 1682, 8, 450.00, 0, NULL),
       (1828, 1683, 1, 1.00, 1, NULL),
       (1829, 1683, 8, 450.00, 0, NULL),
       (1830, 1684, 1, 1.00, 1, NULL),
       (1831, 1684, 8, 450.00, 0, NULL),
       (1832, 1685, 1, 1.00, 1, NULL),
       (1833, 1685, 8, 450.00, 0, NULL),
       (1834, 1686, 1, 1.00, 1, NULL),
       (1835, 1686, 8, 450.00, 0, NULL),
       (1836, 1687, 1, 1.00, 1, NULL),
       (1837, 1687, 8, 450.00, 0, NULL),
       (1838, 1688, 1, 1.00, 1, NULL),
       (1839, 1688, 8, 450.00, 0, NULL),
       (1840, 1689, 1, 1.00, 1, NULL),
       (1841, 1689, 8, 450.00, 0, NULL),
       (1842, 1690, 1, 1.00, 1, NULL),
       (1843, 1690, 8, 450.00, 0, NULL),
       (1844, 1691, 1, 1.00, 1, NULL),
       (1845, 1691, 8, 450.00, 0, NULL),
       (1846, 1692, 1, 1.00, 1, NULL),
       (1847, 1692, 8, 450.00, 0, NULL),
       (1848, 1693, 1, 1.00, 1, NULL),
       (1849, 1693, 8, 450.00, 0, NULL),
       (1850, 1694, 1, 1.00, 1, NULL),
       (1851, 1694, 8, 450.00, 0, NULL),
       (1852, 1695, 1, 1.00, 1, NULL),
       (1853, 1695, 8, 450.00, 0, NULL),
       (1854, 1696, 1, 1.00, 1, NULL),
       (1855, 1696, 8, 450.00, 0, NULL),
       (1856, 1697, 1, 1.00, 1, NULL),
       (1857, 1697, 8, 450.00, 0, NULL),
       (1858, 1698, 1, 1.00, 1, NULL),
       (1859, 1698, 8, 450.00, 0, NULL),
       (1860, 1699, 1, 1.00, 1, NULL),
       (1861, 1699, 8, 450.00, 0, NULL),
       (1862, 1700, 1, 1.00, 1, NULL),
       (1863, 1700, 8, 450.00, 0, NULL),
       (1864, 1701, 1, 1.00, 1, NULL),
       (1865, 1701, 8, 450.00, 0, NULL),
       (1866, 1702, 1, 1.00, 1, NULL),
       (1867, 1702, 8, 450.00, 0, NULL),
       (1868, 1703, 1, 1.00, 1, NULL),
       (1869, 1703, 8, 450.00, 0, NULL),
       (1870, 1704, 1, 1.00, 1, NULL),
       (1871, 1704, 8, 450.00, 0, NULL),
       (1872, 1705, 1, 1.00, 1, NULL),
       (1873, 1705, 8, 450.00, 0, NULL),
       (1874, 1706, 1, 1.00, 1, NULL),
       (1875, 1706, 8, 450.00, 0, NULL),
       (1876, 1707, 1, 1.00, 1, NULL),
       (1877, 1707, 8, 450.00, 0, NULL),
       (1878, 1708, 1, 1.00, 1, NULL),
       (1879, 1708, 8, 450.00, 0, NULL),
       (1880, 1709, 1, 1.00, 1, NULL),
       (1881, 1709, 8, 450.00, 0, NULL),
       (1882, 1710, 1, 1.00, 1, NULL),
       (1883, 1710, 8, 450.00, 0, NULL),
       (1884, 1711, 1, 1.00, 1, NULL),
       (1885, 1711, 8, 450.00, 0, NULL),
       (1886, 1712, 1, 1.00, 1, NULL),
       (1887, 1712, 8, 450.00, 0, NULL),
       (1888, 1713, 1, 1.00, 1, NULL),
       (1889, 1713, 8, 450.00, 0, NULL),
       (1890, 1714, 1, 1.00, 1, NULL),
       (1891, 1714, 8, 450.00, 0, NULL),
       (1892, 1715, 1, 1.00, 1, NULL),
       (1893, 1715, 8, 450.00, 0, NULL),
       (1894, 1716, 1, 1.00, 1, NULL),
       (1895, 1716, 8, 450.00, 0, NULL),
       (1896, 1717, 1, 1.00, 1, NULL),
       (1897, 1717, 8, 450.00, 0, NULL),
       (1898, 1718, 1, 1.00, 1, NULL),
       (1899, 1718, 8, 450.00, 0, NULL),
       (1900, 1719, 1, 1.00, 1, NULL),
       (1901, 1719, 8, 450.00, 0, NULL),
       (1902, 1720, 1, 1.00, 1, NULL),
       (1903, 1720, 8, 450.00, 0, NULL),
       (1904, 1721, 1, 1.00, 1, NULL),
       (1905, 1721, 8, 450.00, 0, NULL),
       (1906, 1722, 1, 1.00, 1, NULL),
       (1907, 1722, 8, 450.00, 0, NULL),
       (1908, 1723, 1, 1.00, 1, NULL),
       (1909, 1723, 8, 450.00, 0, NULL),
       (1910, 1724, 1, 1.00, 1, NULL),
       (1911, 1724, 8, 450.00, 0, NULL),
       (1912, 1725, 1, 1.00, 1, NULL),
       (1913, 1725, 8, 450.00, 0, NULL),
       (1914, 1726, 1, 1.00, 1, NULL),
       (1915, 1726, 8, 450.00, 0, NULL),
       (1916, 1727, 1, 1.00, 1, NULL),
       (1917, 1727, 8, 450.00, 0, NULL),
       (1918, 1728, 1, 1.00, 1, NULL),
       (1919, 1728, 8, 450.00, 0, NULL),
       (1920, 1729, 1, 1.00, 1, NULL),
       (1921, 1729, 8, 450.00, 0, NULL),
       (1922, 1730, 1, 1.00, 1, NULL),
       (1923, 1730, 8, 450.00, 0, NULL),
       (1924, 1731, 1, 1.00, 1, NULL),
       (1925, 1731, 8, 450.00, 0, NULL),
       (1926, 1732, 1, 1.00, 1, NULL),
       (1927, 1732, 8, 450.00, 0, NULL),
       (1928, 1733, 1, 1.00, 1, NULL),
       (1929, 1733, 8, 450.00, 0, NULL),
       (1930, 1734, 1, 1.00, 1, NULL),
       (1931, 1734, 8, 450.00, 0, NULL),
       (1932, 1735, 1, 1.00, 1, NULL),
       (1933, 1735, 8, 450.00, 0, NULL),
       (1934, 1736, 1, 1.00, 1, NULL),
       (1935, 1736, 8, 450.00, 0, NULL),
       (1936, 1737, 1, 1.00, 1, NULL),
       (1937, 1737, 8, 450.00, 0, NULL),
       (1938, 1738, 1, 1.00, 1, NULL),
       (1939, 1738, 8, 450.00, 0, NULL),
       (1940, 1739, 1, 1.00, 1, NULL),
       (1941, 1739, 8, 450.00, 0, NULL),
       (1942, 1740, 1, 1.00, 1, NULL),
       (1943, 1740, 8, 450.00, 0, NULL),
       (1944, 1741, 1, 1.00, 1, NULL),
       (1945, 1741, 8, 450.00, 0, NULL),
       (1946, 1742, 1, 1.00, 1, NULL),
       (1947, 1742, 8, 450.00, 0, NULL),
       (1948, 1743, 1, 1.00, 1, NULL),
       (1949, 1743, 8, 450.00, 0, NULL),
       (1950, 1744, 1, 1.00, 1, NULL),
       (1951, 1744, 8, 450.00, 0, NULL),
       (1952, 1745, 1, 1.00, 1, NULL),
       (1953, 1745, 8, 450.00, 0, NULL),
       (1954, 1746, 1, 1.00, 1, NULL),
       (1955, 1746, 8, 450.00, 0, NULL),
       (1956, 1747, 1, 1.00, 1, NULL),
       (1957, 1747, 8, 450.00, 0, NULL),
       (1958, 1748, 1, 1.00, 1, NULL),
       (1959, 1748, 8, 450.00, 0, NULL),
       (1960, 1749, 1, 1.00, 1, NULL),
       (1961, 1749, 8, 450.00, 0, NULL),
       (1962, 1750, 1, 1.00, 1, NULL),
       (1963, 1750, 8, 450.00, 0, NULL),
       (1964, 1751, 1, 1.00, 1, NULL),
       (1965, 1751, 8, 450.00, 0, NULL),
       (1966, 1752, 1, 1.00, 1, NULL),
       (1967, 1752, 8, 450.00, 0, NULL),
       (1968, 1753, 1, 1.00, 1, NULL),
       (1969, 1753, 8, 450.00, 0, NULL),
       (1970, 1754, 1, 1.00, 1, NULL),
       (1971, 1754, 8, 450.00, 0, NULL),
       (1972, 1755, 7, 1.00, 1, NULL),
       (1973, 1755, 6, 250.00, 0, NULL),
       (1974, 1756, 1, 1.00, 1, NULL),
       (1975, 1756, 8, 450.00, 0, NULL),
       (1976, 1757, 1, 1.00, 1, NULL),
       (1977, 1757, 8, 450.00, 0, NULL),
       (1978, 1758, 1, 1.00, 1, NULL),
       (1979, 1758, 8, 450.00, 0, NULL),
       (1980, 1759, 1, 1.00, 1, NULL),
       (1981, 1759, 8, 450.00, 0, NULL),
       (1982, 1760, 1, 1.00, 1, NULL),
       (1983, 1760, 8, 450.00, 0, NULL),
       (1984, 1761, 1, 1.00, 1, NULL),
       (1985, 1761, 8, 450.00, 0, NULL),
       (1986, 1762, 1, 1.00, 1, NULL),
       (1987, 1762, 8, 450.00, 0, NULL),
       (1988, 1763, 1, 1.00, 1, NULL),
       (1989, 1763, 8, 450.00, 0, NULL),
       (1990, 1764, 1, 1.00, 1, NULL),
       (1991, 1764, 8, 450.00, 0, NULL),
       (1992, 1765, 1, 1.00, 1, NULL),
       (1993, 1765, 8, 450.00, 0, NULL),
       (1994, 1766, 1, 1.00, 1, NULL),
       (1995, 1766, 8, 450.00, 0, NULL),
       (1996, 1767, 1, 1.00, 1, NULL),
       (1997, 1767, 8, 450.00, 0, NULL),
       (1998, 1768, 1, 1.00, 1, NULL),
       (1999, 1768, 8, 450.00, 0, NULL),
       (2000, 1769, 1, 1.00, 1, NULL),
       (2001, 1769, 8, 450.00, 0, NULL),
       (2002, 1770, 1, 1.00, 1, NULL),
       (2003, 1770, 8, 450.00, 0, NULL),
       (2004, 1771, 1, 1.00, 1, NULL),
       (2005, 1771, 8, 450.00, 0, NULL),
       (2006, 1772, 1, 1.00, 1, NULL),
       (2007, 1772, 8, 450.00, 0, NULL),
       (2008, 1773, 1, 1.00, 1, NULL),
       (2009, 1773, 8, 450.00, 0, NULL),
       (2010, 1774, 1, 1.00, 1, NULL),
       (2011, 1774, 8, 450.00, 0, NULL),
       (2012, 1775, 1, 1.00, 1, NULL),
       (2013, 1775, 8, 450.00, 0, NULL),
       (2014, 1776, 1, 1.00, 1, NULL),
       (2015, 1776, 8, 450.00, 0, NULL),
       (2016, 1777, 1, 1.00, 1, NULL),
       (2017, 1777, 8, 450.00, 0, NULL),
       (2018, 1778, 1, 1.00, 1, NULL),
       (2019, 1778, 8, 450.00, 0, NULL),
       (2020, 1779, 1, 1.00, 1, NULL),
       (2021, 1779, 8, 450.00, 0, NULL),
       (2022, 1780, 1, 1.00, 1, NULL),
       (2023, 1780, 8, 450.00, 0, NULL),
       (2024, 1781, 1, 1.00, 1, NULL),
       (2025, 1781, 8, 450.00, 0, NULL),
       (2026, 1782, 1, 1.00, 1, NULL),
       (2027, 1782, 8, 450.00, 0, NULL),
       (2028, 1783, 1, 1.00, 1, NULL),
       (2029, 1783, 8, 450.00, 0, NULL),
       (2030, 1784, 7, 1.00, 1, NULL),
       (2031, 1784, 6, 250.00, 0, NULL),
       (2032, 1785, 1, 1.00, 1, NULL),
       (2033, 1785, 8, 450.00, 0, NULL),
       (2034, 1786, 1, 1.00, 1, NULL),
       (2035, 1786, 8, 450.00, 0, NULL),
       (2036, 1787, 1, 1.00, 1, NULL),
       (2037, 1787, 8, 450.00, 0, NULL),
       (2038, 1788, 1, 1.00, 1, NULL),
       (2039, 1788, 8, 450.00, 0, NULL),
       (2040, 1789, 1, 1.00, 1, NULL),
       (2041, 1789, 8, 450.00, 0, NULL),
       (2042, 1790, 1, 1.00, 1, NULL),
       (2043, 1790, 8, 450.00, 0, NULL),
       (2044, 1791, 1, 1.00, 1, NULL),
       (2045, 1791, 8, 450.00, 0, NULL),
       (2046, 1792, 1, 1.00, 1, NULL),
       (2047, 1792, 8, 450.00, 0, NULL),
       (2048, 1793, 1, 1.00, 1, NULL),
       (2049, 1793, 8, 450.00, 0, NULL),
       (2050, 1011, 8, 450.00, 0, NULL),
       (2051, 1795, 1, 1.00, 1, NULL),
       (2052, 1795, 8, 450.00, 0, NULL),
       (2053, 1796, 1, 1.00, 1, NULL),
       (2054, 1796, 8, 450.00, 0, NULL),
       (2055, 1797, 1, 1.00, 1, NULL),
       (2056, 1797, 8, 450.00, 0, NULL),
       (2057, 1798, 1, 1.00, 1, NULL),
       (2058, 1798, 8, 450.00, 0, NULL),
       (2059, 1799, 1, 1.00, 1, NULL),
       (2060, 1799, 8, 450.00, 0, NULL),
       (2061, 1800, 1, 1.00, 1, NULL),
       (2062, 1800, 8, 450.00, 0, NULL),
       (2063, 1801, 1, 1.00, 1, NULL),
       (2064, 1801, 8, 450.00, 0, NULL),
       (2065, 1802, 1, 1.00, 1, NULL),
       (2066, 1802, 8, 450.00, 0, NULL),
       (2067, 1803, 1, 1.00, 1, NULL),
       (2068, 1803, 8, 450.00, 0, NULL),
       (2069, 1804, 1, 1.00, 1, NULL),
       (2070, 1804, 8, 450.00, 0, NULL),
       (2071, 1805, 1, 1.00, 1, NULL),
       (2072, 1805, 8, 450.00, 0, NULL),
       (2073, 1806, 1, 1.00, 1, NULL),
       (2074, 1806, 8, 450.00, 0, NULL),
       (2075, 1807, 1, 1.00, 1, NULL),
       (2076, 1807, 8, 450.00, 0, NULL),
       (2077, 1808, 1, 1.00, 1, NULL),
       (2078, 1808, 8, 450.00, 0, NULL),
       (2079, 1809, 1, 1.00, 1, NULL),
       (2080, 1809, 8, 450.00, 0, NULL),
       (2081, 1810, 1, 1.00, 1, NULL),
       (2082, 1810, 8, 450.00, 0, NULL),
       (2083, 1811, 1, 1.00, 1, NULL),
       (2084, 1811, 8, 450.00, 0, NULL),
       (2085, 1812, 1, 1.00, 1, NULL),
       (2086, 1812, 8, 450.00, 0, NULL),
       (2087, 1813, 1, 1.00, 1, NULL),
       (2088, 1813, 8, 450.00, 0, NULL),
       (2089, 1814, 1, 1.00, 1, NULL),
       (2090, 1814, 8, 450.00, 0, NULL),
       (2091, 1815, 1, 1.00, 1, NULL),
       (2092, 1815, 8, 450.00, 0, NULL),
       (2093, 1816, 1, 1.00, 1, NULL),
       (2094, 1816, 8, 450.00, 0, NULL),
       (2095, 1817, 1, 1.00, 1, NULL),
       (2096, 1817, 8, 450.00, 0, NULL),
       (2097, 1818, 1, 1.00, 1, NULL),
       (2098, 1818, 8, 450.00, 0, NULL),
       (2099, 1819, 1, 1.00, 1, NULL),
       (2100, 1819, 8, 450.00, 0, NULL),
       (2101, 1820, 1, 1.00, 1, NULL),
       (2102, 1820, 8, 450.00, 0, NULL),
       (2103, 1821, 1, 1.00, 1, NULL),
       (2104, 1821, 8, 450.00, 0, NULL),
       (2105, 1822, 1, 1.00, 1, NULL),
       (2106, 1822, 8, 450.00, 0, NULL),
       (2107, 1823, 1, 1.00, 1, NULL),
       (2108, 1823, 8, 450.00, 0, NULL),
       (2109, 1824, 1, 1.00, 1, NULL),
       (2110, 1824, 8, 450.00, 0, NULL),
       (2111, 1825, 1, 1.00, 1, NULL),
       (2112, 1825, 8, 450.00, 0, NULL),
       (2113, 1826, 1, 1.00, 1, NULL),
       (2114, 1826, 8, 450.00, 0, NULL),
       (2115, 1827, 1, 1.00, 1, NULL),
       (2116, 1827, 8, 450.00, 0, NULL),
       (2117, 1828, 7, 1.00, 1, NULL),
       (2118, 1828, 6, 250.00, 0, NULL),
       (2119, 1829, 1, 1.00, 1, NULL),
       (2120, 1829, 8, 450.00, 0, NULL),
       (2121, 1830, 1, 1.00, 1, NULL),
       (2122, 1830, 8, 450.00, 0, NULL),
       (2123, 1831, 1, 1.00, 1, NULL),
       (2124, 1831, 8, 450.00, 0, NULL),
       (2125, 1832, 1, 1.00, 1, NULL),
       (2126, 1832, 8, 450.00, 0, NULL),
       (2127, 1833, 7, 1.00, 1, NULL),
       (2128, 1833, 6, 250.00, 0, NULL),
       (2129, 1834, 1, 1.00, 1, NULL),
       (2130, 1834, 8, 450.00, 0, NULL),
       (2131, 1835, 1, 1.00, 1, NULL),
       (2132, 1835, 8, 450.00, 0, NULL),
       (2133, 1836, 1, 1.00, 1, NULL),
       (2134, 1836, 8, 450.00, 0, NULL),
       (2135, 1837, 1, 1.00, 1, NULL),
       (2136, 1837, 8, 450.00, 0, NULL),
       (2137, 1838, 1, 1.00, 1, NULL),
       (2138, 1838, 8, 450.00, 0, NULL),
       (2139, 1839, 1, 1.00, 1, NULL),
       (2140, 1839, 8, 450.00, 0, NULL),
       (2141, 1840, 1, 1.00, 1, NULL),
       (2142, 1840, 8, 450.00, 0, NULL),
       (2143, 1841, 1, 1.00, 1, NULL),
       (2144, 1841, 8, 450.00, 0, NULL),
       (2145, 1842, 1, 1.00, 1, NULL),
       (2146, 1842, 8, 450.00, 0, NULL),
       (2147, 1843, 1, 1.00, 1, NULL),
       (2148, 1843, 8, 450.00, 0, NULL),
       (2149, 1844, 1, 1.00, 1, NULL),
       (2150, 1844, 8, 450.00, 0, NULL),
       (2151, 1845, 1, 1.00, 1, NULL),
       (2152, 1845, 8, 450.00, 0, NULL),
       (2153, 1846, 1, 1.00, 1, NULL),
       (2154, 1846, 8, 450.00, 0, NULL),
       (2155, 1847, 1, 1.00, 1, NULL),
       (2156, 1847, 8, 450.00, 0, NULL),
       (2157, 1848, 1, 1.00, 1, NULL),
       (2158, 1848, 8, 450.00, 0, NULL),
       (2159, 1849, 1, 1.00, 1, NULL),
       (2160, 1849, 8, 450.00, 0, NULL),
       (2161, 1850, 1, 1.00, 1, NULL),
       (2162, 1850, 8, 450.00, 0, NULL),
       (2163, 1851, 1, 1.00, 1, NULL),
       (2164, 1851, 8, 450.00, 0, NULL),
       (2165, 1852, 1, 1.00, 1, NULL),
       (2166, 1852, 8, 450.00, 0, NULL),
       (2167, 1853, 1, 1.00, 1, NULL),
       (2168, 1853, 8, 450.00, 0, NULL),
       (2169, 1854, 1, 1.00, 1, NULL),
       (2170, 1854, 8, 450.00, 0, NULL),
       (2171, 1855, 1, 1.00, 1, NULL),
       (2172, 1855, 8, 450.00, 0, NULL),
       (2173, 1856, 1, 1.00, 1, NULL),
       (2174, 1856, 8, 450.00, 0, NULL),
       (2175, 1857, 1, 1.00, 1, NULL),
       (2176, 1857, 8, 450.00, 0, NULL),
       (2177, 1858, 1, 1.00, 1, NULL),
       (2178, 1858, 8, 450.00, 0, NULL),
       (2179, 1859, 1, 1.00, 1, NULL),
       (2180, 1859, 8, 450.00, 0, NULL),
       (2181, 1860, 1, 1.00, 1, NULL),
       (2182, 1860, 8, 450.00, 0, NULL),
       (2183, 1861, 1, 1.00, 1, NULL),
       (2184, 1861, 8, 450.00, 0, NULL),
       (2185, 1862, 1, 1.00, 1, NULL),
       (2186, 1862, 8, 450.00, 0, NULL),
       (2187, 1863, 1, 1.00, 1, NULL),
       (2188, 1863, 8, 450.00, 0, NULL),
       (2189, 1864, 1, 1.00, 1, NULL),
       (2190, 1864, 8, 450.00, 0, NULL),
       (2191, 1865, 1, 1.00, 1, NULL),
       (2192, 1865, 8, 450.00, 0, NULL),
       (2193, 1866, 1, 1.00, 1, NULL),
       (2194, 1866, 8, 450.00, 0, NULL),
       (2195, 1867, 1, 1.00, 1, NULL),
       (2196, 1867, 8, 450.00, 0, NULL),
       (2197, 1868, 1, 1.00, 1, NULL),
       (2198, 1868, 8, 450.00, 0, NULL),
       (2199, 1869, 1, 1.00, 1, NULL),
       (2200, 1869, 8, 450.00, 0, NULL),
       (2201, 1870, 1, 1.00, 1, NULL),
       (2202, 1870, 8, 450.00, 0, NULL),
       (2203, 1871, 1, 1.00, 1, NULL),
       (2204, 1871, 8, 450.00, 0, NULL),
       (2205, 1872, 1, 1.00, 1, NULL),
       (2206, 1872, 8, 450.00, 0, NULL),
       (2207, 1873, 1, 1.00, 1, NULL),
       (2208, 1873, 8, 450.00, 0, NULL),
       (2209, 1874, 1, 1.00, 1, NULL),
       (2210, 1874, 8, 450.00, 0, NULL),
       (2211, 1875, 1, 1.00, 1, NULL),
       (2212, 1875, 8, 450.00, 0, NULL),
       (2213, 1876, 1, 1.00, 1, NULL),
       (2214, 1876, 8, 450.00, 0, NULL),
       (2215, 1877, 1, 1.00, 1, NULL),
       (2216, 1877, 8, 450.00, 0, NULL),
       (2217, 1878, 1, 1.00, 1, NULL),
       (2218, 1878, 8, 450.00, 0, NULL),
       (2219, 1879, 1, 1.00, 1, NULL),
       (2220, 1879, 8, 450.00, 0, NULL),
       (2221, 1880, 1, 1.00, 1, NULL),
       (2222, 1880, 8, 450.00, 0, NULL),
       (2223, 1881, 1, 1.00, 1, NULL),
       (2224, 1881, 8, 450.00, 0, NULL),
       (2225, 1882, 1, 1.00, 1, NULL),
       (2226, 1882, 8, 450.00, 0, NULL),
       (2227, 1883, 1, 1.00, 1, NULL),
       (2228, 1883, 8, 450.00, 0, NULL),
       (2229, 1884, 1, 1.00, 1, NULL),
       (2230, 1884, 8, 450.00, 0, NULL),
       (2231, 1885, 1, 1.00, 1, NULL),
       (2232, 1885, 8, 450.00, 0, NULL),
       (2233, 1886, 1, 1.00, 1, NULL),
       (2234, 1886, 8, 450.00, 0, NULL),
       (2235, 1887, 1, 1.00, 1, NULL),
       (2236, 1887, 8, 450.00, 0, NULL),
       (2237, 1888, 7, 1.00, 1, NULL),
       (2238, 1888, 6, 250.00, 0, NULL),
       (2239, 1889, 1, 1.00, 1, NULL),
       (2240, 1889, 8, 450.00, 0, NULL),
       (2241, 1890, 1, 1.00, 1, NULL),
       (2242, 1890, 8, 450.00, 0, NULL),
       (2243, 1891, 1, 1.00, 1, NULL),
       (2244, 1891, 8, 450.00, 0, NULL),
       (2245, 1892, 1, 1.00, 1, NULL),
       (2246, 1892, 8, 450.00, 0, NULL),
       (2247, 1893, 1, 1.00, 1, NULL),
       (2248, 1893, 8, 450.00, 0, NULL),
       (2249, 1894, 1, 1.00, 1, NULL),
       (2250, 1894, 8, 450.00, 0, NULL),
       (2251, 1895, 1, 1.00, 1, NULL),
       (2252, 1895, 8, 450.00, 0, NULL),
       (2253, 1896, 1, 1.00, 1, NULL),
       (2254, 1896, 8, 450.00, 0, NULL),
       (2255, 1897, 1, 1.00, 1, NULL),
       (2256, 1897, 8, 450.00, 0, NULL),
       (2257, 1898, 1, 1.00, 1, NULL),
       (2258, 1898, 8, 450.00, 0, NULL),
       (2259, 1899, 1, 1.00, 1, NULL),
       (2260, 1899, 8, 450.00, 0, NULL),
       (2261, 1900, 1, 1.00, 1, NULL),
       (2262, 1900, 8, 450.00, 0, NULL),
       (2263, 1901, 1, 1.00, 1, NULL),
       (2264, 1901, 8, 450.00, 0, NULL),
       (2265, 1902, 1, 1.00, 1, NULL),
       (2266, 1902, 8, 450.00, 0, NULL),
       (2267, 1903, 1, 1.00, 1, NULL),
       (2268, 1903, 8, 450.00, 0, NULL),
       (2269, 1904, 1, 1.00, 1, NULL),
       (2270, 1904, 8, 450.00, 0, NULL),
       (2271, 1905, 1, 1.00, 1, NULL),
       (2272, 1905, 8, 450.00, 0, NULL),
       (2273, 1906, 1, 1.00, 1, NULL),
       (2274, 1906, 8, 450.00, 0, NULL),
       (2275, 1907, 1, 1.00, 1, NULL),
       (2276, 1907, 8, 450.00, 0, NULL),
       (2277, 1908, 1, 1.00, 1, NULL),
       (2278, 1908, 8, 450.00, 0, NULL),
       (2279, 1909, 1, 1.00, 1, NULL),
       (2280, 1909, 8, 450.00, 0, NULL),
       (2281, 1910, 1, 1.00, 1, NULL),
       (2282, 1910, 8, 450.00, 0, NULL),
       (2283, 1911, 7, 1.00, 1, NULL),
       (2284, 1911, 6, 250.00, 0, NULL),
       (2285, 1912, 1, 1.00, 1, NULL),
       (2286, 1912, 8, 450.00, 0, NULL),
       (2287, 1913, 1, 1.00, 1, NULL),
       (2288, 1913, 8, 450.00, 0, NULL),
       (2289, 1914, 1, 1.00, 1, NULL),
       (2290, 1914, 8, 450.00, 0, NULL),
       (2291, 1915, 1, 1.00, 1, NULL),
       (2292, 1915, 8, 450.00, 0, NULL),
       (2293, 1916, 1, 1.00, 1, NULL),
       (2294, 1916, 8, 450.00, 0, NULL),
       (2295, 1917, 1, 1.00, 1, NULL),
       (2296, 1917, 8, 450.00, 0, NULL),
       (2297, 1918, 1, 1.00, 1, NULL),
       (2298, 1918, 8, 450.00, 0, NULL),
       (2299, 1919, 1, 1.00, 1, NULL),
       (2300, 1919, 8, 450.00, 0, NULL),
       (2301, 1920, 7, 1.00, 1, NULL),
       (2302, 1920, 6, 250.00, 0, NULL),
       (2303, 1921, 7, 1.00, 1, NULL),
       (2304, 1921, 6, 250.00, 0, NULL),
       (2305, 1922, 1, 1.00, 1, NULL),
       (2306, 1922, 8, 450.00, 0, NULL),
       (2307, 1923, 1, 1.00, 1, NULL),
       (2308, 1923, 8, 450.00, 0, NULL),
       (2309, 1924, 1, 1.00, 1, NULL),
       (2310, 1924, 8, 450.00, 0, NULL),
       (2311, 1925, 1, 1.00, 1, NULL),
       (2312, 1925, 8, 450.00, 0, NULL),
       (2313, 1926, 1, 1.00, 1, NULL),
       (2314, 1926, 8, 450.00, 0, NULL),
       (2315, 1927, 1, 1.00, 1, NULL),
       (2316, 1927, 8, 450.00, 0, NULL),
       (2317, 1928, 1, 1.00, 1, NULL),
       (2318, 1928, 8, 450.00, 0, NULL),
       (2319, 1929, 1, 1.00, 1, NULL),
       (2320, 1929, 8, 450.00, 0, NULL),
       (2321, 1930, 1, 1.00, 1, NULL),
       (2322, 1930, 8, 450.00, 0, NULL),
       (2323, 1931, 1, 1.00, 1, NULL),
       (2324, 1931, 8, 450.00, 0, NULL),
       (2325, 1932, 1, 1.00, 1, NULL),
       (2326, 1932, 8, 450.00, 0, NULL),
       (2327, 1933, 1, 1.00, 1, NULL),
       (2328, 1933, 8, 450.00, 0, NULL),
       (2329, 1934, 1, 1.00, 1, NULL),
       (2330, 1934, 8, 450.00, 0, NULL),
       (2331, 1935, 1, 1.00, 1, NULL),
       (2332, 1935, 8, 450.00, 0, NULL),
       (2333, 1936, 1, 1.00, 1, NULL),
       (2334, 1936, 8, 450.00, 0, NULL),
       (2335, 1937, 1, 1.00, 1, NULL),
       (2336, 1937, 8, 450.00, 0, NULL),
       (2337, 1938, 1, 1.00, 1, NULL),
       (2338, 1938, 8, 450.00, 0, NULL),
       (2339, 1939, 1, 1.00, 1, NULL),
       (2340, 1939, 8, 450.00, 0, NULL),
       (2341, 1940, 1, 1.00, 1, NULL),
       (2342, 1940, 8, 450.00, 0, NULL),
       (2343, 1941, 1, 1.00, 1, NULL),
       (2344, 1941, 8, 450.00, 0, NULL),
       (2345, 1942, 1, 1.00, 1, NULL),
       (2346, 1942, 8, 450.00, 0, NULL),
       (2347, 1943, 1, 1.00, 1, NULL),
       (2348, 1943, 8, 450.00, 0, NULL),
       (2349, 1944, 1, 1.00, 1, NULL),
       (2350, 1944, 8, 450.00, 0, NULL),
       (2351, 1945, 1, 1.00, 1, NULL),
       (2352, 1945, 8, 450.00, 0, NULL),
       (2353, 1946, 1, 1.00, 1, NULL),
       (2354, 1946, 8, 450.00, 0, NULL),
       (2355, 1947, 1, 1.00, 1, NULL),
       (2356, 1947, 8, 450.00, 0, NULL),
       (2357, 1949, 1, 1.00, 1, NULL),
       (2358, 1949, 8, 450.00, 0, NULL),
       (2359, 1950, 1, 1.00, 1, NULL),
       (2360, 1950, 8, 450.00, 0, NULL),
       (2361, 1951, 1, 1.00, 1, NULL),
       (2362, 1951, 8, 450.00, 0, NULL),
       (2363, 1952, 1, 1.00, 1, NULL),
       (2364, 1952, 8, 450.00, 0, NULL),
       (2365, 1953, 1, 1.00, 1, NULL),
       (2366, 1953, 8, 450.00, 0, NULL),
       (2367, 1954, 1, 1.00, 1, NULL),
       (2368, 1954, 8, 450.00, 0, NULL),
       (2369, 1955, 1, 1.00, 1, NULL),
       (2370, 1955, 8, 450.00, 0, NULL),
       (2371, 1956, 1, 1.00, 1, NULL),
       (2372, 1956, 8, 450.00, 0, NULL),
       (2373, 1957, 1, 1.00, 1, NULL),
       (2374, 1957, 8, 450.00, 0, NULL),
       (2375, 1958, 1, 1.00, 1, NULL),
       (2376, 1958, 8, 450.00, 0, NULL),
       (2377, 1959, 1, 1.00, 1, NULL),
       (2378, 1959, 8, 450.00, 0, NULL),
       (2379, 1960, 1, 1.00, 1, NULL),
       (2380, 1960, 8, 450.00, 0, NULL),
       (2381, 1961, 1, 1.00, 1, NULL),
       (2382, 1961, 8, 450.00, 0, NULL),
       (2383, 1962, 1, 1.00, 1, NULL),
       (2384, 1962, 8, 450.00, 0, NULL),
       (2385, 1963, 1, 1.00, 1, NULL),
       (2386, 1963, 8, 450.00, 0, NULL),
       (2387, 1964, 1, 1.00, 1, NULL),
       (2388, 1964, 8, 450.00, 0, NULL),
       (2389, 1965, 1, 1.00, 1, NULL),
       (2390, 1965, 8, 450.00, 0, NULL),
       (2391, 1966, 1, 1.00, 1, NULL),
       (2392, 1966, 8, 450.00, 0, NULL),
       (2393, 1967, 1, 1.00, 1, NULL),
       (2394, 1967, 8, 450.00, 0, NULL),
       (2395, 1968, 1, 1.00, 1, NULL),
       (2396, 1968, 8, 450.00, 0, NULL),
       (2397, 1969, 1, 1.00, 1, NULL),
       (2398, 1969, 8, 450.00, 0, NULL),
       (2399, 1970, 1, 1.00, 1, NULL),
       (2400, 1970, 8, 450.00, 0, NULL),
       (2401, 1971, 1, 1.00, 1, NULL),
       (2402, 1971, 8, 450.00, 0, NULL),
       (2403, 1972, 1, 1.00, 1, NULL),
       (2404, 1972, 8, 450.00, 0, NULL),
       (2405, 1973, 1, 1.00, 1, NULL),
       (2406, 1973, 8, 450.00, 0, NULL),
       (2407, 1974, 1, 1.00, 1, NULL),
       (2408, 1974, 8, 450.00, 0, NULL),
       (2409, 1975, 1, 1.00, 1, NULL),
       (2410, 1975, 8, 450.00, 0, NULL),
       (2411, 1976, 1, 1.00, 1, NULL),
       (2412, 1976, 8, 450.00, 0, NULL),
       (2413, 1977, 1, 1.00, 1, NULL),
       (2414, 1977, 8, 450.00, 0, NULL),
       (2415, 1978, 1, 1.00, 1, NULL),
       (2416, 1978, 8, 450.00, 0, NULL),
       (2417, 1979, 1, 1.00, 1, NULL),
       (2418, 1979, 8, 450.00, 0, NULL),
       (2419, 1980, 1, 1.00, 1, NULL),
       (2420, 1980, 8, 450.00, 0, NULL),
       (2421, 1981, 1, 1.00, 1, NULL),
       (2422, 1981, 8, 450.00, 0, NULL),
       (2423, 1982, 1, 1.00, 1, NULL),
       (2424, 1982, 8, 450.00, 0, NULL),
       (2425, 1983, 1, 1.00, 1, NULL),
       (2426, 1983, 8, 450.00, 0, NULL),
       (2427, 1984, 1, 1.00, 1, NULL),
       (2428, 1984, 8, 450.00, 0, NULL),
       (2429, 1985, 1, 1.00, 1, NULL),
       (2430, 1985, 8, 450.00, 0, NULL),
       (2431, 1986, 1, 1.00, 1, NULL),
       (2432, 1986, 8, 450.00, 0, NULL),
       (2433, 1987, 1, 1.00, 1, NULL),
       (2434, 1987, 8, 450.00, 0, NULL),
       (2435, 1988, 1, 1.00, 1, NULL),
       (2436, 1988, 8, 450.00, 0, NULL),
       (2437, 1989, 1, 1.00, 1, NULL),
       (2438, 1989, 8, 450.00, 0, NULL),
       (2439, 1990, 1, 1.00, 1, NULL),
       (2440, 1990, 8, 450.00, 0, NULL),
       (2441, 1991, 1, 1.00, 1, NULL),
       (2442, 1991, 8, 450.00, 0, NULL),
       (2443, 1992, 1, 1.00, 1, NULL),
       (2444, 1992, 8, 450.00, 0, NULL),
       (2445, 1993, 7, 1.00, 1, NULL),
       (2446, 1993, 6, 250.00, 0, NULL),
       (2447, 1994, 1, 1.00, 1, NULL),
       (2448, 1994, 8, 450.00, 0, NULL),
       (2449, 1995, 1, 1.00, 1, NULL),
       (2450, 1995, 8, 450.00, 0, NULL),
       (2451, 1996, 1, 1.00, 1, NULL),
       (2452, 1996, 8, 450.00, 0, NULL),
       (2453, 1997, 1, 1.00, 1, NULL),
       (2454, 1997, 8, 450.00, 0, NULL),
       (2455, 1998, 1, 1.00, 1, NULL),
       (2456, 1998, 8, 450.00, 0, NULL),
       (2457, 1999, 1, 1.00, 1, NULL),
       (2458, 1999, 8, 450.00, 0, NULL),
       (2459, 2000, 1, 1.00, 1, NULL),
       (2460, 2000, 8, 450.00, 0, NULL),
       (2461, 2001, 1, 1.00, 1, NULL),
       (2462, 2001, 8, 450.00, 0, NULL),
       (2463, 2002, 1, 1.00, 1, NULL),
       (2464, 2002, 8, 450.00, 0, NULL),
       (2465, 2003, 1, 1.00, 1, NULL),
       (2466, 2003, 8, 450.00, 0, NULL),
       (2467, 2004, 1, 1.00, 1, NULL),
       (2468, 2004, 8, 450.00, 0, NULL),
       (2469, 2005, 1, 1.00, 1, NULL),
       (2470, 2005, 8, 450.00, 0, NULL),
       (2471, 2006, 1, 1.00, 1, NULL),
       (2472, 2006, 8, 450.00, 0, NULL),
       (2473, 2007, 1, 1.00, 1, NULL),
       (2474, 2007, 8, 450.00, 0, NULL),
       (2475, 2008, 1, 1.00, 1, NULL),
       (2476, 2008, 8, 450.00, 0, NULL),
       (2477, 2009, 1, 1.00, 1, NULL),
       (2478, 2009, 8, 450.00, 0, NULL),
       (2479, 2010, 1, 1.00, 1, NULL),
       (2480, 2010, 8, 450.00, 0, NULL),
       (2481, 2011, 1, 1.00, 1, NULL),
       (2482, 2011, 8, 450.00, 0, NULL),
       (2483, 2012, 1, 1.00, 1, NULL),
       (2484, 2012, 8, 450.00, 0, NULL),
       (2485, 2013, 1, 1.00, 1, NULL),
       (2486, 2013, 8, 450.00, 0, NULL),
       (2487, 2014, 1, 1.00, 1, NULL),
       (2488, 2014, 8, 450.00, 0, NULL),
       (2489, 2015, 1, 1.00, 1, NULL),
       (2490, 2015, 8, 450.00, 0, NULL),
       (2491, 2016, 1, 1.00, 1, NULL),
       (2492, 2016, 8, 450.00, 0, NULL),
       (2493, 2017, 1, 1.00, 1, NULL),
       (2494, 2017, 8, 450.00, 0, NULL),
       (2495, 2018, 1, 1.00, 1, NULL),
       (2496, 2018, 8, 450.00, 0, NULL),
       (2497, 2019, 1, 1.00, 1, NULL),
       (2498, 2019, 8, 450.00, 0, NULL),
       (2499, 2020, 1, 1.00, 1, NULL),
       (2500, 2020, 8, 450.00, 0, NULL),
       (2501, 2021, 1, 1.00, 1, NULL),
       (2502, 2021, 8, 450.00, 0, NULL),
       (2503, 2022, 1, 1.00, 1, NULL),
       (2504, 2022, 8, 450.00, 0, NULL),
       (2505, 2023, 1, 1.00, 1, NULL),
       (2506, 2023, 8, 450.00, 0, NULL),
       (2507, 2024, 1, 1.00, 1, NULL),
       (2508, 2024, 8, 450.00, 0, NULL),
       (2509, 2025, 1, 1.00, 1, NULL),
       (2510, 2025, 8, 450.00, 0, NULL),
       (2511, 2026, 1, 1.00, 1, NULL),
       (2512, 2026, 8, 450.00, 0, NULL),
       (2513, 2027, 1, 1.00, 1, NULL),
       (2514, 2027, 8, 450.00, 0, NULL),
       (2515, 2028, 1, 1.00, 1, NULL),
       (2516, 2028, 8, 450.00, 0, NULL),
       (2517, 2029, 1, 1.00, 1, NULL),
       (2518, 2029, 8, 450.00, 0, NULL),
       (2519, 2030, 1, 1.00, 1, NULL),
       (2520, 2030, 8, 450.00, 0, NULL),
       (2521, 2031, 1, 1.00, 1, NULL),
       (2522, 2031, 8, 450.00, 0, NULL),
       (2523, 2032, 1, 1.00, 1, NULL),
       (2524, 2032, 8, 450.00, 0, NULL),
       (2525, 2033, 1, 1.00, 1, NULL),
       (2526, 2033, 8, 450.00, 0, NULL),
       (2527, 2034, 1, 1.00, 1, NULL),
       (2528, 2034, 8, 450.00, 0, NULL),
       (2529, 2035, 1, 1.00, 1, NULL),
       (2530, 2035, 8, 450.00, 0, NULL),
       (2531, 2036, 1, 1.00, 1, NULL),
       (2532, 2036, 8, 450.00, 0, NULL),
       (2533, 2037, 1, 1.00, 1, NULL),
       (2534, 2037, 8, 450.00, 0, NULL),
       (2535, 2038, 1, 1.00, 1, NULL),
       (2536, 2038, 8, 450.00, 0, NULL),
       (2537, 2039, 1, 1.00, 1, NULL),
       (2538, 2039, 8, 450.00, 0, NULL),
       (2539, 2040, 1, 1.00, 1, NULL),
       (2540, 2040, 8, 450.00, 0, NULL),
       (2541, 2041, 1, 1.00, 1, NULL),
       (2542, 2041, 8, 450.00, 0, NULL),
       (2543, 2042, 1, 1.00, 1, NULL),
       (2544, 2042, 8, 450.00, 0, NULL),
       (2545, 2043, 1, 1.00, 1, NULL),
       (2546, 2043, 8, 450.00, 0, NULL),
       (2547, 2044, 1, 1.00, 1, NULL),
       (2548, 2044, 8, 450.00, 0, NULL),
       (2549, 2045, 1, 1.00, 1, NULL),
       (2550, 2045, 8, 450.00, 0, NULL),
       (2551, 2046, 1, 1.00, 1, NULL),
       (2552, 2046, 8, 450.00, 0, NULL),
       (2553, 2047, 1, 1.00, 1, NULL),
       (2554, 2047, 8, 450.00, 0, NULL),
       (2555, 2048, 1, 1.00, 1, NULL),
       (2556, 2048, 8, 450.00, 0, NULL),
       (2557, 2049, 1, 1.00, 1, NULL),
       (2558, 2049, 8, 450.00, 0, NULL),
       (2559, 2050, 1, 1.00, 1, NULL),
       (2560, 2050, 8, 450.00, 0, NULL),
       (2561, 2051, 1, 1.00, 1, NULL),
       (2562, 2051, 8, 450.00, 0, NULL),
       (2563, 2052, 1, 1.00, 1, NULL),
       (2564, 2052, 8, 450.00, 0, NULL),
       (2565, 2053, 1, 1.00, 1, NULL),
       (2566, 2053, 8, 450.00, 0, NULL),
       (2567, 2054, 1, 1.00, 1, NULL),
       (2568, 2054, 8, 450.00, 0, NULL),
       (2569, 2055, 1, 1.00, 1, NULL),
       (2570, 2055, 8, 450.00, 0, NULL),
       (2571, 2056, 1, 1.00, 1, NULL),
       (2572, 2056, 8, 450.00, 0, NULL),
       (2573, 2057, 1, 1.00, 1, NULL),
       (2574, 2057, 8, 450.00, 0, NULL),
       (2575, 2058, 1, 1.00, 1, NULL),
       (2576, 2058, 8, 450.00, 0, NULL),
       (2577, 2059, 1, 1.00, 1, NULL),
       (2578, 2059, 8, 450.00, 0, NULL),
       (2579, 2060, 1, 1.00, 1, NULL),
       (2580, 2060, 8, 450.00, 0, NULL),
       (2581, 2061, 1, 1.00, 1, NULL),
       (2582, 2061, 8, 450.00, 0, NULL),
       (2583, 2062, 7, 1.00, 1, NULL),
       (2584, 2062, 6, 250.00, 0, NULL),
       (2585, 2063, 1, 1.00, 1, NULL),
       (2586, 2063, 8, 450.00, 0, NULL),
       (2587, 2064, 1, 1.00, 1, NULL),
       (2588, 2064, 8, 450.00, 0, NULL),
       (2589, 2065, 7, 1.00, 1, NULL),
       (2590, 2065, 6, 250.00, 0, NULL),
       (2591, 2066, 7, 1.00, 1, NULL),
       (2592, 2066, 6, 250.00, 0, NULL),
       (2593, 2067, 7, 1.00, 1, NULL),
       (2594, 2067, 6, 250.00, 0, NULL),
       (2595, 2068, 7, 1.00, 1, NULL),
       (2596, 2068, 6, 250.00, 0, NULL),
       (2597, 2069, 7, 1.00, 1, NULL),
       (2598, 2069, 6, 250.00, 0, NULL),
       (2599, 2070, 7, 1.00, 1, NULL),
       (2600, 2070, 6, 250.00, 0, NULL),
       (2601, 2071, 1, 1.00, 1, NULL),
       (2602, 2071, 8, 450.00, 0, NULL),
       (2603, 2072, 7, 1.00, 1, NULL),
       (2604, 2072, 6, 250.00, 0, NULL),
       (2605, 2073, 1, 1.00, 1, NULL),
       (2606, 2073, 8, 450.00, 0, NULL),
       (2607, 2074, 7, 1.00, 1, NULL),
       (2608, 2074, 6, 250.00, 0, NULL),
       (2609, 2075, 7, 1.00, 1, NULL),
       (2610, 2075, 6, 250.00, 0, NULL),
       (2611, 2076, 7, 1.00, 1, NULL),
       (2612, 2076, 6, 250.00, 0, NULL),
       (2613, 2077, 7, 1.00, 1, NULL),
       (2614, 2077, 6, 250.00, 0, NULL),
       (2615, 2078, 7, 1.00, 1, NULL),
       (2616, 2078, 6, 250.00, 0, NULL),
       (2617, 2079, 7, 1.00, 1, NULL),
       (2618, 2079, 6, 250.00, 0, NULL),
       (2619, 2080, 7, 1.00, 1, NULL),
       (2620, 2080, 6, 250.00, 0, NULL),
       (2621, 2081, 7, 1.00, 1, NULL),
       (2622, 2081, 6, 250.00, 0, NULL),
       (2623, 2082, 7, 1.00, 1, NULL),
       (2624, 2082, 6, 250.00, 0, NULL),
       (2625, 2083, 7, 1.00, 1, NULL),
       (2626, 2083, 6, 250.00, 0, NULL),
       (2627, 2084, 7, 1.00, 1, NULL),
       (2628, 2084, 6, 250.00, 0, NULL),
       (2629, 2085, 7, 1.00, 1, NULL),
       (2630, 2085, 6, 250.00, 0, NULL),
       (2631, 2086, 7, 1.00, 1, NULL),
       (2632, 2086, 6, 250.00, 0, NULL),
       (2633, 2087, 7, 1.00, 1, NULL),
       (2634, 2087, 6, 250.00, 0, NULL),
       (2635, 2088, 7, 1.00, 1, NULL),
       (2636, 2088, 6, 250.00, 0, NULL),
       (2637, 2089, 7, 1.00, 1, NULL),
       (2638, 2089, 6, 250.00, 0, NULL),
       (2639, 2090, 7, 1.00, 1, NULL),
       (2640, 2090, 6, 250.00, 0, NULL),
       (2641, 2091, 7, 1.00, 1, NULL),
       (2642, 2091, 6, 250.00, 0, NULL),
       (2643, 2092, 7, 1.00, 1, NULL),
       (2644, 2092, 6, 250.00, 0, NULL),
       (2645, 2093, 7, 1.00, 1, NULL),
       (2646, 2093, 6, 250.00, 0, NULL),
       (2647, 2094, 1, 1.00, 1, NULL),
       (2648, 2094, 8, 450.00, 0, NULL),
       (2649, 2095, 1, 1.00, 1, NULL),
       (2650, 2095, 8, 450.00, 0, NULL),
       (2651, 2096, 1, 1.00, 1, NULL),
       (2652, 2096, 8, 450.00, 0, NULL),
       (2653, 2097, 7, 1.00, 1, NULL),
       (2654, 2097, 6, 250.00, 0, NULL),
       (2655, 2098, 1, 1.00, 1, NULL),
       (2656, 2098, 8, 450.00, 0, NULL),
       (2657, 2099, 1, 1.00, 1, NULL),
       (2658, 2099, 8, 450.00, 0, NULL),
       (2659, 2100, 1, 1.00, 1, NULL),
       (2660, 2100, 8, 450.00, 0, NULL),
       (2661, 2101, 1, 1.00, 1, NULL),
       (2662, 2101, 8, 450.00, 0, NULL),
       (2663, 2102, 7, 1.00, 1, NULL),
       (2664, 2102, 6, 250.00, 0, NULL),
       (2665, 2103, 7, 1.00, 1, NULL),
       (2666, 2103, 6, 250.00, 0, NULL),
       (2667, 2104, 7, 1.00, 1, NULL),
       (2668, 2104, 6, 250.00, 0, NULL),
       (2669, 2105, 1, 1.00, 1, NULL),
       (2670, 2105, 8, 450.00, 0, NULL),
       (2671, 2106, 1, 1.00, 1, NULL),
       (2672, 2106, 8, 450.00, 0, NULL),
       (2673, 2107, 1, 1.00, 1, NULL),
       (2674, 2107, 8, 450.00, 0, NULL),
       (2675, 2108, 1, 1.00, 1, NULL),
       (2676, 2108, 8, 450.00, 0, NULL),
       (2677, 2109, 1, 1.00, 1, NULL),
       (2678, 2109, 8, 450.00, 0, NULL),
       (2679, 2110, 1, 1.00, 1, NULL),
       (2680, 2110, 8, 450.00, 0, NULL),
       (2681, 2111, 7, 1.00, 1, NULL),
       (2682, 2111, 6, 250.00, 0, NULL),
       (2683, 2112, 1, 1.00, 1, NULL),
       (2684, 2112, 8, 450.00, 0, NULL),
       (2685, 2113, 1, 1.00, 1, NULL),
       (2686, 2113, 8, 450.00, 0, NULL),
       (2687, 2114, 1, 1.00, 1, NULL),
       (2688, 2114, 8, 450.00, 0, NULL),
       (2689, 2115, 1, 1.00, 1, NULL),
       (2690, 2115, 8, 450.00, 0, NULL),
       (2691, 2116, 1, 1.00, 1, NULL),
       (2692, 2116, 8, 450.00, 0, NULL),
       (2693, 2117, 1, 1.00, 1, NULL),
       (2694, 2117, 8, 450.00, 0, NULL),
       (2695, 2118, 1, 1.00, 1, NULL),
       (2696, 2118, 8, 450.00, 0, NULL),
       (2697, 2119, 1, 1.00, 1, NULL),
       (2698, 2119, 8, 450.00, 0, NULL),
       (2699, 2120, 1, 1.00, 1, NULL),
       (2700, 2120, 8, 450.00, 0, NULL),
       (2701, 2121, 1, 1.00, 1, NULL),
       (2702, 2121, 8, 450.00, 0, NULL),
       (2703, 2122, 1, 1.00, 1, NULL),
       (2704, 2122, 8, 450.00, 0, NULL),
       (2705, 2123, 1, 1.00, 1, NULL),
       (2706, 2123, 8, 450.00, 0, NULL),
       (2707, 2124, 1, 1.00, 1, NULL),
       (2708, 2124, 8, 450.00, 0, NULL),
       (2709, 2125, 1, 1.00, 1, NULL),
       (2710, 2125, 8, 450.00, 0, NULL),
       (2711, 2126, 1, 1.00, 1, NULL),
       (2712, 2126, 8, 450.00, 0, NULL),
       (2713, 2127, 1, 1.00, 1, NULL),
       (2714, 2127, 8, 450.00, 0, NULL),
       (2715, 2128, 1, 1.00, 1, NULL),
       (2716, 2128, 8, 450.00, 0, NULL),
       (2717, 2129, 1, 1.00, 1, NULL),
       (2718, 2129, 8, 450.00, 0, NULL),
       (2719, 2130, 1, 1.00, 1, NULL),
       (2720, 2130, 8, 450.00, 0, NULL),
       (2721, 2131, 1, 1.00, 1, NULL),
       (2722, 2131, 8, 450.00, 0, NULL),
       (2723, 2132, 1, 1.00, 1, NULL),
       (2724, 2132, 8, 450.00, 0, NULL),
       (2725, 2133, 1, 1.00, 1, NULL),
       (2726, 2133, 8, 450.00, 0, NULL),
       (2727, 2134, 1, 1.00, 1, NULL),
       (2728, 2134, 8, 450.00, 0, NULL),
       (2729, 2135, 1, 1.00, 1, NULL),
       (2730, 2135, 8, 450.00, 0, NULL),
       (2731, 2136, 1, 1.00, 1, NULL),
       (2732, 2136, 8, 450.00, 0, NULL),
       (2733, 2137, 1, 1.00, 1, NULL),
       (2734, 2137, 8, 450.00, 0, NULL),
       (2735, 2138, 1, 1.00, 1, NULL),
       (2736, 2138, 8, 450.00, 0, NULL),
       (2737, 2139, 1, 1.00, 1, NULL),
       (2738, 2139, 8, 450.00, 0, NULL),
       (2739, 2141, 1, 1.00, 1, NULL),
       (2740, 2141, 8, 450.00, 0, NULL),
       (2741, 2142, 1, 1.00, 1, NULL),
       (2742, 2142, 8, 450.00, 0, NULL),
       (2743, 2143, 1, 1.00, 1, NULL),
       (2744, 2143, 8, 450.00, 0, NULL),
       (2745, 2144, 1, 1.00, 1, NULL),
       (2746, 2144, 8, 450.00, 0, NULL),
       (2747, 2145, 1, 1.00, 1, NULL),
       (2748, 2145, 8, 450.00, 0, NULL),
       (2749, 2146, 1, 1.00, 1, NULL),
       (2750, 2146, 8, 450.00, 0, NULL),
       (2751, 2147, 1, 1.00, 1, NULL),
       (2752, 2147, 8, 450.00, 0, NULL),
       (2753, 2148, 1, 1.00, 1, NULL),
       (2754, 2148, 8, 450.00, 0, NULL),
       (2755, 2149, 1, 1.00, 1, NULL),
       (2756, 2149, 8, 450.00, 0, NULL),
       (2757, 2150, 1, 1.00, 1, NULL),
       (2758, 2150, 8, 450.00, 0, NULL),
       (2759, 2151, 7, 1.00, 1, NULL),
       (2760, 2151, 6, 250.00, 0, NULL),
       (2761, 2152, 1, 1.00, 1, NULL),
       (2762, 2152, 8, 450.00, 0, NULL),
       (2763, 2153, 1, 1.00, 1, NULL),
       (2764, 2153, 8, 450.00, 0, NULL),
       (2765, 2154, 1, 1.00, 1, NULL),
       (2766, 2154, 8, 450.00, 0, NULL),
       (2767, 2155, 1, 1.00, 1, NULL),
       (2768, 2155, 8, 450.00, 0, NULL),
       (2769, 2156, 1, 1.00, 1, NULL),
       (2770, 2156, 8, 450.00, 0, NULL),
       (2771, 2157, 1, 1.00, 1, NULL),
       (2772, 2157, 8, 450.00, 0, NULL),
       (2773, 2158, 1, 1.00, 1, NULL),
       (2774, 2158, 8, 450.00, 0, NULL),
       (2775, 2159, 1, 1.00, 1, NULL),
       (2776, 2159, 8, 450.00, 0, NULL),
       (2777, 2160, 7, 1.00, 1, NULL),
       (2778, 2160, 6, 250.00, 0, NULL);
-- eat_clear.foods DML
INSERT INTO `eat_clear`.`foods` (`id`, `name`, `cat_id`, `user_id`, `status`, `nutrition`, `created_at`, `updated_at`,
                                 `delete_at`)
VALUES (1, '大米', 1, NULL, 1, '{
  "fat": 24.55,
  "iron": 2.48,
  "kcal": 56.85,
  "zinc": 13.64,
  "fiber": 9.46,
  "sugar": 2.94,
  "folate": 12.33,
  "iodine": 37.61,
  "omega3": 1.12,
  "sodium": 412.93,
  "calcium": 349.72,
  "protein": 6.78,
  "selenium": 49.56,
  "vitaminA": 244.16,
  "vitaminC": 40.23,
  "vitaminD": 7.24,
  "vitaminE": 7.28,
  "vitaminK": 377.04,
  "magnesium": 171.95,
  "potassium": 447.69,
  "vitaminB1": 0.69,
  "vitaminB6": 1.36,
  "vitaminB12": 3.96,
  "cholesterol": 13.69,
  "carbohydrate": 79.04
}', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (2, '小麦粉', 1, NULL, 1, '{
         "fat": 19.64,
         "iron": 14.66,
         "kcal": 230.32,
         "zinc": 9.19,
         "fiber": 2.41,
         "sugar": 2.01,
         "folate": 3.89,
         "iodine": 83.62,
         "omega3": 4.49,
         "sodium": 673.71,
         "calcium": 233.18,
         "protein": 1.31,
         "selenium": 36.53,
         "vitaminA": 557.05,
         "vitaminC": 0.45,
         "vitaminD": 8.85,
         "vitaminE": 19.4,
         "vitaminK": 445.81,
         "magnesium": 196.87,
         "potassium": 584.21,
         "vitaminB1": 1.61,
         "vitaminB6": 0.23,
         "vitaminB12": 4.95,
         "cholesterol": 243.57,
         "carbohydrate": 78.63
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (3, '玉米', 1, NULL, 1, '{
         "fat": 24.0,
         "iron": 4.45,
         "kcal": 569.05,
         "zinc": 4.9,
         "fiber": 0.55,
         "sugar": 4.87,
         "folate": 5.0,
         "iodine": 66.55,
         "omega3": 1.95,
         "sodium": 293.14,
         "calcium": 149.21,
         "protein": 8.51,
         "selenium": 42.95,
         "vitaminA": 577.04,
         "vitaminC": 98.02,
         "vitaminD": 3.91,
         "vitaminE": 7.42,
         "vitaminK": 91.59,
         "magnesium": 191.95,
         "potassium": 530.78,
         "vitaminB1": 0.66,
         "vitaminB6": 1.5,
         "vitaminB12": 4.82,
         "cholesterol": 52.44,
         "carbohydrate": 22.47
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (4, '小米', 1, NULL, 1, '{
         "fat": 44.56,
         "iron": 0.42,
         "kcal": 243.24,
         "zinc": 5.81,
         "fiber": 7.11,
         "sugar": 10.64,
         "folate": 39.46,
         "iodine": 55.45,
         "omega3": 4.42,
         "sodium": 587.23,
         "calcium": 105.74,
         "protein": 13.99,
         "selenium": 39.04,
         "vitaminA": 551.75,
         "vitaminC": 64.39,
         "vitaminD": 8.54,
         "vitaminE": 9.45,
         "vitaminK": 203.39,
         "magnesium": 151.69,
         "potassium": 450.83,
         "vitaminB1": 0.55,
         "vitaminB6": 0.96,
         "vitaminB12": 0.32,
         "cholesterol": 75.12,
         "carbohydrate": 12.14
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (5, '高粱', 1, NULL, 1, '{
         "fat": 17.35,
         "iron": 13.61,
         "kcal": 75.43,
         "zinc": 2.38,
         "fiber": 4.94,
         "sugar": 8.1,
         "folate": 43.55,
         "iodine": 46.09,
         "omega3": 1.4,
         "sodium": 31.95,
         "calcium": 413.76,
         "protein": 7.29,
         "selenium": 21.77,
         "vitaminA": 267.2,
         "vitaminC": 44.55,
         "vitaminD": 0.5,
         "vitaminE": 0.42,
         "vitaminK": 66.35,
         "magnesium": 249.17,
         "potassium": 563.43,
         "vitaminB1": 1.99,
         "vitaminB6": 0.83,
         "vitaminB12": 4.62,
         "cholesterol": 99.52,
         "carbohydrate": 69.81
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (6, '燕麦', 1, NULL, 1, '{
         "fat": 32.53,
         "iron": 11.55,
         "kcal": 420.92,
         "zinc": 1.39,
         "fiber": 6.2,
         "sugar": 2.94,
         "folate": 63.75,
         "iodine": 33.23,
         "omega3": 0.62,
         "sodium": 319.86,
         "calcium": 314.43,
         "protein": 26.25,
         "selenium": 45.24,
         "vitaminA": 529.91,
         "vitaminC": 41.37,
         "vitaminD": 8.28,
         "vitaminE": 0.36,
         "vitaminK": 223.53,
         "magnesium": 170.62,
         "potassium": 386.84,
         "vitaminB1": 0.13,
         "vitaminB6": 0.24,
         "vitaminB12": 4.21,
         "cholesterol": 173.05,
         "carbohydrate": 39.52
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (7, '荞麦', 1, NULL, 1, '{
         "fat": 28.45,
         "iron": 7.85,
         "kcal": 466.62,
         "zinc": 12.03,
         "fiber": 5.73,
         "sugar": 6.72,
         "folate": 176.91,
         "iodine": 58.76,
         "omega3": 2.51,
         "sodium": 584.11,
         "calcium": 472.53,
         "protein": 8.3,
         "selenium": 11.42,
         "vitaminA": 730.39,
         "vitaminC": 94.68,
         "vitaminD": 4.87,
         "vitaminE": 8.72,
         "vitaminK": 453.89,
         "magnesium": 244.4,
         "potassium": 97.71,
         "vitaminB1": 0.29,
         "vitaminB6": 1.62,
         "vitaminB12": 3.17,
         "cholesterol": 184.92,
         "carbohydrate": 4.4
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (8, '红薯', 1, NULL, 1, '{
         "fat": 25.9,
         "iron": 4.94,
         "kcal": 555.44,
         "zinc": 4.57,
         "fiber": 4.82,
         "sugar": 3.53,
         "folate": 139.0,
         "iodine": 4.86,
         "omega3": 2.06,
         "sodium": 191.82,
         "calcium": 328.34,
         "protein": 28.99,
         "selenium": 19.77,
         "vitaminA": 625.78,
         "vitaminC": 55.45,
         "vitaminD": 1.29,
         "vitaminE": 4.0,
         "vitaminK": 484.28,
         "magnesium": 268.71,
         "potassium": 535.93,
         "vitaminB1": 0.93,
         "vitaminB6": 1.59,
         "vitaminB12": 3.82,
         "cholesterol": 90.83,
         "carbohydrate": 26.58
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (9, '马铃薯', 1, NULL, 1, '{
         "fat": 6.3,
         "iron": 2.75,
         "kcal": 81.39,
         "zinc": 10.35,
         "fiber": 4.21,
         "sugar": 12.61,
         "folate": 5.52,
         "iodine": 50.83,
         "omega3": 1.7,
         "sodium": 631.31,
         "calcium": 484.19,
         "protein": 0.66,
         "selenium": 49.51,
         "vitaminA": 719.68,
         "vitaminC": 15.09,
         "vitaminD": 7.55,
         "vitaminE": 0.77,
         "vitaminK": 406.65,
         "magnesium": 83.87,
         "potassium": 634.68,
         "vitaminB1": 1.12,
         "vitaminB6": 0.03,
         "vitaminB12": 0.18,
         "cholesterol": 191.41,
         "carbohydrate": 40.08
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (10, '山药', 1, NULL, 1, '{
         "fat": 6.89,
         "iron": 8.25,
         "kcal": 93.0,
         "zinc": 4.4,
         "fiber": 4.93,
         "sugar": 3.17,
         "folate": 145.06,
         "iodine": 64.55,
         "omega3": 1.47,
         "sodium": 111.41,
         "calcium": 465.8,
         "protein": 28.37,
         "selenium": 18.13,
         "vitaminA": 457.39,
         "vitaminC": 47.61,
         "vitaminD": 0.94,
         "vitaminE": 9.1,
         "vitaminK": 22.17,
         "magnesium": 26.03,
         "potassium": 346.72,
         "vitaminB1": 0.16,
         "vitaminB6": 0.41,
         "vitaminB12": 4.44,
         "cholesterol": 242.53,
         "carbohydrate": 44.42
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (11, '黄豆', 2, NULL, 1, '{
         "fat": 43.94,
         "iron": 0.59,
         "kcal": 297.13,
         "zinc": 10.71,
         "fiber": 8.06,
         "sugar": 15.81,
         "folate": 136.87,
         "iodine": 7.99,
         "omega3": 3.34,
         "sodium": 816.56,
         "calcium": 231.8,
         "protein": 19.44,
         "selenium": 3.84,
         "vitaminA": 939.38,
         "vitaminC": 65.81,
         "vitaminD": 3.6,
         "vitaminE": 19.82,
         "vitaminK": 408.25,
         "magnesium": 232.75,
         "potassium": 750.05,
         "vitaminB1": 0.81,
         "vitaminB6": 0.65,
         "vitaminB12": 2.53,
         "cholesterol": 220.34,
         "carbohydrate": 38.39
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (12, '黑豆', 2, NULL, 1, '{
         "fat": 11.53,
         "iron": 7.13,
         "kcal": 546.72,
         "zinc": 1.42,
         "fiber": 5.53,
         "sugar": 14.22,
         "folate": 69.15,
         "iodine": 21.36,
         "omega3": 1.88,
         "sodium": 111.9,
         "calcium": 249.3,
         "protein": 5.77,
         "selenium": 38.45,
         "vitaminA": 778.75,
         "vitaminC": 8.87,
         "vitaminD": 1.9,
         "vitaminE": 11.56,
         "vitaminK": 101.79,
         "magnesium": 129.29,
         "potassium": 87.48,
         "vitaminB1": 1.9,
         "vitaminB6": 0.35,
         "vitaminB12": 2.44,
         "cholesterol": 112.49,
         "carbohydrate": 38.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (13, '豆腐', 2, NULL, 1, '{
         "fat": 18.37,
         "iron": 13.53,
         "kcal": 215.52,
         "zinc": 10.22,
         "fiber": 0.19,
         "sugar": 3.56,
         "folate": 89.59,
         "iodine": 53.66,
         "omega3": 3.09,
         "sodium": 531.44,
         "calcium": 56.27,
         "protein": 1.68,
         "selenium": 8.17,
         "vitaminA": 169.37,
         "vitaminC": 93.06,
         "vitaminD": 0.41,
         "vitaminE": 6.38,
         "vitaminK": 467.84,
         "magnesium": 150.61,
         "potassium": 424.55,
         "vitaminB1": 1.98,
         "vitaminB6": 0.57,
         "vitaminB12": 1.23,
         "cholesterol": 39.15,
         "carbohydrate": 1.77
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (14, '豆浆', 2, NULL, 1, '{
         "fat": 15.92,
         "iron": 4.35,
         "kcal": 473.62,
         "zinc": 13.2,
         "fiber": 2.13,
         "sugar": 8.09,
         "folate": 94.34,
         "iodine": 70.78,
         "omega3": 0.96,
         "sodium": 308.02,
         "calcium": 44.23,
         "protein": 28.21,
         "selenium": 18.47,
         "vitaminA": 415.16,
         "vitaminC": 82.99,
         "vitaminD": 3.25,
         "vitaminE": 0.07,
         "vitaminK": 398.39,
         "magnesium": 33.71,
         "potassium": 540.04,
         "vitaminB1": 1.69,
         "vitaminB6": 0.14,
         "vitaminB12": 3.38,
         "cholesterol": 0.38,
         "carbohydrate": 78.02
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (15, '腐竹', 2, NULL, 1, '{
         "fat": 28.95,
         "iron": 10.11,
         "kcal": 132.93,
         "zinc": 3.61,
         "fiber": 6.54,
         "sugar": 3.49,
         "folate": 8.39,
         "iodine": 76.04,
         "omega3": 0.41,
         "sodium": 133.57,
         "calcium": 244.09,
         "protein": 25.87,
         "selenium": 18.17,
         "vitaminA": 341.45,
         "vitaminC": 21.59,
         "vitaminD": 3.56,
         "vitaminE": 0.61,
         "vitaminK": 12.59,
         "magnesium": 154.56,
         "potassium": 934.34,
         "vitaminB1": 1.44,
         "vitaminB6": 1.88,
         "vitaminB12": 2.34,
         "cholesterol": 110.94,
         "carbohydrate": 33.63
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (16, '白菜', 3, NULL, 1, '{
         "fat": 23.83,
         "iron": 8.87,
         "kcal": 374.57,
         "zinc": 13.7,
         "fiber": 6.25,
         "sugar": 2.9,
         "folate": 2.38,
         "iodine": 82.1,
         "omega3": 4.49,
         "sodium": 161.91,
         "calcium": 474.56,
         "protein": 8.17,
         "selenium": 19.58,
         "vitaminA": 893.59,
         "vitaminC": 55.43,
         "vitaminD": 8.04,
         "vitaminE": 12.24,
         "vitaminK": 220.86,
         "magnesium": 253.36,
         "potassium": 731.19,
         "vitaminB1": 1.89,
         "vitaminB6": 0.56,
         "vitaminB12": 0.36,
         "cholesterol": 264.25,
         "carbohydrate": 62.91
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (17, '菠菜', 3, NULL, 1, '{
         "fat": 23.09,
         "iron": 11.53,
         "kcal": 53.97,
         "zinc": 7.56,
         "fiber": 6.17,
         "sugar": 12.43,
         "folate": 141.96,
         "iodine": 53.32,
         "omega3": 4.56,
         "sodium": 141.43,
         "calcium": 373.03,
         "protein": 0.89,
         "selenium": 0.24,
         "vitaminA": 865.11,
         "vitaminC": 54.49,
         "vitaminD": 1.99,
         "vitaminE": 17.31,
         "vitaminK": 202.42,
         "magnesium": 135.67,
         "potassium": 659.81,
         "vitaminB1": 1.5,
         "vitaminB6": 0.75,
         "vitaminB12": 4.08,
         "cholesterol": 65.83,
         "carbohydrate": 68.55
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (18, '油菜', 3, NULL, 1, '{
         "fat": 37.33,
         "iron": 14.31,
         "kcal": 117.47,
         "zinc": 2.7,
         "fiber": 2.67,
         "sugar": 6.27,
         "folate": 18.97,
         "iodine": 75.22,
         "omega3": 4.09,
         "sodium": 481.32,
         "calcium": 45.3,
         "protein": 6.4,
         "selenium": 24.69,
         "vitaminA": 71.5,
         "vitaminC": 56.17,
         "vitaminD": 8.07,
         "vitaminE": 0.74,
         "vitaminK": 371.98,
         "magnesium": 296.89,
         "potassium": 133.53,
         "vitaminB1": 1.67,
         "vitaminB6": 1.89,
         "vitaminB12": 2.46,
         "cholesterol": 205.3,
         "carbohydrate": 59.16
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (19, '芹菜', 3, NULL, 1, '{
         "fat": 30.26,
         "iron": 7.71,
         "kcal": 193.81,
         "zinc": 11.2,
         "fiber": 9.82,
         "sugar": 10.35,
         "folate": 158.34,
         "iodine": 85.88,
         "omega3": 2.35,
         "sodium": 374.52,
         "calcium": 414.45,
         "protein": 28.91,
         "selenium": 44.27,
         "vitaminA": 249.67,
         "vitaminC": 42.88,
         "vitaminD": 9.93,
         "vitaminE": 7.78,
         "vitaminK": 179.38,
         "magnesium": 199.2,
         "potassium": 42.1,
         "vitaminB1": 0.54,
         "vitaminB6": 1.49,
         "vitaminB12": 3.25,
         "cholesterol": 203.95,
         "carbohydrate": 6.99
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (20, '韭菜', 3, NULL, 1, '{
         "fat": 6.85,
         "iron": 13.09,
         "kcal": 339.08,
         "zinc": 5.04,
         "fiber": 6.48,
         "sugar": 14.84,
         "folate": 153.31,
         "iodine": 86.57,
         "omega3": 4.27,
         "sodium": 80.04,
         "calcium": 266.52,
         "protein": 16.69,
         "selenium": 44.03,
         "vitaminA": 595.82,
         "vitaminC": 67.46,
         "vitaminD": 9.79,
         "vitaminE": 7.62,
         "vitaminK": 478.03,
         "magnesium": 60.02,
         "potassium": 802.32,
         "vitaminB1": 1.39,
         "vitaminB6": 0.49,
         "vitaminB12": 1.6,
         "cholesterol": 81.88,
         "carbohydrate": 76.48
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (21, '西红柿', 3, NULL, 1, '{
         "fat": 35.5,
         "iron": 13.73,
         "kcal": 144.54,
         "zinc": 13.89,
         "fiber": 2.17,
         "sugar": 9.01,
         "folate": 191.03,
         "iodine": 2.61,
         "omega3": 0.75,
         "sodium": 392.89,
         "calcium": 492.36,
         "protein": 17.86,
         "selenium": 35.69,
         "vitaminA": 404.4,
         "vitaminC": 61.75,
         "vitaminD": 5.04,
         "vitaminE": 7.43,
         "vitaminK": 93.3,
         "magnesium": 260.71,
         "potassium": 687.04,
         "vitaminB1": 0.44,
         "vitaminB6": 1.24,
         "vitaminB12": 3.21,
         "cholesterol": 115.84,
         "carbohydrate": 3.16
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (22, '黄瓜', 3, NULL, 1, '{
         "fat": 20.57,
         "iron": 10.53,
         "kcal": 406.27,
         "zinc": 10.67,
         "fiber": 8.75,
         "sugar": 13.67,
         "folate": 179.26,
         "iodine": 99.21,
         "omega3": 2.82,
         "sodium": 712.07,
         "calcium": 163.77,
         "protein": 8.1,
         "selenium": 49.33,
         "vitaminA": 574.71,
         "vitaminC": 17.91,
         "vitaminD": 0.81,
         "vitaminE": 9.07,
         "vitaminK": 178.38,
         "magnesium": 197.68,
         "potassium": 868.25,
         "vitaminB1": 1.95,
         "vitaminB6": 0.02,
         "vitaminB12": 1.55,
         "cholesterol": 276.32,
         "carbohydrate": 68.04
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (23, '茄子', 3, NULL, 1, '{
         "fat": 3.3,
         "iron": 11.28,
         "kcal": 253.34,
         "zinc": 2.29,
         "fiber": 3.76,
         "sugar": 19.71,
         "folate": 67.55,
         "iodine": 20.29,
         "omega3": 1.45,
         "sodium": 256.78,
         "calcium": 399.15,
         "protein": 23.17,
         "selenium": 2.13,
         "vitaminA": 899.64,
         "vitaminC": 87.97,
         "vitaminD": 1.16,
         "vitaminE": 5.96,
         "vitaminK": 247.02,
         "magnesium": 164.24,
         "potassium": 763.09,
         "vitaminB1": 0.37,
         "vitaminB6": 0.38,
         "vitaminB12": 2.2,
         "cholesterol": 26.14,
         "carbohydrate": 9.12
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (24, '辣椒', 3, NULL, 1, '{
         "fat": 49.11,
         "iron": 12.8,
         "kcal": 502.98,
         "zinc": 14.55,
         "fiber": 1.66,
         "sugar": 13.79,
         "folate": 78.5,
         "iodine": 46.31,
         "omega3": 2.51,
         "sodium": 506.41,
         "calcium": 12.32,
         "protein": 24.8,
         "selenium": 39.37,
         "vitaminA": 954.11,
         "vitaminC": 51.61,
         "vitaminD": 3.39,
         "vitaminE": 14.75,
         "vitaminK": 231.63,
         "magnesium": 80.42,
         "potassium": 714.75,
         "vitaminB1": 1.88,
         "vitaminB6": 0.99,
         "vitaminB12": 0.69,
         "cholesterol": 114.8,
         "carbohydrate": 78.94
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (25, '萝卜', 3, NULL, 1, '{
         "fat": 40.6,
         "iron": 12.08,
         "kcal": 192.76,
         "zinc": 11.96,
         "fiber": 9.77,
         "sugar": 14.69,
         "folate": 178.1,
         "iodine": 17.64,
         "omega3": 1.7,
         "sodium": 249.34,
         "calcium": 263.01,
         "protein": 29.59,
         "selenium": 44.1,
         "vitaminA": 497.69,
         "vitaminC": 66.12,
         "vitaminD": 8.45,
         "vitaminE": 17.8,
         "vitaminK": 467.77,
         "magnesium": 248.46,
         "potassium": 421.97,
         "vitaminB1": 0.61,
         "vitaminB6": 0.89,
         "vitaminB12": 0.44,
         "cholesterol": 34.87,
         "carbohydrate": 50.89
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (26, '西兰花', 3, NULL, 1, '{
         "fat": 12.67,
         "iron": 6.51,
         "kcal": 400.05,
         "zinc": 10.5,
         "fiber": 8.14,
         "sugar": 5.86,
         "folate": 158.82,
         "iodine": 90.75,
         "omega3": 3.89,
         "sodium": 474.63,
         "calcium": 312.98,
         "protein": 20.76,
         "selenium": 21.78,
         "vitaminA": 159.63,
         "vitaminC": 53.69,
         "vitaminD": 6.73,
         "vitaminE": 13.45,
         "vitaminK": 191.29,
         "magnesium": 153.93,
         "potassium": 136.64,
         "vitaminB1": 0.31,
         "vitaminB6": 1.23,
         "vitaminB12": 2.33,
         "cholesterol": 289.81,
         "carbohydrate": 79.52
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (27, '生菜', 3, NULL, 1, '{
         "fat": 13.18,
         "iron": 4.76,
         "kcal": 251.71,
         "zinc": 11.4,
         "fiber": 4.21,
         "sugar": 7.57,
         "folate": 162.1,
         "iodine": 89.62,
         "omega3": 3.64,
         "sodium": 221.07,
         "calcium": 432.33,
         "protein": 21.61,
         "selenium": 16.17,
         "vitaminA": 494.57,
         "vitaminC": 16.89,
         "vitaminD": 7.76,
         "vitaminE": 14.42,
         "vitaminK": 71.28,
         "magnesium": 86.51,
         "potassium": 827.54,
         "vitaminB1": 1.32,
         "vitaminB6": 1.42,
         "vitaminB12": 3.48,
         "cholesterol": 113.58,
         "carbohydrate": 30.64
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (28, '冬瓜', 3, NULL, 1, '{
         "fat": 46.0,
         "iron": 12.42,
         "kcal": 263.52,
         "zinc": 8.29,
         "fiber": 3.05,
         "sugar": 0.91,
         "folate": 179.96,
         "iodine": 37.13,
         "omega3": 2.47,
         "sodium": 572.08,
         "calcium": 381.84,
         "protein": 11.23,
         "selenium": 27.87,
         "vitaminA": 921.25,
         "vitaminC": 90.46,
         "vitaminD": 6.9,
         "vitaminE": 18.03,
         "vitaminK": 223.87,
         "magnesium": 113.23,
         "potassium": 625.71,
         "vitaminB1": 1.25,
         "vitaminB6": 0.27,
         "vitaminB12": 4.28,
         "cholesterol": 47.98,
         "carbohydrate": 61.32
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (29, '南瓜', 3, NULL, 1, '{
         "fat": 40.93,
         "iron": 9.63,
         "kcal": 535.94,
         "zinc": 13.34,
         "fiber": 0.15,
         "sugar": 4.86,
         "folate": 115.83,
         "iodine": 42.21,
         "omega3": 0.55,
         "sodium": 872.06,
         "calcium": 288.75,
         "protein": 4.88,
         "selenium": 15.83,
         "vitaminA": 659.03,
         "vitaminC": 35.51,
         "vitaminD": 6.44,
         "vitaminE": 3.46,
         "vitaminK": 312.96,
         "magnesium": 298.46,
         "potassium": 446.85,
         "vitaminB1": 1.65,
         "vitaminB6": 1.84,
         "vitaminB12": 2.93,
         "cholesterol": 269.56,
         "carbohydrate": 32.28
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (30, '苦瓜', 3, NULL, 1, '{
         "fat": 8.22,
         "iron": 12.87,
         "kcal": 379.56,
         "zinc": 9.43,
         "fiber": 7.75,
         "sugar": 17.58,
         "folate": 86.76,
         "iodine": 67.72,
         "omega3": 3.07,
         "sodium": 689.44,
         "calcium": 212.23,
         "protein": 10.68,
         "selenium": 28.04,
         "vitaminA": 347.48,
         "vitaminC": 79.82,
         "vitaminD": 9.42,
         "vitaminE": 3.08,
         "vitaminK": 436.25,
         "magnesium": 142.24,
         "potassium": 347.81,
         "vitaminB1": 1.05,
         "vitaminB6": 1.27,
         "vitaminB12": 1.33,
         "cholesterol": 108.47,
         "carbohydrate": 57.8
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (31, '香菇', 4, NULL, 1, '{
         "fat": 2.54,
         "iron": 3.28,
         "kcal": 208.57,
         "zinc": 8.67,
         "fiber": 1.42,
         "sugar": 12.43,
         "folate": 120.42,
         "iodine": 97.1,
         "omega3": 4.5,
         "sodium": 383.89,
         "calcium": 350.08,
         "protein": 25.36,
         "selenium": 16.72,
         "vitaminA": 478.42,
         "vitaminC": 8.43,
         "vitaminD": 3.52,
         "vitaminE": 11.6,
         "vitaminK": 464.21,
         "magnesium": 45.3,
         "potassium": 752.38,
         "vitaminB1": 0.39,
         "vitaminB6": 1.42,
         "vitaminB12": 2.29,
         "cholesterol": 86.86,
         "carbohydrate": 33.23
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (32, '木耳', 4, NULL, 1, '{
         "fat": 41.08,
         "iron": 7.76,
         "kcal": 423.05,
         "zinc": 10.67,
         "fiber": 6.42,
         "sugar": 12.57,
         "folate": 187.06,
         "iodine": 44.15,
         "omega3": 3.59,
         "sodium": 367.42,
         "calcium": 289.65,
         "protein": 8.8,
         "selenium": 24.94,
         "vitaminA": 531.34,
         "vitaminC": 18.95,
         "vitaminD": 6.98,
         "vitaminE": 1.27,
         "vitaminK": 321.63,
         "magnesium": 268.71,
         "potassium": 261.37,
         "vitaminB1": 0.21,
         "vitaminB6": 1.42,
         "vitaminB12": 2.13,
         "cholesterol": 127.42,
         "carbohydrate": 56.99
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (33, '银耳', 4, NULL, 1, '{
         "fat": 44.87,
         "iron": 7.82,
         "kcal": 557.56,
         "zinc": 3.68,
         "fiber": 9.23,
         "sugar": 13.39,
         "folate": 77.17,
         "iodine": 86.06,
         "omega3": 4.51,
         "sodium": 759.97,
         "calcium": 153.85,
         "protein": 8.6,
         "selenium": 7.72,
         "vitaminA": 392.81,
         "vitaminC": 60.05,
         "vitaminD": 8.93,
         "vitaminE": 18.54,
         "vitaminK": 499.25,
         "magnesium": 295.08,
         "potassium": 786.08,
         "vitaminB1": 0.91,
         "vitaminB6": 0.61,
         "vitaminB12": 0.39,
         "cholesterol": 2.14,
         "carbohydrate": 18.63
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (34, '海带', 4, NULL, 1, '{
         "fat": 26.01,
         "iron": 13.53,
         "kcal": 104.79,
         "zinc": 0.7,
         "fiber": 5.22,
         "sugar": 0.75,
         "folate": 130.09,
         "iodine": 35.59,
         "omega3": 0.8,
         "sodium": 882.69,
         "calcium": 478.99,
         "protein": 11.26,
         "selenium": 37.15,
         "vitaminA": 111.65,
         "vitaminC": 36.62,
         "vitaminD": 6.17,
         "vitaminE": 14.35,
         "vitaminK": 0.33,
         "magnesium": 70.05,
         "potassium": 169.88,
         "vitaminB1": 0.12,
         "vitaminB6": 0.47,
         "vitaminB12": 1.41,
         "cholesterol": 89.44,
         "carbohydrate": 55.14
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (35, '紫菜', 4, NULL, 1, '{
         "fat": 5.04,
         "iron": 5.25,
         "kcal": 209.97,
         "zinc": 13.88,
         "fiber": 7.55,
         "sugar": 1.61,
         "folate": 10.49,
         "iodine": 6.67,
         "omega3": 4.32,
         "sodium": 534.23,
         "calcium": 132.73,
         "protein": 20.13,
         "selenium": 45.09,
         "vitaminA": 717.51,
         "vitaminC": 19.84,
         "vitaminD": 4.46,
         "vitaminE": 2.44,
         "vitaminK": 331.2,
         "magnesium": 203.39,
         "potassium": 206.71,
         "vitaminB1": 0.59,
         "vitaminB6": 0.96,
         "vitaminB12": 0.0,
         "cholesterol": 78.1,
         "carbohydrate": 16.9
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (36, '金针菇', 4, NULL, 1, '{
         "fat": 7.36,
         "iron": 12.44,
         "kcal": 265.9,
         "zinc": 13.58,
         "fiber": 5.2,
         "sugar": 7.34,
         "folate": 135.58,
         "iodine": 54.99,
         "omega3": 1.48,
         "sodium": 75.82,
         "calcium": 38.55,
         "protein": 16.28,
         "selenium": 36.4,
         "vitaminA": 842.86,
         "vitaminC": 39.69,
         "vitaminD": 7.09,
         "vitaminE": 18.89,
         "vitaminK": 379.22,
         "magnesium": 26.47,
         "potassium": 596.16,
         "vitaminB1": 0.84,
         "vitaminB6": 0.78,
         "vitaminB12": 2.92,
         "cholesterol": 106.28,
         "carbohydrate": 73.09
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (37, '苹果', 5, NULL, 1, '{
         "fat": 29.91,
         "iron": 13.8,
         "kcal": 231.09,
         "zinc": 10.49,
         "fiber": 9.67,
         "sugar": 4.33,
         "folate": 45.88,
         "iodine": 10.87,
         "omega3": 2.32,
         "sodium": 513.13,
         "calcium": 209.59,
         "protein": 0.51,
         "selenium": 8.67,
         "vitaminA": 149.43,
         "vitaminC": 54.27,
         "vitaminD": 1.73,
         "vitaminE": 11.83,
         "vitaminK": 403.87,
         "magnesium": 204.92,
         "potassium": 797.91,
         "vitaminB1": 0.23,
         "vitaminB6": 0.32,
         "vitaminB12": 0.73,
         "cholesterol": 15.39,
         "carbohydrate": 17.14
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (38, '香蕉', 5, NULL, 1, '{
         "fat": 46.18,
         "iron": 1.14,
         "kcal": 310.53,
         "zinc": 0.93,
         "fiber": 6.62,
         "sugar": 6.12,
         "folate": 65.64,
         "iodine": 15.94,
         "omega3": 4.29,
         "sodium": 907.1,
         "calcium": 208.22,
         "protein": 23.09,
         "selenium": 31.3,
         "vitaminA": 482.33,
         "vitaminC": 17.32,
         "vitaminD": 7.44,
         "vitaminE": 6.08,
         "vitaminK": 27.83,
         "magnesium": 27.54,
         "potassium": 92.14,
         "vitaminB1": 0.01,
         "vitaminB6": 1.11,
         "vitaminB12": 1.42,
         "cholesterol": 152.51,
         "carbohydrate": 70.18
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (39, '梨', 5, NULL, 1, '{
         "fat": 27.77,
         "iron": 1.58,
         "kcal": 449.0,
         "zinc": 0.79,
         "fiber": 0.69,
         "sugar": 0.91,
         "folate": 188.65,
         "iodine": 24.68,
         "omega3": 2.75,
         "sodium": 368.88,
         "calcium": 440.29,
         "protein": 17.88,
         "selenium": 5.01,
         "vitaminA": 535.71,
         "vitaminC": 23.9,
         "vitaminD": 3.13,
         "vitaminE": 17.96,
         "vitaminK": 271.46,
         "magnesium": 135.61,
         "potassium": 280.79,
         "vitaminB1": 1.74,
         "vitaminB6": 1.81,
         "vitaminB12": 4.78,
         "cholesterol": 223.33,
         "carbohydrate": 22.81
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (40, '桃', 5, NULL, 1, '{
         "fat": 33.96,
         "iron": 7.91,
         "kcal": 21.13,
         "zinc": 9.59,
         "fiber": 5.43,
         "sugar": 15.19,
         "folate": 85.84,
         "iodine": 36.54,
         "omega3": 4.27,
         "sodium": 21.16,
         "calcium": 494.76,
         "protein": 12.35,
         "selenium": 43.5,
         "vitaminA": 887.19,
         "vitaminC": 59.22,
         "vitaminD": 5.05,
         "vitaminE": 7.87,
         "vitaminK": 245.64,
         "magnesium": 94.7,
         "potassium": 84.86,
         "vitaminB1": 0.86,
         "vitaminB6": 1.6,
         "vitaminB12": 0.98,
         "cholesterol": 38.78,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (41, '葡萄', 5, NULL, 1, '{
         "fat": 23.21,
         "iron": 4.93,
         "kcal": 122.85,
         "zinc": 8.88,
         "fiber": 6.0,
         "sugar": 8.84,
         "folate": 193.7,
         "iodine": 54.86,
         "omega3": 1.37,
         "sodium": 406.41,
         "calcium": 272.55,
         "protein": 29.65,
         "selenium": 14.15,
         "vitaminA": 434.17,
         "vitaminC": 78.72,
         "vitaminD": 2.51,
         "vitaminE": 4.48,
         "vitaminK": 122.45,
         "magnesium": 80.05,
         "potassium": 640.3,
         "vitaminB1": 0.21,
         "vitaminB6": 0.56,
         "vitaminB12": 0.74,
         "cholesterol": 166.64,
         "carbohydrate": 79.87
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (42, '西瓜', 5, NULL, 1, '{
         "fat": 4.15,
         "iron": 14.4,
         "kcal": 30.4,
         "zinc": 7.55,
         "fiber": 0.64,
         "sugar": 17.18,
         "folate": 156.8,
         "iodine": 25.01,
         "omega3": 1.85,
         "sodium": 94.46,
         "calcium": 248.81,
         "protein": 0.89,
         "selenium": 7.27,
         "vitaminA": 751.42,
         "vitaminC": 54.05,
         "vitaminD": 3.32,
         "vitaminE": 6.32,
         "vitaminK": 490.13,
         "magnesium": 225.62,
         "potassium": 672.43,
         "vitaminB1": 0.52,
         "vitaminB6": 1.39,
         "vitaminB12": 3.65,
         "cholesterol": 208.58,
         "carbohydrate": 13.79
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (43, '草莓', 5, NULL, 1, '{
         "fat": 3.38,
         "iron": 1.76,
         "kcal": 597.17,
         "zinc": 4.52,
         "fiber": 7.7,
         "sugar": 14.31,
         "folate": 184.17,
         "iodine": 19.61,
         "omega3": 0.37,
         "sodium": 791.48,
         "calcium": 414.5,
         "protein": 26.3,
         "selenium": 20.72,
         "vitaminA": 110.72,
         "vitaminC": 74.69,
         "vitaminD": 0.64,
         "vitaminE": 16.29,
         "vitaminK": 412.74,
         "magnesium": 137.03,
         "potassium": 335.45,
         "vitaminB1": 1.77,
         "vitaminB6": 1.76,
         "vitaminB12": 1.42,
         "cholesterol": 261.7,
         "carbohydrate": 3.7
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (44, '橙子', 5, NULL, 1, '{
         "fat": 9.09,
         "iron": 0.53,
         "kcal": 72.16,
         "zinc": 11.99,
         "fiber": 3.19,
         "sugar": 15.07,
         "folate": 132.76,
         "iodine": 3.62,
         "omega3": 4.98,
         "sodium": 624.5,
         "calcium": 409.43,
         "protein": 1.19,
         "selenium": 28.6,
         "vitaminA": 533.08,
         "vitaminC": 26.87,
         "vitaminD": 6.11,
         "vitaminE": 9.09,
         "vitaminK": 337.47,
         "magnesium": 60.81,
         "potassium": 876.23,
         "vitaminB1": 1.22,
         "vitaminB6": 1.51,
         "vitaminB12": 4.06,
         "cholesterol": 21.87,
         "carbohydrate": 45.98
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (45, '柚子', 5, NULL, 1, '{
         "fat": 12.18,
         "iron": 3.91,
         "kcal": 544.79,
         "zinc": 5.58,
         "fiber": 6.74,
         "sugar": 17.3,
         "folate": 88.67,
         "iodine": 48.01,
         "omega3": 0.91,
         "sodium": 342.08,
         "calcium": 486.8,
         "protein": 8.4,
         "selenium": 7.79,
         "vitaminA": 128.24,
         "vitaminC": 67.14,
         "vitaminD": 1.31,
         "vitaminE": 12.11,
         "vitaminK": 446.04,
         "magnesium": 223.93,
         "potassium": 331.47,
         "vitaminB1": 0.85,
         "vitaminB6": 0.29,
         "vitaminB12": 3.97,
         "cholesterol": 30.9,
         "carbohydrate": 57.26
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (46, '猕猴桃', 5, NULL, 1, '{
         "fat": 1.79,
         "iron": 12.63,
         "kcal": 461.5,
         "zinc": 7.98,
         "fiber": 7.97,
         "sugar": 13.6,
         "folate": 108.48,
         "iodine": 54.62,
         "omega3": 4.69,
         "sodium": 485.82,
         "calcium": 380.37,
         "protein": 5.91,
         "selenium": 17.82,
         "vitaminA": 522.79,
         "vitaminC": 76.34,
         "vitaminD": 2.86,
         "vitaminE": 9.31,
         "vitaminK": 475.66,
         "magnesium": 90.09,
         "potassium": 237.37,
         "vitaminB1": 0.34,
         "vitaminB6": 1.12,
         "vitaminB12": 2.0,
         "cholesterol": 285.13,
         "carbohydrate": 47.61
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (47, '核桃', 6, NULL, 1, '{
         "fat": 31.47,
         "iron": 2.16,
         "kcal": 202.75,
         "zinc": 4.12,
         "fiber": 9.23,
         "sugar": 15.79,
         "folate": 141.98,
         "iodine": 24.99,
         "omega3": 2.37,
         "sodium": 500.73,
         "calcium": 438.75,
         "protein": 26.29,
         "selenium": 49.78,
         "vitaminA": 73.3,
         "vitaminC": 58.89,
         "vitaminD": 7.09,
         "vitaminE": 7.98,
         "vitaminK": 453.23,
         "magnesium": 84.69,
         "potassium": 49.44,
         "vitaminB1": 1.92,
         "vitaminB6": 1.78,
         "vitaminB12": 2.4,
         "cholesterol": 236.81,
         "carbohydrate": 58.26
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (48, '花生', 6, NULL, 1, '{
         "fat": 19.3,
         "iron": 9.23,
         "kcal": 325.25,
         "zinc": 0.57,
         "fiber": 7.95,
         "sugar": 19.93,
         "folate": 39.02,
         "iodine": 6.19,
         "omega3": 2.2,
         "sodium": 34.38,
         "calcium": 294.2,
         "protein": 21.08,
         "selenium": 27.43,
         "vitaminA": 141.81,
         "vitaminC": 66.63,
         "vitaminD": 0.38,
         "vitaminE": 5.3,
         "vitaminK": 81.59,
         "magnesium": 271.61,
         "potassium": 857.51,
         "vitaminB1": 0.56,
         "vitaminB6": 1.5,
         "vitaminB12": 0.47,
         "cholesterol": 87.66,
         "carbohydrate": 77.02
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (49, '腰果', 6, NULL, 1, '{
         "fat": 32.4,
         "iron": 3.87,
         "kcal": 437.34,
         "zinc": 1.53,
         "fiber": 3.31,
         "sugar": 4.73,
         "folate": 79.45,
         "iodine": 97.32,
         "omega3": 4.23,
         "sodium": 329.84,
         "calcium": 355.06,
         "protein": 23.35,
         "selenium": 25.78,
         "vitaminA": 347.85,
         "vitaminC": 50.34,
         "vitaminD": 5.26,
         "vitaminE": 12.04,
         "vitaminK": 154.21,
         "magnesium": 88.58,
         "potassium": 256.8,
         "vitaminB1": 0.01,
         "vitaminB6": 0.07,
         "vitaminB12": 1.09,
         "cholesterol": 200.71,
         "carbohydrate": 40.75
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (50, '榛子', 6, NULL, 1, '{
         "fat": 33.85,
         "iron": 3.0,
         "kcal": 89.09,
         "zinc": 12.06,
         "fiber": 4.94,
         "sugar": 11.56,
         "folate": 86.58,
         "iodine": 18.78,
         "omega3": 0.3,
         "sodium": 854.02,
         "calcium": 485.15,
         "protein": 3.81,
         "selenium": 31.55,
         "vitaminA": 207.21,
         "vitaminC": 67.37,
         "vitaminD": 7.36,
         "vitaminE": 10.47,
         "vitaminK": 179.94,
         "magnesium": 204.16,
         "potassium": 383.47,
         "vitaminB1": 0.38,
         "vitaminB6": 0.16,
         "vitaminB12": 4.11,
         "cholesterol": 134.67,
         "carbohydrate": 6.84
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (51, '松子', 6, NULL, 1, '{
         "fat": 38.72,
         "iron": 4.47,
         "kcal": 233.73,
         "zinc": 8.25,
         "fiber": 9.59,
         "sugar": 0.03,
         "folate": 77.78,
         "iodine": 23.37,
         "omega3": 1.77,
         "sodium": 980.16,
         "calcium": 56.0,
         "protein": 3.69,
         "selenium": 33.04,
         "vitaminA": 745.82,
         "vitaminC": 71.86,
         "vitaminD": 4.83,
         "vitaminE": 10.44,
         "vitaminK": 224.81,
         "magnesium": 26.58,
         "potassium": 364.71,
         "vitaminB1": 1.87,
         "vitaminB6": 1.06,
         "vitaminB12": 2.22,
         "cholesterol": 52.64,
         "carbohydrate": 57.71
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (52, '猪肉', 7, NULL, 1, '{
         "fat": 43.25,
         "iron": 12.62,
         "kcal": 439.27,
         "zinc": 14.73,
         "fiber": 7.16,
         "sugar": 7.78,
         "folate": 32.54,
         "iodine": 93.04,
         "omega3": 4.76,
         "sodium": 616.19,
         "calcium": 301.81,
         "protein": 14.68,
         "selenium": 35.46,
         "vitaminA": 727.7,
         "vitaminC": 25.91,
         "vitaminD": 7.5,
         "vitaminE": 18.06,
         "vitaminK": 437.47,
         "magnesium": 154.68,
         "potassium": 108.81,
         "vitaminB1": 0.66,
         "vitaminB6": 1.77,
         "vitaminB12": 1.17,
         "cholesterol": 4.24,
         "carbohydrate": 22.3
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (53, '牛肉', 7, NULL, 1, '{
         "fat": 23.94,
         "iron": 4.94,
         "kcal": 335.06,
         "zinc": 2.89,
         "fiber": 1.04,
         "sugar": 6.31,
         "folate": 54.89,
         "iodine": 14.89,
         "omega3": 4.04,
         "sodium": 890.43,
         "calcium": 415.89,
         "protein": 9.68,
         "selenium": 23.2,
         "vitaminA": 106.03,
         "vitaminC": 15.1,
         "vitaminD": 9.89,
         "vitaminE": 6.73,
         "vitaminK": 45.34,
         "magnesium": 249.51,
         "potassium": 182.46,
         "vitaminB1": 1.49,
         "vitaminB6": 1.93,
         "vitaminB12": 4.3,
         "cholesterol": 250.37,
         "carbohydrate": 67.07
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (54, '羊肉', 7, NULL, 1, '{
         "fat": 0.14,
         "iron": 4.04,
         "kcal": 189.71,
         "zinc": 5.83,
         "fiber": 5.62,
         "sugar": 4.92,
         "folate": 62.6,
         "iodine": 35.85,
         "omega3": 0.47,
         "sodium": 509.08,
         "calcium": 321.3,
         "protein": 20.22,
         "selenium": 36.32,
         "vitaminA": 674.76,
         "vitaminC": 10.93,
         "vitaminD": 2.72,
         "vitaminE": 8.84,
         "vitaminK": 1.48,
         "magnesium": 177.68,
         "potassium": 513.98,
         "vitaminB1": 0.62,
         "vitaminB6": 1.18,
         "vitaminB12": 2.66,
         "cholesterol": 291.23,
         "carbohydrate": 53.56
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (55, '驴肉', 7, NULL, 1, '{
         "fat": 44.81,
         "iron": 2.69,
         "kcal": 257.37,
         "zinc": 3.21,
         "fiber": 7.23,
         "sugar": 10.52,
         "folate": 44.75,
         "iodine": 78.68,
         "omega3": 0.86,
         "sodium": 726.33,
         "calcium": 25.87,
         "protein": 20.59,
         "selenium": 10.16,
         "vitaminA": 880.22,
         "vitaminC": 84.28,
         "vitaminD": 1.11,
         "vitaminE": 2.43,
         "vitaminK": 270.62,
         "magnesium": 260.91,
         "potassium": 985.95,
         "vitaminB1": 0.81,
         "vitaminB6": 0.44,
         "vitaminB12": 0.48,
         "cholesterol": 269.99,
         "carbohydrate": 74.33
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (56, '兔肉', 7, NULL, 1, '{
         "fat": 49.17,
         "iron": 9.89,
         "kcal": 529.45,
         "zinc": 0.96,
         "fiber": 7.99,
         "sugar": 2.33,
         "folate": 114.07,
         "iodine": 31.2,
         "omega3": 3.39,
         "sodium": 608.87,
         "calcium": 33.68,
         "protein": 17.11,
         "selenium": 36.82,
         "vitaminA": 855.66,
         "vitaminC": 39.77,
         "vitaminD": 6.79,
         "vitaminE": 14.01,
         "vitaminK": 482.02,
         "magnesium": 242.01,
         "potassium": 651.82,
         "vitaminB1": 0.78,
         "vitaminB6": 1.57,
         "vitaminB12": 3.17,
         "cholesterol": 143.89,
         "carbohydrate": 49.13
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (57, '鸡肉', 8, NULL, 1, '{
         "fat": 40.23,
         "iron": 3.3,
         "kcal": 366.55,
         "zinc": 0.96,
         "fiber": 6.46,
         "sugar": 4.52,
         "folate": 155.75,
         "iodine": 84.5,
         "omega3": 3.84,
         "sodium": 492.2,
         "calcium": 296.33,
         "protein": 17.75,
         "selenium": 16.92,
         "vitaminA": 117.92,
         "vitaminC": 48.47,
         "vitaminD": 1.52,
         "vitaminE": 11.87,
         "vitaminK": 194.98,
         "magnesium": 91.98,
         "potassium": 855.14,
         "vitaminB1": 1.3,
         "vitaminB6": 0.61,
         "vitaminB12": 1.86,
         "cholesterol": 37.94,
         "carbohydrate": 14.25
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (58, '鸭肉', 8, NULL, 1, '{
         "fat": 45.51,
         "iron": 1.53,
         "kcal": 157.62,
         "zinc": 6.03,
         "fiber": 3.16,
         "sugar": 4.97,
         "folate": 123.92,
         "iodine": 84.51,
         "omega3": 4.98,
         "sodium": 940.34,
         "calcium": 409.19,
         "protein": 23.95,
         "selenium": 41.41,
         "vitaminA": 232.93,
         "vitaminC": 13.29,
         "vitaminD": 9.57,
         "vitaminE": 18.45,
         "vitaminK": 300.47,
         "magnesium": 262.86,
         "potassium": 233.34,
         "vitaminB1": 0.22,
         "vitaminB6": 1.57,
         "vitaminB12": 0.67,
         "cholesterol": 111.69,
         "carbohydrate": 76.3
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (59, '鹅肉', 8, NULL, 1, '{
         "fat": 49.56,
         "iron": 1.93,
         "kcal": 520.51,
         "zinc": 7.17,
         "fiber": 0.32,
         "sugar": 11.03,
         "folate": 152.34,
         "iodine": 37.67,
         "omega3": 3.21,
         "sodium": 359.86,
         "calcium": 110.59,
         "protein": 10.04,
         "selenium": 27.54,
         "vitaminA": 833.13,
         "vitaminC": 7.9,
         "vitaminD": 0.79,
         "vitaminE": 14.51,
         "vitaminK": 16.19,
         "magnesium": 280.18,
         "potassium": 523.72,
         "vitaminB1": 1.97,
         "vitaminB6": 0.22,
         "vitaminB12": 3.17,
         "cholesterol": 28.94,
         "carbohydrate": 53.85
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (60, '鸽子肉', 8, NULL, 1, '{
         "fat": 41.75,
         "iron": 8.58,
         "kcal": 22.91,
         "zinc": 13.75,
         "fiber": 6.6,
         "sugar": 13.9,
         "folate": 48.92,
         "iodine": 47.67,
         "omega3": 0.26,
         "sodium": 836.33,
         "calcium": 286.45,
         "protein": 20.35,
         "selenium": 34.86,
         "vitaminA": 260.28,
         "vitaminC": 79.89,
         "vitaminD": 7.89,
         "vitaminE": 12.31,
         "vitaminK": 370.46,
         "magnesium": 135.62,
         "potassium": 68.76,
         "vitaminB1": 1.98,
         "vitaminB6": 0.11,
         "vitaminB12": 2.67,
         "cholesterol": 148.63,
         "carbohydrate": 64.84
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (61, '火鸡肉', 8, NULL, 1, '{
         "fat": 15.46,
         "iron": 7.35,
         "kcal": 131.64,
         "zinc": 1.43,
         "fiber": 4.51,
         "sugar": 0.32,
         "folate": 182.79,
         "iodine": 0.57,
         "omega3": 2.08,
         "sodium": 812.75,
         "calcium": 71.31,
         "protein": 23.99,
         "selenium": 48.36,
         "vitaminA": 960.38,
         "vitaminC": 24.21,
         "vitaminD": 6.33,
         "vitaminE": 17.8,
         "vitaminK": 378.75,
         "magnesium": 15.31,
         "potassium": 256.76,
         "vitaminB1": 1.99,
         "vitaminB6": 0.74,
         "vitaminB12": 2.62,
         "cholesterol": 19.07,
         "carbohydrate": 50.64
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (62, '牛奶', 9, NULL, 1, '{
         "fat": 1.49,
         "iron": 1.35,
         "kcal": 173.88,
         "zinc": 8.14,
         "fiber": 5.15,
         "sugar": 17.26,
         "folate": 128.25,
         "iodine": 86.82,
         "omega3": 0.78,
         "sodium": 645.69,
         "calcium": 446.23,
         "protein": 17.55,
         "selenium": 1.22,
         "vitaminA": 17.62,
         "vitaminC": 33.93,
         "vitaminD": 2.35,
         "vitaminE": 9.81,
         "vitaminK": 117.6,
         "magnesium": 4.63,
         "potassium": 831.15,
         "vitaminB1": 1.22,
         "vitaminB6": 1.77,
         "vitaminB12": 0.09,
         "cholesterol": 214.59,
         "carbohydrate": 43.11
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (63, '酸奶', 9, NULL, 1, '{
         "fat": 11.85,
         "iron": 10.44,
         "kcal": 355.87,
         "zinc": 14.8,
         "fiber": 1.7,
         "sugar": 1.16,
         "folate": 99.67,
         "iodine": 47.95,
         "omega3": 4.33,
         "sodium": 980.97,
         "calcium": 351.19,
         "protein": 17.53,
         "selenium": 42.4,
         "vitaminA": 10.71,
         "vitaminC": 84.07,
         "vitaminD": 4.15,
         "vitaminE": 19.57,
         "vitaminK": 265.51,
         "magnesium": 128.6,
         "potassium": 873.66,
         "vitaminB1": 0.87,
         "vitaminB6": 1.56,
         "vitaminB12": 0.31,
         "cholesterol": 258.21,
         "carbohydrate": 26.99
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (64, '奶酪', 9, NULL, 1, '{
         "fat": 32.87,
         "iron": 4.53,
         "kcal": 20.8,
         "zinc": 11.86,
         "fiber": 4.67,
         "sugar": 7.59,
         "folate": 169.45,
         "iodine": 7.9,
         "omega3": 1.14,
         "sodium": 6.77,
         "calcium": 233.8,
         "protein": 16.42,
         "selenium": 48.79,
         "vitaminA": 551.49,
         "vitaminC": 31.81,
         "vitaminD": 7.53,
         "vitaminE": 8.45,
         "vitaminK": 190.99,
         "magnesium": 252.62,
         "potassium": 747.66,
         "vitaminB1": 1.03,
         "vitaminB6": 0.87,
         "vitaminB12": 0.04,
         "cholesterol": 199.5,
         "carbohydrate": 66.25
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (65, '奶粉', 9, NULL, 1, '{
         "fat": 22.06,
         "iron": 5.94,
         "kcal": 543.57,
         "zinc": 11.31,
         "fiber": 4.25,
         "sugar": 12.33,
         "folate": 126.29,
         "iodine": 6.33,
         "omega3": 0.22,
         "sodium": 911.1,
         "calcium": 183.04,
         "protein": 2.55,
         "selenium": 2.99,
         "vitaminA": 304.56,
         "vitaminC": 19.86,
         "vitaminD": 0.31,
         "vitaminE": 12.33,
         "vitaminK": 39.2,
         "magnesium": 159.97,
         "potassium": 508.58,
         "vitaminB1": 1.22,
         "vitaminB6": 0.74,
         "vitaminB12": 2.85,
         "cholesterol": 238.83,
         "carbohydrate": 34.54
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (66, '黄油', 9, NULL, 1, '{
         "fat": 44.31,
         "iron": 2.22,
         "kcal": 343.37,
         "zinc": 13.51,
         "fiber": 7.05,
         "sugar": 1.78,
         "folate": 118.79,
         "iodine": 85.94,
         "omega3": 1.83,
         "sodium": 44.82,
         "calcium": 123.43,
         "protein": 10.27,
         "selenium": 7.16,
         "vitaminA": 570.27,
         "vitaminC": 71.0,
         "vitaminD": 4.38,
         "vitaminE": 10.39,
         "vitaminK": 187.16,
         "magnesium": 58.95,
         "potassium": 387.52,
         "vitaminB1": 0.87,
         "vitaminB6": 0.42,
         "vitaminB12": 0.85,
         "cholesterol": 259.64,
         "carbohydrate": 53.34
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (67, '鸡蛋', 10, NULL, 1, '{
         "fat": 21.55,
         "iron": 5.63,
         "kcal": 139.4,
         "zinc": 13.24,
         "fiber": 0.92,
         "sugar": 16.29,
         "folate": 169.59,
         "iodine": 48.12,
         "omega3": 3.43,
         "sodium": 515.3,
         "calcium": 241.0,
         "protein": 13.08,
         "selenium": 41.65,
         "vitaminA": 411.01,
         "vitaminC": 53.48,
         "vitaminD": 8.98,
         "vitaminE": 12.18,
         "vitaminK": 303.98,
         "magnesium": 250.41,
         "potassium": 852.86,
         "vitaminB1": 0.77,
         "vitaminB6": 0.97,
         "vitaminB12": 1.8,
         "cholesterol": 104.54,
         "carbohydrate": 15.82
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (68, '鸭蛋', 10, NULL, 1, '{
         "fat": 29.23,
         "iron": 11.56,
         "kcal": 112.83,
         "zinc": 3.29,
         "fiber": 2.87,
         "sugar": 3.21,
         "folate": 169.83,
         "iodine": 44.6,
         "omega3": 3.3,
         "sodium": 31.03,
         "calcium": 116.95,
         "protein": 21.47,
         "selenium": 26.04,
         "vitaminA": 698.52,
         "vitaminC": 4.05,
         "vitaminD": 8.09,
         "vitaminE": 2.48,
         "vitaminK": 468.42,
         "magnesium": 39.97,
         "potassium": 321.19,
         "vitaminB1": 0.56,
         "vitaminB6": 0.48,
         "vitaminB12": 3.7,
         "cholesterol": 7.03,
         "carbohydrate": 28.4
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (69, '鹅蛋', 10, NULL, 1, '{
         "fat": 45.27,
         "iron": 4.64,
         "kcal": 214.03,
         "zinc": 10.42,
         "fiber": 6.45,
         "sugar": 8.98,
         "folate": 113.56,
         "iodine": 0.37,
         "omega3": 3.92,
         "sodium": 332.85,
         "calcium": 432.86,
         "protein": 8.88,
         "selenium": 12.85,
         "vitaminA": 226.65,
         "vitaminC": 33.03,
         "vitaminD": 7.2,
         "vitaminE": 6.51,
         "vitaminK": 365.78,
         "magnesium": 137.92,
         "potassium": 745.87,
         "vitaminB1": 0.96,
         "vitaminB6": 0.96,
         "vitaminB12": 3.1,
         "cholesterol": 183.88,
         "carbohydrate": 14.96
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (70, '鹌鹑蛋', 10, NULL, 1, '{
         "fat": 38.24,
         "iron": 12.61,
         "kcal": 82.24,
         "zinc": 8.25,
         "fiber": 4.41,
         "sugar": 0.22,
         "folate": 170.88,
         "iodine": 44.29,
         "omega3": 4.25,
         "sodium": 447.08,
         "calcium": 486.76,
         "protein": 19.01,
         "selenium": 17.98,
         "vitaminA": 590.36,
         "vitaminC": 77.5,
         "vitaminD": 2.34,
         "vitaminE": 10.71,
         "vitaminK": 268.97,
         "magnesium": 261.21,
         "potassium": 331.37,
         "vitaminB1": 1.28,
         "vitaminB6": 0.76,
         "vitaminB12": 4.18,
         "cholesterol": 213.01,
         "carbohydrate": 41.78
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (71, '咸鸭蛋', 10, NULL, 1, '{
         "fat": 29.21,
         "iron": 1.14,
         "kcal": 217.1,
         "zinc": 7.54,
         "fiber": 3.12,
         "sugar": 7.09,
         "folate": 18.52,
         "iodine": 80.85,
         "omega3": 3.93,
         "sodium": 540.03,
         "calcium": 124.58,
         "protein": 0.13,
         "selenium": 14.29,
         "vitaminA": 885.79,
         "vitaminC": 23.57,
         "vitaminD": 5.82,
         "vitaminE": 1.1,
         "vitaminK": 472.95,
         "magnesium": 281.35,
         "potassium": 410.26,
         "vitaminB1": 1.5,
         "vitaminB6": 1.91,
         "vitaminB12": 4.14,
         "cholesterol": 41.58,
         "carbohydrate": 53.85
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (72, '鲤鱼', 11, NULL, 1, '{
         "fat": 46.56,
         "iron": 10.59,
         "kcal": 452.1,
         "zinc": 8.63,
         "fiber": 3.68,
         "sugar": 8.64,
         "folate": 132.54,
         "iodine": 41.78,
         "omega3": 0.96,
         "sodium": 444.47,
         "calcium": 30.77,
         "protein": 24.63,
         "selenium": 40.13,
         "vitaminA": 399.53,
         "vitaminC": 50.3,
         "vitaminD": 1.69,
         "vitaminE": 5.49,
         "vitaminK": 289.36,
         "magnesium": 206.72,
         "potassium": 342.28,
         "vitaminB1": 2.0,
         "vitaminB6": 0.02,
         "vitaminB12": 0.72,
         "cholesterol": 76.92,
         "carbohydrate": 59.69
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (73, '草鱼', 11, NULL, 1, '{
         "fat": 31.17,
         "iron": 12.76,
         "kcal": 377.77,
         "zinc": 11.95,
         "fiber": 7.17,
         "sugar": 6.56,
         "folate": 161.88,
         "iodine": 50.14,
         "omega3": 2.44,
         "sodium": 41.58,
         "calcium": 472.77,
         "protein": 7.32,
         "selenium": 5.66,
         "vitaminA": 70.64,
         "vitaminC": 46.39,
         "vitaminD": 3.08,
         "vitaminE": 9.48,
         "vitaminK": 259.97,
         "magnesium": 168.54,
         "potassium": 833.46,
         "vitaminB1": 0.21,
         "vitaminB6": 0.94,
         "vitaminB12": 2.58,
         "cholesterol": 145.22,
         "carbohydrate": 29.1
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (74, '带鱼', 11, NULL, 1, '{
         "fat": 10.02,
         "iron": 13.55,
         "kcal": 193.8,
         "zinc": 7.45,
         "fiber": 9.96,
         "sugar": 9.06,
         "folate": 136.01,
         "iodine": 79.79,
         "omega3": 4.23,
         "sodium": 380.03,
         "calcium": 258.46,
         "protein": 3.51,
         "selenium": 16.47,
         "vitaminA": 848.54,
         "vitaminC": 94.77,
         "vitaminD": 7.37,
         "vitaminE": 18.99,
         "vitaminK": 25.78,
         "magnesium": 53.01,
         "potassium": 208.47,
         "vitaminB1": 1.46,
         "vitaminB6": 0.54,
         "vitaminB12": 0.55,
         "cholesterol": 191.85,
         "carbohydrate": 29.32
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (75, '大虾', 11, NULL, 1, '{
         "fat": 4.35,
         "iron": 3.82,
         "kcal": 394.83,
         "zinc": 10.87,
         "fiber": 9.83,
         "sugar": 14.47,
         "folate": 93.58,
         "iodine": 36.32,
         "omega3": 3.97,
         "sodium": 327.16,
         "calcium": 360.96,
         "protein": 25.52,
         "selenium": 1.0,
         "vitaminA": 236.11,
         "vitaminC": 10.77,
         "vitaminD": 0.65,
         "vitaminE": 13.79,
         "vitaminK": 308.24,
         "magnesium": 195.19,
         "potassium": 393.91,
         "vitaminB1": 1.98,
         "vitaminB6": 1.76,
         "vitaminB12": 3.68,
         "cholesterol": 64.3,
         "carbohydrate": 33.23
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (76, '螃蟹', 11, NULL, 1, '{
         "fat": 28.65,
         "iron": 6.99,
         "kcal": 304.83,
         "zinc": 12.85,
         "fiber": 2.37,
         "sugar": 17.92,
         "folate": 142.39,
         "iodine": 18.46,
         "omega3": 0.14,
         "sodium": 13.41,
         "calcium": 303.81,
         "protein": 24.96,
         "selenium": 43.44,
         "vitaminA": 898.52,
         "vitaminC": 76.1,
         "vitaminD": 7.9,
         "vitaminE": 17.86,
         "vitaminK": 239.73,
         "magnesium": 162.0,
         "potassium": 372.46,
         "vitaminB1": 0.49,
         "vitaminB6": 0.93,
         "vitaminB12": 1.05,
         "cholesterol": 216.73,
         "carbohydrate": 76.44
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (77, '扇贝', 11, NULL, 1, '{
         "fat": 33.72,
         "iron": 13.96,
         "kcal": 400.95,
         "zinc": 14.75,
         "fiber": 7.5,
         "sugar": 6.36,
         "folate": 105.01,
         "iodine": 31.91,
         "omega3": 1.34,
         "sodium": 339.62,
         "calcium": 230.72,
         "protein": 20.08,
         "selenium": 32.26,
         "vitaminA": 644.16,
         "vitaminC": 13.24,
         "vitaminD": 7.74,
         "vitaminE": 1.53,
         "vitaminK": 337.4,
         "magnesium": 105.07,
         "potassium": 355.74,
         "vitaminB1": 0.88,
         "vitaminB6": 1.69,
         "vitaminB12": 4.23,
         "cholesterol": 33.96,
         "carbohydrate": 0.76
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (78, '牡蛎', 11, NULL, 1, '{
         "fat": 49.9,
         "iron": 13.18,
         "kcal": 450.05,
         "zinc": 14.67,
         "fiber": 7.58,
         "sugar": 2.79,
         "folate": 192.53,
         "iodine": 96.82,
         "omega3": 3.59,
         "sodium": 101.04,
         "calcium": 7.36,
         "protein": 2.75,
         "selenium": 23.17,
         "vitaminA": 158.63,
         "vitaminC": 17.08,
         "vitaminD": 7.55,
         "vitaminE": 4.59,
         "vitaminK": 133.37,
         "magnesium": 12.12,
         "potassium": 255.27,
         "vitaminB1": 1.81,
         "vitaminB6": 0.98,
         "vitaminB12": 1.47,
         "cholesterol": 68.04,
         "carbohydrate": 35.58
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (79, '蛤蜊', 11, NULL, 1, '{
         "fat": 18.14,
         "iron": 4.47,
         "kcal": 119.31,
         "zinc": 5.96,
         "fiber": 9.01,
         "sugar": 6.18,
         "folate": 71.19,
         "iodine": 85.48,
         "omega3": 0.72,
         "sodium": 488.57,
         "calcium": 336.1,
         "protein": 4.42,
         "selenium": 9.62,
         "vitaminA": 317.77,
         "vitaminC": 34.02,
         "vitaminD": 2.27,
         "vitaminE": 7.03,
         "vitaminK": 429.41,
         "magnesium": 277.56,
         "potassium": 925.61,
         "vitaminB1": 0.09,
         "vitaminB6": 0.65,
         "vitaminB12": 0.74,
         "cholesterol": 297.63,
         "carbohydrate": 17.49
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (80, '章鱼', 11, NULL, 1, '{
         "fat": 20.13,
         "iron": 4.17,
         "kcal": 228.97,
         "zinc": 5.73,
         "fiber": 5.04,
         "sugar": 9.68,
         "folate": 59.17,
         "iodine": 25.12,
         "omega3": 3.41,
         "sodium": 3.53,
         "calcium": 415.66,
         "protein": 8.11,
         "selenium": 3.88,
         "vitaminA": 16.1,
         "vitaminC": 5.3,
         "vitaminD": 6.65,
         "vitaminE": 15.12,
         "vitaminK": 170.95,
         "magnesium": 88.55,
         "potassium": 724.63,
         "vitaminB1": 1.33,
         "vitaminB6": 0.74,
         "vitaminB12": 1.61,
         "cholesterol": 74.95,
         "carbohydrate": 70.82
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (81, '鱿鱼', 11, NULL, 1, '{
         "fat": 40.97,
         "iron": 14.08,
         "kcal": 145.52,
         "zinc": 6.88,
         "fiber": 1.68,
         "sugar": 3.4,
         "folate": 48.38,
         "iodine": 74.05,
         "omega3": 4.11,
         "sodium": 405.74,
         "calcium": 62.99,
         "protein": 29.69,
         "selenium": 44.56,
         "vitaminA": 226.84,
         "vitaminC": 70.91,
         "vitaminD": 0.27,
         "vitaminE": 8.0,
         "vitaminK": 175.21,
         "magnesium": 79.54,
         "potassium": 252.7,
         "vitaminB1": 0.29,
         "vitaminB6": 1.81,
         "vitaminB12": 3.77,
         "cholesterol": 150.06,
         "carbohydrate": 59.06
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (82, '面包', 14, NULL, 1, '{
         "fat": 40.54,
         "iron": 14.68,
         "kcal": 146.42,
         "zinc": 9.41,
         "fiber": 8.28,
         "sugar": 8.36,
         "folate": 134.76,
         "iodine": 73.31,
         "omega3": 2.56,
         "sodium": 721.68,
         "calcium": 429.26,
         "protein": 25.19,
         "selenium": 23.51,
         "vitaminA": 960.78,
         "vitaminC": 13.25,
         "vitaminD": 2.44,
         "vitaminE": 6.81,
         "vitaminK": 106.89,
         "magnesium": 98.8,
         "potassium": 958.99,
         "vitaminB1": 0.91,
         "vitaminB6": 1.75,
         "vitaminB12": 2.61,
         "cholesterol": 171.52,
         "carbohydrate": 6.11
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (83, '方便面', 14, NULL, 1, '{
         "fat": 38.2,
         "iron": 14.83,
         "kcal": 351.83,
         "zinc": 4.02,
         "fiber": 7.21,
         "sugar": 10.46,
         "folate": 56.4,
         "iodine": 28.54,
         "omega3": 0.37,
         "sodium": 499.87,
         "calcium": 154.59,
         "protein": 21.66,
         "selenium": 46.74,
         "vitaminA": 168.78,
         "vitaminC": 41.27,
         "vitaminD": 0.38,
         "vitaminE": 15.48,
         "vitaminK": 376.87,
         "magnesium": 208.28,
         "potassium": 516.08,
         "vitaminB1": 1.75,
         "vitaminB6": 0.58,
         "vitaminB12": 4.49,
         "cholesterol": 101.22,
         "carbohydrate": 36.8
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (84, '火腿肠', 14, NULL, 1, '{
         "fat": 45.76,
         "iron": 11.16,
         "kcal": 395.82,
         "zinc": 2.69,
         "fiber": 7.08,
         "sugar": 10.85,
         "folate": 72.65,
         "iodine": 88.86,
         "omega3": 3.28,
         "sodium": 638.55,
         "calcium": 465.98,
         "protein": 3.0,
         "selenium": 17.59,
         "vitaminA": 950.38,
         "vitaminC": 16.66,
         "vitaminD": 2.92,
         "vitaminE": 19.09,
         "vitaminK": 299.58,
         "magnesium": 22.5,
         "potassium": 21.15,
         "vitaminB1": 1.88,
         "vitaminB6": 1.59,
         "vitaminB12": 0.53,
         "cholesterol": 19.5,
         "carbohydrate": 33.71
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (85, '罐头', 14, NULL, 1, '{
         "fat": 29.38,
         "iron": 14.31,
         "kcal": 307.31,
         "zinc": 0.91,
         "fiber": 6.6,
         "sugar": 9.51,
         "folate": 45.69,
         "iodine": 82.17,
         "omega3": 3.34,
         "sodium": 139.4,
         "calcium": 69.39,
         "protein": 5.63,
         "selenium": 33.54,
         "vitaminA": 939.13,
         "vitaminC": 25.14,
         "vitaminD": 6.02,
         "vitaminE": 11.56,
         "vitaminK": 171.21,
         "magnesium": 166.42,
         "potassium": 984.18,
         "vitaminB1": 0.44,
         "vitaminB6": 1.58,
         "vitaminB12": 3.61,
         "cholesterol": 70.92,
         "carbohydrate": 28.4
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (86, '速冻饺子', 14, NULL, 1, '{
         "fat": 22.92,
         "iron": 2.69,
         "kcal": 541.41,
         "zinc": 2.63,
         "fiber": 2.04,
         "sugar": 4.37,
         "folate": 24.11,
         "iodine": 44.04,
         "omega3": 1.67,
         "sodium": 369.24,
         "calcium": 220.48,
         "protein": 20.82,
         "selenium": 20.08,
         "vitaminA": 576.99,
         "vitaminC": 69.85,
         "vitaminD": 8.24,
         "vitaminE": 2.25,
         "vitaminK": 441.39,
         "magnesium": 71.1,
         "potassium": 967.86,
         "vitaminB1": 0.09,
         "vitaminB6": 0.72,
         "vitaminB12": 0.75,
         "cholesterol": 87.95,
         "carbohydrate": 54.81
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (87, '可乐', 15, NULL, 1, '{
         "fat": 45.6,
         "iron": 13.15,
         "kcal": 196.94,
         "zinc": 1.18,
         "fiber": 4.33,
         "sugar": 15.92,
         "folate": 46.03,
         "iodine": 4.07,
         "omega3": 2.57,
         "sodium": 521.41,
         "calcium": 271.22,
         "protein": 26.53,
         "selenium": 33.01,
         "vitaminA": 851.27,
         "vitaminC": 64.04,
         "vitaminD": 0.62,
         "vitaminE": 6.47,
         "vitaminK": 51.24,
         "magnesium": 288.27,
         "potassium": 479.77,
         "vitaminB1": 1.09,
         "vitaminB6": 0.67,
         "vitaminB12": 4.28,
         "cholesterol": 7.99,
         "carbohydrate": 74.62
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (88, '橙汁', 15, NULL, 1, '{
         "fat": 30.34,
         "iron": 3.31,
         "kcal": 384.84,
         "zinc": 11.2,
         "fiber": 1.26,
         "sugar": 9.42,
         "folate": 177.2,
         "iodine": 49.54,
         "omega3": 4.99,
         "sodium": 814.05,
         "calcium": 303.85,
         "protein": 0.47,
         "selenium": 2.38,
         "vitaminA": 545.28,
         "vitaminC": 58.83,
         "vitaminD": 4.69,
         "vitaminE": 3.77,
         "vitaminK": 481.89,
         "magnesium": 246.93,
         "potassium": 460.38,
         "vitaminB1": 1.53,
         "vitaminB6": 0.91,
         "vitaminB12": 4.56,
         "cholesterol": 288.71,
         "carbohydrate": 75.84
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (89, '绿茶', 15, NULL, 1, '{
         "fat": 2.77,
         "iron": 1.88,
         "kcal": 84.55,
         "zinc": 14.37,
         "fiber": 4.11,
         "sugar": 3.46,
         "folate": 74.26,
         "iodine": 2.99,
         "omega3": 0.76,
         "sodium": 164.8,
         "calcium": 273.28,
         "protein": 7.79,
         "selenium": 44.52,
         "vitaminA": 258.12,
         "vitaminC": 41.87,
         "vitaminD": 7.21,
         "vitaminE": 9.79,
         "vitaminK": 382.14,
         "magnesium": 7.84,
         "potassium": 420.01,
         "vitaminB1": 1.16,
         "vitaminB6": 0.64,
         "vitaminB12": 1.52,
         "cholesterol": 150.96,
         "carbohydrate": 72.39
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (90, '咖啡', 15, NULL, 1, '{
         "fat": 4.67,
         "iron": 7.93,
         "kcal": 341.1,
         "zinc": 14.08,
         "fiber": 9.4,
         "sugar": 8.43,
         "folate": 133.02,
         "iodine": 8.77,
         "omega3": 1.38,
         "sodium": 276.21,
         "calcium": 356.47,
         "protein": 19.99,
         "selenium": 7.74,
         "vitaminA": 263.97,
         "vitaminC": 79.02,
         "vitaminD": 6.28,
         "vitaminE": 10.26,
         "vitaminK": 401.13,
         "magnesium": 45.09,
         "potassium": 119.75,
         "vitaminB1": 1.33,
         "vitaminB6": 1.84,
         "vitaminB12": 0.42,
         "cholesterol": 168.69,
         "carbohydrate": 67.95
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (91, '矿泉水', 15, NULL, 1, '{
         "fat": 29.28,
         "iron": 9.78,
         "kcal": 110.76,
         "zinc": 12.64,
         "fiber": 9.42,
         "sugar": 17.58,
         "folate": 67.08,
         "iodine": 65.32,
         "omega3": 4.75,
         "sodium": 313.33,
         "calcium": 313.26,
         "protein": 6.02,
         "selenium": 27.95,
         "vitaminA": 505.55,
         "vitaminC": 51.91,
         "vitaminD": 9.57,
         "vitaminE": 18.48,
         "vitaminK": 384.16,
         "magnesium": 69.5,
         "potassium": 122.13,
         "vitaminB1": 0.85,
         "vitaminB6": 1.66,
         "vitaminB12": 0.15,
         "cholesterol": 130.27,
         "carbohydrate": 78.66
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (92, '食盐', 16, NULL, 1, '{
         "fat": 11.28,
         "iron": 3.8,
         "kcal": 592.39,
         "zinc": 1.72,
         "fiber": 5.97,
         "sugar": 14.34,
         "folate": 169.9,
         "iodine": 94.61,
         "omega3": 3.11,
         "sodium": 523.03,
         "calcium": 185.8,
         "protein": 26.6,
         "selenium": 19.17,
         "vitaminA": 990.25,
         "vitaminC": 41.42,
         "vitaminD": 3.9,
         "vitaminE": 18.02,
         "vitaminK": 121.45,
         "magnesium": 82.03,
         "potassium": 69.0,
         "vitaminB1": 1.34,
         "vitaminB6": 0.39,
         "vitaminB12": 0.74,
         "cholesterol": 272.34,
         "carbohydrate": 28.94
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (93, '酱油', 16, NULL, 1, '{
         "fat": 13.4,
         "iron": 11.34,
         "kcal": 363.5,
         "zinc": 13.4,
         "fiber": 7.1,
         "sugar": 14.21,
         "folate": 80.09,
         "iodine": 3.75,
         "omega3": 1.45,
         "sodium": 71.06,
         "calcium": 211.94,
         "protein": 2.39,
         "selenium": 22.19,
         "vitaminA": 577.76,
         "vitaminC": 52.25,
         "vitaminD": 3.64,
         "vitaminE": 8.26,
         "vitaminK": 478.89,
         "magnesium": 153.1,
         "potassium": 320.76,
         "vitaminB1": 1.04,
         "vitaminB6": 0.08,
         "vitaminB12": 1.69,
         "cholesterol": 136.43,
         "carbohydrate": 21.23
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (94, '食醋', 16, NULL, 1, '{
         "fat": 6.86,
         "iron": 0.06,
         "kcal": 90.26,
         "zinc": 2.98,
         "fiber": 4.8,
         "sugar": 0.26,
         "folate": 35.05,
         "iodine": 97.44,
         "omega3": 1.27,
         "sodium": 492.16,
         "calcium": 124.38,
         "protein": 9.48,
         "selenium": 47.56,
         "vitaminA": 580.59,
         "vitaminC": 32.79,
         "vitaminD": 5.77,
         "vitaminE": 5.44,
         "vitaminK": 294.52,
         "magnesium": 241.35,
         "potassium": 499.32,
         "vitaminB1": 1.83,
         "vitaminB6": 0.04,
         "vitaminB12": 0.7,
         "cholesterol": 169.14,
         "carbohydrate": 36.71
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (95, '白糖', 16, NULL, 1, '{
         "fat": 10.87,
         "iron": 5.97,
         "kcal": 387.17,
         "zinc": 14.41,
         "fiber": 9.48,
         "sugar": 8.29,
         "folate": 46.31,
         "iodine": 91.94,
         "omega3": 0.41,
         "sodium": 390.93,
         "calcium": 170.65,
         "protein": 28.32,
         "selenium": 37.45,
         "vitaminA": 301.03,
         "vitaminC": 47.28,
         "vitaminD": 3.84,
         "vitaminE": 0.35,
         "vitaminK": 221.27,
         "magnesium": 132.9,
         "potassium": 809.72,
         "vitaminB1": 0.56,
         "vitaminB6": 1.04,
         "vitaminB12": 2.64,
         "cholesterol": 296.65,
         "carbohydrate": 76.11
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (96, '辣椒酱', 16, NULL, 1, '{
         "fat": 41.19,
         "iron": 13.67,
         "kcal": 588.85,
         "zinc": 7.01,
         "fiber": 2.17,
         "sugar": 11.03,
         "folate": 147.39,
         "iodine": 1.32,
         "omega3": 3.04,
         "sodium": 77.82,
         "calcium": 130.28,
         "protein": 25.7,
         "selenium": 43.57,
         "vitaminA": 200.89,
         "vitaminC": 49.55,
         "vitaminD": 8.55,
         "vitaminE": 15.97,
         "vitaminK": 27.64,
         "magnesium": 287.76,
         "potassium": 892.21,
         "vitaminB1": 1.47,
         "vitaminB6": 0.26,
         "vitaminB12": 4.52,
         "cholesterol": 183.7,
         "carbohydrate": 29.45
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (97, '花生油', 17, NULL, 1, '{
         "fat": 41.42,
         "iron": 10.11,
         "kcal": 348.87,
         "zinc": 5.81,
         "fiber": 5.01,
         "sugar": 1.86,
         "folate": 95.9,
         "iodine": 38.37,
         "omega3": 4.71,
         "sodium": 858.05,
         "calcium": 203.14,
         "protein": 13.17,
         "selenium": 16.17,
         "vitaminA": 91.55,
         "vitaminC": 59.63,
         "vitaminD": 5.73,
         "vitaminE": 16.63,
         "vitaminK": 140.21,
         "magnesium": 222.91,
         "potassium": 575.51,
         "vitaminB1": 1.28,
         "vitaminB6": 1.91,
         "vitaminB12": 3.49,
         "cholesterol": 284.67,
         "carbohydrate": 15.77
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (98, '大豆油', 17, NULL, 1, '{
         "fat": 49.82,
         "iron": 3.29,
         "kcal": 403.12,
         "zinc": 14.9,
         "fiber": 1.85,
         "sugar": 1.83,
         "folate": 15.27,
         "iodine": 19.81,
         "omega3": 1.2,
         "sodium": 294.6,
         "calcium": 357.76,
         "protein": 23.05,
         "selenium": 17.49,
         "vitaminA": 413.8,
         "vitaminC": 32.78,
         "vitaminD": 5.37,
         "vitaminE": 17.74,
         "vitaminK": 377.47,
         "magnesium": 219.71,
         "potassium": 307.21,
         "vitaminB1": 1.5,
         "vitaminB6": 1.52,
         "vitaminB12": 0.74,
         "cholesterol": 216.87,
         "carbohydrate": 57.6
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (99, '橄榄油', 17, NULL, 1, '{
         "fat": 45.86,
         "iron": 6.24,
         "kcal": 587.69,
         "zinc": 12.33,
         "fiber": 5.17,
         "sugar": 5.03,
         "folate": 58.26,
         "iodine": 29.41,
         "omega3": 0.65,
         "sodium": 750.39,
         "calcium": 463.08,
         "protein": 20.04,
         "selenium": 24.77,
         "vitaminA": 449.62,
         "vitaminC": 57.97,
         "vitaminD": 8.6,
         "vitaminE": 4.66,
         "vitaminK": 197.83,
         "magnesium": 163.86,
         "potassium": 373.36,
         "vitaminB1": 0.52,
         "vitaminB6": 0.97,
         "vitaminB12": 4.62,
         "cholesterol": 62.09,
         "carbohydrate": 40.53
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (100, '芝麻油', 17, NULL, 1, '{
         "fat": 40.8,
         "iron": 2.57,
         "kcal": 31.44,
         "zinc": 12.42,
         "fiber": 6.63,
         "sugar": 18.85,
         "folate": 113.12,
         "iodine": 62.32,
         "omega3": 3.38,
         "sodium": 515.55,
         "calcium": 217.75,
         "protein": 23.19,
         "selenium": 31.87,
         "vitaminA": 1.69,
         "vitaminC": 22.71,
         "vitaminD": 7.74,
         "vitaminE": 9.43,
         "vitaminK": 485.0,
         "magnesium": 246.42,
         "potassium": 88.08,
         "vitaminB1": 0.67,
         "vitaminB6": 1.75,
         "vitaminB12": 2.23,
         "cholesterol": 265.96,
         "carbohydrate": 14.66
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (101, '猪油', 17, NULL, 1, '{
         "fat": 6.9,
         "iron": 5.29,
         "kcal": 24.32,
         "zinc": 11.61,
         "fiber": 9.83,
         "sugar": 16.74,
         "folate": 179.23,
         "iodine": 76.58,
         "omega3": 2.23,
         "sodium": 906.71,
         "calcium": 446.02,
         "protein": 24.31,
         "selenium": 3.3,
         "vitaminA": 603.2,
         "vitaminC": 47.13,
         "vitaminD": 2.09,
         "vitaminE": 9.79,
         "vitaminK": 73.87,
         "magnesium": 170.7,
         "potassium": 492.46,
         "vitaminB1": 0.96,
         "vitaminB6": 0.31,
         "vitaminB12": 0.22,
         "cholesterol": 47.62,
         "carbohydrate": 59.32
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1001, '米饭', 1, NULL, 1, '{
         "fat": 0.3,
         "iron": 1.3,
         "kcal": 116,
         "fiber": 0.3,
         "sodium": 1.5,
         "calcium": 7,
         "protein": 2.6,
         "magnesium": 15,
         "potassium": 30,
         "carbohydrate": 25.9
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1002, '馒头', 1, NULL, 1, '{
         "fat": 1.1,
         "iron": 1.8,
         "kcal": 223,
         "fiber": 1.3,
         "sodium": 160,
         "calcium": 38,
         "protein": 7.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 47.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1003, '面条(煮)', 1, NULL, 1, '{
         "fat": 0.5,
         "iron": 1.7,
         "kcal": 137,
         "fiber": 1.2,
         "sodium": 4,
         "calcium": 11,
         "protein": 4.5,
         "magnesium": 13,
         "potassium": 44,
         "carbohydrate": 28.2
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1004, '紫薯', 1, NULL, 1, '{
         "fat": 0.3,
         "iron": 0.6,
         "kcal": 82,
         "fiber": 1.4,
         "sodium": 15,
         "calcium": 18,
         "protein": 1.3,
         "magnesium": 16,
         "potassium": 271,
         "carbohydrate": 20.1
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1005, '芋头', 1, NULL, 1, '{
         "fat": 0.2,
         "iron": 1.0,
         "kcal": 79,
         "fiber": 1.0,
         "sodium": 33,
         "calcium": 36,
         "protein": 2.2,
         "magnesium": 23,
         "potassium": 378,
         "carbohydrate": 18.1
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1006, '糙米', 1, NULL, 1, '{
         "fat": 2.7,
         "iron": 1.6,
         "kcal": 332,
         "fiber": 3.9,
         "sodium": 3,
         "calcium": 15,
         "protein": 7.7,
         "magnesium": 110,
         "potassium": 223,
         "carbohydrate": 75.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1007, '意大利面', 1, NULL, 1, '{
         "fat": 1.5,
         "iron": 3.3,
         "kcal": 350,
         "fiber": 3.2,
         "sodium": 6,
         "calcium": 21,
         "protein": 12.5,
         "magnesium": 53,
         "potassium": 169,
         "carbohydrate": 71.2
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1008, '红豆', 2, NULL, 1, '{
         "fat": 0.6,
         "iron": 7.4,
         "kcal": 309,
         "fiber": 7.7,
         "sodium": 2.4,
         "calcium": 74,
         "protein": 20.2,
         "magnesium": 138,
         "potassium": 860,
         "carbohydrate": 63.4
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1009, '绿豆', 2, NULL, 1, '{
         "fat": 0.8,
         "iron": 6.5,
         "kcal": 316,
         "fiber": 6.4,
         "sodium": 3.2,
         "calcium": 81,
         "protein": 21.6,
         "magnesium": 125,
         "potassium": 787,
         "carbohydrate": 62.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1010, '豆腐干', 2, NULL, 1, '{
         "fat": 3.6,
         "iron": 4.8,
         "kcal": 140,
         "fiber": 0.8,
         "sodium": 520,
         "calcium": 308,
         "protein": 16.2,
         "magnesium": 87,
         "potassium": 172,
         "carbohydrate": 11.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1011, '豆皮', 2, NULL, 1, '{
         "fat": 17.4,
         "iron": 13.4,
         "kcal": 409,
         "fiber": 0.2,
         "sodium": 11,
         "calcium": 116,
         "protein": 45.0,
         "magnesium": 92,
         "potassium": 553,
         "carbohydrate": 18.8
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1012, '千张', 2, NULL, 1, '{
         "fat": 8.5,
         "iron": 5.6,
         "kcal": 201,
         "fiber": 0.5,
         "sodium": 12,
         "calcium": 164,
         "protein": 22.0,
         "magnesium": 78,
         "potassium": 243,
         "carbohydrate": 8.6
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1013, '青菜', 3, NULL, 1, '{
         "fat": 0.3,
         "iron": 1.2,
         "kcal": 15,
         "fiber": 1.1,
         "sodium": 55,
         "calcium": 108,
         "protein": 1.5,
         "magnesium": 18,
         "potassium": 210,
         "carbohydrate": 2.3
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1014, '空心菜', 3, NULL, 1, '{
         "fat": 0.3,
         "iron": 2.3,
         "kcal": 20,
         "fiber": 1.4,
         "sodium": 94,
         "calcium": 99,
         "protein": 2.2,
         "magnesium": 29,
         "potassium": 243,
         "carbohydrate": 3.9
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1015, '娃娃菜', 3, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.6,
         "kcal": 13,
         "fiber": 0.8,
         "sodium": 48,
         "calcium": 90,
         "protein": 1.1,
         "magnesium": 13,
         "potassium": 178,
         "carbohydrate": 2.6
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1016, '豆芽', 3, NULL, 1, '{
         "fat": 0.4,
         "iron": 0.5,
         "kcal": 18,
         "fiber": 1.5,
         "sodium": 4,
         "calcium": 9,
         "protein": 2.1,
         "magnesium": 18,
         "potassium": 160,
         "carbohydrate": 2.9
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1017, '土豆', 3, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.8,
         "kcal": 81,
         "fiber": 0.7,
         "sodium": 2.7,
         "calcium": 8,
         "protein": 2.6,
         "magnesium": 23,
         "potassium": 342,
         "carbohydrate": 17.8
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1018, '莲藕', 3, NULL, 1, '{
         "fat": 0.2,
         "iron": 1.4,
         "kcal": 73,
         "fiber": 2.2,
         "sodium": 44,
         "calcium": 39,
         "protein": 1.9,
         "magnesium": 19,
         "potassium": 243,
         "carbohydrate": 16.4
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1019, '竹笋', 3, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.5,
         "kcal": 19,
         "fiber": 1.8,
         "sodium": 0.7,
         "calcium": 9,
         "protein": 2.6,
         "magnesium": 1,
         "potassium": 389,
         "carbohydrate": 3.6
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1020, '豌豆', 3, NULL, 1, '{
         "fat": 0.3,
         "iron": 1.5,
         "kcal": 105,
         "fiber": 10.4,
         "sodium": 1.2,
         "calcium": 21,
         "protein": 7.4,
         "magnesium": 43,
         "potassium": 332,
         "carbohydrate": 21.2
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1021, '毛豆', 3, NULL, 1, '{
         "fat": 5.0,
         "iron": 3.5,
         "kcal": 123,
         "fiber": 4.0,
         "sodium": 3.5,
         "calcium": 135,
         "protein": 13.1,
         "magnesium": 70,
         "potassium": 478,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1022, '火龙果', 5, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.4,
         "kcal": 51,
         "fiber": 1.6,
         "sodium": 3.6,
         "calcium": 6,
         "protein": 1.1,
         "magnesium": 41,
         "potassium": 226,
         "carbohydrate": 13.3
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1023, '榴莲', 5, NULL, 1, '{
         "fat": 3.3,
         "iron": 0.3,
         "kcal": 147,
         "fiber": 1.7,
         "sodium": 2.9,
         "calcium": 4,
         "protein": 2.6,
         "magnesium": 27,
         "potassium": 261,
         "carbohydrate": 28.3
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1024, '柿子', 5, NULL, 1, '{
         "fat": 0.1,
         "iron": 0.2,
         "kcal": 71,
         "fiber": 1.4,
         "sodium": 0.8,
         "calcium": 9,
         "protein": 0.4,
         "magnesium": 19,
         "potassium": 151,
         "carbohydrate": 18.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1025, '石榴', 5, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.4,
         "kcal": 63,
         "fiber": 4.8,
         "sodium": 0.9,
         "calcium": 9,
         "protein": 1.4,
         "magnesium": 16,
         "potassium": 231,
         "carbohydrate": 18.7
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1026, '桑葚', 5, NULL, 1, '{
         "fat": 0.4,
         "iron": 0.3,
         "kcal": 48,
         "fiber": 3.3,
         "sodium": 1.9,
         "calcium": 30,
         "protein": 1.6,
         "magnesium": 20,
         "potassium": 32,
         "carbohydrate": 12.9
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1027, '枇杷', 5, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.3,
         "kcal": 39,
         "fiber": 0.8,
         "sodium": 3.0,
         "calcium": 17,
         "protein": 0.8,
         "magnesium": 14,
         "potassium": 122,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1028, '菠萝', 5, NULL, 1, '{
         "fat": 0.1,
         "iron": 0.6,
         "kcal": 44,
         "fiber": 1.3,
         "sodium": 0.8,
         "calcium": 12,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 113,
         "carbohydrate": 10.8
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1029, '荔枝', 5, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.4,
         "kcal": 70,
         "fiber": 0.5,
         "sodium": 1.7,
         "calcium": 2,
         "protein": 0.9,
         "magnesium": 12,
         "potassium": 151,
         "carbohydrate": 16.6
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1030, '龙眼', 5, NULL, 1, '{
         "fat": 0.1,
         "iron": 0.2,
         "kcal": 71,
         "fiber": 0.4,
         "sodium": 3.9,
         "calcium": 6,
         "protein": 1.2,
         "magnesium": 10,
         "potassium": 248,
         "carbohydrate": 16.2
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1031, '瓜子', 6, NULL, 1, '{
         "fat": 53.4,
         "iron": 5.7,
         "kcal": 606,
         "fiber": 4.5,
         "sodium": 5.5,
         "calcium": 72,
         "protein": 19.1,
         "magnesium": 264,
         "potassium": 562,
         "carbohydrate": 16.7
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1032, '开心果', 6, NULL, 1, '{
         "fat": 53.5,
         "iron": 4.2,
         "kcal": 614,
         "fiber": 10.3,
         "sodium": 4,
         "calcium": 120,
         "protein": 20.6,
         "magnesium": 131,
         "potassium": 970,
         "carbohydrate": 18.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1033, '夏威夷果', 6, NULL, 1, '{
         "fat": 75.8,
         "iron": 2.0,
         "kcal": 718,
         "fiber": 8.6,
         "sodium": 5,
         "calcium": 85,
         "protein": 7.9,
         "magnesium": 118,
         "potassium": 363,
         "carbohydrate": 13.8
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1034, '芝麻', 6, NULL, 1, '{
         "fat": 46.1,
         "iron": 22.7,
         "kcal": 517,
         "fiber": 14.0,
         "sodium": 8.3,
         "calcium": 780,
         "protein": 19.1,
         "magnesium": 290,
         "potassium": 358,
         "carbohydrate": 24.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1035, '猪里脊', 7, NULL, 1, '{
         "fat": 7.9,
         "iron": 3.0,
         "kcal": 155,
         "fiber": 0,
         "sodium": 50,
         "calcium": 6,
         "protein": 20.2,
         "magnesium": 27,
         "potassium": 317,
         "carbohydrate": 0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1036, '猪排骨', 7, NULL, 1, '{
         "fat": 20.4,
         "iron": 2.0,
         "kcal": 278,
         "fiber": 0,
         "sodium": 51,
         "calcium": 9,
         "protein": 18.3,
         "magnesium": 16,
         "potassium": 230,
         "carbohydrate": 1.7
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1037, '牛腩', 7, NULL, 1, '{
         "fat": 29.3,
         "iron": 3.3,
         "kcal": 332,
         "fiber": 0,
         "sodium": 57,
         "calcium": 9,
         "protein": 17.1,
         "magnesium": 17,
         "potassium": 178,
         "carbohydrate": 0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1038, '牛里脊', 7, NULL, 1, '{
         "fat": 2.3,
         "iron": 2.8,
         "kcal": 105,
         "fiber": 0,
         "sodium": 52,
         "calcium": 7,
         "protein": 20.2,
         "magnesium": 21,
         "potassium": 282,
         "carbohydrate": 0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1039, '羊排', 7, NULL, 1, '{
         "fat": 14.1,
         "iron": 2.3,
         "kcal": 203,
         "fiber": 0,
         "sodium": 80,
         "calcium": 12,
         "protein": 17.1,
         "magnesium": 20,
         "potassium": 232,
         "carbohydrate": 0.2
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1040, '鸡胸肉', 8, NULL, 1, '{
         "fat": 5.0,
         "iron": 1.4,
         "kcal": 133,
         "fiber": 0,
         "sodium": 63,
         "calcium": 9,
         "protein": 19.4,
         "magnesium": 19,
         "potassium": 251,
         "carbohydrate": 2.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1041, '鸡腿肉', 8, NULL, 1, '{
         "fat": 13.0,
         "iron": 1.1,
         "kcal": 181,
         "fiber": 0,
         "sodium": 76,
         "calcium": 13,
         "protein": 16.0,
         "magnesium": 17,
         "potassium": 189,
         "carbohydrate": 0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1042, '鸡翅', 8, NULL, 1, '{
         "fat": 11.0,
         "iron": 1.6,
         "kcal": 194,
         "fiber": 0,
         "sodium": 69,
         "calcium": 14,
         "protein": 17.4,
         "magnesium": 15,
         "potassium": 165,
         "carbohydrate": 4.6
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1043, '鸭胸肉', 8, NULL, 1, '{
         "fat": 19.7,
         "iron": 2.2,
         "kcal": 240,
         "fiber": 0,
         "sodium": 69,
         "calcium": 6,
         "protein": 15.5,
         "magnesium": 14,
         "potassium": 191,
         "carbohydrate": 0.2
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1044, '鲈鱼', 11, NULL, 1, '{
         "fat": 3.1,
         "iron": 2.0,
         "kcal": 105,
         "fiber": 0,
         "sodium": 55,
         "calcium": 138,
         "protein": 18.6,
         "magnesium": 37,
         "potassium": 205,
         "carbohydrate": 0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1045, '黄鱼', 11, NULL, 1, '{
         "fat": 3.0,
         "iron": 0.9,
         "kcal": 99,
         "fiber": 0,
         "sodium": 103,
         "calcium": 78,
         "protein": 17.9,
         "magnesium": 28,
         "potassium": 228,
         "carbohydrate": 0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1046, '鳕鱼', 11, NULL, 1, '{
         "fat": 0.4,
         "iron": 0.4,
         "kcal": 88,
         "fiber": 0,
         "sodium": 130,
         "calcium": 42,
         "protein": 20.4,
         "magnesium": 82,
         "potassium": 321,
         "carbohydrate": 0.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1047, '蛋糕', 13, NULL, 1, '{
         "fat": 11.6,
         "iron": 1.3,
         "kcal": 347,
         "fiber": 0.5,
         "sodium": 338,
         "calcium": 46,
         "protein": 6.6,
         "magnesium": 17,
         "potassium": 99,
         "carbohydrate": 56.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1048, '饼干', 13, NULL, 1, '{
         "fat": 13.6,
         "iron": 2.8,
         "kcal": 433,
         "fiber": 1.7,
         "sodium": 464,
         "calcium": 45,
         "protein": 7.6,
         "magnesium": 29,
         "potassium": 127,
         "carbohydrate": 71.4
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1049, '曲奇', 13, NULL, 1, '{
         "fat": 31.6,
         "iron": 2.3,
         "kcal": 546,
         "fiber": 1.7,
         "sodium": 275,
         "calcium": 34,
         "protein": 5.9,
         "magnesium": 26,
         "potassium": 120,
         "carbohydrate": 58.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1050, '冰淇淋', 13, NULL, 1, '{
         "fat": 11.0,
         "iron": 0.3,
         "kcal": 207,
         "fiber": 0.7,
         "sodium": 80,
         "calcium": 128,
         "protein": 3.5,
         "magnesium": 14,
         "potassium": 199,
         "carbohydrate": 23.6
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1051, '苹果汁', 15, NULL, 1, '{
         "fat": 0.1,
         "iron": 0.3,
         "kcal": 46,
         "fiber": 0.2,
         "sodium": 4,
         "calcium": 7,
         "protein": 0.1,
         "magnesium": 5,
         "potassium": 101,
         "carbohydrate": 11.3
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1052, '葡萄汁', 15, NULL, 1, '{
         "fat": 0.1,
         "iron": 0.3,
         "kcal": 54,
         "fiber": 0.2,
         "sodium": 5,
         "calcium": 9,
         "protein": 0.4,
         "magnesium": 10,
         "potassium": 132,
         "carbohydrate": 14.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1053, '柠檬水', 15, NULL, 1, '{
         "fat": 0.1,
         "iron": 0.1,
         "kcal": 25,
         "fiber": 0.3,
         "sodium": 1,
         "calcium": 6,
         "protein": 0.4,
         "magnesium": 6,
         "potassium": 103,
         "carbohydrate": 8.2
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1054, '红茶', 15, NULL, 1, '{
         "fat": 0,
         "iron": 0,
         "kcal": 1,
         "fiber": 0,
         "sodium": 3,
         "calcium": 0,
         "protein": 0.1,
         "magnesium": 3,
         "potassium": 37,
         "carbohydrate": 0.3
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1055, '红糖', 16, NULL, 1, '{
         "fat": 0.1,
         "iron": 2.2,
         "kcal": 389,
         "fiber": 0,
         "sodium": 19,
         "calcium": 157,
         "protein": 0.7,
         "magnesium": 54,
         "potassium": 240,
         "carbohydrate": 96.6
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1056, '盐', 16, NULL, 1, '{
         "fat": 0,
         "iron": 0.9,
         "kcal": 0,
         "fiber": 0,
         "sodium": 39300,
         "calcium": 24,
         "protein": 0,
         "magnesium": 9,
         "potassium": 33,
         "carbohydrate": 0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1057, '蚝油', 16, NULL, 1, '{
         "fat": 0.1,
         "iron": 11.3,
         "kcal": 51,
         "fiber": 0,
         "sodium": 5057,
         "calcium": 151,
         "protein": 5.6,
         "magnesium": 46,
         "potassium": 159,
         "carbohydrate": 8.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1058, '番茄酱', 16, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.9,
         "kcal": 81,
         "fiber": 1.5,
         "sodium": 643,
         "calcium": 12,
         "protein": 1.7,
         "magnesium": 21,
         "potassium": 413,
         "carbohydrate": 19.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1059, '黄焖鸡米饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1060, '宫保鸡丁盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1061, '鱼香肉丝盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1062, '麻婆豆腐盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1063, '番茄炒蛋盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1064, '青椒肉丝盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1065, '木须肉盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1066, '回锅肉盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1067, '京酱肉丝盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1068, '蚝油牛肉盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1069, '黑椒牛柳盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1070, '咖喱牛肉盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1071, '咖喱鸡肉盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1072, '红烧肉盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1073, '梅菜扣肉盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1074, '香菇滑鸡盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1075, '照烧鸡腿盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1076, '铁板牛肉盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1077, '孜然羊肉盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1078, '酸菜鱼盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1079, '水煮牛肉盖饭', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1080, '毛血旺盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1081, '三杯鸡盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1082, '香辣虾盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1083, '干锅鸡盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1084, '台式卤肉饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1085, '猪排饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1086, '鸡排饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1087, '牛排饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1088, '亲子丽', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1089, '日式咖喱饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1090, '韩式泡菜炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1091, '扬州炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1092, '蛋炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1093, '虾仁炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1094, '牛肉炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1095, '鸡肉炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1096, '海鲜炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1097, '菠萝炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1098, '黄金炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1099, '牛肉拉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1100, '兰州拉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1101, '红烧牛肉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1102, '葱油拌面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1103, '炸酱面', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1104, '热干面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1105, '刀削面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1106, '牛肉刀削面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1107, '臊子面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1108, '重庆小面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1109, '担担面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1110, '阳春面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1111, '排骨面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1112, '鸡汤面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1113, '酸菜牛肉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1114, '番茄鸡蛋面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1115, '香菇鸡肉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1116, '三鲜面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1117, '海鲜面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1118, '咖喱乌冬面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1119, '日式拉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1120, '豚骨拉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1121, '味增拉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1122, '冷面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1123, '韩式拌面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1125, '肉酱意面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1126, '奶油培根意面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1127, '海鲜意面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1128, '黑椒牛柳意面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1129, '越南河粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1130, '泰式炒河粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1131, '干炒牛河', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1132, '濑粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1133, '云吞面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1134, '米线', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1135, '过桥米线', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1136, '酸辣粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1137, '螺蛳粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1138, '桂林米粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1139, '肠粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1140, '炒面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1141, '炒河粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1142, '炒米粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1143, '新加坡炒面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1144, '日式炒面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1145, '韩式炒年糕', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1146, '年糕汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1147, '麻辣烫', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1148, '冒菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1149, '汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1150, '牛肉汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1151, '鸡肉汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1152, '鱼肉汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1153, '培根汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1154, '芝士汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1155, '双层汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1156, '炸鸡汉堡', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1157, '烤鸡腿堡', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1158, '猪柳堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1159, '披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1160, '玛格丽特披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1161, '夏威夷披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1162, '海鲜披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1163, '培根披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1164, '蘑菇披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1165, '肉酱披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1166, '意式香肠披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1167, '芝士披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1168, '什锦披萨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1169, '炸鸡', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1170, '炸鸡腿', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1171, '炸鸡翅', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1172, '炸鸡块', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1173, '香辣炸鸡', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1174, '奥尔良烤翅', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1175, '烤鸡翅', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1176, '可乐鸡翅', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1177, '薯条', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1178, '炸薯条', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1179, '鸡米花', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1180, '黄金鸡柳', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1181, '鸡肉卷', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1182, '老北京鸡肉卷', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1183, '墨西哥鸡肉卷', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1184, '热狗', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1185, '烤肠', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1186, '三明治', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1187, '鸡蛋三明治', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1188, '火腿三明治', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1189, '金枪鱼三明治', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1190, '俱乐部三明治', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1191, '帕尼尼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1192, '卷饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1193, '牛肉卷饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1194, '包子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1195, '肉包子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1196, '菜包子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1197, '豆沙包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1198, '叉烧包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1199, '灌汤包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1200, '小笼包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1201, '生煎包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1202, '韭菜盒子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1203, '糖三角', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1204, '饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1205, '猪肉饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1206, '韭菜鸡蛋饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1207, '三鲜饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1208, '虾仁饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1209, '白菜猪肉饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1210, '芹菜饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1211, '茴香饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1212, '牛肉饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1213, '羊肉饺子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1214, '煎饺', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1215, '锅贴', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1216, '蒸饺', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1217, '水饺', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1218, '馄饨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1219, '小馄饨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1220, '大馄饨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1221, '抄手', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1222, '云吞', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1223, '烧麦', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1224, '粽子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1225, '肉粽', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1226, '蛋黄肉粽', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1227, '豆沙粽', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1228, '红豆粽', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1229, '春卷', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1230, '蛋卷', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1231, '煎饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1232, '鸡蛋灌饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1233, '手抓饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1234, '葱油饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1235, '肉夹馍', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1236, '凉皮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1237, '煎饼果子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1238, '宫保鸡丁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1239, '鱼香肉丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1240, '回锅肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1241, '青椒肉丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1242, '木须肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1243, '京酱肉丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1244, '糖醋里脊', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1245, '锅包肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1246, '红烧肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1247, '东坡肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1248, '梅菜扣肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1249, '蒜泥白肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1250, '水煮肉片', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1251, '辣子鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1252, '口水鸡', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1253, '宫保虾球', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1254, '油焖大虾', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1255, '龙井虾仁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1256, '白灼虾', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1257, '麻辣小龙虾', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1258, '清蒸鲈鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1259, '红烧鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1260, '糖醋鱼', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1261, '水煮鱼', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1262, '酸菜鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1263, '剁椒鱼头', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1264, '松鼠桂鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1265, '鱼头豆腐汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1266, '番茄鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1267, '酸汤肥牛', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1268, '水煮牛肉', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1269, '黑椒牛柳', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1270, '小炒牛肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1271, '孜然牛肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1272, '蚝油牛肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1273, '蒜蓉排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1274, '糖醋排骨', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1275, '红烧排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1276, '清蒸排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1277, '盐焗排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1278, '烤羊排', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1279, '孜然羊肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1280, '葱爆羊肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1281, '手抓羊肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1282, '羊肉串', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1283, '干锅鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1284, '大盘鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1285, '白切鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1286, '盐焗鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1287, '烧鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1288, '麻婆豆腐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1289, '红烧豆腐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1290, '家常豆腐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1291, '铁板豆腐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1292, '臭豆腐', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1293, '皮蛋豆腐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1294, '番茄炒蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1295, '韭菜炒蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1296, '木耳炒蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1297, '丝瓜炒蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1298, '西红柿炖牛腩', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1299, '土豆炖牛肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1300, '土豆烧鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1301, '土豆炖排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1302, '醋溜土豆丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1303, '地三鲜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1304, '干煸豆角', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1305, '蒜蓉西兰花', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1306, '清炒时蔬', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1307, '炒青菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1308, '蒜蓉菠菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1309, '炝炒圆白菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1310, '手撕包菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1311, '醋溜白菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1312, '酸辣白菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1313, '鱼香茄子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1314, '红烧茄子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1315, '烧茄子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1316, '炒茄子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1317, '蒜泥茄子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1318, '干锅花菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1319, '干锅土豆片', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1320, '干锅娃娃菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1321, '炒豆芽', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1322, '韭菜炒豆芽', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1323, '拍黄瓜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1324, '凉拌黄瓜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1325, '凉拌木耳', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1326, '凉拌海带丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1327, '凉拌三丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1328, '蒜蓉油麦菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1329, '清炒豌豆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1330, '炒芦笋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1331, '炒蘑菇', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1332, '香菇青菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1333, '紫菜蛋花汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1334, '西红柿蛋汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1335, '酸辣汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1336, '疙瘩汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1337, '玉米排骨汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1338, '冬瓜排骨汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1339, '莲藕排骨汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1340, '山药排骨汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1341, '海带排骨汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1342, '萝卜牛腩汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1343, '番茄牛腩汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1344, '鸡汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1345, '乌鸡汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1346, '老鸭汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1347, '鸽子汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1348, '羊肉汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1349, '牛肉汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1350, '猪肚汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1351, '猪蹄汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1352, '花胶鸡汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1353, '鲫鱼豆腐汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1354, '酸菜鱼汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1355, '番茄鱼汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1356, '三鲜汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1357, '豆腐汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1358, '豆芽汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1359, '冬瓜汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1360, '萝卜汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1361, '蘑菇汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1362, '海鲜汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1363, '虾仁豆腐汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1364, '蛤蜊汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1365, '味增汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1366, '泡菜汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1367, '胡辣汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1368, '羊肉泡馍', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1369, '牛肉泡馍', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1370, '豆腐脑', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1371, '豆花', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1372, '火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1373, '麻辣火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1374, '清汤火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1375, '鸳鸯锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1376, '番茄火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1377, '菌汤火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1378, '海鲜火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1379, '羊肉火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1380, '牛肉火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1381, '猪肚鸡火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1382, '潮汕牛肉火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1383, '重庆火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1384, '成都火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1385, '老北京涮羊肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1386, '冰煮羊火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1387, '烤肉', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1388, '韩式烤肉', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1389, '巴西烤肉', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1390, '烤羊肉串', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1391, '烤牛肉串', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1392, '烤鸡心', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1393, '烤板筋', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1394, '烤韭菜', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1395, '烤茄子', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1396, '烤玉米', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1397, '烤土豆', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1398, '烤馒头片', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1399, '烤面筋', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1400, '烤鱿鱼', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1401, '烤生蚝', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1402, '烤扇贝', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1403, '烤鱼', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1404, '万州烤鱼', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1405, '纸上烤鱼', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1406, '铁板烧', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1407, '铁板鱿鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1408, '铁板牛肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1409, '关东煮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1410, '串串香', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1411, '钵钵鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1412, '冷锅串串', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1413, '烧烤', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1414, '章鱼小丸子', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1415, '鸡蛋仔', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1416, '烧饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1417, '麻团', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1418, '油条', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1420, '炸糕', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1421, '炸麻花', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1422, '驴打滚', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1423, '艾窝窝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1424, '豌豆黄', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1425, '糖葫芦', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1426, '棉花糖', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1427, '爆米花', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1428, '烤红薯', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1429, '烤栗子', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1430, '蟹黄包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1431, '汤包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1432, '糍粑', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1433, '年糕', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1434, '米糕', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1435, '发糕', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1436, '马拉糕', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1437, '萝卜糕', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1438, '芋头糕', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1439, '双皮奶', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1440, '龟苓膏', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1441, '烧仙草', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1442, '芋圆', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1443, '红豆沙', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1444, '绿豆沙', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1445, '芝麻糊', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1446, '杏仁茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1447, '凉粉', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1449, '奶油蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1450, '水果蛋糕', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1451, '巧克力蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1452, '芝士蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1453, '提拉米苏', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1454, '慕斯蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1455, '黑森林蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1456, '红丝绒蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1457, '千层蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1458, '泡芙', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1459, '马卡龙', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1462, '威化饼干', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1463, '苏打饼干', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1464, '消化饼干', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1465, '瑞士卷', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1466, '蛋挞', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1467, '葡式蛋挞', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1468, '广式月饼', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1469, '苏式月饼', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1470, '老婆饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1471, '绿豆饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1472, '蛋黄酥', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1473, '凤梨酥', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1474, '太阳饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1475, '牛轧糖', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1476, '花生糖', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1477, '芝麻糖', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1478, '软糖', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1479, '硬糖', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1480, '棒棒糖', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1481, '巧克力', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1482, '黑巧克力', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1483, '白巧克力', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1484, '牛奶巧克力', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1485, '松露巧克力', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1486, '榛子巧克力', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1487, '布丁', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1488, '焦糖布丁', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1489, '牛奶布丁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1490, '芒果布丁', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1491, '鸡蛋布丁', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1492, '果冻', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1494, '冰激凌', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1495, '圣代', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1496, '甜筒', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1497, '雪糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1498, '冰棒', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1499, '刨冰', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1500, '沙冰', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1501, '奶昔', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1502, '甜甜圈', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1503, '华夫饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1504, '松饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1505, '可丽饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1506, '班戟', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1507, '舒芙蕾', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1508, '拿破仑蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1509, '歌剧院蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1510, '沙河蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1511, '戚风蛋糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1512, '奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1513, '珍珠奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1514, '港式奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1515, '丝袜奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1516, '鸳鸯奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1517, '红茶拿铁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1518, '抹茶拿铁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1519, '芋泥波波奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1520, '烧仙草奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1521, '杨枝甘露', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1523, '美式咖啡', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1524, '拿铁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1525, '卡布奇诺', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1526, '摩卡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1527, '焦糖玛奇朵', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1528, '馥芮白', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1529, '澳白', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1530, '意式浓缩', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1531, '冷萃咖啡', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1532, '黑豆浆', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1533, '五谷豆浆', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1534, '红豆薏米浆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1535, '花生浆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1536, '核桃露', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1537, '杏仁露', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1538, '椰汁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1539, '椰子水', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1540, '椰奶', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1542, '纯牛奶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1543, '全脂牛奶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1544, '脱脂牛奶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1545, '低脂牛奶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1547, '原味酸奶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1548, '果味酸奶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1549, '希腊酸奶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1550, '风味发酵乳', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1551, '果汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1555, '西瓜汁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1556, '芒果汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1557, '火龙果汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1558, '胡萝卜汁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1559, '番茄汁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1560, '混合果汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1562, '蜂蜜柠檬水', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1563, '百香果柠檬水', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1564, '金桔柠檬水', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1565, '青柠水', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1566, '茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1569, '乌龙茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1570, '普洱茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1571, '铁观音', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1572, '龙井茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1573, '碧螺春', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1574, '大红袍', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1575, '茉莉花茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1576, '菊花茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1577, '玫瑰花茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1578, '柠檬茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1579, '水果茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1580, '养生茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1581, '碳酸饮料', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1583, '雪碧', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1584, '芬达', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1585, '七喜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1586, '美年达', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1587, '冰红茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1588, '冰绿茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1589, '运动饮料', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1590, '功能饮料', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (1591, '红牛', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1592, '脉动', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1593, '宝矿力', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1594, '尖叫', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1595, '东方树叶', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1596, '汽水', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1597, '盐汽水', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1598, '维他柠檬茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1599, '王老吉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1600, '加多宝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1601, '豆奶', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1602, '维他奶', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1603, '植物奶', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1604, '燕麦奶', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1605, '杏仁奶', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1606, '米浆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1607, '黑米浆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1608, '紫米浆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1609, '红枣豆浆', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1610, '豆浆油条', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1611, '粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1612, '白粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1613, '小米粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1614, '皮蛋瘦肉粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1615, '鸡丝粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1616, '鱼片粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1617, '海鲜粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1618, '八宝粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1619, '红豆粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1620, '绿豆粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1621, '南瓜粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1622, '紫薯粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1623, '山药粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1624, '玉米粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1625, '燕麦粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1626, '黑米粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1627, '薏米粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1628, '莲子粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1629, '茶叶蛋', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1630, '卤蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1631, '溏心蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1632, '水煮蛋', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1633, '煎蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1634, '炒蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1635, '蒸蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1636, '蛋饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1637, '油饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1638, '麻球', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1639, '糖糕', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1640, '肉包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1641, '菜包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1642, '奶黄包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1643, '流沙包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1644, '牛排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1645, '菲力牛排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1646, '西冷牛排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1647, '肋眼牛排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1648, 'T骨牛排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1649, '战斧牛排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1650, '煎牛排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1651, '烤牛排', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1652, '黑椒牛排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1653, '红酒牛排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1655, '香煎羊排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1656, '猪排', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1657, '猪扒', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1658, '白汁意面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1659, '红汁意面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1660, '千层面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1661, '通心粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1662, '芝士焗通心粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1663, '海鲜焗饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1664, '芝士焗饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1665, '烤鸡', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1666, '烤全鸡', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1667, '烤鸡腿', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1668, '烤鸡胸', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1669, '素食汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1670, '沙拉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1671, '凯撒沙拉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1672, '田园沙拉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1673, '水果沙拉', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1674, '蔬菜沙拉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1675, '鸡肉沙拉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1676, '金枪鱼沙拉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1677, '虾仁沙拉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1678, '意式沙拉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1679, '希腊沙拉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1680, '浓汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1681, '奶油蘑菇汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1682, '奶油南瓜汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1683, '罗宋汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1684, '洋葱汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1685, '寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1686, '三文鱼寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1687, '金枪鱼寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1688, '鳗鱼寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1689, '虾寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1690, '蟹棒寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1691, '军舰寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1692, '手握寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1693, '卷寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1694, '反卷寿司', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1695, '刺身', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1696, '三文鱼刺身', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1697, '金枪鱼刺身', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1698, '鲷鱼刺身', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1699, '甜虾刺身', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1700, '天妇罗', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1701, '虾天妇罗', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1702, '蔬菜天妇罗', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1703, '鳗鱼饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1704, '亲子丼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1705, '牛丼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1706, '猪排丼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1707, '天丼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1708, '铁火丼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1709, '海鲜丼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1710, '乌冬面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1711, '荞麦面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1712, '冷荞麦面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1713, '炒乌冬', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1714, '炒荞麦', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1715, '拉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1716, '酱油拉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1717, '盐味拉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1718, '泡菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1719, '辣白菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1720, '泡菜锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1721, '部队锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1722, '石锅拌饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1723, '海鲜锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1724, '韩式炸鸡', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1725, '炒年糕', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1726, '紫菜包饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1727, '大酱汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1728, '参鸡汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1729, '泰式咖喱', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1730, '绿咖喱', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1731, '红咖喱', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1732, '黄咖喱', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1733, 'Massaman咖喱', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1734, '冬阴功汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1735, '冬阴功火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1736, '泰式炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1737, '泰式炒面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1738, '芒果糯米饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1739, '菠萝饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1740, '椰汁饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1741, '泰式春卷', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1742, '越南春卷', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1743, '牛肉河粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1744, '鸡肉河粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1745, '海鲜河粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1746, '越南米线', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1747, '越南肉丸', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1748, '越南法棍', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1749, '印尼炒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1750, '印尼炒面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1751, '沙嗲', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1752, '巴东牛肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1753, '仁当牛肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1754, '咖喱叻沙', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1755, '肉骨茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1756, '海南鸡饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1757, '椰浆饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1758, '炒粿条', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1759, '炒萝卜糕', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1760, '马来糕', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1761, '千层糕', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1762, '北京烤鸭', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1763, '片皮鸭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1764, '烤鸭卷', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1765, '驴肉火烧', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1766, '门钉肉饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1767, '炒肝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1768, '卤煮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1769, '爆肚', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1770, '羊蝎子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1771, '涮羊肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1772, '天津麻花', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1773, '狗不理包子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1774, '煎饼馃子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1775, '锅巴菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1776, '嘎巴菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1777, '上海生煎', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1778, '蟹壳黄', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1779, '排骨年糕', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1780, '糯米鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1781, '四喜丸子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1782, '狮子头', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1783, '淮扬狮子头', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1784, '南京盐水鸭', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1785, '鸭血粉丝汤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1786, '锅盖面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1787, '蟹黄汤包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1788, '开洋干丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1789, '杭州东坡肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1790, '西湖醋鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1791, '宋嫂鱼羹', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1792, '叫花鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1793, '武汉热干面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1795, '面窝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1796, '糊汤粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1797, '鸭脖', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1798, '长沙臭豆腐', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1799, '口味虾', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1800, '糖油粑粑', 13, NULL, 1, '{
         "fat": 12.0,
         "iron": 1.5,
         "kcal": 320,
         "fiber": 1.2,
         "sodium": 180,
         "calcium": 60,
         "protein": 5.5,
         "magnesium": 25,
         "potassium": 120,
         "carbohydrate": 48.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1801, '米粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1802, '毛血旺', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1803, '成都冒菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1804, '夫妻肺片', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1805, '陕西肉夹馍', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1806, 'biangbiang面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1807, '广东肠粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1808, '虾饺', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1809, '烧卖', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1810, '凤爪', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1811, '叉烧', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1812, '烧鹅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1813, '烧鸭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1814, '煲仔饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1815, '云南过桥米线', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1816, '汽锅鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1817, '鲜花饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1818, '豆焖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1819, '饵块', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1820, '新疆大盘鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1821, '手抓饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1822, '拌面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1823, '烤包子', 13, NULL, 1, '{
         "fat": 8.0,
         "iron": 2.0,
         "kcal": 180,
         "fiber": 2.5,
         "sodium": 450,
         "calcium": 45,
         "protein": 6.0,
         "magnesium": 30,
         "potassium": 180,
         "carbohydrate": 22.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1824, '东北锅包肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1825, '小鸡炖蘑菇', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1826, '猪肉炖粉条', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1827, '酸菜炖白肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1828, '茄汁排骨饭', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1829, '腊味煲仔饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1830, '滑蛋虾仁饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1831, '香菇鸡饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1832, '咸鱼鸡粒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1833, '豉汁排骨饭', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1834, '梅菜蒸肉饼饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1835, '豆豉鱼饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1836, '咸蛋肉饼饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1837, '腊肠饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1838, '鱼香茄子饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1839, '干煸豆角饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1840, '孜然鸡腿饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1841, '照烧三文鱼饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1842, '照烧鸡排饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1843, '芝士鸡排饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1844, '黑椒鸡扒饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1845, '咖喱猪排饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1846, '炸猪排饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1847, '日式牛肉饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1848, '寿喜烧牛肉饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1849, '韩式泡菜猪肉饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1850, '韩式辣炒年糕饭', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1851, '韩式拌饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1852, '三文鱼盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1853, '鳗鱼盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1854, '咖喱虾仁盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1855, '咖喱菜花盖饭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1856, '牛肉板面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1857, '羊肉烩面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1858, '猪肉烩面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1859, '三鲜烩面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1860, '海鲜烩面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1861, '鸡丝凉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1862, '麻辣凉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1863, '麻酱凉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1864, '四川凉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1865, '朝鲜冷面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1866, '油泼面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1867, '削筋面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1868, '杂酱面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1869, '炒疙瘩', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1870, '焖面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1871, '烩面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1872, '拉条子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1873, '手擀面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1874, '挂面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1875, '龙须面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1876, '鸡蛋面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1877, '菠菜面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1878, '番茄面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1879, '鸡汤馄饨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1880, '鲜肉馄饨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1881, '三鲜馄饨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1882, '虾肉馄饨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1883, '荠菜馄饨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1884, '油泼扯面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1885, '肉夹馍套餐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1886, '羊肉泡馍套餐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1887, '葫芦头泡馍', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1888, '水盆羊肉', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1889, '蚂蚁上树', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1890, '鱼头泡饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1891, '熘肝尖', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1892, '熘腰花', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1893, '爆三样', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1894, '溜肉段', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1895, '酱爆鸡丁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1896, '酱香茄子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1897, '虎皮青椒', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1898, '炒合菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1899, '九转大肠', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1900, '清蒸武昌鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1901, '珍珠丸子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1902, '芙蓉蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1903, '木樨肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1904, '清炒虾仁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1905, '油焖茄子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1906, '烧二冬', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1907, '熏鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1908, '咕咾肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1909, '荔枝肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1910, '佛跳墙', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1911, '盐水鸭', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1912, '白斩鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1913, '棒棒鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1914, '怪味鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1915, '椒麻鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1916, '葱油鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1917, '醉鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1918, '八宝鸭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1919, '香酥鸭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1920, '樟茶鸭', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1921, '金陵盐水鸭', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1922, '周黑鸭', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1923, '清蒸大闸蟹', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1924, '香辣蟹', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1925, '避风塘炒蟹', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1926, '姜葱炒蟹', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1927, '咖喱蟹', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1928, '椒盐皮皮虾', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1929, '蒜蓉粉丝蒸虾', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1930, '清蒸多宝鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1931, '清蒸石斑鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1932, '糖醋黄鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1933, '红烧带鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1934, '红烧鲳鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1935, '豆瓣鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1936, '干烧鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1937, '葱烧海参', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1938, '红烧海参', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1939, '蒜蓉扇贝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1940, '粉丝扇贝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1941, '芝士焗扇贝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1942, '避风塘扇贝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1943, '炒花蛤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1944, '辣炒花蛤', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1945, '姜葱炒花甲', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1946, '蒜蓉粉丝蒸蛏子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1947, '炒蛏子', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1949, '花胶鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1950, '虫草花炖鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1951, '当归炖鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1952, '党参炖鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1953, '黄芪炖鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1954, '枸杞炖鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1955, '天麻炖鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1956, '人参炖鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1957, '灵芝炖鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1958, '玉米炖排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1959, '山药炖排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1960, '莲藕炖排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1961, '海带炖排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1962, '冬瓜炖排骨', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1963, '萝卜炖羊肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1964, '当归炖羊肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1965, '清炖羊肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1966, '红烧羊肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1967, '番茄土豆牛腩', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1968, '萝卜炖牛腩', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1969, '清炖牛腩', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1970, '红烧牛腩', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1971, '咖喱牛腩', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1972, '鸡块套餐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1973, '鸡翅套餐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1974, '炸鸡套餐', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1975, '全家桶', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1976, '嫩牛五方', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1977, '香辣鸡腿堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1978, '田园脆鸡堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1979, '新奥尔良烤翅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1980, '黄金鸡块', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1981, '上校鸡块', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1982, '薯格', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1983, '香芋派', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1984, '菠萝派', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1985, '苹果派', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1986, '草莓派', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1987, '蓝莓派', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1988, '双层芝士汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1989, '培根芝士汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1990, '蘑菇芝士汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1991, '鸡蛋芝士汉堡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1992, '煎包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1993, '水煎包', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1994, '南瓜饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1995, '香蕉饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1996, '土豆饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1997, '玉米饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1998, '鸡蛋饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (1999, '葱花饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2000, '千层饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2001, '烙饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2002, '发面饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2003, '死面饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2004, '烫面饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2005, '油酥饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2006, '牛肉火烧', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2007, '猪肉火烧', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2008, '羊肉火烧', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2009, '春饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2010, '荷叶饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2011, '单饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2012, '酱香饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2013, '台湾手抓饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2014, '杂粮煎饼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2015, '锅盔', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2016, '米皮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2017, '擀面皮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2018, '热米皮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2019, '汉中热面皮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2020, '宝鸡擀面皮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2021, '秦镇米皮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2022, '岐山擀面皮', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2023, '虾粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2024, '蟹粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2025, '鲍鱼粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2026, '猪肝粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2027, '牛肉粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2028, '排骨粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2029, '蔬菜粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2030, '青菜粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2031, '红薯粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2032, '芋头粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2033, '百合粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2034, '腊八粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2035, '糯米粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2036, '江米粥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2037, '酸辣土豆丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2038, '凉拌土豆丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2039, '炝炒土豆丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2040, '青椒土豆丝', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2041, '孜然土豆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2042, '狼牙土豆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2043, '土豆泥', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2044, '白灼西兰花', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2045, '干煸西兰花', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2046, '西兰花炒虾仁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2047, '西兰花炒肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2048, '干煸四季豆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2049, '蒜蓉四季豆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2050, '橄榄菜四季豆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2051, '肉末四季豆', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2052, '豆角焖面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2053, '清炒芦笋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2054, '培根芦笋卷', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2055, '芦笋炒虾仁', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2056, '芦笋炒肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2057, '白灼芦笋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2058, '木耳炒肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2059, '木耳炒鸡蛋', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2060, '醋溜木耳', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2061, '凉拌黑木耳', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2062, '水蜜桃茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2063, '芝芝莓莓', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2064, '多肉葡萄', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2065, '芋泥啵啵奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2066, '黑糖珍珠奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2067, '红豆奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2068, '布丁奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2069, '仙草奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2070, '四季春茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2071, '茉香奶绿', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2072, '红豆抹茶拿铁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2073, '芋圆烧仙草', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2074, '豆乳奶茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2075, '芝士奶盖茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2076, '草莓奶昔', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2077, '芒果奶昔', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2078, '香蕉奶昔', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2079, '蓝莓奶昔', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2080, '奥利奥奶昔', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2081, '巧克力奶昔', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2082, '抹茶奶昔', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2083, '咖啡奶昔', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2084, '哈密瓜汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2085, '百香果汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2086, '猕猴桃汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2087, '雪梨汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2088, '苦瓜汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2089, '芹菜汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2090, '混合果蔬汁', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2091, '黑芝麻豆浆', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2092, '核桃豆浆', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2093, '花生豆浆', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2094, '黑芝麻糊', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2095, '核桃糊', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2096, '杏仁糊', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2097, '木瓜银耳糖水', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2098, '桃胶银耳羹', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2099, '雪梨银耳羹', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2100, '莲子银耳羹', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2101, '红枣银耳羹', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2102, '芒果西米露', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2103, '紫米露', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2104, '椰汁西米露', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2105, '米凉粉', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2106, '豌豆凉粉', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2107, '绿豆凉粉', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2108, '红薯凉粉', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2109, '冰粉', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2110, '红糖冰粉', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2111, '水果冰粉', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2112, '醪糟', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2113, '酒酿', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2114, '桂花糕', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2115, '绿豆糕', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2116, '红豆糕', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2117, '马蹄糕', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2118, '钵仔糕', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2119, '伦教糕', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2120, '松糕', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2121, '米发糕', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2122, '四川毛血旺', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2123, '重庆烤鱼', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2124, '成都串串', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2125, '乐山钵钵鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2126, '宜宾燃面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2127, '内江牛肉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2128, '自贡冷吃兔', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2129, '达州灯影牛肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2130, '广元女皇蒸凉面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2131, '泸州白糕', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2132, '陕西油泼面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2133, '陕西臊子面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2134, '户县软面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2135, '礼泉烙面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2136, '岐山臊子面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2137, '武功旗花面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2138, '扯面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2139, '裤带面', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2141, '湖南剁椒鱼头', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2142, '毛氏红烧肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2143, '湖南小炒肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2144, '浏阳蒸菜', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2145, '衡阳鱼粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2146, '常德米粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2147, '郴州鱼粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2148, '邵阳米粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2149, '怀化米粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2150, '湘西酸肉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2151, '广东早茶', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2152, '广式肠粉', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2153, '干蒸烧卖', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2154, '云南汽锅鸡', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2155, '野生菌火锅', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2156, '破酥包', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2157, '宣威火腿', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2158, '鸡豆凉粉', 13, NULL, 1, '{
         "fat": 2.0,
         "iron": 0.8,
         "kcal": 180,
         "fiber": 1.5,
         "sodium": 25,
         "calcium": 35,
         "protein": 3.0,
         "magnesium": 18,
         "potassium": 95,
         "carbohydrate": 38.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2159, '丽江粑粑', 14, NULL, 1, '{
         "fat": 22.0,
         "iron": 4.5,
         "kcal": 650,
         "fiber": 4.5,
         "sodium": 1200,
         "calcium": 120,
         "protein": 28.0,
         "magnesium": 85,
         "potassium": 520,
         "carbohydrate": 85.0
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL),
       (2160, '建水烧豆腐', 15, NULL, 1, '{
         "fat": 0.2,
         "iron": 0.2,
         "kcal": 45,
         "fiber": 0.1,
         "sodium": 15,
         "calcium": 25,
         "protein": 0.5,
         "magnesium": 8,
         "potassium": 80,
         "carbohydrate": 10.5
       }', '2026-02-03 21:33:44', '2026-02-03 21:33:44', NULL);
-- eat_clear.units DML
INSERT INTO `eat_clear`.`units` (`id`, `name`, `type`, `desc`, `created_at`, `updated_at`, `delete_at`)
VALUES (1, 'g', 'weight', '克', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (2, 'kg', 'weight', '千克', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (3, '个', 'count', '个', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (4, '片', 'count', '片', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (5, '碗', 'count', '中碗', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (6, '杯', 'volume', '杯', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (7, 'ml', 'volume', '毫升', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL),
       (8, '份', 'service', '一份', '2026-02-03 21:33:43', '2026-02-03 21:33:43', NULL);
-- eat_clear.wa_admin_roles DML
INSERT INTO `eat_clear`.`wa_admin_roles` (`id`, `role_id`, `admin_id`)
VALUES (1, 1, 1);
-- eat_clear.wa_admins DML
INSERT INTO `eat_clear`.`wa_admins` (`id`, `username`, `nickname`, `password`, `avatar`, `email`, `mobile`,
                                     `created_at`, `updated_at`, `login_at`, `status`)
VALUES (1, 'root', '超级管理员', '$2y$10$XY8TsUeBsoT2NTRv5xfHJ.mlGd7haTZl5hd8U5Mo0NtyhQSyXk6Gq',
        '/app/admin/avatar.png', NULL, NULL, '2026-01-29 18:10:38', '2026-01-30 22:27:05', '2026-01-30 22:27:05', NULL);
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
        '2026-01-30 14:18:53', '2026-01-30 14:18:53'),
       (18, 'table_form_schema_food_units',
        '{"id":{"field":"id","_field_id":"0","comment":"ID","control":"inputNumber","control_args":"","list_show":true,"enable_sort":true,"searchable":true,"search_type":"normal","form_show":false},"food_id":{"field":"food_id","_field_id":"1","comment":"食物","control":"select","control_args":"url:\\/app\\/admin\\/food\\/select?format=select","form_show":true,"list_show":true,"enable_sort":true,"searchable":true,"search_type":"normal"},"unit_id":{"field":"unit_id","_field_id":"2","comment":"所属单位","control":"select","control_args":"url:\\/app\\/admin\\/unit\\/select?format=select","form_show":true,"list_show":true,"enable_sort":true,"searchable":true,"search_type":"normal"},"weight":{"field":"weight","_field_id":"3","comment":"换算重量 (1单位 ≈ ? g)","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"is_default":{"field":"is_default","_field_id":"4","comment":"是否为默认","control":"switch","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"remark":{"field":"remark","_field_id":"5","comment":"备注","control":"textArea","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2026-01-30 22:46:02');
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
       (114, '食品库', '', 'plugin\\admin\\app\\controller\\FoodController', 119, '2026-01-30 13:21:23',
        '2026-01-30 22:36:21', '/app/admin/food/index', 1, 0),
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
        '2026-01-30 13:26:33', NULL, 2, 0),
       (130, '单位食品列表', '', 'plugin\\admin\\app\\controller\\FoodUnitController', 119, '2026-01-30 22:44:49',
        '2026-01-30 22:46:27', '/app/admin/food-unit/index', 1, 0),
       (131, '插入', NULL, 'plugin\\admin\\app\\controller\\FoodUnitController@insert', 130, '2026-01-30 22:44:56',
        '2026-01-30 22:44:56', NULL, 2, 0),
       (132, '更新', NULL, 'plugin\\admin\\app\\controller\\FoodUnitController@update', 130, '2026-01-30 22:44:56',
        '2026-01-30 22:44:56', NULL, 2, 0),
       (133, '查询', NULL, 'plugin\\admin\\app\\controller\\FoodUnitController@select', 130, '2026-01-30 22:44:56',
        '2026-01-30 22:44:56', NULL, 2, 0),
       (134, '删除', NULL, 'plugin\\admin\\app\\controller\\FoodUnitController@delete', 130, '2026-01-30 22:44:56',
        '2026-01-30 22:44:56', NULL, 2, 0);
-- 标签表
CREATE TABLE IF NOT EXISTS `eat_clear`.`tags`
(
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name`       VARCHAR(50)  NOT NULL COMMENT '标签名称',
    `type`       TINYINT      NOT NULL DEFAULT 1 COMMENT '类型: 1-餐次(早餐/午餐等), 2-口味, 3-营养特点(低糖/少油)',
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE INDEX `uk_name` (`name`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT ='标签表';

-- 食物标签关联表
CREATE TABLE IF NOT EXISTS `eat_clear`.`food_tags`
(
    `id`      INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `food_id` INT UNSIGNED NOT NULL COMMENT '食物ID',
    `tag_id`  INT UNSIGNED NOT NULL COMMENT '标签ID',
    UNIQUE INDEX `uk_food_tag` (`food_id`, `tag_id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT ='食物标签关联表';
TRUNCATE TABLE `tags`;
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (1, '早餐', 1);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (2, '午餐', 1);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (3, '晚餐', 1);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (4, '加餐', 1);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (5, '低糖', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (6, '少油', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (7, '高蛋白', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (8, '健康脂肪', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (9, '夜宵', 1);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (10, '下午茶', 1);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (11, '早午餐', 1);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (12, '麻辣', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (13, '香辣', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (14, '微辣', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (15, '不辣', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (16, '咸鲜', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (17, '酸甜', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (18, '糖醋', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (19, '酱香', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (20, '清淡', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (21, '浓郁', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (22, '鲜香', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (23, '甜味', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (24, '咸香', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (25, '酸辣', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (26, '孜然', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (27, '蒜香', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (28, '葱香', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (29, '椒盐', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (30, '咖喱', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (31, '红烧', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (32, '清蒸', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (33, '烧烤', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (34, '原味', 2);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (35, '低脂', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (36, '低卡', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (37, '高纤维', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (38, '低钠', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (39, '无糖', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (40, '高钙', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (41, '补铁', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (42, '富含维生素', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (43, '健康', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (44, '低碳水', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (45, '减脂', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (46, '增肌', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (47, '素食', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (48, '无麸质', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (49, '天然', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (50, '粗粮', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (51, '全麦', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (52, '养生', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (53, '滋补', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (54, '清火', 3);
INSERT INTO `tags` (`id`, `name`, `type`)
VALUES (55, '暖胃', 3);
TRUNCATE TABLE `food_tags`;
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1, 1, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2, 1, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3, 2, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4, 2, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (5, 3, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (6, 3, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (7, 3, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (8, 4, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (9, 4, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (10, 4, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (11, 5, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (12, 5, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (13, 5, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (14, 6, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (15, 6, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (16, 6, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (17, 7, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (18, 7, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (19, 7, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (20, 8, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (21, 8, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (22, 8, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (23, 9, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (24, 9, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (25, 10, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (26, 10, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (27, 11, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (28, 12, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (29, 13, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (30, 13, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (31, 13, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (32, 13, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (33, 14, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (34, 14, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (35, 15, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (36, 16, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (37, 16, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (38, 16, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (39, 16, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (40, 16, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (41, 17, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (42, 17, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (43, 17, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (44, 17, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (45, 17, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (46, 17, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (47, 18, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (48, 18, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (49, 18, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (50, 18, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (51, 19, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (52, 19, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (53, 19, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (54, 19, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (55, 20, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (56, 20, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (57, 20, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (58, 20, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (59, 21, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (60, 21, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (61, 21, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (62, 21, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (63, 21, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (64, 22, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (65, 22, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (66, 22, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (67, 22, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (68, 23, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (69, 23, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (70, 23, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (71, 23, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (72, 24, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (73, 24, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (74, 24, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (75, 24, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (76, 25, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (77, 25, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (78, 25, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (79, 25, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (80, 26, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (81, 26, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (82, 26, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (83, 26, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (84, 26, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (85, 26, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (86, 27, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (87, 27, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (88, 27, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (89, 27, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (90, 28, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (91, 28, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (92, 28, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (93, 28, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (94, 29, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (95, 29, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (96, 29, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (97, 29, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (98, 30, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (99, 30, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (100, 30, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (101, 30, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (102, 31, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (103, 31, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (104, 32, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (105, 32, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (106, 32, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (107, 33, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (108, 33, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (109, 33, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (110, 34, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (111, 34, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (112, 34, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (113, 35, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (114, 35, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (115, 36, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (116, 36, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (117, 37, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (118, 37, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (119, 37, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (120, 38, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (121, 38, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (122, 38, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (123, 39, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (124, 39, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (125, 39, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (126, 40, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (127, 40, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (128, 40, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (129, 41, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (130, 41, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (131, 41, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (132, 42, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (133, 42, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (134, 42, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (135, 43, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (136, 43, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (137, 43, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (138, 44, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (139, 44, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (140, 44, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (141, 45, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (142, 45, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (143, 45, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (144, 46, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (145, 46, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (146, 46, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (147, 47, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (148, 48, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (149, 49, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (150, 50, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (151, 51, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (152, 52, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (153, 52, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (154, 53, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (155, 53, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (156, 53, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (157, 54, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (158, 54, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (159, 54, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (160, 55, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (161, 55, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (162, 56, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (163, 56, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (164, 57, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (165, 57, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (166, 58, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (167, 58, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (168, 59, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (169, 59, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (170, 60, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (171, 60, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (172, 61, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (173, 61, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (174, 62, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (175, 62, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (176, 63, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (177, 63, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (178, 63, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (179, 63, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (180, 64, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (181, 67, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (182, 67, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (183, 68, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (184, 69, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (185, 70, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (186, 71, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (187, 71, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (188, 72, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (189, 72, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (190, 72, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (191, 73, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (192, 73, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (193, 73, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (194, 74, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (195, 74, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (196, 74, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (197, 75, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (198, 75, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (199, 75, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (200, 75, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (201, 76, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (202, 76, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (203, 77, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (204, 77, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (205, 78, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (206, 78, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (207, 79, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (208, 79, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (209, 80, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (210, 80, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (211, 80, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (212, 81, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (213, 81, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (214, 81, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (215, 82, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (216, 82, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (217, 82, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (218, 82, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (219, 83, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (220, 83, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (221, 90, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (222, 90, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (223, 93, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (224, 95, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (225, 96, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (226, 100, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (227, 102, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (228, 102, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (229, 103, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (230, 103, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (231, 104, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (232, 104, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (233, 104, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (234, 105, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (235, 105, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (236, 105, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (237, 106, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (238, 106, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (239, 106, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (240, 107, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (241, 107, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (242, 107, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (243, 108, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (244, 108, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (245, 108, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (246, 109, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (247, 109, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (248, 109, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (249, 110, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (250, 110, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (251, 111, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (252, 111, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (253, 112, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (254, 113, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (255, 114, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (256, 114, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (257, 114, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (258, 114, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (259, 115, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (260, 115, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (261, 116, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (262, 117, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (263, 117, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (264, 117, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (265, 117, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (266, 117, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (267, 118, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (268, 118, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (269, 118, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (270, 118, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (271, 118, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (272, 118, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (273, 119, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (274, 119, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (275, 119, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (276, 119, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (277, 120, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (278, 120, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (279, 120, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (280, 120, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (281, 121, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (282, 121, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (283, 121, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (284, 121, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (285, 122, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (286, 122, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (287, 122, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (288, 122, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (289, 122, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (290, 123, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (291, 123, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (292, 123, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (293, 123, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (294, 124, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (295, 124, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (296, 124, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (297, 124, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (298, 125, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (299, 125, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (300, 125, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (301, 125, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (302, 126, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (303, 126, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (304, 126, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (305, 126, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (306, 127, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (307, 127, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (308, 127, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (309, 127, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (310, 127, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (311, 127, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (312, 128, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (313, 128, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (314, 128, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (315, 128, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (316, 129, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (317, 129, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (318, 129, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (319, 129, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (320, 130, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (321, 130, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (322, 130, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (323, 130, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (324, 131, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (325, 131, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (326, 131, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (327, 131, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (328, 132, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (329, 132, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (330, 133, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (331, 133, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (332, 133, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (333, 134, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (334, 134, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (335, 134, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (336, 135, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (337, 135, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (338, 135, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (339, 136, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (340, 136, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (341, 137, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (342, 137, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (343, 138, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (344, 138, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (345, 138, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (346, 139, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (347, 139, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (348, 139, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (349, 140, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (350, 140, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (351, 140, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (352, 141, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (353, 141, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (354, 141, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (355, 142, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (356, 142, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (357, 142, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (358, 143, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (359, 143, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (360, 143, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (361, 144, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (362, 144, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (363, 144, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (364, 145, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (365, 145, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (366, 145, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (367, 146, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (368, 146, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (369, 146, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (370, 147, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (371, 147, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (372, 147, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (373, 148, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (374, 149, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (375, 150, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (376, 151, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (377, 152, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (378, 153, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (379, 153, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (380, 154, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (381, 154, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (382, 154, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (383, 155, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (384, 155, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (385, 155, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (386, 156, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (387, 156, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (388, 157, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (389, 157, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (390, 158, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (391, 158, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (392, 159, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (393, 159, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (394, 160, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (395, 160, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (396, 161, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (397, 161, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (398, 162, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (399, 162, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (400, 163, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (401, 163, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (402, 164, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (403, 164, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (404, 164, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (405, 164, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (406, 165, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (407, 168, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (408, 168, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (409, 169, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (410, 170, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (411, 171, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (412, 172, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (413, 172, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (414, 173, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (415, 173, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (416, 173, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (417, 174, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (418, 174, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (419, 174, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (420, 175, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (421, 175, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (422, 175, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (423, 176, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (424, 176, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (425, 176, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (426, 176, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (427, 177, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (428, 177, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (429, 178, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (430, 178, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (431, 179, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (432, 179, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (433, 180, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (434, 180, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (435, 181, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (436, 181, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (437, 181, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (438, 182, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (439, 182, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (440, 182, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (441, 183, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (442, 183, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (443, 183, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (444, 183, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (445, 184, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (446, 184, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (447, 191, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (448, 191, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (449, 194, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (450, 196, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (451, 197, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (452, 201, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (453, 203, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (454, 203, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (455, 204, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (456, 204, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (457, 205, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (458, 205, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (459, 205, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (460, 206, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (461, 206, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (462, 206, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (463, 207, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (464, 207, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (465, 207, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (466, 208, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (467, 208, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (468, 208, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (469, 209, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (470, 209, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (471, 209, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (472, 210, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (473, 210, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (474, 210, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (475, 211, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (476, 211, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (477, 212, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (478, 212, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (479, 213, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (480, 214, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (481, 215, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (482, 215, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (483, 215, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (484, 215, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (485, 216, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (486, 216, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (487, 217, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (488, 218, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (489, 218, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (490, 218, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (491, 218, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (492, 218, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (493, 219, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (494, 219, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (495, 219, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (496, 219, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (497, 219, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (498, 219, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (499, 220, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (500, 220, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (501, 220, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (502, 220, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (503, 221, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (504, 221, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (505, 221, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (506, 221, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (507, 222, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (508, 222, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (509, 222, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (510, 222, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (511, 223, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (512, 223, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (513, 223, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (514, 223, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (515, 223, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (516, 224, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (517, 224, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (518, 224, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (519, 224, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (520, 225, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (521, 225, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (522, 225, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (523, 225, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (524, 226, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (525, 226, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (526, 226, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (527, 226, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (528, 227, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (529, 227, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (530, 227, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (531, 227, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (532, 228, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (533, 228, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (534, 228, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (535, 228, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (536, 228, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (537, 228, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (538, 229, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (539, 229, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (540, 229, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (541, 229, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (542, 230, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (543, 230, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (544, 230, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (545, 230, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (546, 231, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (547, 231, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (548, 231, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (549, 231, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (550, 232, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (551, 232, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (552, 232, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (553, 232, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (554, 233, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (555, 233, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (556, 234, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (557, 234, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (558, 234, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (559, 235, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (560, 235, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (561, 235, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (562, 236, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (563, 236, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (564, 236, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (565, 237, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (566, 237, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (567, 238, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (568, 238, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (569, 239, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (570, 239, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (571, 239, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (572, 240, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (573, 240, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (574, 240, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (575, 241, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (576, 241, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (577, 241, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (578, 242, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (579, 242, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (580, 242, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (581, 243, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (582, 243, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (583, 243, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (584, 244, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (585, 244, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (586, 244, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (587, 245, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (588, 245, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (589, 245, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (590, 246, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (591, 246, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (592, 246, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (593, 247, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (594, 247, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (595, 247, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (596, 248, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (597, 248, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (598, 248, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (599, 249, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (600, 250, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (601, 251, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (602, 252, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (603, 253, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (604, 254, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (605, 254, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (606, 255, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (607, 255, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (608, 255, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (609, 256, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (610, 256, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (611, 256, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (612, 257, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (613, 257, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (614, 258, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (615, 258, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (616, 259, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (617, 259, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (618, 260, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (619, 260, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (620, 261, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (621, 261, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (622, 262, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (623, 262, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (624, 263, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (625, 263, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (626, 264, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (627, 264, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (628, 265, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (629, 265, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (630, 265, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (631, 265, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (632, 266, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (633, 269, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (634, 269, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (635, 270, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (636, 271, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (637, 272, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (638, 273, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (639, 273, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (640, 274, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (641, 274, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (642, 274, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (643, 275, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (644, 275, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (645, 275, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (646, 276, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (647, 276, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (648, 276, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (649, 277, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (650, 277, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (651, 277, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (652, 277, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (653, 278, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (654, 278, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (655, 279, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (656, 279, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (657, 280, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (658, 280, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (659, 281, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (660, 281, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (661, 282, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (662, 282, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (663, 282, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (664, 283, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (665, 283, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (666, 283, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (667, 284, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (668, 284, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (669, 284, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (670, 284, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (671, 285, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (672, 285, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (673, 292, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (674, 292, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (675, 295, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (676, 297, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (677, 298, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (678, 302, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (679, 304, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (680, 304, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (681, 305, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (682, 305, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (683, 306, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (684, 306, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (685, 306, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (686, 307, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (687, 307, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (688, 307, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (689, 308, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (690, 308, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (691, 308, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (692, 309, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (693, 309, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (694, 309, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (695, 310, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (696, 310, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (697, 310, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (698, 311, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (699, 311, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (700, 311, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (701, 312, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (702, 312, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (703, 313, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (704, 313, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (705, 314, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (706, 315, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (707, 316, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (708, 316, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (709, 316, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (710, 316, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (711, 317, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (712, 317, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (713, 318, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (714, 319, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (715, 319, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (716, 319, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (717, 319, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (718, 319, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (719, 320, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (720, 320, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (721, 320, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (722, 320, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (723, 320, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (724, 320, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (725, 321, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (726, 321, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (727, 321, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (728, 321, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (729, 322, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (730, 322, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (731, 322, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (732, 322, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (733, 323, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (734, 323, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (735, 323, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (736, 323, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (737, 324, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (738, 324, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (739, 324, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (740, 324, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (741, 324, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (742, 325, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (743, 325, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (744, 325, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (745, 325, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (746, 326, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (747, 326, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (748, 326, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (749, 326, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (750, 327, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (751, 327, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (752, 327, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (753, 327, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (754, 328, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (755, 328, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (756, 328, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (757, 328, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (758, 329, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (759, 329, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (760, 329, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (761, 329, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (762, 329, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (763, 329, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (764, 330, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (765, 330, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (766, 330, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (767, 330, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (768, 331, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (769, 331, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (770, 331, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (771, 331, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (772, 332, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (773, 332, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (774, 332, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (775, 332, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (776, 333, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (777, 333, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (778, 333, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (779, 333, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (780, 334, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (781, 334, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (782, 335, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (783, 335, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (784, 335, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (785, 336, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (786, 336, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (787, 336, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (788, 337, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (789, 337, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (790, 337, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (791, 338, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (792, 338, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (793, 339, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (794, 339, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (795, 340, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (796, 340, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (797, 340, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (798, 341, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (799, 341, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (800, 341, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (801, 342, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (802, 342, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (803, 342, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (804, 343, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (805, 343, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (806, 343, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (807, 344, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (808, 344, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (809, 344, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (810, 345, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (811, 345, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (812, 345, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (813, 346, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (814, 346, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (815, 346, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (816, 347, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (817, 347, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (818, 347, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (819, 348, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (820, 348, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (821, 348, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (822, 349, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (823, 349, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (824, 349, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (825, 350, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (826, 351, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (827, 352, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (828, 353, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (829, 354, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (830, 355, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (831, 355, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (832, 356, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (833, 356, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (834, 356, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (835, 357, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (836, 357, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (837, 357, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (838, 358, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (839, 358, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (840, 359, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (841, 359, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (842, 360, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (843, 360, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (844, 361, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (845, 361, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (846, 362, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (847, 362, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (848, 363, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (849, 363, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (850, 364, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (851, 364, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (852, 365, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (853, 365, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (854, 366, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (855, 366, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (856, 366, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (857, 366, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (858, 367, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (859, 370, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (860, 370, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (861, 371, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (862, 372, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (863, 373, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (864, 374, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (865, 374, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (866, 375, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (867, 375, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (868, 375, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (869, 376, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (870, 376, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (871, 376, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (872, 377, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (873, 377, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (874, 377, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (875, 378, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (876, 378, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (877, 378, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (878, 378, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (879, 379, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (880, 379, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (881, 380, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (882, 380, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (883, 381, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (884, 381, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (885, 382, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (886, 382, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (887, 383, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (888, 383, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (889, 383, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (890, 384, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (891, 384, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (892, 384, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (893, 385, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (894, 385, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (895, 385, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (896, 385, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (897, 386, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (898, 386, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (899, 393, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (900, 393, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (901, 396, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (902, 398, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (903, 399, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (904, 403, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (905, 405, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (906, 405, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (907, 406, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (908, 406, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (909, 407, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (910, 407, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (911, 407, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (912, 408, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (913, 408, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (914, 408, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (915, 409, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (916, 409, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (917, 409, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (918, 410, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (919, 410, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (920, 410, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (921, 411, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (922, 411, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (923, 411, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (924, 412, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (925, 412, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (926, 412, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (927, 413, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (928, 413, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (929, 414, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (930, 414, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (931, 415, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (932, 416, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (933, 417, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (934, 417, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (935, 417, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (936, 417, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (937, 418, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (938, 418, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (939, 419, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (940, 420, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (941, 420, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (942, 420, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (943, 420, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (944, 420, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (945, 421, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (946, 421, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (947, 421, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (948, 421, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (949, 421, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (950, 421, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (951, 422, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (952, 422, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (953, 422, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (954, 422, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (955, 423, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (956, 423, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (957, 423, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (958, 423, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (959, 424, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (960, 424, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (961, 424, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (962, 424, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (963, 425, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (964, 425, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (965, 425, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (966, 425, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (967, 425, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (968, 426, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (969, 426, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (970, 426, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (971, 426, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (972, 427, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (973, 427, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (974, 427, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (975, 427, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (976, 428, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (977, 428, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (978, 428, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (979, 428, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (980, 429, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (981, 429, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (982, 429, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (983, 429, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (984, 430, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (985, 430, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (986, 430, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (987, 430, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (988, 430, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (989, 430, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (990, 431, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (991, 431, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (992, 431, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (993, 431, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (994, 432, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (995, 432, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (996, 432, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (997, 432, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (998, 433, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (999, 433, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1000, 433, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1001, 433, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1002, 434, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1003, 434, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1004, 434, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1005, 434, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1006, 435, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1007, 435, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1008, 436, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1009, 436, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1010, 436, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1011, 437, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1012, 437, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1013, 437, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1014, 438, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1015, 438, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1016, 438, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1017, 439, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1018, 439, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1019, 440, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1020, 440, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1021, 441, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1022, 441, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1023, 441, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1024, 442, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1025, 442, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1026, 442, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1027, 443, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1028, 443, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1029, 443, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1030, 444, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1031, 444, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1032, 444, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1033, 445, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1034, 445, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1035, 445, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1036, 446, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1037, 446, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1038, 446, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1039, 447, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1040, 447, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1041, 447, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1042, 448, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1043, 448, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1044, 448, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1045, 449, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1046, 449, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1047, 449, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1048, 450, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1049, 450, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1050, 450, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1051, 451, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1052, 452, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1053, 453, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1054, 454, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1055, 455, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1056, 456, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1057, 456, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1058, 457, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1059, 457, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1060, 457, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1061, 458, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1062, 458, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1063, 458, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1064, 459, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1065, 459, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1066, 460, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1067, 460, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1068, 461, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1069, 461, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1070, 462, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1071, 462, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1072, 463, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1073, 463, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1074, 464, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1075, 464, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1076, 465, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1077, 465, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1078, 466, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1079, 466, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1080, 467, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1081, 467, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1082, 467, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1083, 467, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1084, 468, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1085, 471, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1086, 471, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1087, 472, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1088, 473, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1089, 474, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1090, 475, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1091, 475, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1092, 476, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1093, 476, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1094, 476, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1095, 477, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1096, 477, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1097, 477, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1098, 478, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1099, 478, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1100, 478, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1101, 479, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1102, 479, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1103, 479, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1104, 479, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1105, 480, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1106, 480, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1107, 481, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1108, 481, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1109, 482, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1110, 482, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1111, 483, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1112, 483, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1113, 484, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1114, 484, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1115, 484, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1116, 485, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1117, 485, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1118, 485, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1119, 486, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1120, 486, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1121, 486, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1122, 486, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1123, 487, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1124, 487, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1125, 494, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1126, 494, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1127, 497, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1128, 499, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1129, 500, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1130, 504, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1131, 506, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1132, 506, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1133, 507, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1134, 507, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1135, 508, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1136, 508, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1137, 508, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1138, 509, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1139, 509, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1140, 509, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1141, 510, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1142, 510, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1143, 510, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1144, 511, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1145, 511, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1146, 511, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1147, 512, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1148, 512, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1149, 512, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1150, 513, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1151, 513, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1152, 513, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1153, 514, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1154, 514, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1155, 515, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1156, 515, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1157, 516, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1158, 517, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1159, 518, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1160, 518, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1161, 518, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1162, 518, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1163, 519, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1164, 519, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1165, 520, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1166, 521, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1167, 521, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1168, 521, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1169, 521, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1170, 521, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1171, 522, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1172, 522, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1173, 522, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1174, 522, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1175, 522, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1176, 522, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1177, 523, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1178, 523, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1179, 523, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1180, 523, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1181, 524, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1182, 524, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1183, 524, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1184, 524, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1185, 525, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1186, 525, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1187, 525, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1188, 525, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1189, 526, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1190, 526, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1191, 526, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1192, 526, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1193, 526, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1194, 527, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1195, 527, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1196, 527, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1197, 527, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1198, 528, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1199, 528, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1200, 528, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1201, 528, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1202, 529, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1203, 529, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1204, 529, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1205, 529, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1206, 530, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1207, 530, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1208, 530, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1209, 530, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1210, 531, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1211, 531, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1212, 531, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1213, 531, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1214, 531, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1215, 531, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1216, 532, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1217, 532, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1218, 532, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1219, 532, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1220, 533, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1221, 533, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1222, 533, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1223, 533, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1224, 534, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1225, 534, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1226, 534, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1227, 534, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1228, 535, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1229, 535, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1230, 535, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1231, 535, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1232, 536, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1233, 536, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1234, 537, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1235, 537, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1236, 537, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1237, 538, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1238, 538, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1239, 538, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1240, 539, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1241, 539, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1242, 539, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1243, 540, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1244, 540, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1245, 541, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1246, 541, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1247, 542, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1248, 542, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1249, 542, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1250, 543, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1251, 543, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1252, 543, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1253, 544, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1254, 544, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1255, 544, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1256, 545, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1257, 545, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1258, 545, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1259, 546, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1260, 546, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1261, 546, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1262, 547, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1263, 547, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1264, 547, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1265, 548, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1266, 548, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1267, 548, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1268, 549, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1269, 549, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1270, 549, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1271, 550, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1272, 550, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1273, 550, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1274, 551, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1275, 551, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1276, 551, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1277, 552, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1278, 553, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1279, 554, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1280, 555, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1281, 556, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1282, 557, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1283, 557, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1284, 558, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1285, 558, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1286, 558, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1287, 559, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1288, 559, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1289, 559, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1290, 560, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1291, 560, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1292, 561, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1293, 561, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1294, 562, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1295, 562, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1296, 563, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1297, 563, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1298, 564, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1299, 564, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1300, 565, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1301, 565, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1302, 566, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1303, 566, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1304, 567, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1305, 567, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1306, 568, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1307, 568, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1308, 568, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1309, 568, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1310, 569, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1311, 572, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1312, 572, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1313, 573, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1314, 574, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1315, 575, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1316, 576, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1317, 576, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1318, 577, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1319, 577, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1320, 577, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1321, 578, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1322, 578, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1323, 578, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1324, 579, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1325, 579, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1326, 579, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1327, 580, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1328, 580, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1329, 580, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1330, 580, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1331, 581, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1332, 581, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1333, 582, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1334, 582, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1335, 583, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1336, 583, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1337, 584, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1338, 584, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1339, 585, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1340, 585, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1341, 585, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1342, 586, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1343, 586, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1344, 586, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1345, 587, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1346, 587, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1347, 587, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1348, 587, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1349, 588, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1350, 588, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1351, 595, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1352, 595, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1353, 598, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1354, 600, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1355, 601, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1356, 605, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1357, 607, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1358, 607, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1359, 608, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1360, 608, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1361, 609, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1362, 609, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1363, 609, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1364, 610, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1365, 610, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1366, 610, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1367, 611, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1368, 611, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1369, 611, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1370, 612, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1371, 612, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1372, 612, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1373, 613, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1374, 613, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1375, 613, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1376, 614, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1377, 614, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1378, 614, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1379, 615, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1380, 615, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1381, 616, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1382, 616, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1383, 617, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1384, 618, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1385, 619, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1386, 619, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1387, 619, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1388, 619, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1389, 620, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1390, 620, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1391, 621, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1392, 622, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1393, 622, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1394, 622, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1395, 622, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1396, 622, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1397, 623, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1398, 623, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1399, 623, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1400, 623, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1401, 623, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1402, 623, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1403, 624, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1404, 624, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1405, 624, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1406, 624, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1407, 625, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1408, 625, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1409, 625, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1410, 625, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1411, 626, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1412, 626, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1413, 626, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1414, 626, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1415, 627, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1416, 627, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1417, 627, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1418, 627, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1419, 627, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1420, 628, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1421, 628, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1422, 628, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1423, 628, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1424, 629, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1425, 629, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1426, 629, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1427, 629, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1428, 630, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1429, 630, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1430, 630, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1431, 630, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1432, 631, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1433, 631, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1434, 631, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1435, 631, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1436, 632, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1437, 632, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1438, 632, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1439, 632, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1440, 632, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1441, 632, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1442, 633, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1443, 633, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1444, 633, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1445, 633, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1446, 634, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1447, 634, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1448, 634, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1449, 634, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1450, 635, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1451, 635, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1452, 635, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1453, 635, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1454, 636, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1455, 636, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1456, 636, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1457, 636, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1458, 637, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1459, 637, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1460, 638, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1461, 638, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1462, 638, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1463, 639, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1464, 639, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1465, 639, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1466, 640, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1467, 640, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1468, 640, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1469, 641, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1470, 641, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1471, 642, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1472, 642, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1473, 643, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1474, 643, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1475, 643, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1476, 644, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1477, 644, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1478, 644, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1479, 645, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1480, 645, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1481, 645, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1482, 646, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1483, 646, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1484, 646, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1485, 647, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1486, 647, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1487, 647, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1488, 648, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1489, 648, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1490, 648, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1491, 649, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1492, 649, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1493, 649, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1494, 650, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1495, 650, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1496, 650, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1497, 651, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1498, 651, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1499, 651, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1500, 652, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1501, 652, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1502, 652, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1503, 653, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1504, 654, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1505, 655, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1506, 656, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1507, 657, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1508, 658, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1509, 658, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1510, 659, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1511, 659, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1512, 659, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1513, 660, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1514, 660, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1515, 660, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1516, 661, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1517, 661, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1518, 662, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1519, 662, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1520, 663, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1521, 663, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1522, 664, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1523, 664, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1524, 665, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1525, 665, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1526, 666, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1527, 666, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1528, 667, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1529, 667, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1530, 668, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1531, 668, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1532, 669, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1533, 669, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1534, 669, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1535, 669, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1536, 670, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1537, 673, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1538, 673, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1539, 674, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1540, 675, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1541, 676, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1542, 677, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1543, 677, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1544, 678, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1545, 678, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1546, 678, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1547, 679, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1548, 679, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1549, 679, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1550, 680, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1551, 680, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1552, 680, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1553, 681, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1554, 681, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1555, 681, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1556, 681, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1557, 682, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1558, 682, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1559, 683, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1560, 683, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1561, 684, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1562, 684, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1563, 685, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1564, 685, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1565, 686, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1566, 686, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1567, 686, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1568, 687, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1569, 687, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1570, 687, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1571, 688, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1572, 688, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1573, 688, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1574, 688, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1575, 689, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1576, 689, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1577, 696, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1578, 696, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1579, 699, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1580, 701, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1581, 702, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1582, 706, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1583, 708, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1584, 708, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1585, 709, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1586, 709, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1587, 710, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1588, 710, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1589, 710, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1590, 711, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1591, 711, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1592, 711, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1593, 712, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1594, 712, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1595, 712, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1596, 713, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1597, 713, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1598, 713, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1599, 714, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1600, 714, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1601, 714, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1602, 715, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1603, 715, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1604, 715, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1605, 716, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1606, 716, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1607, 717, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1608, 717, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1609, 718, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1610, 719, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1611, 720, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1612, 720, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1613, 720, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1614, 720, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1615, 721, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1616, 721, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1617, 722, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1618, 723, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1619, 723, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1620, 723, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1621, 723, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1622, 723, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1623, 724, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1624, 724, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1625, 724, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1626, 724, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1627, 724, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1628, 724, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1629, 725, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1630, 725, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1631, 725, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1632, 725, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1633, 726, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1634, 726, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1635, 726, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1636, 726, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1637, 727, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1638, 727, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1639, 727, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1640, 727, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1641, 728, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1642, 728, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1643, 728, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1644, 728, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1645, 728, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1646, 729, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1647, 729, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1648, 729, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1649, 729, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1650, 730, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1651, 730, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1652, 730, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1653, 730, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1654, 731, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1655, 731, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1656, 731, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1657, 731, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1658, 732, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1659, 732, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1660, 732, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1661, 732, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1662, 733, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1663, 733, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1664, 733, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1665, 733, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1666, 733, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1667, 733, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1668, 734, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1669, 734, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1670, 734, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1671, 734, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1672, 735, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1673, 735, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1674, 735, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1675, 735, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1676, 736, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1677, 736, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1678, 736, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1679, 736, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1680, 737, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1681, 737, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1682, 737, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1683, 737, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1684, 738, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1685, 738, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1686, 739, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1687, 739, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1688, 739, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1689, 740, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1690, 740, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1691, 740, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1692, 741, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1693, 741, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1694, 741, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1695, 742, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1696, 742, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1697, 743, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1698, 743, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1699, 744, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1700, 744, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1701, 744, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1702, 745, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1703, 745, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1704, 745, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1705, 746, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1706, 746, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1707, 746, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1708, 747, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1709, 747, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1710, 747, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1711, 748, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1712, 748, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1713, 748, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1714, 749, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1715, 749, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1716, 749, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1717, 750, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1718, 750, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1719, 750, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1720, 751, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1721, 751, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1722, 751, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1723, 752, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1724, 752, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1725, 752, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1726, 753, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1727, 753, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1728, 753, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1729, 754, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1730, 755, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1731, 756, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1732, 757, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1733, 758, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1734, 759, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1735, 759, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1736, 760, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1737, 760, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1738, 760, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1739, 761, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1740, 761, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1741, 761, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1742, 762, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1743, 762, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1744, 763, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1745, 763, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1746, 764, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1747, 764, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1748, 765, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1749, 765, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1750, 766, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1751, 766, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1752, 767, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1753, 767, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1754, 768, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1755, 768, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1756, 769, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1757, 769, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1758, 770, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1759, 770, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1760, 770, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1761, 770, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1762, 771, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1763, 774, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1764, 774, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1765, 775, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1766, 776, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1767, 777, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1768, 778, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1769, 778, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1770, 779, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1771, 779, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1772, 779, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1773, 780, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1774, 780, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1775, 780, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1776, 781, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1777, 781, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1778, 781, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1779, 782, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1780, 782, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1781, 782, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1782, 782, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1783, 783, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1784, 783, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1785, 784, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1786, 784, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1787, 785, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1788, 785, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1789, 786, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1790, 786, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1791, 787, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1792, 787, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1793, 787, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1794, 788, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1795, 788, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1796, 788, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1797, 789, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1798, 789, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1799, 789, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1800, 789, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1801, 790, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1802, 790, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1803, 797, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1804, 797, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1805, 800, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1806, 802, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1807, 803, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1808, 807, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1809, 809, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1810, 809, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1811, 810, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1812, 810, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1813, 811, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1814, 811, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1815, 811, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1816, 812, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1817, 812, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1818, 812, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1819, 813, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1820, 813, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1821, 813, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1822, 814, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1823, 814, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1824, 814, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1825, 815, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1826, 815, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1827, 815, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1828, 816, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1829, 816, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1830, 816, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1831, 817, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1832, 817, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1833, 818, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1834, 818, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1835, 819, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1836, 820, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1837, 821, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1838, 821, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1839, 821, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1840, 821, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1841, 822, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1842, 822, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1843, 823, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1844, 824, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1845, 824, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1846, 824, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1847, 824, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1848, 824, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1849, 825, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1850, 825, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1851, 825, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1852, 825, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1853, 825, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1854, 825, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1855, 826, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1856, 826, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1857, 826, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1858, 826, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1859, 827, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1860, 827, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1861, 827, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1862, 827, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1863, 828, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1864, 828, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1865, 828, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1866, 828, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1867, 829, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1868, 829, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1869, 829, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1870, 829, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1871, 829, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1872, 830, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1873, 830, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1874, 830, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1875, 830, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1876, 831, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1877, 831, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1878, 831, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1879, 831, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1880, 832, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1881, 832, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1882, 832, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1883, 832, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1884, 833, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1885, 833, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1886, 833, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1887, 833, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1888, 834, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1889, 834, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1890, 834, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1891, 834, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1892, 834, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1893, 834, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1894, 835, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1895, 835, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1896, 835, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1897, 835, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1898, 836, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1899, 836, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1900, 836, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1901, 836, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1902, 837, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1903, 837, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1904, 837, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1905, 837, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1906, 838, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1907, 838, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1908, 838, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1909, 838, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1910, 839, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1911, 839, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1912, 840, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1913, 840, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1914, 840, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1915, 841, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1916, 841, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1917, 841, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1918, 842, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1919, 842, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1920, 842, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1921, 843, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1922, 843, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1923, 844, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1924, 844, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1925, 845, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1926, 845, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1927, 845, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1928, 846, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1929, 846, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1930, 846, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1931, 847, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1932, 847, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1933, 847, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1934, 848, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1935, 848, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1936, 848, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1937, 849, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1938, 849, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1939, 849, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1940, 850, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1941, 850, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1942, 850, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1943, 851, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1944, 851, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1945, 851, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1946, 852, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1947, 852, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1948, 852, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1949, 853, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1950, 853, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1951, 853, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1952, 854, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1953, 854, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1954, 854, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1955, 855, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1956, 856, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1957, 857, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1958, 858, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1959, 859, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1960, 860, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1961, 860, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1962, 861, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1963, 861, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1964, 861, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1965, 862, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1966, 862, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1967, 862, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1968, 863, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1969, 863, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1970, 864, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1971, 864, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1972, 865, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1973, 865, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1974, 866, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1975, 866, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1976, 867, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1977, 867, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1978, 868, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1979, 868, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1980, 869, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1981, 869, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1982, 870, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1983, 870, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1984, 871, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1985, 871, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1986, 871, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1987, 871, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1988, 872, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1989, 875, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1990, 875, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1991, 876, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1992, 877, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1993, 878, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1994, 879, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1995, 879, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1996, 880, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1997, 880, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1998, 880, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (1999, 881, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2000, 881, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2001, 881, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2002, 882, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2003, 882, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2004, 882, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2005, 883, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2006, 883, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2007, 883, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2008, 883, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2009, 884, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2010, 884, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2011, 885, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2012, 885, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2013, 886, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2014, 886, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2015, 887, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2016, 887, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2017, 888, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2018, 888, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2019, 888, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2020, 889, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2021, 889, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2022, 889, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2023, 890, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2024, 890, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2025, 890, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2026, 890, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2027, 891, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2028, 891, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2029, 898, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2030, 898, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2031, 901, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2032, 903, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2033, 904, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2034, 908, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2035, 910, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2036, 910, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2037, 911, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2038, 911, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2039, 912, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2040, 912, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2041, 912, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2042, 913, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2043, 913, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2044, 913, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2045, 914, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2046, 914, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2047, 914, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2048, 915, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2049, 915, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2050, 915, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2051, 916, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2052, 916, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2053, 916, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2054, 917, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2055, 917, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2056, 917, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2057, 918, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2058, 918, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2059, 919, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2060, 919, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2061, 920, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2062, 921, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2063, 922, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2064, 922, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2065, 922, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2066, 922, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2067, 923, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2068, 923, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2069, 924, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2070, 925, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2071, 925, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2072, 925, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2073, 925, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2074, 925, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2075, 926, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2076, 926, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2077, 926, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2078, 926, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2079, 926, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2080, 926, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2081, 927, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2082, 927, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2083, 927, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2084, 927, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2085, 928, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2086, 928, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2087, 928, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2088, 928, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2089, 929, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2090, 929, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2091, 929, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2092, 929, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2093, 930, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2094, 930, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2095, 930, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2096, 930, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2097, 930, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2098, 931, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2099, 931, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2100, 931, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2101, 931, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2102, 932, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2103, 932, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2104, 932, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2105, 932, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2106, 933, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2107, 933, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2108, 933, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2109, 933, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2110, 934, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2111, 934, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2112, 934, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2113, 934, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2114, 935, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2115, 935, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2116, 935, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2117, 935, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2118, 935, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2119, 935, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2120, 936, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2121, 936, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2122, 936, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2123, 936, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2124, 937, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2125, 937, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2126, 937, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2127, 937, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2128, 938, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2129, 938, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2130, 938, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2131, 938, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2132, 939, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2133, 939, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2134, 939, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2135, 939, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2136, 940, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2137, 940, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2138, 941, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2139, 941, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2140, 941, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2141, 942, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2142, 942, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2143, 942, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2144, 943, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2145, 943, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2146, 943, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2147, 944, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2148, 944, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2149, 945, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2150, 945, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2151, 946, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2152, 946, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2153, 946, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2154, 947, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2155, 947, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2156, 947, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2157, 948, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2158, 948, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2159, 948, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2160, 949, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2161, 949, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2162, 949, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2163, 950, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2164, 950, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2165, 950, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2166, 951, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2167, 951, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2168, 951, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2169, 952, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2170, 952, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2171, 952, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2172, 953, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2173, 953, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2174, 953, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2175, 954, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2176, 954, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2177, 954, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2178, 955, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2179, 955, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2180, 955, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2181, 956, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2182, 957, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2183, 958, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2184, 959, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2185, 960, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2186, 961, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2187, 961, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2188, 962, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2189, 962, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2190, 962, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2191, 963, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2192, 963, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2193, 963, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2194, 964, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2195, 964, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2196, 965, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2197, 965, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2198, 966, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2199, 966, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2200, 967, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2201, 967, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2202, 968, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2203, 968, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2204, 969, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2205, 969, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2206, 970, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2207, 970, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2208, 971, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2209, 971, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2210, 972, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2211, 972, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2212, 972, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2213, 972, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2214, 973, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2215, 976, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2216, 976, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2217, 977, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2218, 978, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2219, 979, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2220, 980, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2221, 980, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2222, 981, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2223, 981, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2224, 981, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2225, 982, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2226, 982, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2227, 982, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2228, 983, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2229, 983, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2230, 983, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2231, 984, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2232, 984, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2233, 984, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2234, 984, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2235, 985, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2236, 985, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2237, 986, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2238, 986, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2239, 987, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2240, 987, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2241, 988, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2242, 988, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2243, 989, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2244, 989, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2245, 989, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2246, 990, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2247, 990, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2248, 990, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2249, 991, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2250, 991, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2251, 991, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2252, 991, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2253, 992, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2254, 992, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2255, 999, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2256, 999, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2257, 1001, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2258, 1001, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2259, 1001, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2260, 1001, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2261, 1002, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2262, 1002, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2263, 1002, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2264, 1003, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2265, 1003, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2266, 1003, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2267, 1003, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2268, 1004, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2269, 1004, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2270, 1004, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2271, 1005, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2272, 1005, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2273, 1006, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2274, 1006, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2275, 1006, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2276, 1007, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2277, 1007, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2278, 1007, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2279, 1007, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2280, 1008, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2281, 1008, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2282, 1009, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2283, 1009, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2284, 1010, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2285, 1010, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2286, 1010, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2287, 1010, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2288, 1011, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2289, 1012, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2290, 1013, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2291, 1013, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2292, 1013, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2293, 1013, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2294, 1013, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2295, 1013, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2296, 1014, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2297, 1014, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2298, 1014, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2299, 1014, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2300, 1015, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2301, 1015, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2302, 1015, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2303, 1015, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2304, 1016, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2305, 1016, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2306, 1016, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2307, 1016, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2308, 1017, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2309, 1017, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2310, 1017, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2311, 1017, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2312, 1018, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2313, 1018, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2314, 1018, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2315, 1018, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2316, 1019, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2317, 1019, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2318, 1019, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2319, 1019, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2320, 1020, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2321, 1020, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2322, 1020, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2323, 1020, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2324, 1021, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2325, 1021, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2326, 1021, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2327, 1021, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2328, 1022, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2329, 1022, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2330, 1022, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2331, 1023, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2332, 1023, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2333, 1023, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2334, 1024, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2335, 1024, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2336, 1024, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2337, 1025, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2338, 1025, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2339, 1025, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2340, 1026, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2341, 1026, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2342, 1026, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2343, 1027, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2344, 1027, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2345, 1027, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2346, 1028, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2347, 1028, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2348, 1028, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2349, 1029, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2350, 1029, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2351, 1029, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2352, 1030, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2353, 1030, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2354, 1030, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2355, 1031, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2356, 1032, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2357, 1033, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2358, 1034, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2359, 1034, 47);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2360, 1035, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2361, 1035, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2362, 1036, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2363, 1036, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2364, 1037, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2365, 1037, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2366, 1038, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2367, 1038, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2368, 1039, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2369, 1039, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2370, 1040, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2371, 1040, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2372, 1040, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2373, 1040, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2374, 1040, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2375, 1041, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2376, 1041, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2377, 1042, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2378, 1042, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2379, 1043, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2380, 1043, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2381, 1044, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2382, 1044, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2383, 1044, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2384, 1045, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2385, 1045, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2386, 1045, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2387, 1046, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2388, 1046, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2389, 1046, 34);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2390, 1047, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2391, 1047, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2392, 1047, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2393, 1047, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2394, 1048, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2395, 1048, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2396, 1049, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2397, 1050, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2398, 1050, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2399, 1055, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2400, 1058, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2401, 1059, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2402, 1059, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2403, 1060, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2404, 1060, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2405, 1061, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2406, 1061, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2407, 1061, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2408, 1061, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2409, 1062, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2410, 1062, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2411, 1062, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2412, 1062, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2413, 1062, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2414, 1062, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2415, 1063, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2416, 1063, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2417, 1063, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2418, 1064, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2419, 1064, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2420, 1065, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2421, 1065, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2422, 1066, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2423, 1066, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2424, 1067, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2425, 1067, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2426, 1067, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2427, 1068, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2428, 1068, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2429, 1068, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2430, 1068, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2431, 1069, 25);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2432, 1069, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2433, 1069, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2434, 1070, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2435, 1070, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2436, 1070, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2437, 1070, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2438, 1070, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2439, 1071, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2440, 1071, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2441, 1071, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2442, 1072, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2443, 1072, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2444, 1072, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2445, 1072, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2446, 1073, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2447, 1073, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2448, 1074, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2449, 1074, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2450, 1075, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2451, 1075, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2452, 1075, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2453, 1076, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2454, 1076, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2455, 1076, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2456, 1076, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2457, 1077, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2458, 1077, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2459, 1077, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2460, 1077, 22);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2461, 1078, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2462, 1078, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2463, 1078, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2464, 1078, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2465, 1078, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2466, 1079, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2467, 1079, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2468, 1079, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2469, 1079, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2470, 1079, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2471, 1079, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2472, 1080, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2473, 1080, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2474, 1080, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2475, 1081, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2476, 1081, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2477, 1082, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2478, 1082, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2479, 1082, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2480, 1082, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2481, 1082, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2482, 1082, 9);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2483, 1083, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2484, 1083, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2485, 1084, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2486, 1089, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2487, 1090, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2488, 1090, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2489, 1091, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2490, 1091, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2491, 1092, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2492, 1092, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2493, 1092, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2494, 1093, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2495, 1093, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2496, 1093, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2497, 1093, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2498, 1093, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2499, 1094, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2500, 1094, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2501, 1094, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2502, 1094, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2503, 1095, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2504, 1095, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2505, 1096, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2506, 1096, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2507, 1097, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2508, 1097, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2509, 1098, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2510, 1098, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2511, 1099, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2512, 1099, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2513, 1099, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2514, 1099, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2515, 1099, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2516, 1100, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2517, 1100, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2518, 1100, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2519, 1101, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2520, 1101, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2521, 1101, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2522, 1101, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2523, 1101, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2524, 1101, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2525, 1102, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2526, 1102, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2527, 1103, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2528, 1103, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2529, 1103, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2530, 1103, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2531, 1104, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2532, 1104, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2533, 1105, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2534, 1105, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2535, 1106, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2536, 1106, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2537, 1106, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2538, 1106, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2539, 1107, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2540, 1107, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2541, 1108, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2542, 1108, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2543, 1109, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2544, 1109, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2545, 1110, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2546, 1110, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2547, 1111, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2548, 1111, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2549, 1112, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2550, 1112, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2551, 1112, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2552, 1113, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2553, 1113, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2554, 1113, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2555, 1113, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2556, 1113, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2557, 1114, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2558, 1114, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2559, 1114, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2560, 1114, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2561, 1115, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2562, 1115, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2563, 1116, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2564, 1116, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2565, 1117, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2566, 1117, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2567, 1118, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2568, 1118, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2569, 1118, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2570, 1119, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2571, 1119, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2572, 1119, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2573, 1120, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2574, 1120, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2575, 1120, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2576, 1121, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2577, 1121, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2578, 1121, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2579, 1122, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2580, 1122, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2581, 1123, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2582, 1123, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2583, 1124, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2584, 1124, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2585, 1125, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2586, 1125, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2587, 1125, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2588, 1126, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2589, 1126, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2590, 1127, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2591, 1127, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2592, 1128, 25);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2593, 1128, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2594, 1128, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2595, 1130, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2596, 1130, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2597, 1131, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2598, 1131, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2599, 1133, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2600, 1133, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2601, 1136, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2602, 1137, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2603, 1140, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2604, 1140, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2605, 1141, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2606, 1141, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2607, 1142, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2608, 1142, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2609, 1143, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2610, 1143, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2611, 1144, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2612, 1144, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2613, 1145, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2614, 1145, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2615, 1146, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2616, 1147, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2617, 1147, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2618, 1149, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2619, 1150, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2620, 1150, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2621, 1150, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2622, 1151, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2623, 1152, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2624, 1152, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2625, 1152, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2626, 1153, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2627, 1154, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2628, 1155, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2629, 1156, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2630, 1156, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2631, 1157, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2632, 1165, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2633, 1169, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2634, 1169, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2635, 1170, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2636, 1170, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2637, 1171, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2638, 1171, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2639, 1172, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2640, 1172, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2641, 1173, 9);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2642, 1173, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2643, 1173, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2644, 1174, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2645, 1175, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2646, 1178, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2647, 1185, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2648, 1187, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2649, 1187, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2650, 1189, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2651, 1189, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2652, 1193, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2653, 1193, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2654, 1194, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2655, 1195, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2656, 1196, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2657, 1198, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2658, 1198, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2659, 1198, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2660, 1199, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2661, 1201, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2662, 1203, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2663, 1206, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2664, 1206, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2665, 1208, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2666, 1208, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2667, 1208, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2668, 1209, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2669, 1209, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2670, 1212, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2671, 1212, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2672, 1213, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2673, 1214, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2674, 1216, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2675, 1216, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2676, 1216, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2677, 1223, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2678, 1223, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2679, 1223, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2680, 1226, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2681, 1228, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2682, 1230, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2683, 1231, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2684, 1231, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2685, 1232, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2686, 1232, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2687, 1237, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2688, 1237, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2689, 1239, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2690, 1239, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2691, 1243, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2692, 1244, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2693, 1245, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2694, 1245, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2695, 1246, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2696, 1246, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2697, 1246, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2698, 1246, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2699, 1250, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2700, 1250, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2701, 1250, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2702, 1250, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2703, 1251, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2704, 1253, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2705, 1253, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2706, 1253, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2707, 1254, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2708, 1254, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2709, 1254, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2710, 1254, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2711, 1254, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2712, 1255, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2713, 1255, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2714, 1255, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2715, 1256, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2716, 1256, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2717, 1256, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2718, 1256, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2719, 1256, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2720, 1256, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2721, 1256, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2722, 1257, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2723, 1257, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2724, 1257, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2725, 1257, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2726, 1257, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2727, 1258, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2728, 1258, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2729, 1258, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2730, 1258, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2731, 1258, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2732, 1258, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2733, 1258, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2734, 1258, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2735, 1258, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2736, 1259, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2737, 1259, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2738, 1259, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2739, 1259, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2740, 1259, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2741, 1259, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2742, 1260, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2743, 1260, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2744, 1260, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2745, 1261, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2746, 1261, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2747, 1261, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2748, 1261, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2749, 1261, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2750, 1261, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2751, 1262, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2752, 1262, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2753, 1262, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2754, 1263, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2755, 1263, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2756, 1264, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2757, 1264, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2758, 1265, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2759, 1265, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2760, 1265, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2761, 1265, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2762, 1265, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2763, 1266, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2764, 1266, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2765, 1267, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2766, 1267, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2767, 1268, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2768, 1268, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2769, 1268, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2770, 1268, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2771, 1268, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2772, 1268, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2773, 1269, 25);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2774, 1270, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2775, 1270, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2776, 1270, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2777, 1270, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2778, 1271, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2779, 1271, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2780, 1271, 22);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2781, 1272, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2782, 1272, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2783, 1274, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2784, 1275, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2785, 1275, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2786, 1275, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2787, 1275, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2788, 1276, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2789, 1276, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2790, 1276, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2791, 1276, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2792, 1276, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2793, 1276, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2794, 1276, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2795, 1277, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2796, 1278, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2797, 1279, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2798, 1279, 22);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2799, 1280, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2800, 1281, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2801, 1282, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2802, 1286, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2803, 1287, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2804, 1287, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2805, 1287, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2806, 1288, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2807, 1288, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2808, 1288, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2809, 1288, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2810, 1289, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2811, 1289, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2812, 1289, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2813, 1289, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2814, 1289, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2815, 1289, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2816, 1289, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2817, 1290, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2818, 1290, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2819, 1290, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2820, 1291, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2821, 1291, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2822, 1291, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2823, 1292, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2824, 1292, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2825, 1292, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2826, 1293, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2827, 1293, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2828, 1293, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2829, 1294, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2830, 1294, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2831, 1294, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2832, 1295, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2833, 1295, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2834, 1295, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2835, 1296, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2836, 1296, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2837, 1296, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2838, 1296, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2839, 1297, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2840, 1297, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2841, 1297, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2842, 1298, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2843, 1298, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2844, 1298, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2845, 1298, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2846, 1299, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2847, 1299, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2848, 1299, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2849, 1299, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2850, 1299, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2851, 1300, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2852, 1300, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2853, 1300, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2854, 1301, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2855, 1301, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2856, 1301, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2857, 1302, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2858, 1305, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2859, 1305, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2860, 1306, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2861, 1306, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2862, 1306, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2863, 1306, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2864, 1307, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2865, 1307, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2866, 1307, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2867, 1307, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2868, 1307, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2869, 1308, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2870, 1308, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2871, 1308, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2872, 1309, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2873, 1309, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2874, 1309, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2875, 1309, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2876, 1311, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2877, 1311, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2878, 1311, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2879, 1312, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2880, 1312, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2881, 1313, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2882, 1313, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2883, 1314, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2884, 1314, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2885, 1314, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2886, 1314, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2887, 1315, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2888, 1315, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2889, 1315, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2890, 1316, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2891, 1316, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2892, 1321, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2893, 1321, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2894, 1322, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2895, 1322, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2896, 1323, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2897, 1324, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2898, 1324, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2899, 1325, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2900, 1325, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2901, 1326, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2902, 1326, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2903, 1327, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2904, 1329, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2905, 1329, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2906, 1329, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2907, 1329, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2908, 1330, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2909, 1330, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2910, 1331, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2911, 1331, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2912, 1332, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2913, 1332, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2914, 1332, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2915, 1333, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2916, 1333, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2917, 1334, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2918, 1334, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2919, 1334, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2920, 1335, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2921, 1335, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2922, 1336, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2923, 1337, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2924, 1337, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2925, 1338, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2926, 1338, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2927, 1339, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2928, 1340, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2929, 1341, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2930, 1341, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2931, 1342, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2932, 1343, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2933, 1344, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2934, 1345, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2935, 1345, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2936, 1346, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2937, 1347, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2938, 1347, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2939, 1348, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2940, 1348, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2941, 1349, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2942, 1349, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2943, 1349, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2944, 1350, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2945, 1351, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2946, 1352, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2947, 1352, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2948, 1353, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2949, 1353, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2950, 1353, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2951, 1353, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2952, 1353, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2953, 1354, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2954, 1354, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2955, 1354, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2956, 1354, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2957, 1355, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2958, 1355, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2959, 1355, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2960, 1356, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2961, 1357, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2962, 1357, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2963, 1357, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2964, 1357, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2965, 1358, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2966, 1359, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2967, 1359, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2968, 1360, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2969, 1361, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2970, 1362, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2971, 1363, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2972, 1363, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2973, 1363, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2974, 1363, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2975, 1363, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2976, 1364, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2977, 1365, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2978, 1366, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2979, 1367, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2980, 1368, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2981, 1369, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2982, 1369, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2983, 1370, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2984, 1370, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2985, 1370, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2986, 1370, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2987, 1371, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2988, 1372, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2989, 1373, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2990, 1373, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2991, 1374, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2992, 1374, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2993, 1376, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2994, 1377, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2995, 1377, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2996, 1377, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2997, 1378, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2998, 1379, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (2999, 1379, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3000, 1380, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3001, 1380, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3002, 1380, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3003, 1381, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3004, 1382, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3005, 1382, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3006, 1382, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3007, 1383, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3008, 1384, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3009, 1385, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3010, 1386, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3011, 1386, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3012, 1386, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3013, 1387, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3014, 1388, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3015, 1389, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3016, 1390, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3017, 1390, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3018, 1391, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3019, 1391, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3020, 1391, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3021, 1392, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3022, 1393, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3023, 1394, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3024, 1395, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3025, 1396, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3026, 1396, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3027, 1397, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3028, 1398, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3029, 1398, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3030, 1399, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3031, 1399, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3032, 1399, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3033, 1400, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3034, 1400, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3035, 1400, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3036, 1401, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3037, 1402, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3038, 1403, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3039, 1403, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3040, 1403, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3041, 1404, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3042, 1404, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3043, 1404, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3044, 1405, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3045, 1405, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3046, 1405, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3047, 1406, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3048, 1406, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3049, 1406, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3050, 1407, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3051, 1407, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3052, 1408, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3053, 1408, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3054, 1409, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3055, 1409, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3056, 1410, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3057, 1412, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3058, 1413, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3059, 1413, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3060, 1413, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3061, 1413, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3062, 1413, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3063, 1414, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3064, 1414, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3065, 1415, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3066, 1415, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3067, 1416, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3068, 1416, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3069, 1416, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3070, 1418, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3071, 1419, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3072, 1420, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3073, 1421, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3074, 1425, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3075, 1426, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3076, 1428, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3077, 1428, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3078, 1429, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3079, 1431, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3080, 1441, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3081, 1441, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3082, 1441, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3083, 1443, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3084, 1444, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3085, 1445, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3086, 1448, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3087, 1448, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3088, 1448, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3089, 1448, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3090, 1449, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3091, 1449, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3092, 1449, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3093, 1449, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3094, 1450, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3095, 1450, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3096, 1450, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3097, 1450, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3098, 1450, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3099, 1450, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3100, 1450, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3101, 1450, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3102, 1451, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3103, 1451, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3104, 1451, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3105, 1451, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3106, 1452, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3107, 1452, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3108, 1452, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3109, 1452, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3110, 1454, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3111, 1454, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3112, 1454, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3113, 1454, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3114, 1455, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3115, 1455, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3116, 1455, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3117, 1455, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3118, 1456, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3119, 1456, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3120, 1456, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3121, 1456, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3122, 1457, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3123, 1457, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3124, 1457, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3125, 1457, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3126, 1458, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3127, 1459, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3128, 1460, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3129, 1461, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3130, 1461, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3131, 1462, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3132, 1462, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3133, 1463, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3134, 1463, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3135, 1464, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3136, 1464, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3137, 1466, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3138, 1467, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3139, 1471, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3140, 1472, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3141, 1475, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3142, 1476, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3143, 1477, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3144, 1477, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3145, 1478, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3146, 1479, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3147, 1480, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3148, 1481, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3149, 1482, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3150, 1483, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3151, 1484, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3152, 1484, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3153, 1484, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3154, 1485, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3155, 1486, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3156, 1487, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3157, 1488, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3158, 1488, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3159, 1489, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3160, 1489, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3161, 1489, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3162, 1490, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3163, 1491, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3164, 1491, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3165, 1491, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3166, 1493, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3167, 1493, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3168, 1501, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3169, 1508, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3170, 1508, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3171, 1508, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3172, 1508, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3173, 1509, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3174, 1509, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3175, 1509, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3176, 1509, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3177, 1510, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3178, 1510, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3179, 1510, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3180, 1510, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3181, 1511, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3182, 1511, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3183, 1511, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3184, 1511, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3185, 1512, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3186, 1512, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3187, 1513, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3188, 1513, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3189, 1514, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3190, 1514, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3191, 1515, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3192, 1515, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3193, 1516, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3194, 1516, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3195, 1519, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3196, 1519, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3197, 1520, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3198, 1520, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3199, 1520, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3200, 1520, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3201, 1520, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3202, 1522, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3203, 1522, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3204, 1523, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3205, 1523, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3206, 1527, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3207, 1531, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3208, 1531, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3209, 1532, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3210, 1533, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3211, 1534, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3212, 1541, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3213, 1541, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3214, 1542, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3215, 1542, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3216, 1543, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3217, 1543, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3218, 1544, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3219, 1544, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3220, 1544, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3221, 1545, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3222, 1545, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3223, 1545, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3224, 1545, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3225, 1545, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3226, 1546, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3227, 1546, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3228, 1546, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3229, 1546, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3230, 1547, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3231, 1547, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3232, 1547, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3233, 1547, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3234, 1548, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3235, 1548, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3236, 1548, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3237, 1548, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3238, 1549, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3239, 1549, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3240, 1549, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3241, 1549, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3242, 1579, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3243, 1579, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3244, 1579, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3245, 1579, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3246, 1579, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3247, 1581, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3248, 1604, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3249, 1604, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3250, 1609, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3251, 1609, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3252, 1610, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3253, 1611, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3254, 1611, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3255, 1611, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3256, 1612, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3257, 1612, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3258, 1612, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3259, 1613, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3260, 1613, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3261, 1613, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3262, 1613, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3263, 1614, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3264, 1614, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3265, 1614, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3266, 1614, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3267, 1615, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3268, 1615, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3269, 1615, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3270, 1616, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3271, 1616, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3272, 1616, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3273, 1616, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3274, 1616, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3275, 1617, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3276, 1617, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3277, 1617, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3278, 1618, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3279, 1618, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3280, 1618, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3281, 1619, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3282, 1619, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3283, 1619, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3284, 1619, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3285, 1620, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3286, 1620, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3287, 1620, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3288, 1620, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3289, 1621, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3290, 1621, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3291, 1621, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3292, 1622, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3293, 1622, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3294, 1622, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3295, 1622, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3296, 1623, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3297, 1623, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3298, 1623, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3299, 1624, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3300, 1624, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3301, 1624, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3302, 1624, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3303, 1625, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3304, 1625, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3305, 1625, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3306, 1625, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3307, 1625, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3308, 1626, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3309, 1626, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3310, 1626, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3311, 1627, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3312, 1627, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3313, 1627, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3314, 1628, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3315, 1628, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3316, 1628, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3317, 1629, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3318, 1629, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3319, 1630, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3320, 1630, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3321, 1631, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3322, 1632, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3323, 1632, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3324, 1632, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3325, 1632, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3326, 1632, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3327, 1633, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3328, 1633, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3329, 1634, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3330, 1634, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3331, 1634, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3332, 1635, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3333, 1635, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3334, 1635, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3335, 1635, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3336, 1636, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3337, 1639, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3338, 1650, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3339, 1651, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3340, 1652, 25);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3341, 1655, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3342, 1658, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3343, 1658, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3344, 1659, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3345, 1659, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3346, 1660, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3347, 1660, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3348, 1665, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3349, 1666, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3350, 1667, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3351, 1668, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3352, 1668, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3353, 1668, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3354, 1668, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3355, 1668, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3356, 1669, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3357, 1670, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3358, 1670, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3359, 1670, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3360, 1670, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3361, 1670, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3362, 1671, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3363, 1671, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3364, 1671, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3365, 1671, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3366, 1671, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3367, 1672, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3368, 1672, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3369, 1672, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3370, 1672, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3371, 1672, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3372, 1673, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3373, 1673, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3374, 1673, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3375, 1673, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3376, 1673, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3377, 1673, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3378, 1673, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3379, 1673, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3380, 1673, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3381, 1674, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3382, 1674, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3383, 1674, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3384, 1674, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3385, 1674, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3386, 1674, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3387, 1674, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3388, 1675, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3389, 1675, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3390, 1675, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3391, 1675, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3392, 1675, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3393, 1676, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3394, 1676, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3395, 1676, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3396, 1676, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3397, 1676, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3398, 1676, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3399, 1676, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3400, 1677, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3401, 1677, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3402, 1677, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3403, 1677, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3404, 1677, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3405, 1677, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3406, 1677, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3407, 1677, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3408, 1678, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3409, 1678, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3410, 1678, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3411, 1678, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3412, 1678, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3413, 1679, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3414, 1679, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3415, 1679, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3416, 1679, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3417, 1679, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3418, 1680, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3419, 1681, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3420, 1682, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3421, 1683, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3422, 1684, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3423, 1686, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3424, 1686, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3425, 1687, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3426, 1687, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3427, 1688, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3428, 1688, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3429, 1689, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3430, 1689, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3431, 1689, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3432, 1696, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3433, 1696, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3434, 1697, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3435, 1697, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3436, 1698, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3437, 1698, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3438, 1699, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3439, 1699, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3440, 1699, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3441, 1700, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3442, 1701, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3443, 1701, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3444, 1701, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3445, 1701, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3446, 1702, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3447, 1702, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3448, 1702, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3449, 1702, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3450, 1702, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3451, 1703, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3452, 1703, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3453, 1710, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3454, 1710, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3455, 1711, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3456, 1711, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3457, 1711, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3458, 1712, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3459, 1712, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3460, 1712, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3461, 1713, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3462, 1713, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3463, 1714, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3464, 1714, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3465, 1714, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3466, 1715, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3467, 1715, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3468, 1715, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3469, 1716, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3470, 1716, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3471, 1716, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3472, 1716, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3473, 1717, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3474, 1717, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3475, 1717, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3476, 1719, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3477, 1724, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3478, 1724, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3479, 1725, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3480, 1725, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3481, 1727, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3482, 1727, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3483, 1728, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3484, 1729, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3485, 1730, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3486, 1731, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3487, 1732, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3488, 1733, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3489, 1734, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3490, 1735, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3491, 1736, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3492, 1736, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3493, 1737, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3494, 1737, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3495, 1738, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3496, 1738, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3497, 1738, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3498, 1743, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3499, 1743, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3500, 1749, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3501, 1749, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3502, 1750, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3503, 1750, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3504, 1752, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3505, 1752, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3506, 1753, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3507, 1753, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3508, 1754, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3509, 1758, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3510, 1758, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3511, 1759, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3512, 1759, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3513, 1762, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3514, 1764, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3515, 1765, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3516, 1765, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3517, 1765, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3518, 1767, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3519, 1767, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3520, 1768, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3521, 1768, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3522, 1768, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3523, 1771, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3524, 1773, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3525, 1774, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3526, 1774, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3527, 1777, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3528, 1780, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3529, 1784, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3530, 1785, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3531, 1785, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3532, 1786, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3533, 1786, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3534, 1787, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3535, 1790, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3536, 1790, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3537, 1791, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3538, 1791, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3539, 1793, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3540, 1793, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3541, 1795, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3542, 1795, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3543, 1796, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3544, 1798, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3545, 1798, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3546, 1798, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3547, 1799, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3548, 1799, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3549, 1799, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3550, 1800, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3551, 1802, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3552, 1806, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3553, 1806, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3554, 1808, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3555, 1808, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3556, 1808, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3557, 1809, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3558, 1809, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3559, 1809, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3560, 1811, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3561, 1811, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3562, 1811, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3563, 1812, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3564, 1812, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3565, 1812, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3566, 1813, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3567, 1813, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3568, 1813, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3569, 1814, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3570, 1818, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3571, 1818, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3572, 1822, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3573, 1822, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3574, 1823, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3575, 1823, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3576, 1824, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3577, 1824, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3578, 1825, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3579, 1825, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3580, 1825, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3581, 1826, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3582, 1826, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3583, 1826, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3584, 1827, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3585, 1827, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3586, 1827, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3587, 1827, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3588, 1829, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3589, 1830, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3590, 1830, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3591, 1830, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3592, 1832, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3593, 1832, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3594, 1832, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3595, 1834, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3596, 1834, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3597, 1834, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3598, 1835, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3599, 1835, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3600, 1836, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3601, 1836, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3602, 1838, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3603, 1838, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3604, 1840, 22);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3605, 1841, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3606, 1841, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3607, 1841, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3608, 1841, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3609, 1841, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3610, 1842, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3611, 1842, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3612, 1842, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3613, 1844, 25);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3614, 1845, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3615, 1846, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3616, 1847, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3617, 1847, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3618, 1848, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3619, 1848, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3620, 1848, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3621, 1848, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3622, 1848, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3623, 1850, 9);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3624, 1850, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3625, 1850, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3626, 1852, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3627, 1852, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3628, 1852, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3629, 1852, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3630, 1853, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3631, 1853, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3632, 1853, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3633, 1853, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3634, 1854, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3635, 1854, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3636, 1854, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3637, 1854, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3638, 1854, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3639, 1854, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3640, 1855, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3641, 1855, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3642, 1855, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3643, 1856, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3644, 1856, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3645, 1856, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3646, 1856, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3647, 1857, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3648, 1857, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3649, 1857, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3650, 1858, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3651, 1858, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3652, 1859, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3653, 1859, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3654, 1860, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3655, 1860, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3656, 1861, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3657, 1861, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3658, 1862, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3659, 1862, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3660, 1862, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3661, 1863, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3662, 1863, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3663, 1863, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3664, 1864, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3665, 1864, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3666, 1865, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3667, 1865, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3668, 1866, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3669, 1866, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3670, 1867, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3671, 1867, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3672, 1868, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3673, 1868, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3674, 1868, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3675, 1869, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3676, 1869, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3677, 1870, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3678, 1870, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3679, 1871, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3680, 1871, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3681, 1873, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3682, 1873, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3683, 1874, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3684, 1874, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3685, 1875, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3686, 1875, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3687, 1876, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3688, 1876, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3689, 1876, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3690, 1876, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3691, 1877, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3692, 1877, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3693, 1877, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3694, 1877, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3695, 1877, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3696, 1878, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3697, 1878, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3698, 1879, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3699, 1882, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3700, 1882, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3701, 1882, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3702, 1884, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3703, 1884, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3704, 1886, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3705, 1888, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3706, 1890, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3707, 1890, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3708, 1895, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3709, 1896, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3710, 1898, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3711, 1898, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3712, 1900, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3713, 1900, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3714, 1900, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3715, 1900, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3716, 1900, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3717, 1900, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3718, 1900, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3719, 1900, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3720, 1900, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3721, 1902, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3722, 1904, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3723, 1904, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3724, 1904, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3725, 1904, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3726, 1904, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3727, 1904, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3728, 1904, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3729, 1905, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3730, 1905, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3731, 1906, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3732, 1906, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3733, 1906, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3734, 1907, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3735, 1907, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3736, 1911, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3737, 1921, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3738, 1923, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3739, 1923, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3740, 1923, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3741, 1923, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3742, 1923, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3743, 1923, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3744, 1923, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3745, 1924, 9);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3746, 1925, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3747, 1925, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3748, 1926, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3749, 1926, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3750, 1927, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3751, 1928, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3752, 1928, 25);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3753, 1928, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3754, 1928, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3755, 1929, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3756, 1929, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3757, 1929, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3758, 1929, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3759, 1929, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3760, 1929, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3761, 1930, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3762, 1930, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3763, 1930, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3764, 1930, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3765, 1930, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3766, 1930, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3767, 1930, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3768, 1930, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3769, 1930, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3770, 1931, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3771, 1931, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3772, 1931, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3773, 1931, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3774, 1931, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3775, 1931, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3776, 1931, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3777, 1931, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3778, 1931, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3779, 1932, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3780, 1932, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3781, 1932, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3782, 1933, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3783, 1933, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3784, 1933, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3785, 1933, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3786, 1933, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3787, 1933, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3788, 1934, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3789, 1934, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3790, 1934, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3791, 1934, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3792, 1934, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3793, 1934, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3794, 1935, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3795, 1935, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3796, 1936, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3797, 1936, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3798, 1936, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3799, 1936, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3800, 1936, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3801, 1937, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3802, 1937, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3803, 1937, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3804, 1938, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3805, 1938, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3806, 1938, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3807, 1938, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3808, 1943, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3809, 1943, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3810, 1944, 9);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3811, 1944, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3812, 1944, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3813, 1945, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3814, 1945, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3815, 1946, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3816, 1946, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3817, 1946, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3818, 1947, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3819, 1947, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3820, 1949, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3821, 1950, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3822, 1950, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3823, 1950, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3824, 1950, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3825, 1951, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3826, 1951, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3827, 1951, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3828, 1951, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3829, 1952, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3830, 1952, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3831, 1952, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3832, 1952, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3833, 1953, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3834, 1953, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3835, 1953, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3836, 1953, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3837, 1954, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3838, 1954, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3839, 1954, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3840, 1954, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3841, 1955, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3842, 1955, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3843, 1955, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3844, 1955, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3845, 1956, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3846, 1956, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3847, 1956, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3848, 1956, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3849, 1957, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3850, 1957, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3851, 1957, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3852, 1957, 54);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3853, 1958, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3854, 1958, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3855, 1958, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3856, 1958, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3857, 1959, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3858, 1959, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3859, 1959, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3860, 1960, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3861, 1960, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3862, 1960, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3863, 1961, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3864, 1961, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3865, 1961, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3866, 1961, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3867, 1962, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3868, 1962, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3869, 1962, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3870, 1962, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3871, 1963, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3872, 1963, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3873, 1963, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3874, 1963, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3875, 1964, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3876, 1964, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3877, 1964, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3878, 1964, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3879, 1965, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3880, 1965, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3881, 1965, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3882, 1965, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3883, 1966, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3884, 1966, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3885, 1966, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3886, 1966, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3887, 1966, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3888, 1968, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3889, 1968, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3890, 1968, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3891, 1969, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3892, 1969, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3893, 1969, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3894, 1970, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3895, 1970, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3896, 1970, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3897, 1970, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3898, 1971, 26);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3899, 1974, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3900, 1974, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3901, 1977, 9);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3902, 1979, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3903, 1988, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3904, 1989, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3905, 1990, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3906, 1991, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3907, 1991, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3908, 1991, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3909, 1992, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3910, 1993, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3911, 1997, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3912, 1998, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3913, 1998, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3914, 2002, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3915, 2002, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3916, 2003, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3917, 2003, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3918, 2004, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3919, 2004, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3920, 2006, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3921, 2006, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3922, 2006, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3923, 2006, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3924, 2006, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3925, 2007, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3926, 2007, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3927, 2007, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3928, 2008, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3929, 2008, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3930, 2008, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3931, 2008, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3932, 2012, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3933, 2014, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3934, 2014, 30);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3935, 2017, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3936, 2017, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3937, 2019, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3938, 2019, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3939, 2020, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3940, 2020, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3941, 2022, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3942, 2022, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3943, 2023, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3944, 2023, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3945, 2023, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3946, 2023, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3947, 2023, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3948, 2023, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3949, 2024, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3950, 2024, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3951, 2024, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3952, 2025, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3953, 2025, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3954, 2025, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3955, 2025, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3956, 2025, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3957, 2026, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3958, 2026, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3959, 2026, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3960, 2026, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3961, 2027, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3962, 2027, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3963, 2027, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3964, 2027, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3965, 2027, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3966, 2028, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3967, 2028, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3968, 2028, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3969, 2029, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3970, 2029, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3971, 2029, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3972, 2029, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3973, 2029, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3974, 2029, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3975, 2029, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3976, 2030, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3977, 2030, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3978, 2030, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3979, 2030, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3980, 2031, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3981, 2031, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3982, 2031, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3983, 2031, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3984, 2032, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3985, 2032, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3986, 2032, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3987, 2033, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3988, 2033, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3989, 2033, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3990, 2034, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3991, 2034, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3992, 2034, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3993, 2035, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3994, 2035, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3995, 2035, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3996, 2035, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3997, 2036, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3998, 2036, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (3999, 2036, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4000, 2037, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4001, 2038, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4002, 2039, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4003, 2039, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4004, 2041, 22);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4005, 2044, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4006, 2044, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4007, 2044, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4008, 2044, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4009, 2044, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4010, 2044, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4011, 2045, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4012, 2045, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4013, 2046, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4014, 2046, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4015, 2046, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4016, 2046, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4017, 2046, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4018, 2046, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4019, 2046, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4020, 2047, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4021, 2047, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4022, 2047, 45);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4023, 2047, 46);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4024, 2052, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4025, 2052, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4026, 2053, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4027, 2053, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4028, 2053, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4029, 2053, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4030, 2055, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4031, 2055, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4032, 2055, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4033, 2055, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4034, 2055, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4035, 2056, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4036, 2056, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4037, 2057, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4038, 2057, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4039, 2057, 12);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4040, 2057, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4041, 2058, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4042, 2058, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4043, 2058, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4044, 2059, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4045, 2059, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4046, 2059, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4047, 2059, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4048, 2059, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4049, 2060, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4050, 2060, 21);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4051, 2061, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4052, 2061, 39);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4053, 2065, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4054, 2065, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4055, 2066, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4056, 2066, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4057, 2066, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4058, 2067, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4059, 2067, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4060, 2067, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4061, 2068, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4062, 2068, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4063, 2069, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4064, 2069, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4065, 2072, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4066, 2073, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4067, 2073, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4068, 2073, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4069, 2074, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4070, 2074, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4071, 2076, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4072, 2077, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4073, 2078, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4074, 2079, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4075, 2080, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4076, 2081, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4077, 2082, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4078, 2083, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4079, 2083, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4080, 2083, 6);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4081, 2091, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4082, 2091, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4083, 2092, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4084, 2093, 1);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4085, 2094, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4086, 2097, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4087, 2097, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4088, 2098, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4089, 2099, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4090, 2100, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4091, 2101, 53);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4092, 2107, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4093, 2108, 51);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4094, 2110, 14);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4095, 2111, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4096, 2111, 4);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4097, 2111, 37);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4098, 2111, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4099, 2111, 43);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4100, 2115, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4101, 2116, 19);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4102, 2122, 8);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4103, 2123, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4104, 2123, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4105, 2123, 29);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4106, 2124, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4107, 2126, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4108, 2126, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4109, 2127, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4110, 2127, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4111, 2127, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4112, 2127, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4113, 2129, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4114, 2129, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4115, 2130, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4116, 2130, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4117, 2130, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4118, 2132, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4119, 2132, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4120, 2133, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4121, 2133, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4122, 2134, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4123, 2134, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4124, 2135, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4125, 2135, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4126, 2136, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4127, 2136, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4128, 2137, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4129, 2137, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4130, 2138, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4131, 2138, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4132, 2139, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4133, 2139, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4134, 2140, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4135, 2140, 35);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4136, 2140, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4137, 2140, 41);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4138, 2140, 11);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4139, 2141, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4140, 2141, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4141, 2142, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4142, 2142, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4143, 2142, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4144, 2142, 15);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4145, 2143, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4146, 2143, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4147, 2144, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4148, 2144, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4149, 2144, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4150, 2145, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4151, 2145, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4152, 2147, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4153, 2147, 33);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4154, 2150, 13);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4155, 2153, 27);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4156, 2153, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4157, 2153, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4158, 2153, 28);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4159, 2155, 36);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4160, 2155, 5);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4161, 2160, 32);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4162, 2160, 2);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4163, 2160, 3);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4164, 2160, 40);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4165, 2160, 16);
INSERT INTO `food_tags` (`id`, `food_id`, `tag_id`)
VALUES (4166, 2160, 27);

-- blog tables
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog`
(
    `id`            bigint                                                        NOT NULL AUTO_INCREMENT,
    `user_id`       bigint                                                        NULL DEFAULT 0 COMMENT '用户id',
    `title`         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '标题',
    `like`    int UNSIGNED                                                  NULL DEFAULT 0 COMMENT '点赞数量',
    `view`    int UNSIGNED                                                  NULL DEFAULT 0 COMMENT '查看数量',
    `comment` int UNSIGNED                                                  NULL DEFAULT 0 COMMENT '评论数量',
    `fav`     int UNSIGNED                                                  NULL DEFAULT 0 COMMENT '收藏数量',
    `content`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NULL,
    `status`        tinyint(1)                                                    NULL DEFAULT NULL COMMENT '状态 0隐藏 1所有人可见 2仅自己可见 3仅好友可见',
    `created_at`    datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 9
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = '博客'
  ROW_FORMAT = Dynamic;
alter table blog
    change status visibility tinyint(1) null comment '状态 0隐藏 1所有人可见 2仅自己可见 3仅好友可见';

DROP TABLE IF EXISTS `blog_attach`;
CREATE TABLE `blog_attach`
(
    `id`         bigint                                                        NOT NULL AUTO_INCREMENT,
    `blog_id`    bigint                                                        NULL DEFAULT 0 COMMENT '博客id',
    `attach`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
    `poster`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '视频封面',
    `sort`       int                                                           NULL DEFAULT 0 COMMENT '排序',
    `type`       tinyint                                                       NULL DEFAULT 0 COMMENT '类型 0 图片 1 视频 3食物 4食谱 5就餐记录',
    `created_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_blog_id` (`blog_id` ASC) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 14
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = '博客附件'
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment`
(
    `id`         bigint                                                NOT NULL AUTO_INCREMENT,
    `blog_id`    bigint                                                NULL DEFAULT 0 COMMENT '博客id',
    `user_id`    bigint                                                NULL DEFAULT 0 COMMENT '用户id',
    `content`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `parent_id`  bigint                                                NULL DEFAULT 0 COMMENT '父评论id',
    `like` int                                                   NULL DEFAULT 0 COMMENT '点赞数量',
    `created_at` datetime                                              NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                              NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_blog_id` (`blog_id` ASC) USING BTREE,
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE,
    INDEX `idx_parent_id` (`parent_id` ASC) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = '博客评论'
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `blog_location`;
CREATE TABLE `blog_location`
(
    `id`        bigint                                                        NOT NULL AUTO_INCREMENT,
    `blog_id`   bigint                                                        NOT NULL,
    `latitude`  decimal(10, 6)                                                NOT NULL,
    `longitude` decimal(10, 6)                                                NOT NULL,
    `name`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `address`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 4
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '博客位置表'
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `blog_topic`;
CREATE TABLE `blog_topic`
(
    `id`       bigint NOT NULL AUTO_INCREMENT,
    `blog_id`  bigint NOT NULL,
    `topic_id` bigint NOT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_blog_topic` (`blog_id` ASC, `topic_id` ASC) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '博客话题表'
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `checkin_record`;
CREATE TABLE `checkin_record`
(
    `id`             bigint                                                                                     NOT NULL AUTO_INCREMENT,
    `user_id`        bigint                                                                                     NOT NULL,
    `target_calorie` int                                                                                        NOT NULL COMMENT '当日目标卡路里',
    `total_calorie`  int                                                                                        NOT NULL COMMENT '当日摄入总卡路里',
    `result`         enum ('success','fail_over','fail_under') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '打卡结果',
    `date`           date                                                                                       NOT NULL COMMENT '打卡日期，一个用户一天一条记录',
    `created_at`     datetime                                                                                   NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     datetime                                                                                   NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_user_id_date` (`user_id` ASC, `date` ASC) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = '打卡记录'
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite`
(
    `id`         bigint   NOT NULL AUTO_INCREMENT,
    `user_id`    bigint   NULL DEFAULT 0 COMMENT '用户id',
    `target`     bigint   NULL DEFAULT 0 COMMENT '食物id',
    `type`       tinyint  NULL DEFAULT 0 COMMENT '类型 1 帖子 2 食物 3食谱',
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_user_id_type_target` (`user_id` ASC, `type` ASC, `target` ASC) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 3
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `follow`;
CREATE TABLE `follow`
(
    `id`           bigint     NOT NULL AUTO_INCREMENT,
    `user_id`      bigint     NULL DEFAULT 0 COMMENT '用户id',
    `follow_id`    bigint     NULL DEFAULT 0 COMMENT '关注id',
    `is_attention` tinyint(1) NULL DEFAULT 0 COMMENT '是否互相关注 0否 1是',
    `created_at`   datetime   NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`   datetime   NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_user_follow_id` (`user_id` ASC, `follow_id` ASC) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `meal_record`;
CREATE TABLE `meal_record`
(
    `id`         bigint                                                        NOT NULL AUTO_INCREMENT,
    `user_id`    bigint                                                        NULL     DEFAULT 0 COMMENT '所属用户',
    `type`       tinyint                                                       NULL     DEFAULT 0 COMMENT '类型 0 早餐 1 午餐 2 晚餐 3加餐',
    `nutrition`  json                                                          NULL COMMENT '营养信息',
    `created_at` datetime                                                      NULL     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `meal_date`  date                                                          NOT NULL DEFAULT (curdate()),
    `latitude`   decimal(10, 6)                                                NULL     DEFAULT NULL COMMENT '纬度',
    `longitude`  decimal(10, 6)                                                NULL     DEFAULT NULL COMMENT '经度',
    `address`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL     DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_user_type_date` (`user_id` ASC, `type` ASC, `meal_date` ASC) USING BTREE,
    INDEX `idx_user_id_type` (`user_id` ASC, `type` ASC) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = '就餐记录'
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `meal_record_food`;
CREATE TABLE `meal_record_food`
(
    `id`         bigint                                                        NOT NULL AUTO_INCREMENT,
    `meal_id`    bigint                                                        NULL DEFAULT 0 COMMENT '就餐记录id',
    `user_id`    bigint                                                        NULL DEFAULT NULL,
    `food_id`    bigint                                                        NULL DEFAULT 0 COMMENT '食物id',
    `unit_id`    bigint                                                        NULL DEFAULT 0 COMMENT '单位',
    `nutrition`  json                                                          NULL COMMENT '营养成分',
    `number`     decimal(10, 2)                                                NULL DEFAULT 1.00 COMMENT '分量',
    `image`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片',
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
    `created_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_meal_id` (`meal_id` ASC) USING BTREE,
    INDEX `idx_food_id` (`food_id` ASC) USING BTREE,
    INDEX `idx_unit_id` (`unit_id` ASC) USING BTREE,
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE,
    INDEX `idx_crated_at` (`created_at` ASC) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = '就餐记录食物'
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `recipe`;
CREATE TABLE `recipe`
(
    `id`         bigint                                                        NOT NULL AUTO_INCREMENT,
    `user_id`    bigint                                                        NULL DEFAULT 0 COMMENT '用户id',
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
    `summary`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NULL,
    `content`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NULL,
    `like` int                                                           NULL DEFAULT 0 COMMENT '点赞数量',
    `created_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = '食谱'
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `recipe_attach`;
CREATE TABLE `recipe_attach`
(
    `id`         bigint                                                        NOT NULL AUTO_INCREMENT,
    `recipe_id`  bigint                                                        NULL DEFAULT 0 COMMENT '食谱id',
    `attach`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
    `created_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_recipe_id` (`recipe_id` ASC) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = '食谱附件'
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `recipe_food`;
CREATE TABLE `recipe_food`
(
    `id`         bigint         NOT NULL AUTO_INCREMENT,
    `recipe_id`  bigint         NULL DEFAULT 0 COMMENT '食谱id',
    `food_id`    bigint         NULL DEFAULT 0 COMMENT '食物id',
    `number`     decimal(10, 2) NULL DEFAULT 0.00 COMMENT '分量',
    `created_at` datetime       NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_recipe_id` (`recipe_id` ASC) USING BTREE,
    INDEX `idx_food_id` (`food_id` ASC) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`
(
    `id`          bigint                                                        NOT NULL AUTO_INCREMENT COMMENT '话题ID',
    `title`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '话题标题',
    `thumb` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '话题封面图片',
    `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '话题描述',
    `creator_id`  bigint                                                        NOT NULL COMMENT '创建者用户ID',
    `status`      tinyint                                                       NULL DEFAULT 1 COMMENT '状态 1正常 0禁用',
    `join`  int                                                           NULL DEFAULT 0 COMMENT '参与人数',
    `post`  int                                                           NULL DEFAULT 0 COMMENT '关联文章/餐食记录数',
    `created_at`  datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`  datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_creator_id` (`creator_id` ASC) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '话题表'
  ROW_FORMAT = Dynamic;



rename table topic to topics;



DROP TABLE IF EXISTS `topic_relation`;
CREATE TABLE `topic_relation`
(
    `id`          bigint   NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `topic_id`    bigint   NOT NULL COMMENT '话题ID',
    `target_id`   bigint   NOT NULL COMMENT '关联对象ID（博客ID、餐食记录ID等）',
    `target_type` tinyint  NOT NULL COMMENT '关联类型 1博客 2餐食记录 3其他',
    `created_at`  datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_topic_target` (`topic_id` ASC, `target_type` ASC, `target_id` ASC) USING BTREE,
    INDEX `idx_target` (`target_id` ASC, `target_type` ASC) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT = '话题关联表'
  ROW_FORMAT = Dynamic;

SET
    FOREIGN_KEY_CHECKS = 1;
