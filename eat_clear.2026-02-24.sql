SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;
-- blog DDL
CREATE TABLE `blog` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`user_id` BIGINT NULL DEFAULT 0 Comment "用户id",
`title` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' Comment "标题",
`like` INT NULL DEFAULT 0 Comment "点赞数量",
`view` INT NULL DEFAULT 0 Comment "浏览数量",
`comment` INT NULL DEFAULT 0 Comment "评论数量",
`fav` INT NULL DEFAULT 0 Comment "收藏数量",
`content` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
`status` TINYINT(1) NULL Comment "状态 0隐藏 1所有人可见 2仅自己可见 3仅好友可见",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci AUTO_INCREMENT = 9 ROW_FORMAT = Dynamic COMMENT = "博客";
-- blog_attach DDL
CREATE TABLE `blog_attach` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`blog_id` BIGINT NULL DEFAULT 0 Comment "博客id",
`attach` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
`poster` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "视频封面",
`sort` INT NULL DEFAULT 0 Comment "排序",
`type` TINYINT NULL DEFAULT 0 Comment "类型 0 图片 1 视频 3食物 4食谱 5就餐记录",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
INDEX `idx_blog_id`(`blog_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci AUTO_INCREMENT = 14 ROW_FORMAT = Dynamic COMMENT = "博客附件";
-- blog_comment DDL
CREATE TABLE `blog_comment` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`blog_id` BIGINT NULL DEFAULT 0 Comment "博客id",
`user_id` BIGINT NULL DEFAULT 0 Comment "用户id",
`content` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
`parent_id` BIGINT NULL DEFAULT 0 Comment "父评论id",
`like_count` INT NULL DEFAULT 0 Comment "点赞数量",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
INDEX `idx_blog_id`(`blog_id` ASC) USING BTREE,
INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci AUTO_INCREMENT = 1 ROW_FORMAT = Dynamic COMMENT = "博客评论";
-- blog_location DDL
CREATE TABLE `blog_location` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`blog_id` BIGINT NOT NULL,
`latitude` DECIMAL(10,6) NOT NULL,
`longitude` DECIMAL(10,6) NOT NULL,
`name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
`address` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci AUTO_INCREMENT = 4 ROW_FORMAT = Dynamic COMMENT = "博客位置表";
-- blog_topic DDL
CREATE TABLE `blog_topic` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`blog_id` BIGINT NOT NULL,
`topic_id` BIGINT NOT NULL,
UNIQUE INDEX `idx_blog_topic`(`blog_id` ASC,`topic_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci AUTO_INCREMENT = 2 ROW_FORMAT = Dynamic COMMENT = "博客话题表";
-- cats DDL
CREATE TABLE `cats` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "分类名称",
`pid` BIGINT NULL DEFAULT 0 Comment "上级分类",
`sort` INT NULL Comment "排序",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) Comment "编辑时间",
UNIQUE INDEX `name`(`name` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci AUTO_INCREMENT = 19 ROW_FORMAT = Dynamic COMMENT = "食品分类";
-- checkin_record DDL
CREATE TABLE `checkin_record` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`user_id` BIGINT NOT NULL,
`target_calorie` INT NOT NULL Comment "当日目标卡路里",
`total_calorie` INT NOT NULL Comment "当日摄入总卡路里",
`result` ENUM("success","fail_over","fail_under") CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL Comment "打卡结果",
`date` DATE NOT NULL Comment "打卡日期，一个用户一天一条记录",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
UNIQUE INDEX `idx_user_id_date`(`user_id` ASC,`date` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci AUTO_INCREMENT = 1 ROW_FORMAT = Dynamic COMMENT = "打卡记录";
-- favorite DDL
CREATE TABLE `favorite` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`user_id` BIGINT NULL DEFAULT 0 Comment "用户id",
`target` BIGINT NULL DEFAULT 0 Comment "食物id",
`type` TINYINT NULL DEFAULT 0 Comment "类型 1 帖子 2 食物 3食谱",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
UNIQUE INDEX `idx_user_id_type_target`(`user_id` ASC,`type` ASC,`target` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci AUTO_INCREMENT = 3 ROW_FORMAT = Dynamic;
-- follow DDL
CREATE TABLE `follow` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`user_id` BIGINT NULL DEFAULT 0 Comment "用户id",
`follow_id` BIGINT NULL DEFAULT 0 Comment "关注id",
`is_attention` TINYINT(1) NULL DEFAULT 0 Comment "是否互相关注 0否 1是",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
UNIQUE INDEX `idx_user_follow_id`(`user_id` ASC,`follow_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci AUTO_INCREMENT = 1 ROW_FORMAT = Dynamic;
-- food_tags DDL
CREATE TABLE `food_tags` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
`food_id` INT UNSIGNED NOT NULL Comment "食物ID",
`tag_id` INT UNSIGNED NOT NULL Comment "标签ID",
UNIQUE INDEX `uk_food_tag`(`food_id` ASC,`tag_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci AUTO_INCREMENT = 4167 ROW_FORMAT = Dynamic COMMENT = "食物标签关联表";
-- food_units DDL
CREATE TABLE `food_units` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT Comment "主键ID",
`food_id` INT UNSIGNED NOT NULL Comment "食物ID",
`unit_id` INT UNSIGNED NOT NULL Comment "单位ID",
`weight` DECIMAL(10,2) NOT NULL Comment "换算重量 (1单位 ≈ ? g)",
`is_default` TINYINT(1) NOT NULL DEFAULT 0 Comment "是否为默认单位",
`remark` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL Comment "备注 (如: 杯(约250ml))",
INDEX `fk_foodunit_unit`(`unit_id` ASC) USING BTREE,
UNIQUE INDEX `uk_food_unit`(`food_id` ASC,`unit_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci AUTO_INCREMENT = 4063 ROW_FORMAT = Dynamic COMMENT = "食物单位换算关系表";
-- foods DDL
CREATE TABLE `foods` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT Comment "食物ID",
`name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL Comment "食物名称",
`cat_id` INT UNSIGNED NULL Comment "食物分类",
`user_id` INT UNSIGNED NULL Comment "所属用户",
`status` TINYINT NOT NULL DEFAULT 1 Comment "状态",
`nutrition` JSON NULL Comment "每100g的营养信息",
`created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) Comment "更新时间",
`delete_at` TIMESTAMP NULL,
INDEX `idx_cat_id`(`cat_id` ASC) USING BTREE,
INDEX `idx_name`(`name` ASC,`status` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci AUTO_INCREMENT = 2161 ROW_FORMAT = Dynamic COMMENT = "食物基础信息与营养表";
-- meal_record DDL
CREATE TABLE `meal_record` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`user_id` BIGINT NULL DEFAULT 0 Comment "所属用户",
`type` TINYINT NULL DEFAULT 0 Comment "类型 0 早餐 1 午餐 2 晚餐 3加餐",
`nutrition` JSON NULL Comment "营养信息",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
`meal_date` DATE NOT NULL DEFAULT 'curdate()',
`latitude` DECIMAL(10,6) NULL Comment "纬度",
`longitude` DECIMAL(10,6) NULL Comment "经度",
`address` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
INDEX `idx_user_id_type`(`user_id` ASC,`type` ASC) USING BTREE,
UNIQUE INDEX `uk_user_type_date`(`user_id` ASC,`type` ASC,`meal_date` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci AUTO_INCREMENT = 4 ROW_FORMAT = Dynamic COMMENT = "就餐记录";
-- meal_record_food DDL
CREATE TABLE `meal_record_food` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`meal_id` BIGINT NULL DEFAULT 0 Comment "就餐记录id",
`user_id` BIGINT NULL,
`food_id` BIGINT NULL DEFAULT 0 Comment "食物id",
`unit_id` BIGINT NULL DEFAULT 0 Comment "单位",
`nutrition` JSON NULL Comment "营养成分",
`number` DECIMAL(10,2) NULL DEFAULT 1.00 Comment "分量",
`image` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL Comment "图片",
`name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
INDEX `idx_crated_at`(`created_at` ASC) USING BTREE,
INDEX `idx_food_id`(`food_id` ASC) USING BTREE,
INDEX `idx_meal_id`(`meal_id` ASC) USING BTREE,
INDEX `idx_unit_id`(`unit_id` ASC) USING BTREE,
INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci AUTO_INCREMENT = 5 ROW_FORMAT = Dynamic COMMENT = "就餐记录食物";
-- recipe DDL
CREATE TABLE `recipe` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`user_id` BIGINT NULL DEFAULT 0 Comment "用户id",
`name` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
`summary` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
`content` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
`like_count` INT NULL DEFAULT 0 Comment "点赞数量",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic COMMENT = "食谱";
-- recipe_attach DDL
CREATE TABLE `recipe_attach` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`recipe_id` BIGINT NULL DEFAULT 0 Comment "食谱id",
`attach` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
INDEX `idx_recipe_id`(`recipe_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic COMMENT = "食谱附件";
-- recipe_food DDL
CREATE TABLE `recipe_food` (`id` BIGINT NOT NULL AUTO_INCREMENT,
`recipe_id` BIGINT NULL DEFAULT 0 Comment "食谱id",
`food_id` BIGINT NULL DEFAULT 0 Comment "食物id",
`number` DECIMAL(10,2) NULL DEFAULT 0.00 Comment "分量",
`created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP Comment "创建时间",
`updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0),
INDEX `idx_food_id`(`food_id` ASC) USING BTREE,
INDEX `idx_recipe_id`(`recipe_id` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;
-- tags DDL
CREATE TABLE `tags` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
`name` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL Comment "标签名称",
`type` TINYINT NOT NULL DEFAULT 1 Comment "类型: 1-餐次(早餐/午餐等), 2-口味, 3-营养特点(低糖/少油)",
`created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
UNIQUE INDEX `uk_name`(`name` ASC) USING BTREE,
PRIMARY KEY (`id`)) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci AUTO_INCREMENT = 56 ROW_FORMAT = Dynamic COMMENT = "标签表";
SET FOREIGN_KEY_CHECKS = 1;
