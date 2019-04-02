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
class FlightTask extends Controller
{
    #首页
    public function index(){
        $flights=Db::table("flight_base")->whereTime('end_date','>',date("Y-m-d",time()))->select();
        
        dump($flights);
        
        return view();
    }
    
    #添加航班任务界面
    public function toAddFlightTask(){
        return view();
    }
    

    public function flightTaskDetails(){
        return view();
    }
}
