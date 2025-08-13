SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;
CREATE TABLE `topic`
(
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '话题ID',
    `title`       VARCHAR(100) NOT NULL COMMENT '话题标题',
    `cover_image` VARCHAR(255) DEFAULT NULL COMMENT '话题封面图片',
    `description` VARCHAR(500) DEFAULT NULL COMMENT '话题描述',
    `creator_id`  BIGINT       NOT NULL COMMENT '创建者用户ID',
    `status`      TINYINT      DEFAULT 1 COMMENT '状态 1正常 0禁用',
    `join_count`  INT          DEFAULT 0 COMMENT '参与人数',
    `post_count`  INT          DEFAULT 0 COMMENT '关联文章/餐食记录数',
    `created_at`  DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_creator_id` (`creator_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='话题表';
CREATE TABLE `topic_relation`
(
    `id`          BIGINT  NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `topic_id`    BIGINT  NOT NULL COMMENT '话题ID',
    `target_id`   BIGINT  NOT NULL COMMENT '关联对象ID（博客ID、餐食记录ID等）',
    `target_type` TINYINT NOT NULL COMMENT '关联类型 1博客 2餐食记录 3其他',
    `created_at`  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE INDEX `idx_topic_target` (`topic_id`, `target_type`, `target_id`),
    INDEX `idx_target` (`target_id`, `target_type`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='话题关联表';
-- blog DDL
CREATE TABLE `blog`
(
    `id`            BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `user_id`       BIGINT                                                        NULL DEFAULT 0 Comment "用户id",
    `title`         VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' Comment "标题",
    `like_count`    INT                                                           NULL DEFAULT 0 Comment "点赞数量",
    `view_count`    INT                                                           NULL DEFAULT 0 Comment "查看数量",
    `comment_count` INT                                                           NULL DEFAULT 0 Comment "评论数量",
    `fav_count`     INT                                                           NULL DEFAULT 0 Comment "收藏数量",
    `content`       TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NULL,
    `created_at`    DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at`    DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic COMMENT = "博客";
-- blog_attach DDL
CREATE TABLE `blog_attach`
(
    `id`         BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `blog_id`    BIGINT                                                        NULL DEFAULT 0 Comment "博客id",
    `attach`     VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `poster`     VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "视频封面",
    `sort`       INT                                                           NULL DEFAULT 0 Comment "排序",
    `type`       TINYINT                                                       NULL DEFAULT 0 Comment "类型 0 图片 1 视频 3食物 4食谱 5就餐记录",
    `created_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    INDEX `idx_blog_id` (`blog_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic COMMENT = "博客附件";
-- blog_comment DDL
CREATE TABLE `blog_comment`
(
    `id`         BIGINT                                                NOT NULL AUTO_INCREMENT,
    `blog_id`    BIGINT                                                NULL DEFAULT 0 Comment "博客id",
    `user_id`    BIGINT                                                NULL DEFAULT 0 Comment "用户id",
    `content`    TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `parent_id`  BIGINT                                                NULL DEFAULT 0 Comment "父评论id",
    `like_count` INT                                                   NULL DEFAULT 0 Comment "点赞数量",
    `created_at` DATETIME                                              NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                              NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    INDEX `idx_blog_id` (`blog_id` ASC) USING BTREE,
    INDEX `idx_parent_id` (`parent_id` ASC) USING BTREE,
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic COMMENT = "博客评论";
-- checkin_record DDL
CREATE TABLE `checkin_record`
(
    `id`             BIGINT                                                                                     NOT NULL AUTO_INCREMENT,
    `user_id`        BIGINT                                                                                     NOT NULL,
    `target_calorie` INT                                                                                        NOT NULL Comment "当日目标卡路里",
    `total_calorie`  INT                                                                                        NOT NULL Comment "当日摄入总卡路里",
    `result`         ENUM ("success","fail_over","fail_under") CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL Comment "打卡结果",
    `date`           DATE                                                                                       NOT NULL Comment "打卡日期，一个用户一天一条记录",
    `created_at`     DATETIME                                                                                   NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     DATETIME                                                                                   NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    UNIQUE INDEX `idx_user_id_date` (`user_id` ASC, `date` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic COMMENT = "打卡记录";
-- favorite DDL
CREATE TABLE `favorite`
(
    `id`         BIGINT   NOT NULL AUTO_INCREMENT,
    `user_id`    BIGINT   NULL DEFAULT 0 Comment "用户id",
    `target`     BIGINT   NULL DEFAULT 0 Comment "食物id",
    `type`       TINYINT  NULL DEFAULT 0 Comment "类型 1 帖子 2 食物 3食谱",
    `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    UNIQUE INDEX `idx_user_id_type_target` (`user_id` ASC, `type` ASC, `target` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic;
-- follow DDL
CREATE TABLE `follow`
(
    `id`           BIGINT     NOT NULL AUTO_INCREMENT,
    `user_id`      BIGINT     NULL DEFAULT 0 Comment "用户id",
    `follow_id`    BIGINT     NULL DEFAULT 0 Comment "关注id",
    `is_attention` TINYINT(1) NULL DEFAULT 0 Comment "是否互相关注 0否 1是",
    `created_at`   DATETIME   NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at`   DATETIME   NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    UNIQUE INDEX `idx_user_follow_id` (`user_id` ASC, `follow_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic;
-- food DDL
CREATE TABLE `food`
(
    `id`         BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `user_id`    BIGINT                                                        NULL DEFAULT 0 Comment "所属用户 0为公共数据",
    `cat_id`     BIGINT                                                        NULL DEFAULT 0 Comment "分类",
    `name`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "食物名称",
    `kal`        INT                                                           NULL Comment "每100g卡路里",
    `status`     TINYINT(1)                                                    NULL DEFAULT 1 Comment "状态 1可用 2不可用",
    `created_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "更新时间",
    INDEX `idx_cat_id` (`cat_id` ASC) USING BTREE,
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 19
  ROW_FORMAT = Dynamic COMMENT = "食物模板";
-- food_cat DDL
CREATE TABLE `food_cat`
(
    `id`         BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `name`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "分类名称",
    `pid`        BIGINT                                                        NULL DEFAULT 0 Comment "上级分类id",
    `sort`       INT                                                           NULL Comment "排序",
    `created_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    UNIQUE INDEX `name` (`name` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 37
  ROW_FORMAT = Dynamic COMMENT = "食品分类";
-- food_nutrition DDL
CREATE TABLE `food_nutrition`
(
    `id`         BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `food_id`    BIGINT                                                        NULL DEFAULT 0 Comment "食物id",
    `unit_id`    BIGINT                                                        NULL DEFAULT 0 Comment "单位",
    `number`     INT                                                           NULL DEFAULT 1 Comment "默认数量",
    `kal`        INT                                                           NULL Comment "卡路里",
    `protein`    INT                                                           NULL Comment "蛋白质",
    `fat`        INT                                                           NULL Comment "脂肪",
    `carbo`      INT                                                           NULL Comment "碳水化合物",
    `sugar`      INT                                                           NULL Comment "糖分",
    `fiber`      INT                                                           NULL DEFAULT 0 Comment "膳食纤维",
    `image`      VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "参考图片",
    `created_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    `desc`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    UNIQUE INDEX `food_id` (`food_id` ASC, `unit_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 16
  ROW_FORMAT = Dynamic COMMENT = "食物营养";
-- foods_unit DDL
CREATE TABLE `foods_unit`
(
    `id`         BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `name`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "单位名称",
    `created_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    UNIQUE INDEX `name` (`name` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 5
  ROW_FORMAT = Dynamic COMMENT = "食品单位";
-- likes DDL
CREATE TABLE `likes`
(
    `id`         BIGINT   NOT NULL AUTO_INCREMENT,
    `user_id`    BIGINT   NULL DEFAULT 0 Comment "用户id",
    `target`     BIGINT   NULL DEFAULT 0 Comment "目标id",
    `type`       TINYINT  NULL DEFAULT 0 Comment "类型 1 帖子 2 食物 3食谱 4 评论 5用户",
    `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic;
-- meal_checkin_relation DDL
CREATE TABLE `meal_checkin_relation`
(
    `id`         BIGINT NOT NULL AUTO_INCREMENT,
    `checkin_id` BIGINT NOT NULL,
    `meal_id`    BIGINT NOT NULL,
    INDEX `meal_id` (`meal_id` ASC) USING BTREE,
    UNIQUE INDEX `unique_relation` (`checkin_id` ASC, `meal_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 1
  ROW_FORMAT = Dynamic COMMENT = "打卡记录-就餐记录关系表";
-- meal_record DDL
CREATE TABLE `meal_record`
(
    `id`         BIGINT   NOT NULL AUTO_INCREMENT,
    `user_id`    BIGINT   NULL     DEFAULT 0 Comment "所属用户",
    `type`       TINYINT  NULL     DEFAULT 0 Comment "类型 0 早餐 1 午餐 2 晚餐 3加餐",
    `kal`        INT      NULL     DEFAULT 0 Comment "总卡路里",
    `fat`        INT      NULL Comment "总脂肪",
    `protein`    INT      NULL Comment "总蛋白质",
    `carbo`      INT      NULL Comment "总碳水",
    `sugar`      INT      NULL Comment "总糖",
    `fiber`      INT      NULL Comment "总纤维",
    `created_at` DATETIME NULL     DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME NULL     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    `meal_date`  DATE     NOT NULL DEFAULT 'curdate()',
    INDEX `idx_user_id_type` (`user_id` ASC, `type` ASC) USING BTREE,
    UNIQUE INDEX `uk_user_type_date` (`user_id` ASC, `type` ASC, `meal_date` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 11
  ROW_FORMAT = Dynamic COMMENT = "就餐记录";
-- meal_record_food DDL
CREATE TABLE `meal_record_food`
(
    `id`         BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `meal_id`    BIGINT                                                        NULL DEFAULT 0 Comment "就餐记录id",
    `user_id`    BIGINT                                                        NULL,
    `food_id`    BIGINT                                                        NULL DEFAULT 0 Comment "食物id",
    `unit_id`    BIGINT                                                        NULL DEFAULT 0 Comment "单位",
    `kal`        INT                                                           NULL Comment "卡路里",
    `protein`    INT                                                           NULL Comment "蛋白质",
    `fat`        INT                                                           NULL Comment "脂肪",
    `carbo`      INT                                                           NULL Comment "碳水化合物",
    `sugar`      INT                                                           NULL Comment "糖分",
    `fiber`      INT                                                           NULL Comment "纤维",
    `number`     INT                                                           NULL DEFAULT 1 Comment "分量",
    `image`      VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "图片",
    `name`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `address`    VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `latitude`   DECIMAL(10, 6)                                                NULL Comment "纬度",
    `longitude`  DECIMAL(10, 6)                                                NULL Comment "经度",
    `created_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    INDEX `idx_crated_at` (`created_at` ASC) USING BTREE,
    INDEX `idx_food_id` (`food_id` ASC) USING BTREE,
    INDEX `idx_meal_id` (`meal_id` ASC) USING BTREE,
    INDEX `idx_unit_id` (`unit_id` ASC) USING BTREE,
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 7
  ROW_FORMAT = Dynamic COMMENT = "就餐记录食物";
-- recipe DDL
CREATE TABLE `recipe`
(
    `id`         BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `user_id`    BIGINT                                                        NULL DEFAULT 0 Comment "用户id",
    `name`       VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `summary`    TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NULL,
    `content`    TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NULL,
    `like_count` INT                                                           NULL DEFAULT 0 Comment "点赞数量",
    `created_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic COMMENT = "食谱";
-- recipe_attach DDL
CREATE TABLE `recipe_attach`
(
    `id`         BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `recipe_id`  BIGINT                                                        NULL DEFAULT 0 Comment "食谱id",
    `attach`     VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `created_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    INDEX `idx_recipe_id` (`recipe_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic COMMENT = "食谱附件";
-- recipe_food DDL
CREATE TABLE `recipe_food`
(
    `id`         BIGINT         NOT NULL AUTO_INCREMENT,
    `recipe_id`  BIGINT         NULL DEFAULT 0 Comment "食谱id",
    `food_id`    BIGINT         NULL DEFAULT 0 Comment "食物id",
    `number`     DECIMAL(10, 2) NULL DEFAULT 0.00 Comment "分量",
    `created_at` DATETIME       NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    INDEX `idx_food_id` (`food_id` ASC) USING BTREE,
    INDEX `idx_recipe_id` (`recipe_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic;
-- user DDL
CREATE TABLE `user`
(
    `id`                  BIGINT                                                        NOT NULL AUTO_INCREMENT,
    `name`                VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `password`            VARCHAR(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL Comment "密码",
    `email`               VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `phone`               VARCHAR(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL Comment "手机号码",
    `openid`              VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL,
    `unionid`             VARCHAR(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL,
    `avatar`              VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' Comment "头像",
    `age`                 INT                                                           NULL DEFAULT 0 Comment "年龄",
    `gender`              TINYINT                                                       NULL DEFAULT 0 Comment "性别 1男2女",
    `weight`              DECIMAL(10, 2)                                                NULL Comment "体重 kg",
    `tall`                INT                                                           NULL Comment "身高 cm",
    `bmi`                 DECIMAL(10, 2)                                                NULL Comment "bmi",
    `bust`                DECIMAL(10, 2)                                                NULL Comment "胸围 cm",
    `waist`               DECIMAL(10, 2)                                                NULL Comment "腰围 cm",
    `hip`                 DECIMAL(10, 2)                                                NULL Comment "臀围 cm",
    `target`              INT                                                           NULL Comment "卡路里目标",
    `is_full`             TINYINT(1)                                                    NULL DEFAULT 0 Comment "上月是否全勤",
    `check_in_days`       INT                                                           NULL DEFAULT 0 Comment "连续打卡天数",
    `status`              TINYINT(1)                                                    NULL Comment "状态 1normal 2 forbiden",
    `created_at`          DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at`          DATETIME                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    `last_login_platform` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci         NULL Comment "最后登录平台",
    `last_login_time`     DATETIME                                                      NULL,
    `last_login_ip`       VARCHAR(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL,
    INDEX `idx_email` (`email` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 2
  ROW_FORMAT = Dynamic COMMENT = "用户";
-- user_account DDL
CREATE TABLE `user_account`
(
    `id`                    BIGINT         NOT NULL AUTO_INCREMENT,
    `user_id`               BIGINT         NULL DEFAULT 0 Comment "用户id",
    `weight`                DECIMAL(10, 2) NULL DEFAULT 65.00 Comment "体重 单位kg",
    `tall`                  DECIMAL(10, 2) NULL DEFAULT 170.00 Comment "身高 单位cm",
    `bust`                  DECIMAL(10, 2) NULL DEFAULT 90.00 Comment "胸围 单位cm",
    `waist`                 DECIMAL(10, 2) NULL DEFAULT 80.00 Comment "腰围 单位cm",
    `hip`                   DECIMAL(10, 2) NULL DEFAULT 90.00 Comment "臀线 单位cm",
    `full_attendance_month` TINYINT        NULL DEFAULT 0 Comment "上月是否全勤",
    `target`                INT            NULL DEFAULT 0 Comment "目标",
    `created_at`            DATETIME       NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at`            DATETIME       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
    INDEX `idx_user_id` (`user_id` ASC) USING BTREE,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = Dynamic COMMENT = "用户账号";
-- user_body_history DDL
CREATE TABLE `user_body_history`
(
    `id`         BIGINT         NOT NULL AUTO_INCREMENT,
    `user_id`    BIGINT         NULL DEFAULT 0 Comment "用户id",
    `tall`       INT            NULL DEFAULT 0 Comment "身高",
    `weight`     INT            NULL DEFAULT 0 Comment "体重",
    `bmi`        DECIMAL(10, 2) NULL DEFAULT 0.00 Comment "bmi",
    `waist`      DECIMAL(10, 2) NULL DEFAULT 0.00 Comment "腰围",
    `hip`        DECIMAL(10, 2) NULL DEFAULT 0.00 Comment "臀围",
    `bust`       DECIMAL(10, 2) NULL DEFAULT 0.00 Comment "胸围",
    `created_at` DATETIME       NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
    `updated_at` DATETIME       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) Comment "更新时间",
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  AUTO_INCREMENT = 1
  ROW_FORMAT = Dynamic COMMENT = "身体信息历史";
-- wa_admin_roles DDL
CREATE TABLE `wa_admin_roles`
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
-- wa_admins DDL
CREATE TABLE `wa_admins`
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
-- wa_options DDL
CREATE TABLE `wa_options`
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
  AUTO_INCREMENT = 16
  ROW_FORMAT = Dynamic COMMENT = "选项表";
-- wa_roles DDL
CREATE TABLE `wa_roles`
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
-- wa_rules DDL
CREATE TABLE `wa_rules`
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
-- wa_uploads DDL
CREATE TABLE `wa_uploads`
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
-- wa_users DDL
CREATE TABLE `wa_users`
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
  ROW_FORMAT = Dynamic COMMENT = "用户表";
-- meal_checkin_relation Indexes
ALTER TABLE `meal_checkin_relation`
    ADD CONSTRAINT `meal_checkin_relation_ibfk_1` FOREIGN KEY (`checkin_id`) REFERENCES `checkin_record` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
    ADD CONSTRAINT `meal_checkin_relation_ibfk_2` FOREIGN KEY (`meal_id`) REFERENCES `meal_record` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
-- food DML
INSERT INTO `food` (`id`, `user_id`, `cat_id`, `name`, `kal`, `status`, `created_at`, `updated_at`)
VALUES (9, 0, 1, '苹果', 52, 1, '2025-08-04 03:39:21', '2025-08-04 03:39:21'),
       (10, 0, 5, '馒头', 220, 1, '2025-08-04 03:52:07', '2025-08-04 03:52:07'),
       (11, 0, 32, '全脂牛奶粉', 478, 1, '2025-08-08 13:02:07', '2025-08-08 13:02:07'),
       (12, 0, 33, '牛奶饼干', 408, 1, '2025-08-08 13:02:07', '2025-08-08 13:02:07'),
       (13, 0, 34, '油条', 386, 1, '2025-08-09 01:34:20', '2025-08-09 01:34:20'),
       (14, 0, 34, '烧饼(加糖)', 293, 1, '2025-08-09 02:12:10', '2025-08-09 02:12:10'),
       (15, 0, 36, '面包', 83, 1, '2025-08-09 03:21:47', '2025-08-09 03:21:47'),
       (16, 0, 34, '烧饼', 293, 1, '2025-08-09 03:21:47', '2025-08-09 03:21:47'),
       (17, 0, 37, '菜花[花椰菜]', 24, 1, '2025-08-12 20:05:51', '2025-08-12 20:05:51'),
       (18, 0, 37, '菜花(脱水)[脱水花椰菜]', 286, 1, '2025-08-12 20:05:51', '2025-08-12 20:05:51');
-- food_cat DML
INSERT INTO `food_cat` (`id`, `name`, `pid`, `sort`, `created_at`, `updated_at`)
VALUES (1, '水果', 0, 0, '2025-08-03 21:20:17', '2025-08-03 21:20:17'),
       (2, '蔬菜', 0, 0, '2025-08-03 21:20:26', '2025-08-03 21:20:26'),
       (3, '肉类', 0, 0, '2025-08-03 21:21:33', '2025-08-03 21:21:33'),
       (4, '西瓜类', 1, NULL, '2025-08-03 22:44:40', '2025-08-03 22:44:40'),
       (5, '主食', 0, 0, '2025-08-04 03:48:37', '2025-08-09 01:35:52'),
       (32, '乳类', 0, NULL, '2025-08-08 13:02:08', '2025-08-08 13:02:08'),
       (33, '速食食品', 0, NULL, '2025-08-08 13:02:08', '2025-08-08 13:02:08'),
       (34, '谷类', 0, NULL, '2025-08-09 01:34:20', '2025-08-09 01:34:20'),
       (36, '鱼虾蟹贝', 0, NULL, '2025-08-09 03:21:47', '2025-08-09 03:21:47'),
       (37, '蔬菜类', 0, NULL, '2025-08-12 20:05:51', '2025-08-12 20:05:51');
-- food_nutrition DML
INSERT INTO `food_nutrition` (`id`, `food_id`, `unit_id`, `number`, `kal`, `protein`, `fat`, `carbo`, `sugar`, `fiber`,
                              `image`, `created_at`, `updated_at`, `desc`)
VALUES (2, 9, 1, 1, 52, 3, 3, 14, 10, 0, '/app/admin/upload/img/20250804/688fba40a2b9.png', '2025-08-04 03:39:21',
        '2025-08-08 12:07:27', NULL),
       (3, 9, 3, 1, 9500, 50, 30, 2500, 1900, 0, '/app/admin/upload/img/20250804/688fba80f934.png',
        '2025-08-04 03:39:21', '2025-08-08 11:59:29', NULL),
       (4, 10, 1, 1, 22000, 7, 1, 45, 1, 0, '', '2025-08-04 03:52:07', '2025-08-08 11:59:29', NULL),
       (5, 10, 3, 1, 220, 7, 1, 45, 1, 0, '', '2025-08-04 03:52:07', '2025-08-04 03:52:07', NULL),
       (6, 11, 1, 100, 478, 20, 21, 52, NULL, 0, NULL, '2025-08-08 13:02:07', '2025-08-08 13:02:07', '每100g含量'),
       (7, 12, 1, 100, 408, 8, 6, 80, NULL, 0, NULL, '2025-08-08 13:02:07', '2025-08-08 13:02:07', '每100g含量'),
       (8, 13, 1, 100, 386, 7, 18, 50, NULL, 0, NULL, '2025-08-09 01:34:20', '2025-08-09 01:34:20', '每100g含量'),
       (9, 14, 1, 100, 293, 8, 2, 61, NULL, 0, NULL, '2025-08-09 02:12:10', '2025-08-09 02:12:10', '每100g含量'),
       (10, 15, 1, 100, 83, 18, 1, 1, NULL, 0, NULL, '2025-08-09 03:21:47', '2025-08-09 03:21:47', '每100g含量'),
       (11, 16, 1, 100, 293, 8, 2, 61, NULL, 0, NULL, '2025-08-09 03:21:47', '2025-08-09 03:21:47', '每100g含量'),
       (15, 17, 1, 100, 24, 2, 0, 3, NULL, 0, NULL, '2025-08-12 20:05:51', '2025-08-12 20:05:51', '每100g含量'),
       (16, 18, 1, 100, 286, 7, 1, 64, NULL, 0, NULL, '2025-08-12 20:05:51', '2025-08-12 20:05:51', '每100g含量');
-- foods_unit DML
INSERT INTO `foods_unit` (`id`, `name`, `created_at`, `updated_at`)
VALUES (1, '克', '2025-08-04 01:49:01', '2025-08-04 01:49:01'),
       (2, '杯', '2025-08-04 01:49:08', '2025-08-04 01:49:08'),
       (3, '个', '2025-08-04 01:49:15', '2025-08-04 01:49:15'),
       (4, '颗', '2025-08-04 01:49:22', '2025-08-04 01:49:22');
-- meal_record DML
INSERT INTO `meal_record` (`id`, `user_id`, `type`, `kal`, `fat`, `protein`, `carbo`, `sugar`, `fiber`, `created_at`,
                           `updated_at`, `meal_date`)
VALUES (6, 1, 0, 293, 2, 8, 61, 0, 0, '2025-08-09 12:40:09', '2025-08-09 12:40:09', '2025-08-09'),
       (7, 1, 1, 376, 3, 26, 62, 0, 0, '2025-08-09 14:40:47', '2025-08-09 18:23:37', '2025-08-09'),
       (8, 1, 0, 408, 6, 8, 80, 0, 0, '2025-08-10 19:19:45', '2025-08-10 19:19:45', '2025-08-10'),
       (9, 1, 0, 386, 18, 7, 50, 0, 0, '2025-08-11 12:05:17', '2025-08-11 12:05:17', '2025-08-11'),
       (10, 1, 0, 293, 2, 8, 61, 0, 0, '2025-08-12 20:35:49', '2025-08-12 20:35:49', '2025-08-12');
-- meal_record_food DML
INSERT INTO `meal_record_food` (`id`, `meal_id`, `user_id`, `food_id`, `unit_id`, `kal`, `protein`, `fat`, `carbo`,
                                `sugar`, `fiber`, `number`, `image`, `name`, `address`, `latitude`, `longitude`,
                                `created_at`, `updated_at`)
VALUES (1, 6, 1, 16, 1, 293, 8, 2, 61, 0, 0, 100, NULL, NULL, NULL, NULL, NULL, '2025-08-09 12:40:09',
        '2025-08-09 12:40:09'),
       (2, 7, 1, 16, 1, 293, 8, 2, 61, 0, 0, 100, 'uploads/20250809/6896418939352.png', '郑州市金水区人民政府 东风路北',
        '河南省郑州市金水区东风路16号', 34.799770, 113.660720, '2025-08-09 14:40:47', '2025-08-09 18:38:16'),
       (3, 7, 1, 15, 1, 83, 18, 1, 1, 0, 0, 100, 'uploads/20250809/6896418939352.png', '郑州市金水区人民政府 东风路北',
        '河南省郑州市金水区东风路16号', 34.799770, 113.660720, '2025-08-09 18:23:37', '2025-08-09 18:38:16'),
       (4, 8, 1, 12, 1, 408, 8, 6, 80, 0, 0, 100, NULL, '安竞电竞酒店 郑州科技市场店',
        '河南省郑州市金水区太平洋安防大厦 东风路北', 34.799914, 113.662046, '2025-08-10 19:19:45',
        '2025-08-10 19:19:45'),
       (5, 9, 1, 13, 1, 386, 7, 18, 50, 0, 0, 100, NULL, '静泊容慢酒店 文化路郑州轻工业大学东风校区店',
        '河南省郑州市金水区东风路16号', 34.799864, 113.661646, '2025-08-11 12:05:17', '2025-08-11 12:05:17'),
       (6, 10, 1, 16, 1, 293, 8, 2, 61, 0, 0, 100, NULL, '郑州市金水区人民政府', '河南省郑州市金水区东风路16号',
        34.799770, 113.660720, '2025-08-12 20:35:49', '2025-08-12 20:35:49');
-- user DML
INSERT INTO `user` (`id`, `name`, `password`, `email`, `phone`, `openid`, `unionid`, `avatar`, `age`, `gender`,
                    `weight`, `tall`, `bmi`, `bust`, `waist`, `hip`, `target`, `is_full`, `check_in_days`, `status`,
                    `created_at`, `updated_at`, `last_login_platform`, `last_login_time`, `last_login_ip`)
VALUES (1, 'LazyPanda8089', NULL, NULL, NULL, 'oWogM5OC6XubXR33X4ub8FSNFfkE', '',
        '/uploads/avatar/5195173d0a0b0938b98c513335799d28.png', 25, 1, 65.00, 175, NULL, NULL, NULL, NULL, 1200, 0, 0,
        1, '2025-08-07 22:58:26', '2025-08-13 18:36:01',
        'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0.1 Mobile/21A360 Safari/604.1 wechatdevtools/1.06.2504010 MicroMessenger/8.0.5 Language/zh_CN webview/ sessionid/1',
        '2025-08-13 18:36:01', '192.168.31.238');
-- wa_admin_roles DML
INSERT INTO `wa_admin_roles` (`id`, `role_id`, `admin_id`)
VALUES (1, 1, 1);
-- wa_admins DML
INSERT INTO `wa_admins` (`id`, `username`, `nickname`, `password`, `avatar`, `email`, `mobile`, `created_at`,
                         `updated_at`, `login_at`, `status`)
VALUES (1, 'eatMeal', '超级管理员', '$2y$10$wOZzNbqD645.dM1V.MSi1eWIcwFA1t7vXmkFM4ItLWzZW/.DTYJle',
        '/app/admin/avatar.png', NULL, NULL, '2025-08-03 21:36:53', '2025-08-03 22:25:17', '2025-08-03 22:25:17', NULL);
-- wa_options DML
INSERT INTO `wa_options` (`id`, `name`, `value`, `created_at`, `updated_at`)
VALUES (1, 'system_config',
        '{"logo":{"title":"Webman Admin","image":"\\/app\\/admin\\/admin\\/images\\/logo.png"},"menu":{"data":"\\/app\\/admin\\/rule\\/get","method":"GET","accordion":true,"collapse":false,"control":false,"controlWidth":500,"select":"0","async":true},"tab":{"enable":true,"keepState":true,"preload":false,"session":true,"max":"30","index":{"id":"0","href":"\\/app\\/admin\\/index\\/dashboard","title":"\\u4eea\\u8868\\u76d8"}},"theme":{"defaultColor":"2","defaultMenu":"light-theme","defaultHeader":"light-theme","allowCustom":true,"banner":false},"colors":[{"id":"1","color":"#36b368","second":"#f0f9eb"},{"id":"2","color":"#2d8cf0","second":"#ecf5ff"},{"id":"3","color":"#f6ad55","second":"#fdf6ec"},{"id":"4","color":"#f56c6c","second":"#fef0f0"},{"id":"5","color":"#3963bc","second":"#ecf5ff"}],"other":{"keepLoad":"500","autoHead":false,"footer":false},"header":{"message":false}}',
        '2022-12-05 14:49:01', '2022-12-08 20:20:28'),
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
       (9, 'dict_sex', '[{"value":"0","name":"女"},{"value":"1","name":"男"}]', '2022-12-04 15:04:40',
        '2022-12-04 15:04:40'),
       (10, 'dict_status', '[{"value":"0","name":"正常"},{"value":"1","name":"禁用"}]', '2022-12-04 15:05:09',
        '2022-12-04 15:05:09'),
       (11, 'table_form_schema_wa_admin_roles',
        '{"id":{"field":"id","_field_id":"0","comment":"主键","control":"inputNumber","control_args":"","list_show":true,"enable_sort":true,"searchable":true,"search_type":"normal","form_show":false},"role_id":{"field":"role_id","_field_id":"1","comment":"角色id","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"admin_id":{"field":"admin_id","_field_id":"2","comment":"管理员id","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-12-20 19:42:51'),
       (12, 'dict_dict_name',
        '[{"value":"dict_name","name":"字典名称"},{"value":"status","name":"启禁用状态"},{"value":"sex","name":"性别"},{"value":"upload","name":"附件分类"}]',
        '2022-08-15 00:00:00', '2022-12-20 19:42:51'),
       (13, 'table_form_schema_food_cat',
        '{"id":{"field":"id","_field_id":"0","comment":"","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"name":{"field":"name","_field_id":"1","comment":"分类名称","control":"input","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"pid":{"field":"pid","_field_id":"2","comment":"上级分类id","control":"treeSelect","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"sort":{"field":"sort","_field_id":"3","comment":"排序","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"4","comment":"创建时间","control":"dateTimePicker","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"updated_at":{"field":"updated_at","_field_id":"5","comment":"","control":"dateTimePicker","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-08-15 00:00:00'),
       (14, 'table_form_schema_food',
        '{"id":{"field":"id","_field_id":"0","comment":"","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"user_id":{"field":"user_id","_field_id":"1","comment":"所属用户 0为公共数据","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"cat_id":{"field":"cat_id","_field_id":"2","comment":"分类","control":"select","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"name":{"field":"name","_field_id":"3","comment":"食物名称","control":"input","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"kal":{"field":"kal","_field_id":"4","comment":"每100g卡路里","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"5","comment":"创建时间","control":"dateTimePicker","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"updated_at":{"field":"updated_at","_field_id":"6","comment":"更新时间","control":"dateTimePicker","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-08-15 00:00:00'),
       (15, 'table_form_schema_foods_unit',
        '{"id":{"field":"id","_field_id":"0","comment":"","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"name":{"field":"name","_field_id":"1","comment":"单位名称","control":"input","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"2","comment":"创建时间","control":"dateTimePicker","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"updated_at":{"field":"updated_at","_field_id":"3","comment":"","control":"dateTimePicker","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-08-15 00:00:00'),
       (16, 'table_form_schema_food_nutrition',
        '{"id":{"field":"id","_field_id":"0","comment":"","control":"inputNumber","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"food_id":{"field":"food_id","_field_id":"1","comment":"食物id","control":"select","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"unit_id":{"field":"unit_id","_field_id":"2","comment":"单位","control":"select","control_args":"","form_show":true,"list_show":true,"searchable":true,"search_type":"normal","enable_sort":false},"number":{"field":"number","_field_id":"3","comment":"默认数量","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"kal":{"field":"kal","_field_id":"4","comment":"卡路里","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"protein":{"field":"protein","_field_id":"5","comment":"蛋白质","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"fat":{"field":"fat","_field_id":"6","comment":"脂肪","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"carbo":{"field":"carbo","_field_id":"7","comment":"碳水化合物","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"sugar":{"field":"sugar","_field_id":"8","comment":"糖分","control":"inputNumber","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"image":{"field":"image","_field_id":"9","comment":"参考图片","control":"uploadImage","control_args":"","form_show":true,"list_show":true,"search_type":"normal","enable_sort":false,"searchable":false},"created_at":{"field":"created_at","_field_id":"10","comment":"创建时间","control":"dateTimePicker","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false},"updated_at":{"field":"updated_at","_field_id":"11","comment":"","control":"dateTimePicker","control_args":"","list_show":true,"search_type":"normal","form_show":false,"enable_sort":false,"searchable":false}}',
        '2022-08-15 00:00:00', '2022-08-15 00:00:00');
-- wa_roles DML
INSERT INTO `wa_roles` (`id`, `name`, `rules`, `created_at`, `updated_at`, `pid`)
VALUES (1, '超级管理员', '*', '2022-08-13 16:15:01', '2022-12-23 12:05:07', NULL);
-- wa_rules DML
INSERT INTO `wa_rules` (`id`, `title`, `icon`, `key`, `pid`, `created_at`, `updated_at`, `href`, `type`, `weight`)
VALUES (1, '数据库', 'layui-icon-template-1', 'database', 0, '2025-08-03 21:36:36', '2025-08-03 21:36:36', NULL, 0,
        1000),
       (2, '所有表', NULL, 'plugin\\admin\\app\\controller\\TableController', 1, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/table/index', 1, 800),
       (3, '权限管理', 'layui-icon-vercode', 'auth', 0, '2025-08-03 21:36:36', '2025-08-03 21:36:36', NULL, 0, 900),
       (4, '账户管理', NULL, 'plugin\\admin\\app\\controller\\AdminController', 3, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/admin/index', 1, 1000),
       (5, '角色管理', NULL, 'plugin\\admin\\app\\controller\\RoleController', 3, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/role/index', 1, 900),
       (6, '菜单管理', NULL, 'plugin\\admin\\app\\controller\\RuleController', 3, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/rule/index', 1, 800),
       (7, '会员管理', 'layui-icon-username', 'user', 0, '2025-08-03 21:36:36', '2025-08-03 21:36:36', NULL, 0, 800),
       (8, '用户', NULL, 'plugin\\admin\\app\\controller\\UserController', 7, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/user/index', 1, 800),
       (9, '通用设置', 'layui-icon-set', 'common', 0, '2025-08-03 21:36:36', '2025-08-03 21:36:36', NULL, 0, 700),
       (10, '个人资料', NULL, 'plugin\\admin\\app\\controller\\AccountController', 9, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/account/index', 1, 800),
       (11, '附件管理', NULL, 'plugin\\admin\\app\\controller\\UploadController', 9, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/upload/index', 1, 700),
       (12, '字典设置', NULL, 'plugin\\admin\\app\\controller\\DictController', 9, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/dict/index', 1, 600),
       (13, '系统设置', NULL, 'plugin\\admin\\app\\controller\\ConfigController', 9, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/config/index', 1, 500),
       (14, '插件管理', 'layui-icon-app', 'plugin', 0, '2025-08-03 21:36:36', '2025-08-03 21:36:36', NULL, 0, 600),
       (15, '应用插件', NULL, 'plugin\\admin\\app\\controller\\PluginController', 14, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/plugin/index', 1, 800),
       (16, '开发辅助', 'layui-icon-fonts-code', 'dev', 0, '2025-08-03 21:36:36', '2025-08-03 21:36:36', NULL, 0, 500),
       (17, '表单构建', NULL, 'plugin\\admin\\app\\controller\\DevController', 16, '2025-08-03 21:36:36',
        '2025-08-03 21:36:36', '/app/admin/dev/form-build', 1, 800),
       (18, '示例页面', 'layui-icon-templeate-1', 'demos', 0, '2025-08-03 21:36:36', '2025-08-03 21:36:36', NULL, 0,
        400),
       (19, '工作空间', 'layui-icon-console', 'demo1', 18, '2025-08-03 21:36:36', '2025-08-03 21:36:36', '', 0, 0),
       (20, '控制后台', 'layui-icon-console', 'demo10', 19, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/console/console1.html', 1, 0),
       (21, '数据分析', 'layui-icon-console', 'demo13', 19, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/console/console2.html', 1, 0),
       (22, '百度一下', 'layui-icon-console', 'demo14', 19, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        'http://www.baidu.com', 1, 0),
       (23, '主题预览', 'layui-icon-console', 'demo15', 19, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/system/theme.html', 1, 0),
       (24, '常用组件', 'layui-icon-component', 'demo20', 18, '2025-08-03 21:36:36', '2025-08-03 21:36:36', '', 0, 0),
       (25, '功能按钮', 'layui-icon-face-smile', 'demo2011', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/button.html', 1, 0),
       (26, '表单集合', 'layui-icon-face-cry', 'demo2014', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/form.html', 1, 0),
       (27, '字体图标', 'layui-icon-face-cry', 'demo2010', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/icon.html', 1, 0),
       (28, '多选下拉', 'layui-icon-face-cry', 'demo2012', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/select.html', 1, 0),
       (29, '动态标签', 'layui-icon-face-cry', 'demo2013', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/tag.html', 1, 0),
       (30, '数据表格', 'layui-icon-face-cry', 'demo2031', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/table.html', 1, 0),
       (31, '分布表单', 'layui-icon-face-cry', 'demo2032', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/step.html', 1, 0),
       (32, '树形表格', 'layui-icon-face-cry', 'demo2033', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/treetable.html', 1, 0),
       (33, '树状结构', 'layui-icon-face-cry', 'demo2034', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/dtree.html', 1, 0),
       (34, '文本编辑', 'layui-icon-face-cry', 'demo2035', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/tinymce.html', 1, 0),
       (35, '卡片组件', 'layui-icon-face-cry', 'demo2036', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/card.html', 1, 0),
       (36, '抽屉组件', 'layui-icon-face-cry', 'demo2021', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/drawer.html', 1, 0),
       (37, '消息通知', 'layui-icon-face-cry', 'demo2022', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/notice.html', 1, 0),
       (38, '加载组件', 'layui-icon-face-cry', 'demo2024', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/loading.html', 1, 0),
       (39, '弹层组件', 'layui-icon-face-cry', 'demo2023', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/popup.html', 1, 0),
       (40, '多选项卡', 'layui-icon-face-cry', 'demo60131', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/tab.html', 1, 0),
       (41, '数据菜单', 'layui-icon-face-cry', 'demo60132', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/menu.html', 1, 0),
       (42, '哈希加密', 'layui-icon-face-cry', 'demo2041', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/encrypt.html', 1, 0),
       (43, '图标选择', 'layui-icon-face-cry', 'demo2042', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/iconPicker.html', 1, 0),
       (44, '省市级联', 'layui-icon-face-cry', 'demo2043', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/area.html', 1, 0),
       (45, '数字滚动', 'layui-icon-face-cry', 'demo2044', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/count.html', 1, 0),
       (46, '顶部返回', 'layui-icon-face-cry', 'demo2045', 24, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/document/topBar.html', 1, 0),
       (47, '结果页面', 'layui-icon-auz', 'demo666', 18, '2025-08-03 21:36:36', '2025-08-03 21:36:36', '', 0, 0),
       (48, '成功', 'layui-icon-face-smile', 'demo667', 47, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/result/success.html', 1, 0),
       (49, '失败', 'layui-icon-face-cry', 'demo668', 47, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/result/error.html', 1, 0),
       (50, '错误页面', 'layui-icon-face-cry', 'demo-error', 18, '2025-08-03 21:36:36', '2025-08-03 21:36:36', '', 0,
        0),
       (51, '403', 'layui-icon-face-smile', 'demo403', 50, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/error/403.html', 1, 0),
       (52, '404', 'layui-icon-face-cry', 'demo404', 50, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/error/404.html', 1, 0),
       (53, '500', 'layui-icon-face-cry', 'demo500', 50, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/error/500.html', 1, 0),
       (54, '系统管理', 'layui-icon-set-fill', 'demo-system', 18, '2025-08-03 21:36:36', '2025-08-03 21:36:36', '', 0,
        0),
       (55, '用户管理', 'layui-icon-face-smile', 'demo601', 54, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/system/user.html', 1, 0),
       (56, '角色管理', 'layui-icon-face-cry', 'demo602', 54, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/system/role.html', 1, 0),
       (57, '权限管理', 'layui-icon-face-cry', 'demo603', 54, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/system/power.html', 1, 0),
       (58, '部门管理', 'layui-icon-face-cry', 'demo604', 54, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/system/deptment.html', 1, 0),
       (59, '行为日志', 'layui-icon-face-cry', 'demo605', 54, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/system/log.html', 1, 0),
       (60, '数据字典', 'layui-icon-face-cry', 'demo606', 54, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/system/dict.html', 1, 0),
       (61, '常用页面', 'layui-icon-template-1', 'demo-common', 18, '2025-08-03 21:36:36', '2025-08-03 21:36:36', '', 0,
        0),
       (62, '空白页面', 'layui-icon-face-smile', 'demo702', 61, '2025-08-03 21:36:36', '2025-08-03 21:36:36',
        '/app/admin/demos/system/space.html', 1, 0),
       (63, '查看表', NULL, 'plugin\\admin\\app\\controller\\TableController@view', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (64, '查询表', NULL, 'plugin\\admin\\app\\controller\\TableController@show', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (65, '创建表', NULL, 'plugin\\admin\\app\\controller\\TableController@create', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (66, '修改表', NULL, 'plugin\\admin\\app\\controller\\TableController@modify', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (67, '一键菜单', NULL, 'plugin\\admin\\app\\controller\\TableController@crud', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (68, '查询记录', NULL, 'plugin\\admin\\app\\controller\\TableController@select', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (69, '插入记录', NULL, 'plugin\\admin\\app\\controller\\TableController@insert', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (70, '更新记录', NULL, 'plugin\\admin\\app\\controller\\TableController@update', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (71, '删除记录', NULL, 'plugin\\admin\\app\\controller\\TableController@delete', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (72, '删除表', NULL, 'plugin\\admin\\app\\controller\\TableController@drop', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (73, '表摘要', NULL, 'plugin\\admin\\app\\controller\\TableController@schema', 2, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (74, '插入', NULL, 'plugin\\admin\\app\\controller\\AdminController@insert', 4, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (75, '更新', NULL, 'plugin\\admin\\app\\controller\\AdminController@update', 4, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (76, '删除', NULL, 'plugin\\admin\\app\\controller\\AdminController@delete', 4, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (77, '插入', NULL, 'plugin\\admin\\app\\controller\\RoleController@insert', 5, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (78, '更新', NULL, 'plugin\\admin\\app\\controller\\RoleController@update', 5, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (79, '删除', NULL, 'plugin\\admin\\app\\controller\\RoleController@delete', 5, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (80, '获取角色权限', NULL, 'plugin\\admin\\app\\controller\\RoleController@rules', 5, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (81, '查询', NULL, 'plugin\\admin\\app\\controller\\RuleController@select', 6, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (82, '添加', NULL, 'plugin\\admin\\app\\controller\\RuleController@insert', 6, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (83, '更新', NULL, 'plugin\\admin\\app\\controller\\RuleController@update', 6, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (84, '删除', NULL, 'plugin\\admin\\app\\controller\\RuleController@delete', 6, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (85, '插入', NULL, 'plugin\\admin\\app\\controller\\UserController@insert', 8, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (86, '更新', NULL, 'plugin\\admin\\app\\controller\\UserController@update', 8, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (87, '查询', NULL, 'plugin\\admin\\app\\controller\\UserController@select', 8, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (88, '删除', NULL, 'plugin\\admin\\app\\controller\\UserController@delete', 8, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (89, '更新', NULL, 'plugin\\admin\\app\\controller\\AccountController@update', 10, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (90, '修改密码', NULL, 'plugin\\admin\\app\\controller\\AccountController@password', 10, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (91, '查询', NULL, 'plugin\\admin\\app\\controller\\AccountController@select', 10, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (92, '添加', NULL, 'plugin\\admin\\app\\controller\\AccountController@insert', 10, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (93, '删除', NULL, 'plugin\\admin\\app\\controller\\AccountController@delete', 10, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (94, '浏览附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@attachment', 11, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (95, '查询附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@select', 11, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (96, '更新附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@update', 11, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (97, '添加附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@insert', 11, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (98, '上传文件', NULL, 'plugin\\admin\\app\\controller\\UploadController@file', 11, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (99, '上传图片', NULL, 'plugin\\admin\\app\\controller\\UploadController@image', 11, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (100, '上传头像', NULL, 'plugin\\admin\\app\\controller\\UploadController@avatar', 11, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (101, '删除附件', NULL, 'plugin\\admin\\app\\controller\\UploadController@delete', 11, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (102, '查询', NULL, 'plugin\\admin\\app\\controller\\DictController@select', 12, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (103, '插入', NULL, 'plugin\\admin\\app\\controller\\DictController@insert', 12, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (104, '更新', NULL, 'plugin\\admin\\app\\controller\\DictController@update', 12, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (105, '删除', NULL, 'plugin\\admin\\app\\controller\\DictController@delete', 12, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (106, '更改', NULL, 'plugin\\admin\\app\\controller\\ConfigController@update', 13, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (107, '列表', NULL, 'plugin\\admin\\app\\controller\\PluginController@list', 15, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (108, '安装', NULL, 'plugin\\admin\\app\\controller\\PluginController@install', 15, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (109, '卸载', NULL, 'plugin\\admin\\app\\controller\\PluginController@uninstall', 15, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (110, '支付', NULL, 'plugin\\admin\\app\\controller\\PluginController@pay', 15, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (111, '登录官网', NULL, 'plugin\\admin\\app\\controller\\PluginController@login', 15, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (112, '获取已安装的插件列表', NULL, 'plugin\\admin\\app\\controller\\PluginController@getInstalledPlugins', 15,
        '2025-08-03 22:25:28', '2025-08-03 22:25:28', NULL, 2, 0),
       (113, '表单构建', NULL, 'plugin\\admin\\app\\controller\\DevController@formBuild', 17, '2025-08-03 22:25:28',
        '2025-08-03 22:25:28', NULL, 2, 0),
       (114, '食品库管理', 'layui-icon-water', 'food', NULL, '2025-08-03 22:25:59', '2025-08-04 01:47:23', '', 0, 0),
       (115, '食品分类', '', 'plugin\\admin\\app\\controller\\FoodCatController', 114, '2025-08-03 22:26:18',
        '2025-08-03 22:26:18', '/app/admin/food-cat/index', 1, 0),
       (116, '插入', NULL, 'plugin\\admin\\app\\controller\\FoodCatController@insert', 115, '2025-08-03 22:26:24',
        '2025-08-03 22:26:24', NULL, 2, 0),
       (117, '更新', NULL, 'plugin\\admin\\app\\controller\\FoodCatController@update', 115, '2025-08-03 22:26:24',
        '2025-08-03 22:26:24', NULL, 2, 0),
       (118, '查询', NULL, 'plugin\\admin\\app\\controller\\FoodCatController@select', 115, '2025-08-03 22:26:24',
        '2025-08-03 22:26:24', NULL, 2, 0),
       (119, '删除', NULL, 'plugin\\admin\\app\\controller\\FoodCatController@delete', 115, '2025-08-03 22:26:24',
        '2025-08-03 22:26:24', NULL, 2, 0),
       (120, '食品列表', '', 'plugin\\admin\\app\\controller\\FoodController', 114, '2025-08-03 22:26:38',
        '2025-08-03 22:26:38', '/app/admin/food/index', 1, 0),
       (121, '插入', NULL, 'plugin\\admin\\app\\controller\\FoodController@insert', 120, '2025-08-03 22:26:42',
        '2025-08-03 22:26:42', NULL, 2, 0),
       (122, '更新', NULL, 'plugin\\admin\\app\\controller\\FoodController@update', 120, '2025-08-03 22:26:42',
        '2025-08-03 22:26:42', NULL, 2, 0),
       (123, '查询', NULL, 'plugin\\admin\\app\\controller\\FoodController@select', 120, '2025-08-03 22:26:42',
        '2025-08-03 22:26:42', NULL, 2, 0),
       (124, '删除', NULL, 'plugin\\admin\\app\\controller\\FoodController@delete', 120, '2025-08-03 22:26:42',
        '2025-08-03 22:26:42', NULL, 2, 0),
       (125, '食品单位', '', 'plugin\\admin\\app\\controller\\FoodsUnitController', 114, '2025-08-03 22:26:51',
        '2025-08-03 22:26:51', '/app/admin/foods-unit/index', 1, 0),
       (126, '插入', NULL, 'plugin\\admin\\app\\controller\\FoodsUnitController@insert', 125, '2025-08-03 22:26:55',
        '2025-08-03 22:26:55', NULL, 2, 0),
       (127, '更新', NULL, 'plugin\\admin\\app\\controller\\FoodsUnitController@update', 125, '2025-08-03 22:26:55',
        '2025-08-03 22:26:55', NULL, 2, 0),
       (128, '查询', NULL, 'plugin\\admin\\app\\controller\\FoodsUnitController@select', 125, '2025-08-03 22:26:55',
        '2025-08-03 22:26:55', NULL, 2, 0),
       (129, '删除', NULL, 'plugin\\admin\\app\\controller\\FoodsUnitController@delete', 125, '2025-08-03 22:26:55',
        '2025-08-03 22:26:55', NULL, 2, 0),
       (130, '每单位营养成分', '', 'plugin\\admin\\app\\controller\\FoodNutritionController', 120,
        '2025-08-03 22:27:08', '2025-08-04 04:36:29', '/app/admin/food-nutrition/index', 2, 0),
       (131, '插入', NULL, 'plugin\\admin\\app\\controller\\FoodNutritionController@insert', 130, '2025-08-03 22:30:22',
        '2025-08-03 22:30:22', NULL, 2, 0),
       (132, '更新', NULL, 'plugin\\admin\\app\\controller\\FoodNutritionController@update', 130, '2025-08-03 22:30:22',
        '2025-08-03 22:30:22', NULL, 2, 0),
       (133, '查询', NULL, 'plugin\\admin\\app\\controller\\FoodNutritionController@select', 130, '2025-08-03 22:30:22',
        '2025-08-03 22:30:22', NULL, 2, 0),
       (134, '删除', NULL, 'plugin\\admin\\app\\controller\\FoodNutritionController@delete', 130, '2025-08-03 22:30:22',
        '2025-08-03 22:30:22', NULL, 2, 0);
SET FOREIGN_KEY_CHECKS = 1;
