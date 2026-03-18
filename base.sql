create table eat_clear.blog_attaches
(
    id         bigint auto_increment
        primary key,
    blog_id    bigint   default 0                 null comment '博客id',
    attach     varchar(255)                       null,
    poster     varchar(255)                       null comment '视频封面',
    sort       int      default 0                 null comment '排序',
    type       tinyint  default 0                 null comment '类型 0 图片 1 视频 3食物 4食谱 5就餐记录',
    created_at datetime default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP
)
    comment '博客附件' collate = utf8mb4_unicode_ci
                       row_format = DYNAMIC;

create index idx_blog_id
    on eat_clear.blog_attaches (blog_id);

create table eat_clear.blog_comments
(
    id         bigint auto_increment
        primary key,
    blog_id    bigint   default 0                 null comment '博客id',
    user_id    bigint   default 0                 null comment '用户id',
    content    text                               null,
    parent_id  bigint   default 0                 null comment '父评论id',
    `like`     int      default 0                 null comment '点赞数量',
    created_at datetime default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP
)
    comment '博客评论' collate = utf8mb4_unicode_ci
                       row_format = DYNAMIC;

create index idx_blog_id
    on eat_clear.blog_comments (blog_id);

create index idx_parent_id
    on eat_clear.blog_comments (parent_id);

create index idx_user_id
    on eat_clear.blog_comments (user_id);

create table eat_clear.blog_locations
(
    id        bigint auto_increment
        primary key,
    blog_id   bigint         not null,
    latitude  decimal(10, 6) not null,
    longitude decimal(10, 6) not null,
    name      varchar(255)   not null,
    address   varchar(255)   not null
)
    comment '博客位置表' row_format = DYNAMIC;

create table eat_clear.blog_topics
(
    id       bigint auto_increment
        primary key,
    blog_id  bigint not null,
    topic_id bigint not null,
    constraint idx_blog_topic
        unique (blog_id, topic_id)
)
    comment '博客话题表' row_format = DYNAMIC;

create table eat_clear.blogs
(
    id         bigint auto_increment
        primary key,
    user_id    bigint       default 0                 null comment '用户id',
    title      varchar(255) default ''                null comment '标题',
    likes      int unsigned default '0'               null comment '点赞数量',
    views      int unsigned default '0'               null comment '查看数量',
    comments   int unsigned default '0'               null comment '评论数量',
    favs       int unsigned default '0'               null comment '收藏数量',
    content    text                                   null,
    visibility tinyint(1)   default 1                 null comment '状态 0隐藏 1所有人可见 2仅自己可见 3仅好友可见',
    created_at datetime     default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime     default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP
)
    comment '博客' collate = utf8mb4_unicode_ci
                   row_format = DYNAMIC;

create index idx_user_id
    on eat_clear.blogs (user_id);

create table eat_clear.cats
(
    id         bigint auto_increment
        primary key,
    name       varchar(255)                       null comment '分类名称',
    pid        bigint   default 0                 null comment '上级分类',
    sort       int                                null comment '排序',
    created_at datetime default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment '编辑时间',
    constraint name
        unique (name)
)
    comment '食品分类' collate = utf8mb4_unicode_ci
                       row_format = DYNAMIC;

create table eat_clear.checkin_records
(
    id             bigint auto_increment
        primary key,
    user_id        bigint                                      not null,
    target_calorie int                                         not null comment '当日目标卡路里',
    total_calorie  int                                         not null comment '当日摄入总卡路里',
    result         enum ('success', 'fail_over', 'fail_under') not null comment '打卡结果',
    date           date                                        not null comment '打卡日期，一个用户一天一条记录',
    created_at     datetime default CURRENT_TIMESTAMP          null,
    updated_at     datetime default CURRENT_TIMESTAMP          null on update CURRENT_TIMESTAMP,
    constraint idx_user_id_date
        unique (user_id, date)
)
    comment '打卡记录' collate = utf8mb4_unicode_ci
                       row_format = DYNAMIC;

create table eat_clear.favorites
(
    id         bigint auto_increment
        primary key,
    user_id    bigint   default 0                 null comment '用户id',
    target     bigint   default 0                 null comment '食物id',
    type       tinyint  default 0                 null comment '类型 1 帖子 2 食物 3食谱',
    created_at datetime default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint user_target_type
        unique (user_id, target, type)
)
    collate = utf8mb4_unicode_ci
    row_format = DYNAMIC;

create index target_type
    on eat_clear.favorites (target, type);

create table eat_clear.follows
(
    id           bigint auto_increment
        primary key,
    user_id      bigint     default 0                 null comment '用户id',
    follow_id    bigint     default 0                 null comment '关注id',
    is_attention tinyint(1) default 0                 null comment '是否互相关注 0否 1是',
    created_at   datetime   default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at   datetime   default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint idx_user_follow_id
        unique (user_id, follow_id)
)
    collate = utf8mb4_unicode_ci
    row_format = DYNAMIC;

create table eat_clear.food_make_steps
(
    id         int auto_increment
        primary key,
    step_no    int            null,
    name       int            null,
    food       int            null comment '食物id',
    ingredient int            null comment '食材id',
    number     decimal(10, 2) null comment '所需多少单位的食材',
    unit       int            null comment '单位',
    remark     int            null
)
    row_format = DYNAMIC;

create table eat_clear.food_nutrients
(
    id      bigint auto_increment
        primary key,
    food_id bigint                     not null comment '所属食物ID',
    water   double(10, 2) default 0.00 not null comment '水分(g/100g)',
    kcal    double(10, 2) default 0.00 not null comment '热量(kcal/100g)',
    pro     double(10, 2) default 0.00 not null comment '蛋白质(g/100g)',
    fat     double(10, 2) default 0.00 not null comment '脂肪(g/100g)',
    carb    double(10, 2) default 0.00 not null comment '碳水化合物(g/100g)',
    sugar   double(10, 2) default 0.00 null comment '糖分(g/100g)',
    fiber   double(10, 2) default 0.00 not null comment '膳食纤维(g/100g)',
    chol    double(10, 2) default 0.00 not null comment '胆固醇(mg/100g)',
    purine  double(10, 2) default 0.00 null comment '总嘌呤(mg/100g)',
    gi      double(10, 2) default 0.00 null comment '血糖指数',
    vit_a   double(10, 2) default 0.00 not null comment '维生素A(μg/100g)',
    vit_c   double(10, 2) default 0.00 null comment '维生素C(mg/100g)',
    vit_d   double(10, 2) default 0.00 null comment '维生素D(μg/100g)',
    vit_e   double(10, 2) default 0.00 null comment '维生素E(mg/100g)',
    folic   double(10, 2) default 0.00 not null comment '叶酸(mg/100g)',
    na      double(10, 2) default 0.00 not null comment '钠(mg/100g) - Sodium',
    cal     double(10, 2) default 0.00 not null comment '钙(mg/100g) - Calcium',
    iron    double(10, 2) default 0.00 not null comment '铁(mg/100g) - Iron',
    kal     double(10, 2) default 0.00 not null comment '钾(mg/100g) - Potassium',
    mag     double(10, 2) default 0.00 not null comment '镁(mg/100g) - Magnesium',
    zinc    double(10, 2) default 0.00 not null comment '锌(mg/100g) - Zinc',
    sel     double(10, 2) default 0.00 not null comment '硒(μg/100g) - Selenium',
    cup     double(10, 2) default 0.00 not null comment '铜(mg/100g) - Cuprum',
    mang    double(10, 2) default 0.00 not null comment '锰(mg/100g) - Manganese',
    iod     double(10, 2) default 0.00 not null comment '碘(μg/100g) - Iodine',
    fa      double(10, 2) default 0.00 not null comment '总脂肪酸(g/100g)',
    sfa     double(10, 2) default 0.00 not null comment '饱和脂肪酸(g/100g)',
    mufa    double(10, 2) default 0.00 not null comment '单不饱和脂肪酸(g/100g)',
    pufa    double(10, 2) default 0.00 not null comment '多不饱和脂肪酸(g/100g)',
    origin  varchar(32)   default ''   not null comment '产地/备注'
)
    comment '食物营养成分缩写表' collate = utf8mb4_unicode_ci
                                 row_format = DYNAMIC;

create index idx_food_id
    on eat_clear.food_nutrients (food_id);

create table eat_clear.food_tags
(
    id      int unsigned auto_increment
        primary key,
    food_id int unsigned not null comment '食物ID',
    tag_id  int unsigned not null comment '标签ID',
    constraint uk_food_tag
        unique (food_id, tag_id)
)
    comment '食物标签关联表' collate = utf8mb4_general_ci
                             row_format = DYNAMIC;

create table eat_clear.food_units
(
    id         int unsigned auto_increment comment '主键ID'
        primary key,
    food_id    int unsigned         not null comment '食物ID',
    unit_id    int unsigned         not null comment '单位ID',
    weight     decimal(10, 2)       not null comment '换算重量 (1单位 ≈ ? g)',
    is_default tinyint(1) default 0 not null comment '是否为默认单位',
    remark     varchar(255)         null comment '备注 (如: 杯(约250ml))',
    thumb      varchar(255)         null comment '示意图',
    constraint uk_food_unit
        unique (food_id, unit_id)
)
    comment '食物单位换算关系表' row_format = DYNAMIC;

create index fk_foodunit_unit
    on eat_clear.food_units (unit_id);

create table eat_clear.foods
(
    id            int unsigned auto_increment comment '食物ID'
        primary key,
    name          varchar(255)                        not null comment '食物名称',
    cat_id        int unsigned                        null comment '食物分类',
    user_id       int unsigned                        null comment '所属用户',
    status        tinyint   default 1                 not null comment '状态',
    is_ingredient tinyint                             null comment '是否食材 1是 2不是',
    created_at    timestamp default CURRENT_TIMESTAMP not null comment '创建时间',
    updated_at    timestamp default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    delete_at     timestamp                           null,
    is_common     tinyint   default 2                 null comment '是否常见食物 1是 2不是'
)
    comment '食物基础信息与营养表' row_format = DYNAMIC;

create index idx_cat_id
    on eat_clear.foods (cat_id);

create index idx_name
    on eat_clear.foods (name, status);

create table eat_clear.likes
(
    id         int unsigned auto_increment
        primary key,
    user_id    int                  not null comment '用户ID',
    target     int                  not null comment '目标ID (动态ID/食谱ID/用户ID等)',
    type       tinyint(1) default 1 not null comment '类型: 1=动态, 2=食谱, 3=用户',
    created_at datetime             null comment '点赞时间',
    updated_at datetime             null,
    constraint user_target_type
        unique (user_id, target, type)
)
    comment '通用点赞记录表' row_format = DYNAMIC;

create index target_type
    on eat_clear.likes (target, type);

create table eat_clear.meal_record_foods
(
    id         bigint auto_increment
        primary key,
    meal_id    bigint         default 0                 null comment '就餐记录id',
    user_id    bigint                                   null,
    food_id    bigint         default 0                 null comment '食物id',
    unit_id    bigint         default 0                 null comment '单位',
    nutrition  json                                     null comment '营养成分',
    number     decimal(10, 2) default 1.00              null comment '分量',
    image      varchar(255)                             null comment '图片',
    name       varchar(255)                             null,
    created_at datetime       default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP
)
    comment '就餐记录食物' collate = utf8mb4_unicode_ci
                           row_format = DYNAMIC;

create index idx_crated_at
    on eat_clear.meal_record_foods (created_at);

create index idx_food_id
    on eat_clear.meal_record_foods (food_id);

create index idx_meal_id
    on eat_clear.meal_record_foods (meal_id);

create index idx_unit_id
    on eat_clear.meal_record_foods (unit_id);

create index idx_user_id
    on eat_clear.meal_record_foods (user_id);

create table eat_clear.meal_records
(
    id         bigint auto_increment
        primary key,
    user_id    bigint   default 0                 null comment '所属用户',
    type       tinyint  default 0                 null comment '类型 0 早餐 1 午餐 2 晚餐 3加餐',
    nutrition  json                               null comment '营养信息',
    created_at datetime default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    meal_date  date     default (curdate())       not null,
    latitude   decimal(10, 6)                     null comment '纬度',
    longitude  decimal(10, 6)                     null comment '经度',
    address    varchar(255)                       null,
    constraint uk_user_type_date
        unique (user_id, type, meal_date)
)
    comment '就餐记录' collate = utf8mb4_unicode_ci
                       row_format = DYNAMIC;

create index idx_user_id_type
    on eat_clear.meal_records (user_id, type);

create table eat_clear.menu_dishes
(
    id                    bigint auto_increment comment '主键id'
        primary key,
    dishes_id             bigint                                  not null comment '菜品id',
    base_dishes_id        bigint                                  null comment '菜品基础id',
    meal_type             int           default 1                 not null comment '类型(1-菜品,2-套餐)',
    dishes_num            varchar(32)   default ''                not null comment '菜品编码',
    custom_id             int                                     not null comment '自定义id',
    inventory_id          varchar(64)                             null comment '存货id(数据同步)',
    dishes_name           varchar(255)                            not null comment '菜品名称',
    alias_name            varchar(255)                            null comment '菜品别称',
    pinyin_initials       varchar(255)  default ''                not null comment '菜品名称拼音首字母',
    pinyin_full           varchar(1024) default ''                not null comment '菜品名称全拼',
    bar_code              varchar(32)   default ''                not null comment '条形码',
    intro                 varchar(256)  default ''                not null comment '菜品简介',
    cook_id               bigint        default -1                not null comment '菜品灶类ID',
    type_id               bigint        default 1                 not null comment '菜品类型ID',
    classify_id           bigint                                  null comment '菜品分类id(自定义)',
    effect_id             bigint                                  null comment '菜品功效id（强筋健骨）',
    style_id              bigint                                  null comment '菜系id(鲁系主食，沪系主食)',
    if_local_feature      int                                     null comment '是否本地特色(1是2否)',
    dishes_depart         int                                     null comment '菜别(1小荤,2大荤,3素)',
    sequence              int           default -1                null comment '次序（1餐前,2餐后）',
    pungency_degree       int                                     null comment '辣度',
    sales_mode            int           default 1                 not null comment '销售方式(1按份,2称重)',
    size_type             int           default 1                 null comment '规格类型(1-标准,2-大小份)',
    size_json             varchar(255)                            null comment '菜品规格',
    weight                double(10, 2) default 100.00            not null comment '每份重量(g)',
    large_weight          double(10, 2)                           null comment '大份份量',
    little_weight         double(10, 2)                           null comment '小份份量',
    weight_deviation      double(10, 2) default 0.00              not null comment '质量偏差(g)',
    price                 int           default 999999            not null comment '菜品基础单价(分)',
    unit_price            int           default 100               not null comment '称重单位多少克(默认100g)',
    large_price           int                                     null comment '大份单价',
    little_price          int                                     null comment '小份单价',
    image_url             varchar(1024) default ''                not null comment '菜品图片url',
    particulars           text                                    null comment '菜品详情',
    recommend             varchar(255)  default ''                not null comment '菜品推荐',
    index_recommend       int           default 2                 not null comment '首页推荐(1-推荐,2-不推荐)',
    like_survey           int           default 2                 not null comment '点赞调查标识(1-是,2-否)',
    like_batch            bigint                                  null comment '点赞调查批次号',
    like_num              int           default 0                 not null comment '点赞数',
    initial_score         int           default 80                null comment '菜品初始推荐值',
    calories              double(10, 2) default 0.00              not null comment '热量(千卡/份)',
    protein               double(10, 2) default 0.00              not null comment '蛋白质(g/份)',
    fat                   double(10, 2) default 0.00              not null comment '脂肪(g/份)',
    carbohydrate          double(10, 2) default 0.00              not null comment '碳水化合物(g/份)',
    dietary_fiber         double(10, 2) default 0.00              not null comment '膳食纤维(g/份)',
    cholesterol           double(10, 2) default 0.00              not null comment '胆固醇(mg/份)',
    calcium               double(10, 2) default 0.00              not null comment '钙(mg/份)',
    sodium                double(10, 2) default 0.00              not null comment '钠(mg/份)',
    purine                double(10, 2) default 0.00              not null comment '总嘌呤含量(mg/100g)',
    iron                  double(10, 2) default 0.00              not null comment '铁(mg/100g)',
    iodine                double(10, 2) default 0.00              not null comment '碘(μg/100g)',
    kalium                double(10, 2) default 0.00              not null comment '钾(mg/100g)',
    vitamin_a             double(10, 2) default 0.00              not null comment '维生素a(μg/100g)',
    vitamin_c             double(10, 2) default 0.00              not null comment '维生素c(mg/100g)',
    vitamin_e             double(10, 2) default 0.00              not null comment '维生素e(g/100g)',
    magnesium             double(10, 2) default 0.00              not null comment '镁(mg/100g)',
    zinc                  double(10, 2) default 0.00              not null comment '锌(mg/100g)',
    glycemic_index        double(10, 2) default 0.00              not null comment '血糖生成指数(GI)',
    sort                  int           default 0                 not null comment '优先级',
    canteen_id            bigint        default -1                not null comment '食堂ID',
    shopstall_id          bigint        default -1                not null comment '档口或店铺id',
    hide_flag             int           default 2                 not null comment '隐藏标识(1隐藏,2展示)',
    convert_flag          int           default 1                 not null comment '结果图转注册图',
    material_cost         int                                     null comment '成本价',
    gross_profit          int                                     null comment '毛利',
    gross_profit_rate     double(10, 2)                           null comment '毛利率',
    public_dishes         int           default 2                 not null comment '是否是公共菜品(1-是,2-否,)',
    area_id               bigint        default -1                not null comment '区域id',
    del_flag              int           default 2                 not null comment '删除标识(1删除,2正常)',
    revision              int           default 0                 not null comment '乐观锁',
    crby                  varchar(32)   default ''                not null comment '创建人',
    crtime                timestamp     default CURRENT_TIMESTAMP not null comment '创建时间',
    upby                  varchar(32)   default ''                not null comment '更新人',
    uptime                timestamp     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    praise_rate           double(10, 2)                           null comment '好评率',
    monthly_sales         int                                     null comment '月销',
    intelligent_recipe    int           default 1                 not null comment '是否智能菜谱适用',
    main_cooking_method   int                                     null comment '主要烹饪方式',
    treatment_dishes_flag int           default 2                 null comment '是否为治疗菜(1是,2否)',
    sub_alias_name        varchar(255)                            null comment '别名2'
)
    comment '菜品信息' collate = utf8mb4_unicode_ci
                       row_format = DYNAMIC;

create index index_del_flag
    on eat_clear.menu_dishes (del_flag);

create index index_dishes_id
    on eat_clear.menu_dishes (dishes_id);

create index menu_dishes_area_id_IDX
    on eat_clear.menu_dishes (area_id);

create index menu_dishes_base_dishes_id_IDX
    on eat_clear.menu_dishes (base_dishes_id);

create index menu_dishes_canteen_id_IDX
    on eat_clear.menu_dishes (canteen_id);

create index menu_dishes_custom_id_IDX
    on eat_clear.menu_dishes (custom_id);

create index menu_dishes_hide_flag_IDX
    on eat_clear.menu_dishes (hide_flag);

create index menu_dishes_shopstall_id_IDX
    on eat_clear.menu_dishes (shopstall_id);

create index menu_dishes_size_json_IDX
    on eat_clear.menu_dishes (size_json);

create index menu_dishes_type_id_IDX
    on eat_clear.menu_dishes (type_id);

create table eat_clear.menu_dishes_make
(
    id                            int auto_increment
        primary key,
    step_no                       int          null comment '步骤数',
    base_dishes_id                bigint       null comment '菜品基础id',
    make_name                     varchar(255) null comment '步骤名称',
    make_time_start               int          null comment '时长范围开始',
    make_time_end                 int          null comment '时长范围结束',
    make_center_temperature_start int          null comment '中心温度开始',
    make_center_temperature_end   int          null comment '中心温度结束',
    make_oil_temperature_start    int          null comment '油温开始',
    make_oil_temperature_end      int          null comment '油温结束'
)
    collate = utf8mb4_unicode_ci
    row_format = DYNAMIC;

create table eat_clear.menu_material
(
    id                     bigint auto_increment comment '主键id'
        primary key,
    area_id                bigint                                   null comment '区域id',
    material_id            bigint                                   not null comment '食材id',
    material_name          varchar(255)                             not null comment '食材名称',
    material_code          varchar(255)   default ''                not null comment '原料编码',
    pinyin_initials        text                                     null comment '拼音首字母',
    pinyin_full            text                                     null comment '拼音全拼',
    image_url              varchar(255)   default ''                not null comment '原料图片',
    nutrition_id           bigint                                   null comment '营养信息',
    category_id            bigint                                   null comment '类别id',
    material_type          int            default 1                 not null comment '原料类型(1原料2商品)',
    bar_code               varchar(128)                             null comment '条码',
    unit_id                bigint                                   null comment '单位',
    sale_price             int                                      null comment '销售价',
    unit_price             int                                      null comment '进价',
    sales_mode             int            default 1                 null comment '售卖类型(1计量2散称)',
    reserve_rate           int            default 0                 not null comment '预留比例(0-100)',
    shelf_life_type        int                                      null comment '保质期类型 1年 2月 3日',
    shelf_life_days        int                                      null comment '保质期数',
    synopsis               varchar(8000)                            null comment '简介',
    del_flag               int            default 2                 not null comment '删除标识(1删除,2正常)',
    revision               int            default 0                 not null comment '乐观锁',
    crby                   varchar(32)    default ''                not null comment '创建人',
    crtime                 timestamp      default CURRENT_TIMESTAMP not null comment '创建时间',
    upby                   varchar(32)    default ''                not null comment '更新人',
    uptime                 timestamp      default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    pur_price_ceiling      int                                      null comment '采购价格上限',
    cert_id                bigint                                   null comment '资格证书',
    big_category_id        bigint                                   null comment '大类id',
    size                   varchar(500)                             null comment '规格',
    tax_rate               int                                      null comment '税率',
    disable_status         int                                      null comment '禁用状态1启用 2禁用',
    convert_grams          int                                      null comment '转换数量  单位g',
    brand_id               bigint                                   null comment '品牌 id',
    dietary_category       int                                      null comment '膳食宝塔类别',
    spu_id                 bigint                                   null comment '商品spuId',
    attrs                  text                                     null comment '销售属性值id{attr_value_id}-{attr_value_id} 多个销售属性值id逗号分隔',
    attr_values            text                                     null comment '销售属性值，多个销售属性值/拼接',
    gross_proportion       decimal(10, 2) default 100.00            null comment '毛净比(%)',
    if_use_batch_inventory int            default 2                 null comment '是否使用批次库存操作(1是2否)',
    cost_accounting_style  int                                      null comment '成本核算方式(1先入先出,2移动加权平均法,3月度加权平均法)',
    gross_net_type         int            default 1                 not null comment '毛净类型(1净料2毛料)',
    valuable_goods         int                                      null comment '高价值货品品(1是2否)',
    process_price          int                                      null comment '加工工序总价 分/公斤',
    unit_price_start_date  date                                     null comment '进价开始日期',
    unit_price_end_date    date                                     null comment '进价结束日期',
    alias_name             varchar(255)                             null comment '别名',
    sub_alias_name         varchar(255)                             null comment '别名2',
    third_party_id         varchar(256)                             null comment '三方ID'
)
    comment '商家食材原料信息' collate = utf8mb4_unicode_ci
                               row_format = DYNAMIC;

create index idx_area_status_id
    on eat_clear.menu_material (area_id, del_flag, disable_status);

create index idx_material_name
    on eat_clear.menu_material (material_name);

create index idx_unique_material_code
    on eat_clear.menu_material (material_code);

create index index_area_id
    on eat_clear.menu_material (area_id);

create index index_category_id
    on eat_clear.menu_material (category_id);

create index index_material_type
    on eat_clear.menu_material (material_type);

create index index_material_unit
    on eat_clear.menu_material (material_id, unit_id);

create index index_zh_id
    on eat_clear.menu_material (material_id, category_id, unit_id);

create table eat_clear.menu_material_category
(
    id              bigint auto_increment comment '主键id'
        primary key,
    area_id         bigint                                null comment '区域id',
    category_id     bigint                                not null comment '类别id',
    category_num    varchar(64)                           null comment '类别编码',
    category_name   varchar(255)                          not null comment '类别名称',
    parent_id       bigint      default -1                not null comment '父类id',
    category_type   int         default 1                 not null comment '类型(1原料2商品)',
    del_flag        int         default 2                 not null comment '删除标识(1-删除,2-正常)',
    revision        int         default 0                 not null comment '乐观锁',
    crby            varchar(32) default ''                not null comment '创建人',
    crtime          timestamp   default CURRENT_TIMESTAMP not null comment '创建时间',
    upby            varchar(32) default ''                not null comment '更新人',
    uptime          timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    level           int                                   null comment '等级(0,1,2,3)',
    big_category_id bigint                                null comment '大类id',
    disable_status  int         default 1                 null comment '禁用状态1启用 2禁用'
)
    comment '原料类别表' collate = utf8mb4_unicode_ci
                         row_format = DYNAMIC;

create index index_area_id
    on eat_clear.menu_material_category (area_id);

create index index_category_id
    on eat_clear.menu_material_category (category_id);

create table eat_clear.menu_material_dishes
(
    id              bigint auto_increment comment '主键id'
        primary key,
    dishes_id       bigint                                not null comment '菜品id',
    material_id     bigint                                not null comment '食材id',
    weight          double(10, 2)                         not null comment '食材重量(g)',
    material_type   int                                   not null comment '材料类型(1主料,2辅料,3配料)',
    del_flag        int         default 2                 not null comment '删除标识(1删除,2正常)',
    revision        int         default 0                 not null comment '乐观锁',
    crby            varchar(32) default ''                not null comment '创建人',
    crtime          timestamp   default CURRENT_TIMESTAMP not null comment '创建时间',
    upby            varchar(32) default ''                not null comment '更新人',
    uptime          timestamp   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    gross_net_ratio double(10, 2)                         null comment '毛净比',
    gross_weight    double(10, 2)                         null comment '毛料重量',
    cost_price      int                                   null comment '毛料成本价'
)
    comment '菜品食材关联' collate = utf8mb4_unicode_ci
                           row_format = DYNAMIC;

create index index_dishes_id
    on eat_clear.menu_material_dishes (dishes_id);

create index index_material_id
    on eat_clear.menu_material_dishes (material_id);

create table eat_clear.menu_nutrition
(
    id                          bigint auto_increment comment '主键id'
        primary key,
    nutrition_id                bigint                                  not null comment '食材营养id',
    nutrition_code              varchar(32)   default '0'               not null comment '食材编码',
    nutrition_name              varchar(32)                             not null comment '食材名称',
    nutrition_image_url         varchar(1024) default ''                not null comment '食材图片url',
    weight                      double(10, 2) default 100.00            not null comment '标准份重量(g)',
    price                       int           default 999999            not null comment '食材基础单价(分)',
    color                       varchar(32)   default ''                not null comment '食材颜色',
    category_id                 bigint                                  null comment '类别id',
    big_type                    varchar(32)                             not null comment '食材大类',
    little_type                 varchar(32)                             not null comment '食材小类',
    label                       varchar(32)   default ''                not null comment '标签(海产海鱼、淡水鱼、海鲜类等)',
    processing_method           varchar(32)   default ''                not null comment '加工方式',
    processing_time             double(10, 2) default 0.00              not null comment '加工时间(min)',
    recommended_combination     varchar(256)  default ''                not null comment '推荐组合(以英文逗号分割,食材编码区分不超过20个)',
    combination_not_recommended varchar(256)  default ''                not null comment '不推荐组合(以英文逗号分割,以食材编码区分不超过20个)',
    edible                      double(10, 2) default 100.00            not null comment '可食部分(g/100g)',
    water                       double(10, 2) default 0.00              not null comment '水分(g/100g)',
    calories                    double(10, 2) default 0.00              not null comment '热量(千卡/100g)',
    protein                     double(10, 2) default 0.00              not null comment '蛋白质(g/100g)',
    fat                         double(10, 2) default 0.00              not null comment '脂肪(g/100g)',
    carbohydrate                double(10, 2) default 0.00              not null comment '碳水化合物(g/100g)',
    dietary_fiber               double(10, 2) default 0.00              not null comment '不溶性膳食纤维(g/100g)',
    cholesterol                 double(10, 2) default 0.00              not null comment '胆固醇(mg/100g)',
    ash                         double(10, 2) default 0.00              not null comment '灰分(g/100g)',
    vitamin_a                   double(10, 2) default 0.00              not null comment '维生素a(μg/100g)',
    carotene                    double(10, 2) default 0.00              not null comment '胡萝卜素(μg/100g)',
    thiamine                    double(10, 2) default 0.00              not null comment '硫胺素(mg/100g)',
    riboflavin                  double(10, 2) default 0.00              not null comment '核黄素(mg/100g)',
    niacin                      double(10, 2) default 0.00              not null comment '烟酸/尼克酸(mg/100g)',
    vitamin_c                   double(10, 2) default 0.00              not null comment '维生素c(mg/100g)',
    vitamin_d                   double(10, 2) default 0.00              not null comment '维生素d(μg/100g)',
    vitamin_e                   double(10, 2) default 0.00              not null comment '维生素e(mg/100g)',
    del_flag                    int           default 2                 not null comment '删除标识(1删除,2正常)',
    choline                     double(10, 2) default 0.00              not null comment '胆碱(mg/100g)',
    biotin                      double(10, 2) default 0.00              not null comment '生物素/维生素7(ug/100g)',
    pantothenic_acid            double(10, 2) default 0.00              not null comment '泛酸(mg/100g)',
    guanine                     double(10, 2) default 0.00              not null comment '鸟嘌呤(mg/100g)',
    adenine                     double(10, 2) default 0.00              not null comment '腺嘌呤(mg/100g)',
    hypoxanthine                double(10, 2) default 0.00              not null comment '次黄嘌呤(mg/100g)',
    xanthine                    double(10, 2) default 0.00              not null comment '黄嘌呤(mg/100g)',
    purine                      double(10, 2) default 0.00              not null comment '总嘌呤含量(mg/100g)',
    glycemic_index              double(10, 2) default 0.00              not null comment '血糖生成指数(GI)',
    total_phytosterol_content   double(10, 2) default 0.00              not null comment '植物甾醇总含量(mg/100g)',
    cereal_sterol               double(10, 2) default 0.00              not null comment 'β-谷甾醇(mg/100g)',
    camelia_sterol              double(10, 2) default 0.00              not null comment '菜油甾醇(mg/100g)',
    sterol                      double(10, 2) default 0.00              not null comment '豆甾醇(mg/100g)',
    cereal_steranol             double(10, 2) default 0.00              not null comment 'β-谷甾烷醇(mg/100g)',
    rapesanol                   double(10, 2) default 0.00              not null comment '菜油甾烷醇(mg/100g)',
    rapeseed_steranol           double(10, 2) default 0.00              not null comment '菜子甾醇(mg/100g)',
    lutein_zeaxanthin           double(10, 2) default 0.00              not null comment '叶黄素+玉米素(μg/100g)',
    quercetin                   double(10, 2) default 0.00              not null comment '槲皮素(mg/100g)',
    myricetin                   double(10, 2) default 0.00              not null comment '杨梅黄酮(mg/100g)',
    luteolin                    double(10, 2) default 0.00              not null comment '玉米黄酮(mg/100g)',
    kaem_pferol                 double(10, 2) default 0.00              not null comment '坎二菲醇(mg/100g)',
    apigenin                    double(10, 2) default 0.00              not null comment '芹菜配基(mg/100g)',
    isoflavone                  double(10, 2) default 0.00              not null comment '大豆异黄酮总含量(mg/100g)',
    daidzein                    double(10, 2) default 0.00              not null comment '黄豆苷元(mg/100g)',
    genistein                   double(10, 2) default 0.00              not null comment '染料木黄酮(mg/100g)',
    glycitein                   double(10, 2) default 0.00              not null comment '黄豆黄素(mg/100g)',
    anthocyan                   double(10, 2) default 0.00              not null comment '花青素(mg/100g鲜重,包含飞燕草素、矢车菊素、芍药素)',
    resveratrol                 double(10, 2) default 0.00              not null comment '白藜芦醇(μg/100g)',
    polydatin                   double(10, 2) default 0.00              not null comment '白藜芦醇苷(μg/100g)',
    origin_place                varchar(32)   default ''                not null comment '备注/原产地',
    calcium                     double(10, 2) default 0.00              not null comment '钙(mg/100g)',
    phosphorus                  double(10, 2) default 0.00              not null comment '磷(mg/100g)',
    kalium                      double(10, 2) default 0.00              not null comment '钾(mg/100g)',
    sodium                      double(10, 2) default 0.00              not null comment '钠(mg/100g)',
    magnesium                   double(10, 2) default 0.00              not null comment '镁(mg/100g)',
    iron                        double(10, 2) default 0.00              not null comment '铁(mg/100g)',
    zinc                        double(10, 2) default 0.00              not null comment '锌(mg/100g)',
    selenium                    double(10, 2) default 0.00              not null comment '硒(μg/100g)',
    cuprum                      double(10, 2) default 0.00              not null comment '铜(mg/100g)',
    manganese                   double(10, 2) default 0.00              not null comment '锰(mg/100g)',
    isoleucine                  double(10, 2) default 0.00              not null comment '异亮氨酸(mg/100g)',
    leucine                     double(10, 2) default 0.00              not null comment '亮氨酸(mg/100g)',
    lysine                      double(10, 2) default 0.00              not null comment '赖氨酸(mg/100g)',
    saa_total                   double(10, 2) default 0.00              not null comment '含硫氨基酸(mg/100g)',
    aaa_total                   double(10, 2) default 0.00              not null comment '芳香族氨基酸(mg/100g)',
    threonine                   double(10, 2) default 0.00              not null comment '苏氨酸(mg/100g)',
    tryptophan                  double(10, 2) default 0.00              not null comment '色氨酸(mg/100g)',
    valine                      double(10, 2) default 0.00              not null comment '缬氨酸(mg/100g)',
    arginine                    double(10, 2) default 0.00              not null comment '精氨酸(mg/100g)',
    histidine                   double(10, 2) default 0.00              not null comment '组氨酸(mg/100g)',
    alanine                     double(10, 2) default 0.00              not null comment '丙氨酸(mg/100g)',
    aspartic_acid               double(10, 2) default 0.00              not null comment '天冬氨酸(mg/100g)',
    glutamate                   double(10, 2) default 0.00              not null comment '谷氨酸(mg/100g)',
    glycine                     double(10, 2) default 0.00              not null comment '甘氨酸(mg/100g)',
    proline                     double(10, 2) default 0.00              not null comment '脯氨酸(mg/100g)',
    serine                      double(10, 2) default 0.00              not null comment '丝氨酸(mg/100g)',
    fatty_acid                  double(10, 2) default 0.00              not null comment '脂肪酸(g/100g可食部)',
    saturated_fatty_acid        double(10, 2) default 0.00              not null comment '饱和脂肪酸(g/100g可食部)',
    monounsaturated_fatty_acid  double(10, 2) default 0.00              not null comment '单不饱和脂肪酸(g/100g可食部)',
    polyunsaturated_fatty_acid  double(10, 2) default 0.00              not null comment '多不饱和脂肪酸(g/100g可食部)',
    iodine                      double(10, 2) default 0.00              not null comment '碘(μg/100g)',
    folic                       double(10, 2) default 0.00              not null comment '叶酸(mg/100g)',
    retinol                     double(10, 2) default 0.00              not null comment '视黄醇(μg/100g)',
    default_flag                int           default 2                 not null comment '是否默认(1-默认,2-非默认)',
    revision                    int           default 0                 not null comment '乐观锁',
    crby                        varchar(32)   default ''                not null comment '创建人',
    crtime                      timestamp     default CURRENT_TIMESTAMP not null comment '创建时间',
    upby                        varchar(32)   default ''                not null comment '更新人',
    uptime                      timestamp     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
)
    comment '食材营养基础信息_新' collate = utf8mb4_unicode_ci
                                  row_format = DYNAMIC;

create index index_nutrition_id
    on eat_clear.menu_nutrition (nutrition_id);

create table eat_clear.recipe_attaches
(
    id         bigint auto_increment
        primary key,
    recipe_id  bigint   default 0                 null comment '食谱id',
    attach     varchar(255)                       null,
    created_at datetime default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP
)
    comment '食谱附件' collate = utf8mb4_unicode_ci
                       row_format = DYNAMIC;

create index idx_recipe_id
    on eat_clear.recipe_attaches (recipe_id);

create table eat_clear.recipe_foods
(
    id         bigint auto_increment
        primary key,
    recipe_id  bigint         default 0                 null comment '食谱id',
    food_id    bigint         default 0                 null comment '食物id',
    number     decimal(10, 2) default 0.00              null comment '分量',
    created_at datetime       default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime       default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP
)
    collate = utf8mb4_unicode_ci
    row_format = DYNAMIC;

create index idx_food_id
    on eat_clear.recipe_foods (food_id);

create index idx_recipe_id
    on eat_clear.recipe_foods (recipe_id);

create table eat_clear.recipes
(
    id         bigint auto_increment
        primary key,
    user_id    bigint   default 0                 null comment '用户id',
    name       varchar(255)                       null,
    summary    text                               null,
    content    text                               null,
    `like`     int      default 0                 null comment '点赞数量',
    created_at datetime default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP
)
    comment '食谱' collate = utf8mb4_unicode_ci
                   row_format = DYNAMIC;

create index idx_user_id
    on eat_clear.recipes (user_id);

create table eat_clear.tags
(
    id         int unsigned auto_increment
        primary key,
    name       varchar(50)                         not null comment '标签名称 (如: 红烧, 健身)',
    type       tinyint   default 1                 not null comment '一级分类: 1-餐次, 2-口味, 3-营养特点, 4-烹饪方式, 5-适用人群, 6-食材状态, 7-过敏原,8-品牌产地,9-时令季节,10-特殊场景,11-存储方式',
    meta_type  varchar(20)                         null comment '二级分类/维度 (用于前端筛选分组, 如: Cooking,人群, 状态)',
    created_at timestamp default CURRENT_TIMESTAMP not null,
    deleted_at datetime                            null,
    constraint uk_name
        unique (name)
)
    comment '标签表' collate = utf8mb4_general_ci
                     row_format = DYNAMIC;

create index idx_type_name
    on eat_clear.tags (type, name);

create table eat_clear.topic_relation
(
    id          bigint auto_increment comment '主键ID'
        primary key,
    topic_id    bigint                             not null comment '话题ID',
    target_id   bigint                             not null comment '关联对象ID（博客ID、餐食记录ID等）',
    target_type tinyint                            not null comment '关联类型 1博客 2餐食记录 3其他',
    created_at  datetime default CURRENT_TIMESTAMP null comment '创建时间',
    constraint idx_topic_target
        unique (topic_id, target_type, target_id)
)
    comment '话题关联表' row_format = DYNAMIC;

create index idx_target
    on eat_clear.topic_relation (target_id, target_type);

create table eat_clear.topics
(
    id          bigint auto_increment comment '话题ID'
        primary key,
    title       varchar(100)                       not null comment '话题标题',
    thumb       varchar(255)                       null comment '话题封面图片',
    description varchar(500)                       null comment '话题描述',
    status      tinyint  default 1                 null comment '状态 1正常 0禁用',
    `join`      int      default 0                 null comment '参与人数',
    post        int      default 0                 null comment '关联文章/餐食记录数',
    created_at  datetime default CURRENT_TIMESTAMP null comment '创建时间',
    updated_at  datetime default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP comment '更新时间'
)
    comment '话题表' row_format = DYNAMIC;

create table eat_clear.units
(
    id         int unsigned auto_increment comment '单位ID'
        primary key,
    name       varchar(50)                                                        not null comment '单位名称',
    type       enum ('weight', 'count', 'volume', 'package', 'service', 'length') not null comment '单位类型 ',
    `desc`     varchar(255)                                                       null comment '描述',
    created_at timestamp default CURRENT_TIMESTAMP                                not null comment '创建时间',
    updated_at timestamp default CURRENT_TIMESTAMP                                not null on update CURRENT_TIMESTAMP comment '更新时间',
    delete_at  timestamp                                                          null,
    constraint uk_name
        unique (name, type, delete_at)
)
    comment '计量单位表' row_format = DYNAMIC;

create index idx_type
    on eat_clear.units (type);

create table eat_clear.user_goals
(
    id             int unsigned auto_increment comment '主键'
        primary key,
    user_id        int unsigned                 not null comment '用户ID',
    daily_calories int            default 2000  not null comment '每日热量目标 (kcal)',
    protein        int            default 150   not null comment '蛋白质 (g)',
    fat            int            default 55    not null comment '脂肪 (g)',
    carbohydrate   int            default 225   not null comment '碳水化合物 (g)',
    weight         decimal(10, 2) default 60.00 not null comment '体重目标 (kg)',
    created_at     datetime                     null comment '创建时间',
    updated_at     datetime                     null comment '更新时间',
    constraint idx_user_id
        unique (user_id)
)
    comment '用户目标设置' collate = utf8mb4_general_ci
                           row_format = DYNAMIC;

create table eat_clear.user_steps
(
    id          int unsigned auto_increment
        primary key,
    user_id     int           not null comment '用户ID',
    steps       int default 0 not null comment '步数',
    record_date date          not null comment '记录日期',
    created_at  datetime      null,
    updated_at  datetime      null,
    constraint user_date
        unique (user_id, record_date)
)
    comment '用户步数记录表' row_format = DYNAMIC;

create table eat_clear.user_usages
(
    id         bigint auto_increment comment 'id'
        primary key,
    user_id    int                                null,
    `usage`    int                                null comment '剩余次数',
    token      int                                null,
    date       date                               null,
    created_at datetime default CURRENT_TIMESTAMP not null,
    updated_at datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP,
    constraint date
        unique (date, user_id)
);

create table eat_clear.wa_admin_roles
(
    id       int auto_increment comment '主键'
        primary key,
    role_id  int not null comment '角色id',
    admin_id int not null comment '管理员id',
    constraint role_admin_id
        unique (role_id, admin_id)
)
    comment '管理员角色表' collate = utf8mb4_general_ci
                           row_format = DYNAMIC;

create table eat_clear.wa_admins
(
    id         int unsigned auto_increment comment 'ID'
        primary key,
    username   varchar(32)                                  not null comment '用户名',
    nickname   varchar(40)                                  not null comment '昵称',
    password   varchar(255)                                 not null comment '密码',
    avatar     varchar(255) default '/app/admin/avatar.png' null comment '头像',
    email      varchar(100)                                 null comment '邮箱',
    mobile     varchar(16)                                  null comment '手机',
    created_at datetime                                     null comment '创建时间',
    updated_at datetime                                     null comment '更新时间',
    login_at   datetime                                     null comment '登录时间',
    status     tinyint                                      null comment '禁用',
    constraint username
        unique (username)
)
    comment '管理员表' collate = utf8mb4_general_ci
                       row_format = DYNAMIC;

create table eat_clear.wa_options
(
    id         int unsigned auto_increment
        primary key,
    name       varchar(128)                           not null comment '键',
    value      longtext                               not null comment '值',
    created_at datetime default '2022-08-15 00:00:00' not null comment '创建时间',
    updated_at datetime default '2022-08-15 00:00:00' not null comment '更新时间',
    constraint name
        unique (name)
)
    comment '选项表' collate = utf8mb4_general_ci
                     row_format = DYNAMIC;

create table eat_clear.wa_roles
(
    id         int unsigned auto_increment comment '主键'
        primary key,
    name       varchar(80)  not null comment '角色组',
    rules      text         null comment '权限',
    created_at datetime     not null comment '创建时间',
    updated_at datetime     not null comment '更新时间',
    pid        int unsigned null comment '父级'
)
    comment '管理员角色' collate = utf8mb4_general_ci
                         row_format = DYNAMIC;

create table eat_clear.wa_rules
(
    id         int unsigned auto_increment comment '主键'
        primary key,
    title      varchar(255)             not null comment '标题',
    icon       varchar(255)             null comment '图标',
    `key`      varchar(255)             not null comment '标识',
    pid        int unsigned default '0' null comment '上级菜单',
    created_at datetime                 not null comment '创建时间',
    updated_at datetime                 not null comment '更新时间',
    href       varchar(255)             null comment 'url',
    type       int          default 1   not null comment '类型',
    weight     int          default 0   null comment '排序'
)
    comment '权限规则' collate = utf8mb4_general_ci
                       row_format = DYNAMIC;

create table eat_clear.wa_uploads
(
    id           int auto_increment comment '主键'
        primary key,
    name         varchar(128)                 not null comment '名称',
    url          varchar(255)                 not null comment '文件',
    admin_id     int                          null comment '管理员',
    file_size    int                          not null comment '文件大小',
    mime_type    varchar(255)                 not null comment 'mime类型',
    image_width  int                          null comment '图片宽度',
    image_height int                          null comment '图片高度',
    ext          varchar(128)                 not null comment '扩展名',
    storage      varchar(255) default 'local' not null comment '存储位置',
    created_at   date                         null comment '上传时间',
    category     varchar(128)                 null comment '类别',
    updated_at   date                         null comment '更新时间'
)
    comment '附件' collate = utf8mb4_general_ci
                   row_format = DYNAMIC;

create index admin_id
    on eat_clear.wa_uploads (admin_id);

create index category
    on eat_clear.wa_uploads (category);

create index ext
    on eat_clear.wa_uploads (ext);

create index name
    on eat_clear.wa_uploads (name);

create table eat_clear.wa_users
(
    id         int unsigned auto_increment comment '主键'
        primary key,
    username   varchar(32)                        not null comment '用户名',
    nickname   varchar(40)                        not null comment '昵称',
    password   varchar(255)                       not null comment '密码',
    sex        enum ('1', '2', '3') default '1'   not null comment '性别1男2女3保密',
    avatar     varchar(255)                       null comment '头像',
    email      varchar(128)                       null comment '邮箱',
    mobile     varchar(16)                        null comment '手机',
    openid     varchar(255)                       null comment '微信openid',
    unionid    varchar(255)                       null comment '微信unionid',
    signature  varchar(255)                       null comment '个性签名',
    background varchar(255)                       null comment '背景图',
    age        int                  default 0     null comment '年龄',
    tall       int                  default 170   null comment '身高 cm',
    weight     decimal(10, 2)       default 62.00 null comment '体重 kg',
    bmi        decimal(10, 2)                     null comment 'bmi',
    bust       decimal(10, 2)                     null comment '胸围 cm',
    waist      decimal(10, 2)                     null comment '腰围 cm',
    hip        decimal(10, 2)                     null comment '臀围 cm',
    target     int                                null comment '卡路里目标',
    level      tinyint              default 0     not null comment '等级',
    birthday   date                               null comment '生日',
    money      decimal(10, 2)       default 0.00  not null comment '余额(元)',
    score      int                  default 0     not null comment '积分',
    last_time  datetime                           null comment '登录时间',
    last_ip    varchar(50)                        null comment '登录ip',
    join_time  datetime                           null comment '注册时间',
    join_ip    varchar(50)                        null comment '注册ip',
    token      varchar(50)                        null comment 'token',
    created_at datetime                           null comment '创建时间',
    updated_at datetime                           null comment '更新时间',
    role       int                  default 1     not null comment '角色',
    status     tinyint              default 1     not null comment '禁用',
    constraint username
        unique (username)
)
    comment '用户表' collate = utf8mb4_general_ci
                     row_format = DYNAMIC;

create index email
    on eat_clear.wa_users (email);

create index join_time
    on eat_clear.wa_users (join_time);

create index mobile
    on eat_clear.wa_users (mobile);

