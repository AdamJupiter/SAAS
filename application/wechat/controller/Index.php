<?php
/**
 * 发送验证码到手机
 */

namespace app\wechat\controller;
use EasyWeChat\Factory;
use think\Controller;
class Index extends Controller
{
    public function index() {
        $config = [
            'app_id' => 'wx3cf0f39249eb0xxx',
            'secret' => 'f1c242f4f28f735d4687abb469072xxx',
            'token' => 'TestToken',
            'response_type' => 'array',

            'log' => [
                'level' => 'debug',
                'file' => __DIR__.'/wechat.log',
            ],
        ];

        $app = Factory::officialAccount($config);
        $app->server->push(function ($message) {
            return "您好！欢迎使用 EasyWeChat!";
        });
        $response = $app->server->serve();
        $response->send();
    }
}