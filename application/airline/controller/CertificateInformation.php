<?php
namespace app\airline\controller;
use think\Controller;
use think\Db;
use think\Session;
use think\Request;
/**
 * author 罗佳
 */
class CertificateInformation extends Controller
{
    #首页
    public function index(){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);

        if(!$is_login){
            $this->error("请先登录"); 
        }

        $where=[
            "company_id"=>$companyId
        ];
        $companyLicenses=Db::table("company_license")->where($where)->select();
        $this->assign("companyLicenses",$companyLicenses);

        return view();
    }

    #添加证件界面
    public function toAddCertificate(){
        return view();
    }

    #添加证件方法
    public function addCertificate(Request $request){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);

        if(!$is_login){
            $this->error("请先登录"); 
        }

        $file=$request->file("companyLicense");
        if(empty($file)) {  
            $this->error("选择的图片异常，修改失败");  
        }  
        
        $dir="static/airline/images/companyLicenses";
        $info = $file->move($dir); 
        if ($info) { 
            $imageUrl=(date("Ymd",time()))."/".($info->getFilename()); 
        } else { 
            $this->error($file->getError()); 
        } 

        $where=[
            "company_id"=>$companyId,
        ];
        $newLicenseId=Db::table("company_license")->where($where)->max("license_id")+1;
        $data=[
            "company_id"=>$companyId,
            "license_id"=>$newLicenseId,
            "license_name"=>$_POST["证件名称"],
            "license_img"=>$imageUrl
        ];

        $count=Db::table("company_license")->insert($data);

        if($count>0){
            $this->success("添加成功","index");
        }
        else{
            $this->error("添加失败");
        }

    }

    #删除证件
    public function deleteLicense($id){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);

        if(!$is_login){
            $this->error("请先登录"); 
        }

        $where=[
            "company_id"=>$companyId,
            "license_id"=>$id
        ];

        $count=Db::table("company_license")->where($where)->delete();

        if($count>0){
            $this->success("删除成功","index");
        }
        else{
            $this->error("删除失败");
        }
    }

    #修改证件界面
    public function toUpdateLicense($id){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);

        if(!$is_login){
            $this->error("请先登录"); 
        }
        $where=[
            "company_id"=>$companyId,
            "license_id"=>$id
        ];
        $license=Db::table("company_license")->where($where)->select();
        $this->assign("license",$license[0]);
        return view();
    }

    #修改证件方法
    public function updateLicense(Request $request){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);

        if(!$is_login){
            $this->error("请先登录"); 
        }

        $file=$request->file("companyLicense");
        if(empty($file)) {  
            $data=[
                "license_name"=>$_POST["证件名称"],
            ];
        }else{
            $dir="static/airline/images/companyLicenses";
            $info = $file->move($dir); 
            if ($info) { 
                $imageUrl=(date("Ymd",time()))."/".($info->getFilename()); 
            } else { 
                $this->error($file->getError()); 
            } 
            $data=[
                "license_name"=>$_POST["证件名称"],
                "license_img"=>$imageUrl
            ];
        }

        $where=[
            "company_id"=>$companyId,
            "license_id"=>$_POST["license_id"]
        ];


        $count=Db::table("company_license")->where($where)->update($data);
        if($count>0){
            $this->success("修改成功","index");
        }
        else{
            $this->error("修改失败或没有任何数据发生变化");
        }
    }   
}
