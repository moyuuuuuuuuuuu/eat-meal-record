<?php

namespace app\common\context;

/**
 * @property  int $id;
 * @property string $username;
 * @property string $nickname;
 * @property int $sex;
 * @property string $avatar;
 * @property string $email;
 * @property string $mobile;
 * @property string $openid;
 * @property string $unionid;
 * @property string $signature;
 * @property string $background;
 * @property string $age;
 * @property string $tall;
 * @property string $weight;
 * @property string $bmi;
 * @property string $bust;
 * @property string $waist;
 * @property string $hip;
 * @property string $target;
 * @property string $level;
 * @property string $birthday;
 * @property string $status;
 */
final class UserInfoData implements \JsonSerializable
{
    /**
     * @var int
     */
    protected int $id;
    /**
     * @deprecated
     * @var string
     */
    protected ?string $username;
    /**
     * @var string
     */
    protected string $nickname;
    /**
     * @var int
     */
    protected int     $sex;
    protected ?string $avatar;
    protected ?string $email;
    protected ?string $mobile;
    protected string  $openid;
    protected ?string $unionid;
    protected ?string $signature;
    protected ?string $background;
    protected ?int    $age;
    protected ?int    $tall;
    protected ?float  $weight;
    protected ?float  $bmi;
    /**
     * 胸围
     * @var float|null
     */
    protected ?float $bust;
    /**
     * 腰围
     * @var float|null
     */
    protected ?float $waist;
    /**
     * 臀围
     * @var float|null
     */
    protected ?float $hip;
    /**
     * 卡路里目标
     * @var int|null
     */
    protected ?int    $target;
    protected ?int    $level;
    protected ?string $birthday;
    protected ?int    $status;
    protected ?string $sex_text;
    protected ?string $status_text;
    protected array   $data   = [];
    protected array   $hidden = [];

    public function __construct(array $userInfo)
    {
        foreach ($userInfo as $k => $v) {
            if (property_exists($this, $k)) {
                $this->data[$k] = $v;
            }
        }
    }

    public function toArray(): array
    {
        $array = [];
        foreach ($this->data as $k => $v) {
            if (in_array($k, $this->hidden)) {
                unset($array[$k]);
            }
            $array[$k] = $v;
        }
        return $array;
    }

    public function jsonSerialize(): array
    {
        return $this->toArray();
    }

    public function __get(string $name)
    {
        return $this->data[$name] ?? null;
    }

    public function hidden(...$field): self
    {
        $this->hidden = $field;
        return $this;
    }

}
