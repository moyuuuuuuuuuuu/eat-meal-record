<?php

namespace app\common\base;



abstract class BaseBusiness
{
    // 1. 显式赋值 null，解决 "must not be accessed before initialization" 报错
    protected static self|null $instance = null;

    protected ?BaseModel $model = null;
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
        if (!static::$instance instanceof static) {
            static::$instance = new static($model);
        }

        // 每次返回前重置状态，防止 CLI 环境下的数据污染
        return static::$instance->reset();
    }

    public function reset(): static{
        $this->model = null;
        return $this;
    }

    private function __clone() {}
    public function __wakeup() { throw new \Exception("Cannot unserialize singleton"); }

    public function isLoadedModel()
    {
        return (bool)$this->model || (bool)$this->staticModel;
    }

    protected function loadModel(BaseModel $model)
    {
        $this->model = $model;
        $this->loadStaticModel($model);
    }

    protected function loadStaticModel(BaseModel $model){
        $this->staticModel = $model;
    }

    protected function getModel(){
        return $this->model ?? new $this->staticModel();
    }
}
