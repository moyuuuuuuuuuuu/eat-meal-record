-- ----------------------------
-- Table structure for blog
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog`
(
    `id`            bigint NOT NULL AUTO_INCREMENT,
    `user_id`       bigint NULL DEFAULT 0 COMMENT '用户id',
    `title`         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '标题',
    `like_count`    int UNSIGNED NULL DEFAULT 0 COMMENT '点赞数量',
    `view_count`    int UNSIGNED NULL DEFAULT 0 COMMENT '查看数量',
    `comment_count` int UNSIGNED NULL DEFAULT 0 COMMENT '评论数量',
    `fav_count`     int UNSIGNED NULL DEFAULT 0 COMMENT '收藏数量',
    `content`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `status`        tinyint(1) NULL DEFAULT NULL COMMENT '状态 0隐藏 1所有人可见 2仅自己可见 3仅好友可见',
    `created_at`    datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`    datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX           `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '博客' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for blog_attach
-- ----------------------------
DROP TABLE IF EXISTS `blog_attach`;
CREATE TABLE `blog_attach`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `blog_id`    bigint NULL DEFAULT 0 COMMENT '博客id',
    `attach`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
    `poster`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '视频封面',
    `sort`       int NULL DEFAULT 0 COMMENT '排序',
    `type`       tinyint NULL DEFAULT 0 COMMENT '类型 0 图片 1 视频 3食物 4食谱 5就餐记录',
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX        `idx_blog_id`(`blog_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '博客附件' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for blog_comment
-- ----------------------------
DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `blog_id`    bigint NULL DEFAULT 0 COMMENT '博客id',
    `user_id`    bigint NULL DEFAULT 0 COMMENT '用户id',
    `content`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `parent_id`  bigint NULL DEFAULT 0 COMMENT '父评论id',
    `like_count` int NULL DEFAULT 0 COMMENT '点赞数量',
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX        `idx_blog_id`(`blog_id` ASC) USING BTREE,
    INDEX        `idx_user_id`(`user_id` ASC) USING BTREE,
    INDEX        `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '博客评论' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog_comment
-- ----------------------------

-- ----------------------------
-- Table structure for blog_location
-- ----------------------------
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '博客位置表' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for blog_topic
-- ----------------------------
DROP TABLE IF EXISTS `blog_topic`;
CREATE TABLE `blog_topic`
(
    `id`       bigint NOT NULL AUTO_INCREMENT,
    `blog_id`  bigint NOT NULL,
    `topic_id` bigint NOT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_blog_topic`(`blog_id` ASC, `topic_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '博客话题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog_topic
-- ----------------------------

-- ----------------------------
-- Table structure for checkin_record
-- ----------------------------
DROP TABLE IF EXISTS `checkin_record`;
CREATE TABLE `checkin_record`
(
    `id`             bigint NOT NULL AUTO_INCREMENT,
    `user_id`        bigint NOT NULL,
    `target_calorie` int    NOT NULL COMMENT '当日目标卡路里',
    `total_calorie`  int    NOT NULL COMMENT '当日摄入总卡路里',
    `result`         enum('success','fail_over','fail_under') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '打卡结果',
    `date`           date   NOT NULL COMMENT '打卡日期，一个用户一天一条记录',
    `created_at`     datetime NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_user_id_date`(`user_id` ASC, `date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '打卡记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of checkin_record
-- ----------------------------

-- ----------------------------
-- Table structure for favorite
-- ----------------------------
DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `user_id`    bigint NULL DEFAULT 0 COMMENT '用户id',
    `target`     bigint NULL DEFAULT 0 COMMENT '食物id',
    `type`       tinyint NULL DEFAULT 0 COMMENT '类型 1 帖子 2 食物 3食谱',
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_user_id_type_target`(`user_id` ASC, `type` ASC, `target` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of favorite
-- ----------------------------

-- ----------------------------
-- Table structure for follow
-- ----------------------------
DROP TABLE IF EXISTS `follow`;
CREATE TABLE `follow`
(
    `id`           bigint NOT NULL AUTO_INCREMENT,
    `user_id`      bigint NULL DEFAULT 0 COMMENT '用户id',
    `follow_id`    bigint NULL DEFAULT 0 COMMENT '关注id',
    `is_attention` tinyint(1) NULL DEFAULT 0 COMMENT '是否互相关注 0否 1是',
    `created_at`   datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`   datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_user_follow_id`(`user_id` ASC, `follow_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of follow
-- ----------------------------

-- ----------------------------
-- Table structure for meal_record
-- ----------------------------
DROP TABLE IF EXISTS `meal_record`;
CREATE TABLE `meal_record`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `user_id`    bigint NULL DEFAULT 0 COMMENT '所属用户',
    `type`       tinyint NULL DEFAULT 0 COMMENT '类型 0 早餐 1 午餐 2 晚餐 3加餐',
    `nutrition`  json NULL COMMENT '营养信息',
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `meal_date`  date   NOT NULL DEFAULT (curdate()),
    `latitude`   decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
    `longitude`  decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
    `address`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uk_user_type_date`(`user_id` ASC, `type` ASC, `meal_date` ASC) USING BTREE,
    INDEX        `idx_user_id_type`(`user_id` ASC, `type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '就餐记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of meal_record
-- ----------------------------

-- ----------------------------
-- Table structure for meal_record_food
-- ----------------------------
DROP TABLE IF EXISTS `meal_record_food`;
CREATE TABLE `meal_record_food`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `meal_id`    bigint NULL DEFAULT 0 COMMENT '就餐记录id',
    `user_id`    bigint NULL DEFAULT NULL,
    `food_id`    bigint NULL DEFAULT 0 COMMENT '食物id',
    `unit_id`    bigint NULL DEFAULT 0 COMMENT '单位',
    `nutrition`  json NULL COMMENT '营养成分',
    `number`     decimal(10, 2) NULL DEFAULT 1.00 COMMENT '分量',
    `image`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片',
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX        `idx_meal_id`(`meal_id` ASC) USING BTREE,
    INDEX        `idx_food_id`(`food_id` ASC) USING BTREE,
    INDEX        `idx_unit_id`(`unit_id` ASC) USING BTREE,
    INDEX        `idx_user_id`(`user_id` ASC) USING BTREE,
    INDEX        `idx_crated_at`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '就餐记录食物' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of meal_record_food
-- ----------------------------

-- ----------------------------
-- Table structure for recipe
-- ----------------------------
DROP TABLE IF EXISTS `recipe`;
CREATE TABLE `recipe`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `user_id`    bigint NULL DEFAULT 0 COMMENT '用户id',
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
    `summary`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `content`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `like_count` int NULL DEFAULT 0 COMMENT '点赞数量',
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX        `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '食谱' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recipe
-- ----------------------------

-- ----------------------------
-- Table structure for recipe_attach
-- ----------------------------
DROP TABLE IF EXISTS `recipe_attach`;
CREATE TABLE `recipe_attach`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `recipe_id`  bigint NULL DEFAULT 0 COMMENT '食谱id',
    `attach`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX        `idx_recipe_id`(`recipe_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '食谱附件' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recipe_attach
-- ----------------------------

-- ----------------------------
-- Table structure for recipe_food
-- ----------------------------
DROP TABLE IF EXISTS `recipe_food`;
CREATE TABLE `recipe_food`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `recipe_id`  bigint NULL DEFAULT 0 COMMENT '食谱id',
    `food_id`    bigint NULL DEFAULT 0 COMMENT '食物id',
    `number`     decimal(10, 2) NULL DEFAULT 0.00 COMMENT '分量',
    `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    INDEX        `idx_recipe_id`(`recipe_id` ASC) USING BTREE,
    INDEX        `idx_food_id`(`food_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recipe_food
-- ----------------------------

-- ----------------------------
-- Table structure for topic
-- ----------------------------
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`
(
    `id`          bigint                                                        NOT NULL AUTO_INCREMENT COMMENT '话题ID',
    `title`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '话题标题',
    `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '话题封面图片',
    `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '话题描述',
    `creator_id`  bigint                                                        NOT NULL COMMENT '创建者用户ID',
    `status`      tinyint NULL DEFAULT 1 COMMENT '状态 1正常 0禁用',
    `join_count`  int NULL DEFAULT 0 COMMENT '参与人数',
    `post_count`  int NULL DEFAULT 0 COMMENT '关联文章/餐食记录数',
    `created_at`  datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`  datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX         `idx_creator_id`(`creator_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '话题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic
-- ----------------------------

-- ----------------------------
-- Table structure for topic_relation
-- ----------------------------
DROP TABLE IF EXISTS `topic_relation`;
CREATE TABLE `topic_relation`
(
    `id`          bigint  NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `topic_id`    bigint  NOT NULL COMMENT '话题ID',
    `target_id`   bigint  NOT NULL COMMENT '关联对象ID（博客ID、餐食记录ID等）',
    `target_type` tinyint NOT NULL COMMENT '关联类型 1博客 2餐食记录 3其他',
    `created_at`  datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `idx_topic_target`(`topic_id` ASC, `target_type` ASC, `target_id` ASC) USING BTREE,
    INDEX         `idx_target`(`target_id` ASC, `target_type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '话题关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic_relation
-- ----------------------------

