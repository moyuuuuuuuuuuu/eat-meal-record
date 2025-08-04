create table if not exists food
(
    id         bigint primary key auto_increment,
    user_id    bigint   default 0 comment '所属用户 0为公共数据',
    cat_id     bigint   default 0 comment '分类',
    name       varchar(255) comment '食物名称',
    kal        decimal(10, 4) comment '每100g卡路里',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp comment '更新时间',
    index idx_user_id (user_id),
    index idx_cat_id (cat_id)
) comment '食物模板';

create table if not exists food_cat
(
    id         bigint primary key auto_increment,
    name       varchar(255) unique comment '分类名称',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp
);

create table if not exists foods_unit
(
    id         bigint primary key auto_increment,
    name       varchar(255) unique comment '单位名称',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp
) comment '单位';

create table if not exists food_nutrition
(
    id         bigint primary key auto_increment,
    food_id    bigint   default 0 comment '食物id',
    unit_id    bigint   default 0 comment '单位',
    kal        decimal(10, 4) comment '卡路里',
    protein    decimal(10, 4) comment '蛋白质',
    fat        decimal(10, 4) comment '脂肪',
    carbo      decimal(10, 4) comment '碳水化合物',
    sugar      decimal(10, 4) comment '糖分',
    image      varchar(255) comment '参考图片',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp,
    unique key (food_id, unit_id)
) comment '食物营养';

create table if not exists meal_record
(
    id         bigint primary key auto_increment,
    user_id    bigint   default 0 comment '所属用户',
    type       tinyint  default 0 comment '类型 0 早餐 1 午餐 2 晚餐 3加餐',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp,
    index idx_user_id_type (user_id, type)
) comment '就餐记录';

create table if not exists meal_record_food
(
    id         bigint primary key auto_increment,
    meal_id    bigint   default 0 comment '就餐记录id',
    food_id    bigint   default 0 comment '食物id',
    unit_id    bigint   default 0 comment '单位',
    kal        decimal(10, 4) comment '卡路里',
    protein    decimal(10, 4) comment '蛋白质',
    fat        decimal(10, 4) comment '脂肪',
    carbo      decimal(10, 4) comment '碳水化合物',
    sugar      decimal(10, 4) comment '糖分',
    number     int      default 1 comment '分量',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp,
    index idx_meal_id (meal_id),
    index idx_food_id (food_id),
    index idx_unit_id (unit_id)
) comment '就餐记录食物';

create table if not exists user
(
    id                  bigint primary key auto_increment,
    name                varchar(255),
    email               varchar(255),
    avatar              varchar(255) default 0 comment '头像',
    age                 int          default 0 comment '年龄',
    gender              tinyint      default 0 comment '性别 1男2女',
    created_at          datetime     default current_timestamp comment '创建时间',
    updated_at          datetime     default current_timestamp on update current_timestamp,
    last_login_platform tinyint      default 0 comment '最后登录平台 0 未知 1 微信 2 抖音',
    last_login_time     datetime,
    last_login_ip       varchar(15)  default null,
    index idx_email (email)
) comment '用户';

create table if not exists user_account
(
    id                    bigint primary key auto_increment,
    user_id               bigint         default 0 comment '用户id',
    sn                    varchar(255),
    unionid               varchar(255) comment 'unionid',
    openid                varchar(255) comment 'openid',
    weight                decimal(10, 2) default 65.00 comment '体重 单位kg',
    tall                  decimal(10, 2) default 170.00 comment '身高 单位cm',
    bust                  decimal(10, 2) default 90.00 comment '胸围 单位cm',
    waist                 decimal(10, 2) default 80.00 comment '腰围 单位cm',
    hip                   decimal(10, 2) default 90.00 comment '臀线 单位cm',
    full_attendance_month tinyint        default 0 comment '上月是否全勤',
    target                int            default 0 comment '目标卡路里',
    created_at            datetime       default current_timestamp comment '创建时间',
    updated_at            datetime       default current_timestamp on update current_timestamp,
    index idx_user_id (user_id),
    index idx_unionid (unionid),
    unique index idx_sn (sn)
) comment '用户账号';

create table if not exists blog
(
    id            bigint primary key auto_increment,
    user_id       bigint       default 0 comment '用户id',
    title         varchar(255) default '' comment '标题',
    like_count    int          default 0 comment '点赞数量',
    view_count    int          default 0 comment '查看数量',
    comment_count int          default 0 comment '评论数量',
    fav_count     int          default 0 comment '收藏数量',
    content       text,
    created_at    datetime     default current_timestamp comment '创建时间',
    updated_at    datetime     default current_timestamp on update current_timestamp,
    index idx_user_id (user_id)
) comment '博客';

create table if not exists blog_attach
(
    id         bigint primary key auto_increment,
    blog_id    bigint   default 0 comment '博客id',
    attach     varchar(255),
    sort       int      default 0 comment '排序',
    type       tinyint  default 0 comment '类型 0 图片 1 视频 3食物 4食谱 5就餐记录',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp,
    index idx_blog_id (blog_id)
) comment '博客附件';

create table if not exists blog_comment
(
    id         bigint primary key auto_increment,
    blog_id    bigint   default 0 comment '博客id',
    user_id    bigint   default 0 comment '用户id',
    content    text,
    parent_id  bigint   default 0 comment '父评论id',
    like_count int      default 0 comment '点赞数量',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp,
    index idx_blog_id (blog_id),
    index idx_user_id (user_id),
    index idx_parent_id (parent_id)
) comment '博客评论';

create table if not exists follow
(
    id         bigint primary key auto_increment,
    user_id    bigint   default 0 comment '用户id',
    follow_id  bigint   default 0 comment '关注id',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp,
    index idx_user_id (user_id),
    index idx_follow_id (follow_id)
);

create table if not exists likes
(
    id         bigint primary key auto_increment,
    user_id    bigint   default 0 comment '用户id',
    target     bigint   default 0 comment '目标id',
    type       tinyint  default 0 comment '类型 1 帖子 2 食物 3食谱 4 评论 5用户',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp
);

create table if not exists favorite
(
    id         bigint primary key auto_increment,
    user_id    bigint   default 0 comment '用户id',
    target     bigint   default 0 comment '食物id',
    type       tinyint  default 0 comment '类型 1 帖子 2 食物 3食谱',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp,
    unique index idx_user_id_type_target (user_id, type, target)
);

create table if not exists recipe
(
    id         bigint primary key auto_increment,
    user_id    bigint   default 0 comment '用户id',
    name       varchar(255),
    summary    text,
    content    text,
    like_count int      default 0 comment '点赞数量',
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp,
    index idx_user_id (user_id)
) comment '食谱';

create table if not exists recipe_food
(
    id         bigint primary key auto_increment,
    recipe_id  bigint         default 0 comment '食谱id',
    food_id    bigint         default 0 comment '食物id',
    number     decimal(10, 2) default 0 comment '分量',
    created_at datetime       default current_timestamp comment '创建时间',
    updated_at datetime       default current_timestamp on update current_timestamp,
    index idx_recipe_id (recipe_id),
    index idx_food_id (food_id)
);
create table if not exists recipe_attach
(
    id         bigint primary key auto_increment,
    recipe_id  bigint   default 0 comment '食谱id',
    attach     varchar(255),
    created_at datetime default current_timestamp comment '创建时间',
    updated_at datetime default current_timestamp on update current_timestamp,
    index idx_recipe_id (recipe_id)
) comment '食谱附件';

CREATE TABLE checkin_record
(
    id             BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id        BIGINT                                      NOT NULL,
    target_calorie INT                                         NOT NULL COMMENT '当日目标卡路里',
    total_calorie  INT                                         NOT NULL COMMENT '当日摄入总卡路里',
    result         ENUM ('success', 'fail_over', 'fail_under') NOT NULL COMMENT '打卡结果',
    date           DATE                                        NOT NULL COMMENT '打卡日期，一个用户一天一条记录',
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique index idx_user_id_date (user_id, date)
) comment '打卡记录';

CREATE TABLE meal_checkin_relation
(
    id         BIGINT PRIMARY KEY AUTO_INCREMENT,
    checkin_id BIGINT NOT NULL,
    meal_id    BIGINT NOT NULL,
    FOREIGN KEY (checkin_id) REFERENCES checkin_record (id) ON DELETE CASCADE,
    FOREIGN KEY (meal_id) REFERENCES meal_record (id) ON DELETE CASCADE,
    UNIQUE KEY unique_relation (checkin_id, meal_id)
) comment '打卡记录-就餐记录关系表';
