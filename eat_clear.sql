-- blog_attaches ddl
CREATE TABLE `blog_attaches`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `blog_id`    bigint                                                        DEFAULT '0' COMMENT '博客id',
    `attach`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `poster`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '视频封面',
    `sort`       int                                                           DEFAULT '0' COMMENT '排序',
    `type`       tinyint                                                       DEFAULT '0' COMMENT '类型 0 图片 1 视频 3食物 4食谱 5就餐记录',
    `created_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    KEY `idx_blog_id` (`blog_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 19
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC COMMENT ='博客附件';
-- blog_comments ddl
CREATE TABLE `blog_comments`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `blog_id`    bigint   DEFAULT '0' COMMENT '博客id',
    `user_id`    bigint   DEFAULT '0' COMMENT '用户id',
    `content`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `parent_id`  bigint   DEFAULT '0' COMMENT '父评论id',
    `like`       int      DEFAULT '0' COMMENT '点赞数量',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    KEY `idx_blog_id` (`blog_id`) USING BTREE,
    KEY `idx_user_id` (`user_id`) USING BTREE,
    KEY `idx_parent_id` (`parent_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC COMMENT ='博客评论';
-- blog_locations ddl
CREATE TABLE `blog_locations`
(
    `id`        bigint                                                        NOT NULL AUTO_INCREMENT,
    `blog_id`   bigint                                                        NOT NULL,
    `latitude`  decimal(10, 6)                                                NOT NULL,
    `longitude` decimal(10, 6)                                                NOT NULL,
    `name`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `address`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 9
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = DYNAMIC COMMENT ='博客位置表';
-- blog_topics ddl
CREATE TABLE `blog_topics`
(
    `id`       bigint NOT NULL AUTO_INCREMENT,
    `blog_id`  bigint NOT NULL,
    `topic_id` bigint NOT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `idx_blog_topic` (`blog_id`, `topic_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 3
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = DYNAMIC COMMENT ='博客话题表';
-- blogs ddl
CREATE TABLE `blogs`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `user_id`    bigint                                                        DEFAULT '0' COMMENT '用户id',
    `title`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '标题',
    `like`       int unsigned                                                  DEFAULT '0' COMMENT '点赞数量',
    `view`       int unsigned                                                  DEFAULT '0' COMMENT '查看数量',
    `comment`    int unsigned                                                  DEFAULT '0' COMMENT '评论数量',
    `fav`        int unsigned                                                  DEFAULT '0' COMMENT '收藏数量',
    `content`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `visibility` tinyint(1)                                                    DEFAULT NULL COMMENT '状态 0隐藏 1所有人可见 2仅自己可见 3仅好友可见',
    `created_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    KEY `idx_user_id` (`user_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 16
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC COMMENT ='博客';
-- cats ddl
CREATE TABLE `cats`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分类名称',
    `pid`        bigint                                                        DEFAULT '0' COMMENT '上级分类',
    `sort`       int                                                           DEFAULT NULL COMMENT '排序',
    `created_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '编辑时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 19
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC COMMENT ='食品分类';
-- checkin_records ddl
CREATE TABLE `checkin_records`
(
    `id`             bigint                                                                                     NOT NULL AUTO_INCREMENT,
    `user_id`        bigint                                                                                     NOT NULL,
    `target_calorie` int                                                                                        NOT NULL COMMENT '当日目标卡路里',
    `total_calorie`  int                                                                                        NOT NULL COMMENT '当日摄入总卡路里',
    `result`         enum ('success','fail_over','fail_under') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '打卡结果',
    `date`           date                                                                                       NOT NULL COMMENT '打卡日期，一个用户一天一条记录',
    `created_at`     datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at`     datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `idx_user_id_date` (`user_id`, `date`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC COMMENT ='打卡记录';
-- favorites ddl
CREATE TABLE `favorites`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `user_id`    bigint   DEFAULT '0' COMMENT '用户id',
    `target`     bigint   DEFAULT '0' COMMENT '食物id',
    `type`       tinyint  DEFAULT '0' COMMENT '类型 1 帖子 2 食物 3食谱',
    `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `user_target_type` (`user_id`, `target`, `type`),
    KEY `target_type` (`target`, `type`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 3
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC;
-- follows ddl
CREATE TABLE `follows`
(
    `id`           bigint NOT NULL AUTO_INCREMENT,
    `user_id`      bigint     DEFAULT '0' COMMENT '用户id',
    `follow_id`    bigint     DEFAULT '0' COMMENT '关注id',
    `is_attention` tinyint(1) DEFAULT '0' COMMENT '是否互相关注 0否 1是',
    `created_at`   datetime   DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`   datetime   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `idx_user_follow_id` (`user_id`, `follow_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC;
-- food_nutrients ddl
CREATE TABLE `food_nutrients`
(
    `id`                         bigint                                                       NOT NULL AUTO_INCREMENT,
    `food_id`                    bigint                                                       NOT NULL COMMENT '所属食物',
    `water`                      double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '水分(g/100g)',
    `kcal`                       double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '热量(千卡/100g)',
    `protein`                    double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '蛋白质(g/100g)',
    `fat`                        double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '脂肪(g/100g)',
    `carbohydrate`               double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '碳水化合物(g/100g)',
    `fiber`                      double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '不溶性膳食纤维(g/100g)',
    `sodium`                     double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '钠(mg/100g)',
    `cholesterol`                double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '胆固醇(mg/100g)',
    `vitamin_a`                  double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '维生素a(μg/100g)',
    `calcium`                    double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '钙(mg/100g)',
    `iron`                       double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '铁(mg/100g)',
    `kalium`                     double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '钾(mg/100g)',
    `magnesium`                  double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '镁(mg/100g)',
    `zinc`                       double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '锌(mg/100g)',
    `selenium`                   double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '硒(μg/100g)',
    `cuprum`                     double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '铜(mg/100g)',
    `manganese`                  double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '锰(mg/100g)',
    `iodine`                     double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '碘(μg/100g)',
    `folic`                      double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '叶酸(mg/100g)',
    `fatty_acid`                 double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '脂肪酸(g/100g可食部)',
    `saturated_fatty_acid`       double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '饱和脂肪酸(g/100g可食部)',
    `monounsaturated_fatty_acid` double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '单不饱和脂肪酸(g/100g可食部)',
    `polyunsaturated_fatty_acid` double(10, 2)                                                NOT NULL DEFAULT '0.00' COMMENT '多不饱和脂肪酸(g/100g可食部)',
    `origin_place`               varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '备注/原产地',
    PRIMARY KEY (`id`),
    KEY `idx_food_id` (`food_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
-- food_tags ddl
CREATE TABLE `food_tags`
(
    `id`      int unsigned NOT NULL AUTO_INCREMENT,
    `food_id` int unsigned NOT NULL COMMENT '食物ID',
    `tag_id`  int unsigned NOT NULL COMMENT '标签ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_food_tag` (`food_id`, `tag_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 4167
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT ='食物标签关联表';
-- food_units ddl
CREATE TABLE `food_units`
(
    `id`         int unsigned   NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `food_id`    int unsigned   NOT NULL COMMENT '食物',
    `unit_id`    int unsigned   NOT NULL COMMENT '所属单位',
    `weight`     decimal(10, 2) NOT NULL COMMENT '换算重量 (1单位 ≈ ? g)',
    `is_default` tinyint        NOT NULL                                       DEFAULT '0' COMMENT '是否为默认',
    `remark`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_food_unit` (`food_id`, `unit_id`) USING BTREE,
    KEY `fk_foodunit_unit` (`unit_id`) USING BTREE,
    CONSTRAINT `fk_foodunit_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_foodunit_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB
  AUTO_INCREMENT = 2779
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = DYNAMIC COMMENT ='食物单位换算关系表';
-- foods ddl
CREATE TABLE `foods`
(
    `id`         int unsigned                                                  NOT NULL AUTO_INCREMENT COMMENT '食物ID',
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '食物名称',
    `cat_id`     int unsigned                                                           DEFAULT NULL COMMENT '食物分类',
    `user_id`    int unsigned                                                           DEFAULT NULL COMMENT '所属用户',
    `status`     tinyint                                                       NOT NULL DEFAULT '1' COMMENT '状态',
    `nutrition`  json                                                                   DEFAULT NULL COMMENT '每100g的营养信息',
    `created_at` timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` timestamp                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `delete_at`  timestamp                                                     NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_cat_id` (`cat_id`) USING BTREE,
    KEY `idx_name` (`name`, `status`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 2161
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = DYNAMIC COMMENT ='食物基础信息与营养表';
-- likes ddl
CREATE TABLE `likes`
(
    `id`         int unsigned NOT NULL AUTO_INCREMENT,
    `user_id`    int          NOT NULL COMMENT '用户ID',
    `target`     int          NOT NULL COMMENT '目标ID (动态ID/食谱ID/用户ID等)',
    `type`       tinyint(1)   NOT NULL DEFAULT '1' COMMENT '类型: 1=动态, 2=食谱, 3=用户',
    `created_at` datetime              DEFAULT NULL COMMENT '点赞时间',
    `updated_at` datetime              DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `user_target_type` (`user_id`, `target`, `type`),
    KEY `target_type` (`target`, `type`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='通用点赞记录表';
-- meal_record_foods ddl
CREATE TABLE `meal_record_foods`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `meal_id`    bigint                                                        DEFAULT '0' COMMENT '就餐记录id',
    `user_id`    bigint                                                        DEFAULT NULL,
    `food_id`    bigint                                                        DEFAULT '0' COMMENT '食物id',
    `unit_id`    bigint                                                        DEFAULT '0' COMMENT '单位',
    `nutrition`  json                                                          DEFAULT NULL COMMENT '营养成分',
    `number`     decimal(10, 2)                                                DEFAULT '1.00' COMMENT '分量',
    `image`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '图片',
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `created_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    KEY `idx_meal_id` (`meal_id`) USING BTREE,
    KEY `idx_food_id` (`food_id`) USING BTREE,
    KEY `idx_unit_id` (`unit_id`) USING BTREE,
    KEY `idx_user_id` (`user_id`) USING BTREE,
    KEY `idx_crated_at` (`created_at`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 5
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC COMMENT ='就餐记录食物';
-- meal_records ddl
CREATE TABLE `meal_records`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `user_id`    bigint                                                        DEFAULT '0' COMMENT '所属用户',
    `type`       tinyint                                                       DEFAULT '0' COMMENT '类型 0 早餐 1 午餐 2 晚餐 3加餐',
    `nutrition`  json                                                          DEFAULT NULL COMMENT '营养信息',
    `created_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `meal_date`  date   NOT NULL                                               DEFAULT (curdate()),
    `latitude`   decimal(10, 6)                                                DEFAULT NULL COMMENT '纬度',
    `longitude`  decimal(10, 6)                                                DEFAULT NULL COMMENT '经度',
    `address`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `uk_user_type_date` (`user_id`, `type`, `meal_date`) USING BTREE,
    KEY `idx_user_id_type` (`user_id`, `type`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 4
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC COMMENT ='就餐记录';
-- recipe_attaches ddl
CREATE TABLE `recipe_attaches`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `recipe_id`  bigint                                                        DEFAULT '0' COMMENT '食谱id',
    `attach`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `created_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    KEY `idx_recipe_id` (`recipe_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC COMMENT ='食谱附件';
-- recipe_foods ddl
CREATE TABLE `recipe_foods`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `recipe_id`  bigint         DEFAULT '0' COMMENT '食谱id',
    `food_id`    bigint         DEFAULT '0' COMMENT '食物id',
    `number`     decimal(10, 2) DEFAULT '0.00' COMMENT '分量',
    `created_at` datetime       DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    KEY `idx_recipe_id` (`recipe_id`) USING BTREE,
    KEY `idx_food_id` (`food_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC;
-- recipes ddl
CREATE TABLE `recipes`
(
    `id`         bigint NOT NULL AUTO_INCREMENT,
    `user_id`    bigint                                                        DEFAULT '0' COMMENT '用户id',
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    `summary`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `content`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
    `like`       int                                                           DEFAULT '0' COMMENT '点赞数量',
    `created_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    KEY `idx_user_id` (`user_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci
  ROW_FORMAT = DYNAMIC COMMENT ='食谱';
-- tags ddl
CREATE TABLE `tags`
(
    `id`         int unsigned                                                 NOT NULL AUTO_INCREMENT,
    `name`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名称 (如: 红烧, 健身)',
    `type`       tinyint                                                      NOT NULL DEFAULT '1' COMMENT '一级分类: 1-餐次, 2-口味, 3-营养特点, 4-烹饪方式, 5-适用人群, 6-食材状态, 7-过敏原,8-品牌产地,9-时令季节,10-特殊场景,11-存储方式',
    `meta_type`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci          DEFAULT NULL COMMENT '二级分类/维度 (用于前端筛选分组, 如: Cooking,人群, 状态)',
    `created_at` timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name_type` (`name`, `type`) USING BTREE,
    KEY `idx_type` (`type`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 199
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT ='标签表';
-- topic_relation ddl
CREATE TABLE `topic_relation`
(
    `id`          bigint  NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `topic_id`    bigint  NOT NULL COMMENT '话题ID',
    `target_id`   bigint  NOT NULL COMMENT '关联对象ID（博客ID、餐食记录ID等）',
    `target_type` tinyint NOT NULL COMMENT '关联类型 1博客 2餐食记录 3其他',
    `created_at`  datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `idx_topic_target` (`topic_id`, `target_type`, `target_id`) USING BTREE,
    KEY `idx_target` (`target_id`, `target_type`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = DYNAMIC COMMENT ='话题关联表';
-- topics ddl
CREATE TABLE `topics`
(
    `id`          bigint                                                        NOT NULL AUTO_INCREMENT COMMENT '话题ID',
    `title`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '话题标题',
    `thumb`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '话题封面图片',
    `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '话题描述',
    `creator_id`  bigint                                                        NOT NULL COMMENT '创建者用户ID',
    `status`      tinyint                                                       DEFAULT '1' COMMENT '状态 1正常 0禁用',
    `join`        int                                                           DEFAULT '0' COMMENT '参与人数',
    `post`        int                                                           DEFAULT '0' COMMENT '关联文章/餐食记录数',
    `created_at`  datetime                                                      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at`  datetime                                                      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE,
    KEY `idx_creator_id` (`creator_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = DYNAMIC COMMENT ='话题表';
-- units ddl
CREATE TABLE `units`
(
    `id`         int unsigned                                                                                                   NOT NULL AUTO_INCREMENT COMMENT '单位ID',
    `name`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci                                                   NOT NULL COMMENT '单位名称',
    `type`       enum ('weight','count','volume','package','service','length') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '单位类型 ',
    `desc`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci                                                           DEFAULT NULL COMMENT '描述',
    `created_at` timestamp                                                                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` timestamp                                                                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `delete_at`  timestamp                                                                                                      NULL     DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`, `type`, `delete_at`) USING BTREE,
    KEY `idx_type` (`type`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 9
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci
  ROW_FORMAT = DYNAMIC COMMENT ='计量单位表';
-- user_steps ddl
CREATE TABLE `user_steps`
(
    `id`          int unsigned NOT NULL AUTO_INCREMENT,
    `user_id`     int          NOT NULL COMMENT '用户ID',
    `steps`       int          NOT NULL DEFAULT '0' COMMENT '步数',
    `record_date` date         NOT NULL COMMENT '记录日期',
    `created_at`  datetime              DEFAULT NULL,
    `updated_at`  datetime              DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `user_date` (`user_id`, `record_date`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci COMMENT ='用户步数记录表';
-- wa_admin_roles ddl
CREATE TABLE `wa_admin_roles`
(
    `id`       int NOT NULL AUTO_INCREMENT COMMENT '主键',
    `role_id`  int NOT NULL COMMENT '角色id',
    `admin_id` int NOT NULL COMMENT '管理员id',
    PRIMARY KEY (`id`),
    UNIQUE KEY `role_admin_id` (`role_id`, `admin_id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci
  ROW_FORMAT = DYNAMIC COMMENT ='管理员角色表';
-- wa_admins ddl
CREATE TABLE `wa_admins`
(
    `id`         int unsigned                                                  NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `username`   varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '用户名',
    `nickname`   varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  NOT NULL COMMENT '昵称',
    `password`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
    `avatar`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '/app/admin/avatar.png' COMMENT '头像',
    `email`      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
    `mobile`     varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci  DEFAULT NULL COMMENT '手机',
    `created_at` datetime                                                      DEFAULT NULL COMMENT '创建时间',
    `updated_at` datetime                                                      DEFAULT NULL COMMENT '更新时间',
    `login_at`   datetime                                                      DEFAULT NULL COMMENT '登录时间',
    `status`     tinyint                                                       DEFAULT NULL COMMENT '禁用',
    PRIMARY KEY (`id`),
    UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci
  ROW_FORMAT = DYNAMIC COMMENT ='管理员表';
-- wa_options ddl
CREATE TABLE `wa_options`
(
    `id`         int unsigned                                                  NOT NULL AUTO_INCREMENT,
    `name`       varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '键',
    `value`      longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci     NOT NULL COMMENT '值',
    `created_at` datetime                                                      NOT NULL DEFAULT '2022-08-15 00:00:00' COMMENT '创建时间',
    `updated_at` datetime                                                      NOT NULL DEFAULT '2022-08-15 00:00:00' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 19
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci
  ROW_FORMAT = DYNAMIC COMMENT ='选项表';
-- wa_roles ddl
CREATE TABLE `wa_roles`
(
    `id`         int unsigned                                                 NOT NULL AUTO_INCREMENT COMMENT '主键',
    `name`       varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色组',
    `rules`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '权限',
    `created_at` datetime                                                     NOT NULL COMMENT '创建时间',
    `updated_at` datetime                                                     NOT NULL COMMENT '更新时间',
    `pid`        int unsigned DEFAULT NULL COMMENT '父级',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci
  ROW_FORMAT = DYNAMIC COMMENT ='管理员角色';
-- wa_rules ddl
CREATE TABLE `wa_rules`
(
    `id`         int unsigned                                                  NOT NULL AUTO_INCREMENT COMMENT '主键',
    `title`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
    `icon`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci          DEFAULT NULL COMMENT '图标',
    `key`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标识',
    `pid`        int unsigned                                                           DEFAULT '0' COMMENT '上级菜单',
    `created_at` datetime                                                      NOT NULL COMMENT '创建时间',
    `updated_at` datetime                                                      NOT NULL COMMENT '更新时间',
    `href`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci          DEFAULT NULL COMMENT 'url',
    `type`       int                                                           NOT NULL DEFAULT '1' COMMENT '类型',
    `weight`     int                                                                    DEFAULT '0' COMMENT '排序',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 141
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci
  ROW_FORMAT = DYNAMIC COMMENT ='权限规则';
-- wa_uploads ddl
CREATE TABLE `wa_uploads`
(
    `id`           int                                                           NOT NULL AUTO_INCREMENT COMMENT '主键',
    `name`         varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
    `url`          varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件',
    `admin_id`     int                                                                    DEFAULT NULL COMMENT '管理员',
    `file_size`    int                                                           NOT NULL COMMENT '文件大小',
    `mime_type`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'mime类型',
    `image_width`  int                                                                    DEFAULT NULL COMMENT '图片宽度',
    `image_height` int                                                                    DEFAULT NULL COMMENT '图片高度',
    `ext`          varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '扩展名',
    `storage`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'local' COMMENT '存储位置',
    `created_at`   date                                                                   DEFAULT NULL COMMENT '上传时间',
    `category`     varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci          DEFAULT NULL COMMENT '类别',
    `updated_at`   date                                                                   DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `admin_id` (`admin_id`) USING BTREE,
    KEY `category` (`category`) USING BTREE,
    KEY `ext` (`ext`) USING BTREE,
    KEY `name` (`name`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci
  ROW_FORMAT = DYNAMIC COMMENT ='附件';
-- wa_users ddl
CREATE TABLE `wa_users`
(
    `id`         int unsigned                                                        NOT NULL AUTO_INCREMENT COMMENT '主键',
    `username`   varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci        NOT NULL COMMENT '用户名',
    `nickname`   varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci        NOT NULL COMMENT '昵称',
    `password`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci       NOT NULL COMMENT '密码',
    `sex`        enum ('1','2','3') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1' COMMENT '性别1男2女3保密',
    `avatar`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                DEFAULT NULL COMMENT '头像',
    `email`      varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                DEFAULT NULL COMMENT '邮箱',
    `mobile`     varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                 DEFAULT NULL COMMENT '手机',
    `openid`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                DEFAULT NULL COMMENT '微信openid',
    `unionid`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                DEFAULT NULL COMMENT '微信unionid',
    `signature`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                DEFAULT NULL COMMENT '个性签名',
    `background` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                DEFAULT NULL COMMENT '背景图',
    `age`        int                                                                          DEFAULT '0' COMMENT '年龄',
    `tall`       int                                                                          DEFAULT NULL COMMENT '身高 cm',
    `weight`     decimal(10, 2)                                                               DEFAULT NULL COMMENT '体重 kg',
    `bmi`        decimal(10, 2)                                                               DEFAULT NULL COMMENT 'bmi',
    `bust`       decimal(10, 2)                                                               DEFAULT NULL COMMENT '胸围 cm',
    `waist`      decimal(10, 2)                                                               DEFAULT NULL COMMENT '腰围 cm',
    `hip`        decimal(10, 2)                                                               DEFAULT NULL COMMENT '臀围 cm',
    `target`     int                                                                          DEFAULT NULL COMMENT '卡路里目标',
    `level`      tinyint                                                             NOT NULL DEFAULT '0' COMMENT '等级',
    `birthday`   date                                                                         DEFAULT NULL COMMENT '生日',
    `money`      decimal(10, 2)                                                      NOT NULL DEFAULT '0.00' COMMENT '余额(元)',
    `score`      int                                                                 NOT NULL DEFAULT '0' COMMENT '积分',
    `last_time`  datetime                                                                     DEFAULT NULL COMMENT '登录时间',
    `last_ip`    varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                 DEFAULT NULL COMMENT '登录ip',
    `join_time`  datetime                                                                     DEFAULT NULL COMMENT '注册时间',
    `join_ip`    varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                 DEFAULT NULL COMMENT '注册ip',
    `token`      varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci                 DEFAULT NULL COMMENT 'token',
    `created_at` datetime                                                                     DEFAULT NULL COMMENT '创建时间',
    `updated_at` datetime                                                                     DEFAULT NULL COMMENT '更新时间',
    `role`       int                                                                 NOT NULL DEFAULT '1' COMMENT '角色',
    `status`     tinyint                                                             NOT NULL DEFAULT '0' COMMENT '禁用',
    PRIMARY KEY (`id`),
    UNIQUE KEY `username` (`username`) USING BTREE,
    KEY `email` (`email`) USING BTREE,
    KEY `join_time` (`join_time`) USING BTREE,
    KEY `mobile` (`mobile`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 2
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci
  ROW_FORMAT = DYNAMIC COMMENT ='用户表';
