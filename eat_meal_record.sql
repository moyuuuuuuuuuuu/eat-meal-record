/*
 Navicat Premium Dump SQL

 Source Server         : docker
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : 127.0.0.1:3306
 Source Schema         : eat_meal_record

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 22/08/2025 02:36:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for blog
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT 0 COMMENT '用户id',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '标题',
  `like_count` int UNSIGNED NULL DEFAULT 0 COMMENT '点赞数量',
  `view_count` int UNSIGNED NULL DEFAULT 0 COMMENT '查看数量',
  `comment_count` int UNSIGNED NULL DEFAULT 0 COMMENT '评论数量',
  `fav_count` int UNSIGNED NULL DEFAULT 0 COMMENT '收藏数量',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态 0隐藏 1所有人可见 2仅自己可见 3仅好友可见',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '博客' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for blog_attach
-- ----------------------------
DROP TABLE IF EXISTS `blog_attach`;
CREATE TABLE `blog_attach`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blog_id` bigint NULL DEFAULT 0 COMMENT '博客id',
  `attach` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `poster` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '视频封面',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `type` tinyint NULL DEFAULT 0 COMMENT '类型 0 图片 1 视频 3食物 4食谱 5就餐记录',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_blog_id`(`blog_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '博客附件' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for blog_comment
-- ----------------------------
DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blog_id` bigint NULL DEFAULT 0 COMMENT '博客id',
  `user_id` bigint NULL DEFAULT 0 COMMENT '用户id',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父评论id',
  `like_count` int NULL DEFAULT 0 COMMENT '点赞数量',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_blog_id`(`blog_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '博客评论' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog_comment
-- ----------------------------

-- ----------------------------
-- Table structure for blog_location
-- ----------------------------
DROP TABLE IF EXISTS `blog_location`;
CREATE TABLE `blog_location`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blog_id` bigint NOT NULL,
  `latitude` decimal(10, 6) NOT NULL,
  `longitude` decimal(10, 6) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '博客位置表' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for blog_topic
-- ----------------------------
DROP TABLE IF EXISTS `blog_topic`;
CREATE TABLE `blog_topic`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blog_id` bigint NOT NULL,
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
CREATE TABLE `checkin_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `target_calorie` int NOT NULL COMMENT '当日目标卡路里',
  `total_calorie` int NOT NULL COMMENT '当日摄入总卡路里',
  `result` enum('success','fail_over','fail_under') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '打卡结果',
  `date` date NOT NULL COMMENT '打卡日期，一个用户一天一条记录',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
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
CREATE TABLE `favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT 0 COMMENT '用户id',
  `target` bigint NULL DEFAULT 0 COMMENT '食物id',
  `type` tinyint NULL DEFAULT 0 COMMENT '类型 1 帖子 2 食物 3食谱',
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
CREATE TABLE `follow`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT 0 COMMENT '用户id',
  `follow_id` bigint NULL DEFAULT 0 COMMENT '关注id',
  `is_attention` tinyint(1) NULL DEFAULT 0 COMMENT '是否互相关注 0否 1是',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_user_follow_id`(`user_id` ASC, `follow_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of follow
-- ----------------------------

-- ----------------------------
-- Table structure for food
-- ----------------------------
DROP TABLE IF EXISTS `food`;
CREATE TABLE `food`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT 0 COMMENT '所属用户 0为公共数据',
  `cat_id` bigint NULL DEFAULT 0 COMMENT '分类',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '食物名称',
  `kal` int NULL DEFAULT NULL COMMENT '每100g卡路里',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '状态 1可用 2不可用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_cat_id`(`cat_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '食物模板' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of food
-- ----------------------------


-- ----------------------------
-- Table structure for food_cat
-- ----------------------------
DROP TABLE IF EXISTS `food_cat`;
CREATE TABLE `food_cat`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类名称',
  `pid` bigint NULL DEFAULT 0 COMMENT '上级分类id',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '食品分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of food_cat
-- ----------------------------


-- ----------------------------
-- Table structure for food_nutrition
-- ----------------------------
DROP TABLE IF EXISTS `food_nutrition`;
CREATE TABLE `food_nutrition`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `food_id` bigint NULL DEFAULT 0 COMMENT '食物id',
  `unit_id` bigint NULL DEFAULT 0 COMMENT '单位',
  `number` int NULL DEFAULT 1 COMMENT '默认数量',
  `kal` int NULL DEFAULT NULL COMMENT '卡路里',
  `protein` int NULL DEFAULT NULL COMMENT '蛋白质',
  `fat` int NULL DEFAULT NULL COMMENT '脂肪',
  `carbo` int NULL DEFAULT NULL COMMENT '碳水化合物',
  `sugar` int NULL DEFAULT NULL COMMENT '糖分',
  `fiber` int NULL DEFAULT 0 COMMENT '膳食纤维',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '参考图片',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `food_id`(`food_id` ASC, `unit_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '食物营养' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of food_nutrition
-- ----------------------------

-- ----------------------------
-- Table structure for foods_unit
-- ----------------------------
DROP TABLE IF EXISTS `foods_unit`;
CREATE TABLE `foods_unit`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位名称',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '食品单位' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of foods_unit
-- ----------------------------


-- ----------------------------
-- Table structure for likes
-- ----------------------------
DROP TABLE IF EXISTS `likes`;
CREATE TABLE `likes`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT 0 COMMENT '用户id',
  `target` bigint NULL DEFAULT 0 COMMENT '目标id',
  `type` tinyint NULL DEFAULT 0 COMMENT '类型 1 帖子 2 食物 3食谱 4 评论 5用户',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `utt_idx`(`user_id` ASC, `type` ASC, `target` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of likes
-- ----------------------------

-- ----------------------------
-- Table structure for meal_checkin_relation
-- ----------------------------
DROP TABLE IF EXISTS `meal_checkin_relation`;
CREATE TABLE `meal_checkin_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `checkin_id` bigint NOT NULL,
  `meal_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_relation`(`checkin_id` ASC, `meal_id` ASC) USING BTREE,
  INDEX `meal_id`(`meal_id` ASC) USING BTREE,
  CONSTRAINT `meal_checkin_relation_ibfk_1` FOREIGN KEY (`checkin_id`) REFERENCES `checkin_record` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `meal_checkin_relation_ibfk_2` FOREIGN KEY (`meal_id`) REFERENCES `meal_record` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '打卡记录-就餐记录关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of meal_checkin_relation
-- ----------------------------

-- ----------------------------
-- Table structure for meal_record
-- ----------------------------
DROP TABLE IF EXISTS `meal_record`;
CREATE TABLE `meal_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT 0 COMMENT '所属用户',
  `type` tinyint NULL DEFAULT 0 COMMENT '类型 0 早餐 1 午餐 2 晚餐 3加餐',
  `kal` int NULL DEFAULT 0 COMMENT '总卡路里',
  `fat` int NULL DEFAULT NULL COMMENT '总脂肪',
  `protein` int NULL DEFAULT NULL COMMENT '总蛋白质',
  `carbo` int NULL DEFAULT NULL COMMENT '总碳水',
  `sugar` int NULL DEFAULT NULL COMMENT '总糖',
  `fiber` int NULL DEFAULT NULL COMMENT '总纤维',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `meal_date` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_type_date`(`user_id` ASC, `type` ASC, `meal_date` ASC) USING BTREE,
  INDEX `idx_user_id_type`(`user_id` ASC, `type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '就餐记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of meal_record
-- ----------------------------

-- ----------------------------
-- Table structure for meal_record_food
-- ----------------------------
DROP TABLE IF EXISTS `meal_record_food`;
CREATE TABLE `meal_record_food`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `meal_id` bigint NULL DEFAULT 0 COMMENT '就餐记录id',
  `user_id` bigint NULL DEFAULT NULL,
  `food_id` bigint NULL DEFAULT 0 COMMENT '食物id',
  `unit_id` bigint NULL DEFAULT 0 COMMENT '单位',
  `kal` int NULL DEFAULT NULL COMMENT '卡路里',
  `protein` int NULL DEFAULT NULL COMMENT '蛋白质',
  `fat` int NULL DEFAULT NULL COMMENT '脂肪',
  `carbo` int NULL DEFAULT NULL COMMENT '碳水化合物',
  `sugar` int NULL DEFAULT NULL COMMENT '糖分',
  `fiber` int NULL DEFAULT NULL COMMENT '纤维',
  `number` int NULL DEFAULT 1 COMMENT '分量',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图片',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `latitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_meal_id`(`meal_id` ASC) USING BTREE,
  INDEX `idx_food_id`(`food_id` ASC) USING BTREE,
  INDEX `idx_unit_id`(`unit_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_crated_at`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '就餐记录食物' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of meal_record_food
-- ----------------------------

-- ----------------------------
-- Table structure for recipe
-- ----------------------------
DROP TABLE IF EXISTS `recipe`;
CREATE TABLE `recipe`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NULL DEFAULT 0 COMMENT '用户id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `like_count` int NULL DEFAULT 0 COMMENT '点赞数量',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '食谱' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recipe
-- ----------------------------

-- ----------------------------
-- Table structure for recipe_attach
-- ----------------------------
DROP TABLE IF EXISTS `recipe_attach`;
CREATE TABLE `recipe_attach`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `recipe_id` bigint NULL DEFAULT 0 COMMENT '食谱id',
  `attach` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_recipe_id`(`recipe_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '食谱附件' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recipe_attach
-- ----------------------------

-- ----------------------------
-- Table structure for recipe_food
-- ----------------------------
DROP TABLE IF EXISTS `recipe_food`;
CREATE TABLE `recipe_food`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `recipe_id` bigint NULL DEFAULT 0 COMMENT '食谱id',
  `food_id` bigint NULL DEFAULT 0 COMMENT '食物id',
  `number` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '分量',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_recipe_id`(`recipe_id` ASC) USING BTREE,
  INDEX `idx_food_id`(`food_id` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recipe_food
-- ----------------------------

-- ----------------------------
-- Table structure for topic
-- ----------------------------
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '话题ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '话题标题',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '话题封面图片',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '话题描述',
  `creator_id` bigint NOT NULL COMMENT '创建者用户ID',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态 1正常 0禁用',
  `join_count` int NULL DEFAULT 0 COMMENT '参与人数',
  `post_count` int NULL DEFAULT 0 COMMENT '关联文章/餐食记录数',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_creator_id`(`creator_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '话题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic
-- ----------------------------

-- ----------------------------
-- Table structure for topic_relation
-- ----------------------------
DROP TABLE IF EXISTS `topic_relation`;
CREATE TABLE `topic_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `topic_id` bigint NOT NULL COMMENT '话题ID',
  `target_id` bigint NOT NULL COMMENT '关联对象ID（博客ID、餐食记录ID等）',
  `target_type` tinyint NOT NULL COMMENT '关联类型 1博客 2餐食记录 3其他',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_topic_target`(`topic_id` ASC, `target_type` ASC, `target_id` ASC) USING BTREE,
  INDEX `idx_target`(`target_id` ASC, `target_type` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '话题关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of topic_relation
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `password` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号码',
  `openid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `unionid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '头像',
  `signature` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '个性签名',
  `background` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '背景图',
  `age` int NULL DEFAULT 0 COMMENT '年龄',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `gender` tinyint NULL DEFAULT 0 COMMENT '性别 1男2女',
  `weight` decimal(10, 2) NULL DEFAULT NULL COMMENT '体重 kg',
  `tall` int NULL DEFAULT NULL COMMENT '身高 cm',
  `bmi` decimal(10, 2) NULL DEFAULT NULL COMMENT 'bmi',
  `bust` decimal(10, 2) NULL DEFAULT NULL COMMENT '胸围 cm',
  `waist` decimal(10, 2) NULL DEFAULT NULL COMMENT '腰围 cm',
  `hip` decimal(10, 2) NULL DEFAULT NULL COMMENT '臀围 cm',
  `target` int NULL DEFAULT NULL COMMENT '卡路里目标',
  `is_full` tinyint(1) NULL DEFAULT 0 COMMENT '上月是否全勤',
  `check_in_days` int NULL DEFAULT 0 COMMENT '连续打卡天数',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态 1normal 2 forbiden',
  `like_count` int UNSIGNED NULL DEFAULT 0 COMMENT '点赞数量',
  `view_count` int UNSIGNED NULL DEFAULT 0 COMMENT '浏览数量',
  `fav_count` int UNSIGNED NULL DEFAULT 0 COMMENT '收藏数量',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login_platform` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '最后登录平台',
  `last_login_time` datetime NULL DEFAULT NULL,
  `last_login_ip` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------


-- ----------------------------
-- Table structure for wa_admin_roles
-- ----------------------------
DROP TABLE IF EXISTS `wa_admin_roles`;
CREATE TABLE `wa_admin_roles`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `role_id` int NOT NULL COMMENT '角色id',
  `admin_id` int NOT NULL COMMENT '管理员id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_admin_id`(`role_id` ASC, `admin_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wa_admin_roles
-- ----------------------------

-- ----------------------------
-- Table structure for wa_admins
-- ----------------------------
DROP TABLE IF EXISTS `wa_admins`;
CREATE TABLE `wa_admins`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `nickname` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '昵称',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '/app/admin/avatar.png' COMMENT '头像',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `login_at` datetime NULL DEFAULT NULL COMMENT '登录时间',
  `status` tinyint NULL DEFAULT NULL COMMENT '禁用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wa_admins
-- ----------------------------

-- ----------------------------
-- Table structure for wa_options
-- ----------------------------
DROP TABLE IF EXISTS `wa_options`;
CREATE TABLE `wa_options`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '键',
  `value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '值',
  `created_at` datetime NOT NULL DEFAULT '2022-08-15 00:00:00' COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT '2022-08-15 00:00:00' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '选项表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wa_options
-- ----------------------------

-- ----------------------------
-- Table structure for wa_roles
-- ----------------------------
DROP TABLE IF EXISTS `wa_roles`;
CREATE TABLE `wa_roles`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色组',
  `rules` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '权限',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `pid` int UNSIGNED NULL DEFAULT NULL COMMENT '父级',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wa_roles
-- ----------------------------

-- ----------------------------
-- Table structure for wa_rules
-- ----------------------------
DROP TABLE IF EXISTS `wa_rules`;
CREATE TABLE `wa_rules`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标识',
  `pid` int UNSIGNED NULL DEFAULT 0 COMMENT '上级菜单',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间',
  `href` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'url',
  `type` int NOT NULL DEFAULT 1 COMMENT '类型',
  `weight` int NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 135 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '权限规则' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wa_rules
-- ----------------------------
-- ----------------------------
-- Table structure for wa_uploads
-- ----------------------------
DROP TABLE IF EXISTS `wa_uploads`;
CREATE TABLE `wa_uploads`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件',
  `admin_id` int NULL DEFAULT NULL COMMENT '管理员',
  `file_size` int NOT NULL COMMENT '文件大小',
  `mime_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'mime类型',
  `image_width` int NULL DEFAULT NULL COMMENT '图片宽度',
  `image_height` int NULL DEFAULT NULL COMMENT '图片高度',
  `ext` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '扩展名',
  `storage` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'local' COMMENT '存储位置',
  `created_at` date NULL DEFAULT NULL COMMENT '上传时间',
  `category` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类别',
  `updated_at` date NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `category`(`category` ASC) USING BTREE,
  INDEX `admin_id`(`admin_id` ASC) USING BTREE,
  INDEX `name`(`name` ASC) USING BTREE,
  INDEX `ext`(`ext` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '附件' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wa_uploads
-- ----------------------------

-- ----------------------------
-- Table structure for wa_users
-- ----------------------------
DROP TABLE IF EXISTS `wa_users`;
CREATE TABLE `wa_users`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `nickname` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '昵称',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `sex` enum('0','1') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '性别',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机',
  `level` tinyint NOT NULL DEFAULT 0 COMMENT '等级',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `money` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '余额(元)',
  `score` int NOT NULL DEFAULT 0 COMMENT '积分',
  `last_time` datetime NULL DEFAULT NULL COMMENT '登录时间',
  `last_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '登录ip',
  `join_time` datetime NULL DEFAULT NULL COMMENT '注册时间',
  `join_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '注册ip',
  `token` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'token',
  `created_at` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `role` int NOT NULL DEFAULT 1 COMMENT '角色',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '禁用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `join_time`(`join_time` ASC) USING BTREE,
  INDEX `mobile`(`mobile` ASC) USING BTREE,
  INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of wa_users
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
