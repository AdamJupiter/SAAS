<?php
namespace app\servers\controller;
use think\Controller;
use think\Db;
use think\Session;

class Index extends Controller
{
    #首页
    public function index()
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
             $data=Db::table("user_servers")->where("userTel='$userinfo' and password='$password'")->select();
             if(!boolval($data)){
                 $data=Db::table("user_servers")->where("email='$userinfo' and password='$password'")->select();
             }
             
             #判断结果
             if(boolval($data)){
                 #Session保存用户Tel
                 Session::set('servers_userTel',$data[0]['userTel']);
                 #Session保存用户名
                 Session::set('servers_username',$data[0]['user_name']);
                  #Session保存账户id
                  Session::set('servers_staff_id',$data[0]['servers_staff_id']);
 
                 $this->success("登录成功","index/main");
             }else{
                 $this->error("用户名或密码错误");
             }
         }
     }
 
     #注销登录
     public function logout()
     {
         #清除相关的session
         Session::delete('servers_userTel');
         Session::delete('servers_username');
         Session::delete('servers_staff_id');
         
         $this->success("注销成功","index/index");
     }

     #主页
     public function main(){
         return view();
     }

     
}
