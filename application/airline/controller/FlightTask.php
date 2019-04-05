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
        
        return view();
    }
    
    #添加航班任务界面
    public function toAddFlightTrip(){
        $flightType=Db::table("flight_type")->select();
        $this->assign("flightType",$flightType);
        return view();
    }

    #添加航班
    public function addFlightTask(){
        #数据控制
        if($_POST["flight_id"]==""){
            $this->error("航班号不能为空");
        }

        $data=$_POST;

        #生成航班匹配码
        $filghtCode=md5($_POST["flight_id"]."|".date("Y-m-d H:i:s",time()));
        $data["flight_match_code"]=$filghtCode;

        #提交到数据库
        $count=Db::table("flight_base")->insert($data);
        if($count>0){
            $this->success("添加成功");
        }
        else{
            $this->error("添加失败");
        }
    }
    

    public function flightTaskDetails(){
        return view();
    }



    public function ajaxTest(Request $request){
        #接收前端的ajax信息，写入文件测试
        // $myfile = fopen("ajaxtest.txt", "w") or die("Unable to open file!");
        // $finalData= $request->param("final_data");
        // fwrite($myfile, $finalData);
        // fclose($myfile);

        $finalData="{\"occupation\":\"F/O\",\"PPN\":\"432423\",\"DOE\":\"2019-04-10\",\"POB\":\"天津\",\"name\":\"罗佳\",\"gender\":\"MALE\",\"nationality\":\"中国\",\"DOB\":\"2019-04-10\"}";

        $msg;//返回给前端的信息

        #从session读取companyId
        $companyId=Session::get("airline_companyId");

        #判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $msg=[
                "statu"=>"error",
                "detailes"=>"请先登录"
            ];
        }

        #解析前端传送过来的数据
        $staff=json_decode($finalData,true);

        #生成新的员工id
        $staffInfo=Db::table("flight_leg_crew_staff")->where(["leg_match_code"=>"123"])->order('staff_id','desc')->limit(1)->select();
        if(empty($staffId)){
            $staffId=1;
        }
        else{
            $staffId=$staffInfo[0]["staff_id"]+1;
        }

        #组装数据
        $staff["staff_id"]=$staffId;

        #提交数据到数据库
        $count=Db::table("flight_leg_crew_staff")->insert($staff);
        if($count>0){
            $msg=[
                "statu"=>"success",
                "detailes"=>"提交成功"
            ];
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
        }

        dump($staff);
        dump($msg);
    }
}
