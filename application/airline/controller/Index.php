<?php
namespace app\airline\controller;
use think\Controller;
use think\Db;
use think\Session;
use think\Loader;
use think\Request;
/**
 * author 罗佳
 */
class Index extends Controller
{
    #首页
    public function Index()
    {
        return view();
    }

    #登录
    public function Login()
    {
        if($this->request->isPost()){
            #获取登录信息
            $userinfo=$_POST['userinfo'];//用户电话或邮箱
            $password=$_POST['password'];//用户密码

            #和数据库进行比对(userTel or email)，返回用户信息
            $data=Db::table("user_company")->where("userTel='$userinfo' and password='$password'")->select();
            if(!boolval($data)){
                $data=Db::table("user_company")->where("email='$userinfo' and password='$password'")->select();
            }
            
            #判断结果
            if(boolval($data)){
                #Session保存用户Tel
                Session::set('airline_userTel',$data[0]['userTel']);
                #Session保存用户名
                Session::set('airline_username',$data[0]['user_name']);
                 #Session保存账户所属航空公司
                 Session::set('airline_companyId',$data[0]['company_id']);

                $this->success("登录成功","index/index");
            }else{
                $this->error("用户名或密码错误");
            }
        }
    }

    #注销登录
    public function logout()
    {
        #清除相关的session
        Session::delete('airline_userTel');
        Session::delete('airline_username');
        Session::delete('airline_companyId');
        
        $this->success("注销成功","index/index");
    }

    public function sendMsg()
    {
        $tel=$_POST["tel"];
        Loader::import('alimsg.api_demo.SmsDemo',EXTEND_PATH);//对应extend目录，路径，如果你对SmsDemo类添加了命名空间可在上面 use 后在此处直接实例化

        $code = rand(100000,999999);
        session('code',$code);

        //得到信息文件并执行.实例化阿里短信类
        $msg = new \SmsDemo();
        
        //此配置在sdk包中有相关例子
        $res = $msg->sendSms(
            //短信签名名称
            "smile佳",//此处填写你在阿里云平台配置的短信签名名称（第二步有说明）
            //短信模板code
            "SMS_147439706",//此处填写你在阿里云平台配置的短信模板code（第二步有说明）
            //短信接收者的手机号码
            $tel,
            //模板信息
            Array(
                'code' => $code,//随机变化的
            )
        );
        dump($res);

    }

    public function checkMsg()
    {
        $code = input('post.code');
        if($code == session('code'))
        {
            session('code',null);
            return 1;
        }
        return "验证码错误";
    }
 
    
    
}
