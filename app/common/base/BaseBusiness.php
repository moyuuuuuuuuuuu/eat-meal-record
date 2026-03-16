<?php

namespace app\common\base;


abstract class BaseBusiness
{
    // 1. 显式赋值 null，解决 "must not be accessed before initialization" 报错
    protected static array $instances = [];

    protected ?BaseModel $model       = null;
    protected ?BaseModel $staticModel = null;

    // 私有化构造函数，强制通过 instance() 访问
    protected function __construct(BaseModel $model = null)
    {
        $this->model = $model;
    }

    /**
     * 获取单例
     */
    public static function instance(BaseModel $model = null): static
    {
        $class = static::class;
        if (!isset(self::$instances[$class])) {
            self::$instances[$class] = new static($model);
        } elseif ($model !== null) {
            self::$instances[$class]->loadModel($model);
        }
        return self::$instances[$class];
    }

    /**
     * 重置模型
     */
    public function reset(): static
    {
        $this->model = null;
        return $this;
    }

    private function __clone()
    {
    }

    public function __wakeup()
    {
        throw new \Exception("Cannot unserialize singleton");
    }

    /**
     * 判断是否已加载模型
     */
    public function isLoadedModel(): bool
    {
        return $this->model !== null || $this->staticModelClass !== null;
    }

    /**
     * 加载模型实例
     */
    protected function loadModel(BaseModel $model): void
    {
        $this->model            = $model;
        $this->staticModelClass = get_class($model);
    }

    /**
     * 获取模型实例
     *
     * @return BaseModel
     */
    protected function getModel(): BaseModel
    {
        if ($this->model !== null) {
            return $this->model;
        }

        if ($this->staticModelClass !== null) {
            return new $this->staticModelClass();
        }

        throw new \RuntimeException("No model loaded in " . static::class);
    }
}
