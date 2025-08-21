<?php

namespace app\model;

class BlogCommentModel extends BaseModel
{
    protected $table    = 'blog_comment';
    protected $fillable = [
        'blog_id',
        'user_id',
        'content',
        'parent_id',
        'like_count',
        'parent_user_id',
    ];

    public function parent()
    {
        return $this->belongsTo(BlogModel::class, 'parent_id', 'id')->with('user');
    }

    public function user()
    {
        return $this->belongsTo(UserModel::class, 'user_id', 'id')->select(['id', 'name', 'avatar', 'gender']);
    }
}
