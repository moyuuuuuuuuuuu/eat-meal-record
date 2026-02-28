<?php

namespace app\common\validate;

use app\common\base\BaseValidator;
use app\common\enum\blog\AttachType;
use app\common\enum\blog\Visibility;
use support\validation\{Rule};

class FeedValidator extends BaseValidator
{

    protected array $messages = [
        'visibility.required'         => '请选择可见度',
        'visibility.in'               => '可见度参数错误',
        'content.required'            => '发布内容不能为空',
        'content.string'              => '发布内容必须是字符串',
        'content.max'                 => '发布内容最多不能超过255个字符',
        'attach.required'             => '请上传附件',
        'attach.array'                => '附件数据格式不正确',
        'attach.max'                  => '附件数量最多不能超过255个',
        'attach.*.type.required'      => '附件类型不能为空',
        'attach.*.type.in'            => '附件类型不合法',
        'attach.*.attach.required'    => '附件不能为空',
        'attach.*.poster.required_if' => '视频封面图不能为空',
        'attach.*.poster.string'      => '视频封面图地址必须是字符串',
        'topics.array'                => '话题数据格式不正确',
        'topics.*.required'           => '话题ID不能为空',
        'topics.*.min'                => '话题ID格式不正确',
        'topics.*.numeric'            => '话题ID必须是数字',
        'location.array'              => '地理位置数据格式不正确',
        'location.latitude.numeric'   => '纬度格式不正确',
        'location.longitude.numeric'  => '经度格式不正确',
        'location.address.string'     => '地理位置详细地址必须是字符串',
        'location.name.string'        => '地理位置名称必须是字符串',
        'id.required'                 => '缺少动态ID',
        'id.numeric'                  => '动态ID必须是数字',
        'id.min'                      => '动态ID不合法',
    ];

    protected array $scenes = [
        'create' => ['content', 'attach', 'topics', 'location'],
        'like'   => ['id']
    ];

    public function rules(): array
    {
        $this->rule = [
            'id'                 => ['required', 'numeric', 'min:1'],
            'content'            => ['required', 'string', 'max:255'],
            'visibility'         => ['required', Rule::in(Visibility::cases())],
            'attach'             => ['required', 'array', 'max:255'],
            'attach.*.type'      => ['required', Rule::in(AttachType::values())],
            'attach.*.attach'    => ['required'],
            'attach.*.poster'    => ['required_if.attach.*.type,' . AttachType::VIDEO->value, 'string'],
            'topics'             => ['nullable', 'array'],
            'topics.*'           => ['required', 'min:1', 'numeric'],
            'location'           => ['nullable', 'array'],
            'location.latitude'  => ['nullable', 'numeric'],
            'location.longitude' => ['nullable', 'numeric'],
            'location.address'   => ['nullable', 'string'],
            'location.name'      => ['nullable', 'string'],
        ];
        return parent::rules();
    }
}
