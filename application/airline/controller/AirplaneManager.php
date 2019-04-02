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
class AirplaneManager extends Controller
{
    #飞机管理首页
    public function Index(){

        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $this->error("请先登录");
        }

        $where=[
            "company_id"=>$companyId
        ];
        $airplanes=Db::table("airplane_in_company")->where($where)->select();

        $this->assign("airplanes",$airplanes);
        return view();
       
    }

    #查看飞机详情
    public function AirplaneDeatails($airplane_id){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $this->error("请先登录");
        }

        $where=[
            "company_id"=>$companyId,
            "airplane_id"=>$airplane_id
        ];
        $airplane=Db::table("airplane_in_company")->where($where)->select();

        $this->assign("airplane",$airplane[0]);
        return view();
    }

    #修改该公司的飞机信息界面
    public function changeAirplaneInfo($airplane_id){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $this->error("请先登录");
        }

        $where=[
            "company_id"=>$companyId,
            "airplane_id"=>$airplane_id
        ];
        $airplane=Db::table("airplane_in_company")->where($where)->select();

        $this->assign("airplane",$airplane[0]);
        return view();
    }

    public function updateAirplaneInfo(){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $this->error("请先登录");
        }

        $airplane_id=$_POST["airplane_id"];

        $where=[
            "company_id"=> $companyId,
            "airplane_id"=> $airplane_id
        ];
        $data=[
            "register_num"=>$_POST["注册号"],
            "call_sign"=>$_POST["呼号"],
            "airplane_type"=>$_POST["机型"],
            "total_Passenger"=>$_POST["载客数"],
            "MTOW"=>$_POST["MTOW"]
        ];

        $count=Db::table("airplane_in_company")->where($where)->update($data);

        if($count<=0){
            $this->error("修改失败或未有任何数据发生变化");
        }else{
            $this->success("修改成功","AirplaneManager/index");
        }
    }

    #增加飞机界面
    public function toAddAirplane(){
        return view();
    }

    #增加飞机-功能
    public function addAirplane(){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $this->error("请先登录");
        }

        $data=[
            "company_id"=> $companyId,
            "register_num"=>$_POST["注册号"],
            "call_sign"=>$_POST["呼号"],
            "airplane_type"=>$_POST["机型"],
            "total_Passenger"=>$_POST["载客数"],
            "MTOW"=>$_POST["MTOW"]
        ];
        $count=Db::table("airplane_in_company")->insert($data);

        if($count>0){
            $this->success("增加成功","AirplaneManager/index");
        }else{
            $this->error("增加失败");
        }
    }

    #删除飞机
    public function deleteAirplane($airplane_id){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $this->error("请先登录");
        }

        $where=[
            "company_id"=> $companyId,
            "airplane_id"=> $airplane_id
        ];
        $count=Db::table("airplane_in_company")->where($where)->delete();
        if($count>0){
            $this->success("删除成功","AirplaneManager/index");
        }else{
            $this->error("删除失败");
        }

    }

    
}
