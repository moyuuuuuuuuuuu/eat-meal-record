<?php

namespace app\service\sms;

class Sms
{

    const LOGIN_TEMPLET_CODE = 'SMS_492520178';
    const DEFAULT_SIGN_NAME  = '木头IO';
    private $signName = self::DEFAULT_SIGN_NAME;
    private $templet  = self::LOGIN_TEMPLET_CODE;
    private $templetParams;
    private $phoneNumber;

    protected $apiCall;

    public function __construct()
    {
        $this->apiCall = new ApiCall(env('ALI_ACCESS_KEY_ID'), env('ALI_ACCESS_KEY_SECRET'));
    }

    /**
     * @param $phoneNumber
     * @return Sms
     */
    public function setPhoneNumber($phoneNumber)
    {
        $this->phoneNumber = $phoneNumber;
        return $this;
    }


    /**
     * @param $signName
     * @return Sms
     */
    public function setSignName($signName)
    {
        $this->signName = $signName;
        return $this;
    }

    /**
     * @param $templet
     * @return Sms
     */
    public function setTemplet($templet)
    {
        $this->templet = $templet;
        return $this;
    }

    /**
     * @param array $templetParams
     * @return Sms
     */
    public function setTempletParams(array $templetParams)
    {
        $this->templetParams = json_encode($templetParams);
        return $this;
    }

    /**
     * @return array
     */
    public function send()
    {
        $result = $this->apiCall->setAction('SendSms')
            ->setVersion()
            ->setParams([
                'PhoneNumbers'  => $this->phoneNumber,
                'SignName'      => $this->signName,
                'TemplateCode'  => $this->templet,
                'TemplateParam' => $this->templetParams,
            ])->call();
        if ($result['Code'] !== 'OK') {
            throw new \Exception($result['Message']);
        }
        return $result['RequestId'];
    }
}
