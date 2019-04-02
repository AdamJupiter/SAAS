<?php
namespace app\airline\controller;
use think\Controller;
use think\Db;
use think\Session;
use think\Request;
/**
 * author 罗佳
 */
class Company extends Controller
{
    public function Index()
    {
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);

        if(!$is_login){
            $this->error("请先登录"); 
        }

        $companyInfo=Db::table("company")->find($companyId);//查询对应ID的公司信息
        $this->assign('companyInfo',$companyInfo);
        return view();
    }

    public function updateCompanyInfo()
    {
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);

        if(!$is_login){
            $this->error("请先登录"); 
        }

        $where=[
            "company_id"=>$companyId
        ];
        $data=[
            "company_name"=>$_POST["公司名称"],
            "company_address"=>$_POST["公司地址"],
            "company_email"=>$_POST["运行邮箱"],
            "company_tel"=>$_POST["联系方式"],
            "company_fax"=>$_POST["传真"],
            "company_sita"=>$_POST["SITA"],
            "company_aifn"=>$_POST["AIFN"]
        ];
        $count=Db::table("company")->where($where)->update($data);

        if($count>0){
            $this->success("修改成功","Company/index");
        }else{
            $this->error("修改失败或没有任何数据发生修改");
        }
    }

    public function updateCompanyLogo(Request $request){
        $companyId=Session::get("airline_companyId");
        //判断用户是否登录
        $is_login=boolval($companyId);

        if(!$is_login){
            $this->error("请先登录"); 
        }

        $where=[
            "company_id"=>$companyId
        ];

        $file=$request->file("logo");
        if(empty($file)) {  
            $this->error("选择的图片异常，修改失败");  
        }  
        
        $dir="static/airline/images/companyLogo";
        $info = $file->move($dir); 
        if ($info) { 
            $imageUrl=(date("Ymd",time()))."/".($info->getFilename()); 
        } else { 
        $this->error($file->getError()); 
        } 

        $where=[
            "company_id"=>$companyId
        ];
        $data=[
            "company_logo"=> $imageUrl
        ];
        $count=Db::table("company")->where($where)->update($data);

        if($count>0){
            $this->success("修改成功","Company/index");
        }else{
            $this->error("修改失败");
        }
    }
}
