<?php

namespace app\controller;

use app\common\base\BaseController;
use app\common\validate\LocationValidator;
use app\service\baidu\Ibs;
use support\Request;
use Webman\Validation\Annotation\Validate;

class LocationController extends BaseController
{
    protected $noNeedLogin = [];

    /**
     * 逆地理编码
     * @param Request $request
     * @return \support\Response
     */
    #[Validate(validator: LocationValidator::class, scene: 'rgeo')]
    public function rgeo(Request $request)
    {
        $addressData = Ibs::instance()->getAddress($request->get('latitude'), $request->get('longitude'));
        if ($addressData['business']) {
            $business = explode(',', $addressData['business']);
            $business = array_pop($business);
        } else {
            $business = $addressData['addressComponent']['city'];
        }
        $address = [
            $addressData['addressComponent']['province'],
            $addressData['addressComponent']['city'],
            $addressData['addressComponent']['town'],
        ];
        return $this->success('ok', [
            'address' => implode('', $address),
            'name'    => $business,
        ]);
    }
}
