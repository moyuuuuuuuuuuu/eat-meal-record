-- 食品
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
-- 食品单位
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
-- 食品标签关系表
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
-- 分类
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
-- 标签
CREATE TABLE `tags`
(
    `id`         int unsigned                                                 NOT NULL AUTO_INCREMENT,
    `name`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标签名称 (如: 红烧, 健身)',
    `type`       tinyint                                                      NOT NULL DEFAULT '1' COMMENT '一级分类: 1-餐次, 2-口味, 3-营养特点, 4-烹饪方式, 5-适用人群, 6-食材状态, 7-过敏原',
    `meta_type`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci          DEFAULT NULL COMMENT '二级分类/维度 (用于前端筛选分组, 如: Cooking,人群, 状态)',
    `created_at` timestamp                                                    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name_type` (`name`, `type`) USING BTREE,
    KEY `idx_type` (`type`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 100
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT ='标签表';
-- 单位
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
