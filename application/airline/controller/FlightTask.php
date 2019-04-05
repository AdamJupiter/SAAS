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
            $this->success("添加成功",url("FlightTask/toaddflightleg",array('filghtCode'=>$filghtCode)));
        }
        else{
            $this->error("添加失败");
        }
    }

    #添加航段页面
    public function toaddflightleg($filghtCode){
        #将航班号给前端
        $where=[
            'flight_match_code'=>$filghtCode
        ];
        $flightId=Db::table("flight_base")->where($where)->select();
        $this->assign("flightId",$flightId[0]["flight_id"]);


        #将航班匹配码给前端
        $this->assign("filghtCode",$filghtCode);

        #生成航段号并传给前端
        $where=[
            'flight_match_code'=>$filghtCode
        ];  
        $newLegId=Db::table("flight_contain_leg")->where($where)->max("leg_id")+1;
        $this->assign("newLegId",$newLegId);

        #将飞行类型传给前端
        $flightType=Db::table("flight_type")->select();
        $this->assign("flightType",$flightType);

        #将员工职位给前端
        $crewOccupation=Db::table("crew_occupation_meaning")->select();
        $this->assign("crewOccupation",$crewOccupation);

        #将国籍信息给前端
        $countrys=Db::table("country")->select();
        $this->assign("countrys",$countrys);

        #将航班许可类型传给前端
        $flightPermissionType=Db::table("flight_permission_type")->select();
        $this->assign("flightPermissionType",$flightPermissionType);

        return view();
    }
    

    public function flightTaskDetails(){
        return view();
    }

    #添加航段
    public function addLeg(){
        #从session读取companyId
        $companyId=Session::get("airline_companyId");
        #判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $msg=[
                "statu"=>"error",
                "detailes"=>"请先登录"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
             
        }

        #接收前端的ajax信息
        // $receiveData= $request->param("final_data");

        #模拟接收的数据
        $receiveData= '{"flight_match_code":"9d20510591b84cb27525b055cc622e94","leg_id":1,"origin_code":"ABCD","depart_time":"2019-04-05 14:27:29","depart_code":"CDEF","arrive_time":"2019-04-05 14:27:38","flight_type":"FERRY"}';
       
        #解析前端传送过来的数据
        $flightLeg=json_decode($receiveData,true);

        #提交数据到数据库
        $count=Db::table("flight_contain_leg")->insert($flightLeg);
        if($count>0){
            $msg=[
                "statu"=>"success",
                "detailes"=>"提交成功"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
             
        }
        
    }

    #添加航段工作人员
    public function addLegCrew(){
        #从session读取companyId
        $companyId=Session::get("airline_companyId");
        #判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $msg=[
                "statu"=>"error",
                "detailes"=>"请先登录"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
             
        }

        #接收前端的ajax信息
        // $receiveData= $request->param("final_data");
        #模拟接收的数据
        $receiveData='{"flight_match_code":"6fcede7bb95e3e2410cd5af224f091a0","leg_id":"1","name":"中国","gender":"M","occupation":"F\/O","DOB":"2019-04-10","PPN":"432423","POB":"432","DOE":"2019-04-10","nationality":"中国"}';
        
       
        #解析前端传送过来的数据
        $flightLegCrew=json_decode($receiveData,true);

        #生成员工id
        $where=[
            "flight_match_code"=>$flightLegCrew["flight_match_code"],
            "leg_id"=>$flightLegCrew["leg_id"]
        ];
        $newFlightLegCrewId=Db::table("flight_leg_crew_staff")->where($where)->max("staff_id")+1;
        dump($newFlightLegCrewId);

        #组装数据
        $flightLegCrew["staff_id"]=$newFlightLegCrewId;


        #提交数据到数据库
        $count=Db::table("flight_leg_crew_staff")->insert($flightLegCrew);
        if($count>0){
            $msg=[
                "statu"=>"success",
                "detailes"=>"提交成功"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
             
        }
    }

    #添加航段乘客
    public function addLegPassenger(){
        #从session读取companyId
        $companyId=Session::get("airline_companyId");
        #判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $msg=[
                "statu"=>"error",
                "detailes"=>"请先登录"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }

        #接收前端的ajax信息
        // $receiveData= $request->param("final_data");

        #模拟接收的数据
        $receiveData='{"flight_match_code":"6fcede7bb95e3e2410cd5af224f091a0","leg_id":1,"name":"罗佳","DOE":"2019-04-05","gender":"M","PPN":"7482278","DOB":"2019-04-05","nationality":"中国"}';
        
       
        #解析前端传送过来的数据
        $flightLegCrew=json_decode($receiveData,true);

        #生成乘客id
        $where=[
            "flight_match_code"=>$flightLegCrew["flight_match_code"],
            "leg_id"=>$flightLegCrew["leg_id"]
        ];
        $newFlightLegCrewId=Db::table("flight_leg_passenger")->where($where)->max("passenger_id")+1;
        dump($newFlightLegCrewId);

        #组装数据
        $flightLegCrew["passenger_id"]=$newFlightLegCrewId;


        #提交数据到数据库
        $count=Db::table("flight_leg_passenger")->insert($flightLegCrew);
        if($count>0){
            $msg=[
                "statu"=>"success",
                "detailes"=>"提交成功"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
             
        }
    }

    #添加航段许可
    public function addLegPermit(){
        #从session读取companyId
        $companyId=Session::get("airline_companyId");
        #判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $msg=[
                "statu"=>"error",
                "detailes"=>"请先登录"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
             
        }

        #接收前端的ajax信息
        // $receiveData= $request->param("final_data");

        #模拟接收的数据
        $receiveData='{"flight_match_code":"6fcede7bb95e3e2410cd5af224f091a0","leg_id":1,"nation":"中国","permit_type":"OVF","permit_no":"17383812318"}';
       
        #解析前端传送过来的数据
        $flightLegPemit=json_decode($receiveData,true);

         #判断数据是否存在
         $where=[
            "flight_match_code"=>$flightLegPemit["flight_match_code"],
            "leg_id"=>$flightLegPemit["leg_id"]
        ];
        $isExist=!empty(Db::table("flight_leg_permit")->where($where)->select());
        if($isExist){
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据已存在，请勿重复添加"
            ];
            return json_encode($msg,JSON_UNESCAPED_UNICODE);   
        }

        #提交数据到数据库
        $count=Db::table("flight_leg_permit")->insert($flightLegPemit);
        if($count>0){
            $msg=[
                "statu"=>"success",
                "detailes"=>"提交成功"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
             
        }
    }

    #添加航段FBO
    public function addLegFBO(){
        #从session读取companyId
        $companyId=Session::get("airline_companyId");
        #判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $msg=[
                "statu"=>"error",
                "detailes"=>"请先登录"
            ];
            return json_encode($msg,JSON_UNESCAPED_UNICODE);  
        }

        #接收前端的ajax信息
        // $receiveData= $request->param("final_data");

        #模拟接收的数据
        $receiveData='{"flight_match_code":"6fcede7bb95e3e2410cd5af224f091a0","leg_id":1,"fbo_name":"经典款卡航段号","fbo_address":"的几哈客户端咔汇顶科技看","fbo_VHF":345.6780090332,"fbo_fex":"312312","fbo_tel":"312231"}';
       
        #解析前端传送过来的数据
        $flightLegFBO=json_decode($receiveData,true);

        #判断数据是否存在
        $where=[
            "flight_match_code"=>$flightLegFBO["flight_match_code"],
            "leg_id"=>$flightLegFBO["leg_id"]
        ];
        $isExist=!empty(Db::table("flight_leg_airport_fbo")->where($where)->select());
        if($isExist){
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据已存在，请勿重复添加"
            ];
            return json_encode($msg,JSON_UNESCAPED_UNICODE);   
        }

        #提交数据到数据库
        $count=Db::table("flight_leg_airport_fbo")->insert($flightLegFBO);
        if($count>0){
            $msg=[
                "statu"=>"success",
                "detailes"=>"提交成功"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);      
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }

        dump($flightLegFBO);
        dump($msg);
    }

    #添加航段酒店信息
    public function addLegHotel(){
        #从session读取companyId
        $companyId=Session::get("airline_companyId");
        #判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $msg=[
                "statu"=>"error",
                "detailes"=>"请先登录"
            ];
            return json_encode($msg,JSON_UNESCAPED_UNICODE);  
        }

        #接收前端的ajax信息
        // $receiveData= $request->param("final_data");

        #模拟接收的数据
        $receiveData='{"flight_match_code":"6fcede7bb95e3e2410cd5af224f091a0","leg_id":1,"airport_code":"ADBC","hotel_name":"7天酒店","hotel_address":"就看到巨好看"}';
       
        #解析前端传送过来的数据
        $flightLegHotel=json_decode($receiveData,true);

        #判断数据是否存在
        $where=[
            "flight_match_code"=>$flightLegHotel["flight_match_code"],
            "leg_id"=>$flightLegHotel["leg_id"]
        ];
        $isExist=!empty(Db::table("flight_leg_hotel")->where($where)->select());
        if($isExist){
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据已存在，请勿重复添加"
            ];
            return json_encode($msg,JSON_UNESCAPED_UNICODE);   
        }

        #提交数据到数据库
        $count=Db::table("flight_leg_hotel")->insert($flightLegHotel);
        if($count>0){
            $msg=[
                "statu"=>"success",
                "detailes"=>"提交成功"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);      
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }
    }

   

    #添加航段接机信息
    public function addLegTransportation(){
        #从session读取companyId
        $companyId=Session::get("airline_companyId");
        #判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $msg=[
                "statu"=>"error",
                "detailes"=>"请先登录"
            ];
            return json_encode($msg,JSON_UNESCAPED_UNICODE);  
        }

        #接收前端的ajax信息
        // $receiveData= $request->param("final_data");

        #模拟接收的数据
        $receiveData= '{"flight_match_code":"6fcede7bb95e3e2410cd5af224f091a0","leg_id":1,"airport":"dasd","vehicle":"大卡车","driver":"葵司","tel":783867812,"pick_up_time_utc":"2019-04-05 16:53:07","local_time":"2019-04-05 16:53:11","pick_up_point":"建华大街"}';

         #解析前端传送过来的数据
        $flightLegTransportation=json_decode($receiveData,true);

        #判断数据是否存在
        $where=[
            "flight_match_code"=>$flightLegTransportation["flight_match_code"],
            "leg_id"=>$flightLegTransportation["leg_id"]
        ];
        $isExist=!empty(Db::table("flight_leg_crew_transportation")->where($where)->select());
        if($isExist){
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据已存在，请勿重复添加"
            ];
            return json_encode($msg,JSON_UNESCAPED_UNICODE);   
        }

        #提交数据到数据库
        $count=Db::table("flight_leg_crew_transportation")->insert($flightLegTransportation);
        if($count>0){
            $msg=[
                "statu"=>"success",
                "detailes"=>"提交成功"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);      
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }
    }

    public function getJsonData(){
        $receiveData=Db::table("flight_leg_remarks")->select()[0];
        dump(json_encode($receiveData,JSON_UNESCAPED_UNICODE));
    }

    #添加航段备注
    public function addLegRemaks(){
        #从session读取companyId
        $companyId=Session::get("airline_companyId");
        #判断用户是否登录
        $is_login=boolval($companyId);
        if(!$is_login){
            $msg=[
                "statu"=>"error",
                "detailes"=>"请先登录"
            ];
            return json_encode($msg,JSON_UNESCAPED_UNICODE);  
        }

        #接收前端的ajax信息
        // $receiveData= $request->param("final_data");

        #模拟接收的数据
        $receiveData= '{"flight_match_code":"6fcede7bb95e3e2410cd5af224f091a0","leg_id":1,"remarks":"旷达科技贺卡和贷款户打卡机"}';

         #解析前端传送过来的数据
        $flightLegReamrks=json_decode($receiveData,true);

        #判断数据是否存在
        $where=[
            "flight_match_code"=>$flightLegReamrks["flight_match_code"],
            "leg_id"=>$flightLegReamrks["leg_id"]
        ];
        $isExist=!empty(Db::table("flight_leg_remarks")->where($where)->select());
        if($isExist){
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据已存在，请勿重复添加"
            ];
            return json_encode($msg,JSON_UNESCAPED_UNICODE);   
        }
        #提交数据到数据库
        $count=Db::table("flight_leg_remarks")->insert($flightLegReamrks);
        if($count>0){
            $msg=[
                "statu"=>"success",
                "detailes"=>"提交成功"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);      
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }
    }


    public function ajaxTest(Request $request){
        #接收前端的ajax信息，写入文件测试
        // $myfile = fopen("ajaxtest.txt", "w") or die("Unable to open file!");
        // $receiveData= $request->param("final_data");
        // fwrite($myfile, $receiveData);
        // fclose($myfile);

        $receiveData="{\"occupation\":\"F/O\",\"PPN\":\"432423\",\"DOE\":\"2019-04-10\",\"POB\":\"天津\",\"name\":\"罗佳\",\"gender\":\"MALE\",\"nationality\":\"中国\",\"DOB\":\"2019-04-10\"}";

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
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
             
        }

        #解析前端传送过来的数据
        $staff=json_decode($receiveData,true);

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
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
        }else{
            $msg=[
                "statu"=>"error",
                "detailes"=>"数据存入数据库异常"
            ];
             return json_encode($msg,JSON_UNESCAPED_UNICODE);
             
        }

        dump($staff);
        dump($msg);
    }
}
