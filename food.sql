-- ----------------------------
-- 1. (最终版) 食物表
-- ----------------------------
CREATE TABLE `foods`
(
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '食物ID',
    `name`       VARCHAR(255) NOT NULL COMMENT '食物名称',
    `cat_id`     INT UNSIGNED NULL COMMENT '食物分类ID',
    `user_id`    INT UNSIGNED NULL COMMENT '创建者ID (如果是用户创建)',
    `status`     TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '状态 (1: 可用, 0: 禁用)',
    `nutrition`  JSON         NULL COMMENT '每100g的营养信息 (JSON格式)',
    `created_at` timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `delete_at`  timestamp,
    PRIMARY KEY (`id`),
    INDEX `idx_name` (`name`, `status`),
    INDEX idx_cat_id (`cat_id`)
) COMMENT ='食物基础信息与营养表';

-- ----------------------------
-- 2. 单位表
-- ----------------------------
CREATE TABLE `units`
(
    `id`         INT UNSIGNED                                                    NOT NULL AUTO_INCREMENT COMMENT '单位ID',
    `name`       VARCHAR(50)                                                     NOT NULL COMMENT '单位名称 (如: g, 个, 碗, 杯)',
    `type`       ENUM ('weight', 'count', 'volume','package','service','length') NOT NULL COMMENT '单位类型 (重量, 数量, 体积,商业预包装,,长度)',
    `desc`       varchar(255)                                                             default null comment '描述',
    `created_at` timestamp                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` timestamp                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `delete_at`  timestamp,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `uk_name` (`name`, `type`, delete_at),
    index idx_type (`type`)
) COMMENT ='计量单位表';

-- ----------------------------
-- 3. 食物单位换算表
-- ----------------------------
CREATE TABLE `food_units`
(
    `id`         INT UNSIGNED   NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `food_id`    INT UNSIGNED   NOT NULL COMMENT '食物ID',
    `unit_id`    INT UNSIGNED   NOT NULL COMMENT '单位ID',
    `weight`   DECIMAL(10, 2) NOT NULL COMMENT '换算重量 (1单位 ≈ ? g)',
    `is_default` BOOLEAN        NOT NULL DEFAULT FALSE COMMENT '是否为默认单位',
    `remark`     VARCHAR(255)   NULL COMMENT '备注 (如: 杯(约250ml))',
    PRIMARY KEY (`id`),
    UNIQUE INDEX `uk_food_unit` (`food_id`, `unit_id`),
    CONSTRAINT `fk_foodunit_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_foodunit_unit` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) COMMENT ='食物单位换算关系表';
-- ----------------------------
-- 4. 食物分类表
-- ----------------------------
CREATE TABLE `cats`
(
    `id`         bigint                                                        NOT NULL AUTO_INCREMENT,
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类名称',
    `pid`        bigint                                                        NULL DEFAULT 0 COMMENT '上级分类id',
    `sort`       int                                                           NULL DEFAULT NULL COMMENT '排序',
    `created_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updated_at` datetime                                                      NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `name` (`name` ASC) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 39
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci COMMENT = '食品分类'
  ROW_FORMAT = Dynamic;

