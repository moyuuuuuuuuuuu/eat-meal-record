<?php

namespace app\model;


class BlogLocationModel extends BaseModel
{
    protected $table      = 'blog_location';
    public    $timestamps = false;
    protected $fillable   = [
        'blog_id',
        'latitude',
        'longitude',
        'address',
        'name'
    ];
}
