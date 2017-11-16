package com.controllers;

import com.common.DLog;
import com.common.DTable;
import org.apache.commons.collections.map.HashedMap;
import org.apache.http.ssl.PrivateKeyDetails;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;


/**
 *自动生成缴费表
 * @author zcy
 * Created by zcy on 2017/5/23.
 */

@Controller
@RequestMapping("/nxlg")
public class PaymentInfoController {
    private static  String coursebookid="";
    @RequestMapping("/getInfo")
//    @RequestMapping(value = "/getInfo",method= RequestMethod.POST)
    @ResponseBody
    public static Object getInfo(){
        String result = "{}";
//        int payment_count = 0;
        try{
            DTable bllSemester=new DTable("arrangecourse");
            String a="1";
            Map<String,String> tblSemester =bllSemester.where("1=1 and is_now=?",new ArrayList<String>(){{add(a);}}).find();
            //获取当前学期
            String semester=tblSemester.get("semester");
            //初始化,参数为数据库表名
            DTable bllMenu=new DTable("stuchoosecourse");
            // .where()是设置where条件,第一个参数是sql,需要替换的参数用?代替,第二个是ArrayList<String>使用sql参数的方式
            // .count()是查询出的条数
            int menu_count=bllMenu.where("iscomfirm='1' and term=? ", new ArrayList<String>(){{add(semester);}}).count();
//            count=Integer.toString(menu_count);
            if(menu_count>0) {
                // .where()是设置where条件,第一个参数是sql,需要替换的参数用?代替,第二个是ArrayList<String>使用sql参数的方式
                // .setOrder()是设置排序方式,可不设置
                // .setField()是设置查询的字段,可不设置,默认查询*所有
                // .findAll()是查询数据列表
                List<Hashtable<String, String>> lstMenu = bllMenu.reset().where("iscomfirm='1' and term like ?", new ArrayList<String>() {{
                    add(semester);
                }}).findAll();//获取当前学期的所有选课信息
                //教材发放表
                List<Map<String,String>> bookdistribution=new ArrayList<>();

                for (Hashtable<String, String> tblMenu : lstMenu) { //第n条选课记录
                    String studentId = tblMenu.get("studentId"); //第n条选课记录studentId
                    String courseId = tblMenu.get("courseId"); //第n条选课记录courseCode
                    DTable bllPaymentinfo = new DTable("paymentstatus");
                    Map<String, String> bllPaymentinf = bllPaymentinfo.where("1=1 and semester=? and studentId=?", new ArrayList<String>() {{
                        add(semester);
                        add(studentId);
                    }}).find();
                    //是否有该studentId的缴费表
                    int paymentinfo_count = bllPaymentinfo.where("1=1 and semester like ? and studentId like ?", new ArrayList<String>() {{
                        add(semester);
                        add(studentId);
                    }}).count();
                    DTable bllCourse=new DTable("course");
                    Map<String,String> tblCourse =bllCourse.where("1=1 and courseId=?",new ArrayList<String>(){{add(courseId);}}).find();
                    String issparecourse=tblCourse.get("issparecourse");
                    coursebookid="";
                    if(issparecourse.equals("1")){
                        coursebookid=tblCourse.get("sparecoursebookid");
                    } else{
                        coursebookid=tblCourse.get("coursebookid");
                    }
                    tblMenu.put("coursebookid",coursebookid);
                    tblMenu.put("booktotalnum","1");
                    tblMenu.put("repeatstatus","true");
//                    String chineseName=tblCourse.get("chineseName");
                    DTable bllCourseinfo = new DTable("teachingmaterials");
                    Map<String, String> tblCourseinfo = bllCourseinfo.where("1=1 and tmId like ?", new ArrayList<String>() {{
                        add(coursebookid);
                    }}).find();
                    float price = Float.parseFloat(tblCourseinfo.get("price"));
                    String books =tblCourseinfo.get("name");
                    //有该studentId的缴费表:把该条选课记录的书费加入缴费金额中
                    if (paymentinfo_count > 0) {
                        float shouldPay = Float.parseFloat(bllPaymentinf.get("shouldPay"));
                        String status=bllPaymentinf.get("status");
                        if(status.equals("已缴费")){
                            bookdistribution.add(tblMenu);
                        }
                        String bookname= bllPaymentinf.get("books")+"|"+books;
                        shouldPay += price;
                        Map<String, String> updateData =new HashMap<String, String>();
                        updateData.put("shouldPay", Float.toString(shouldPay));
                        updateData.put("books", bookname);
                        int res = bllPaymentinfo.update(updateData, "semester=? and studentId=?", new ArrayList<String>() {{
                            add(semester);
                            add(studentId);
                        }});
                    } else {
                        String paymentstatusId = UUID.randomUUID().toString();
                        String realPay = "0";
                        String status = "未缴费";
                        String is_auto = "";
                        try {
                            Map<String, String> insertData = new HashMap<String, String>();
                            insertData.put("paymentstatusId", paymentstatusId);
                            insertData.put("studentId", studentId);
                            insertData.put("semester", semester);
                            insertData.put("shouldPay", Float.toString(price));
                            insertData.put("realPay", realPay);
                            insertData.put("status", status);
                            insertData.put("is_auto", is_auto);
                            insertData.put("books", books);
                            //调用insert方法往数据库增加数据
                            int res = bllPaymentinfo.insert(insertData);
                            result = "{'result':" + res + ",'msg':'执行成功'}";
                        } catch (Exception ex) {
                            DLog.w(ex.getMessage());
                            result = "{'result':0,'msg':'执行错误:" + ex.getMessage() + "'}";
                        }
                    }
                }
//                List<Map<String,String>> newbookdistribution=ifRepeat(bookdistribution);
//                for (Map<String, String> aNewbookdistribution : newbookdistribution) {
//                    Map<String, String> distributioninsertData = new HashMap<String, String>();
//                    distributioninsertData.put("distributionId", UUID.randomUUID().toString());
//                    distributioninsertData.put("className", aNewbookdistribution.get("class"));
//                    distributioninsertData.put("booktotalnum", aNewbookdistribution.get("booktotalnum"));
//                    distributioninsertData.put("is_giveout", "否");
//                    distributioninsertData.put("bookid", aNewbookdistribution.get("coursebookid"));
//
//                    DTable bookdistributioninfo = new DTable("bookdistribution");
//                    int rest = bookdistributioninfo.insert(distributioninsertData);
//                    result = "{'result':" + rest + ",'msg':'执行成功'}";
//                }
            }
            result =  "{'msg':'执行成功'}";
        }catch (Exception ex){
            ex.printStackTrace();
            DLog.w(ex.getMessage());
            result= "{'result':0,'msg':'执行错误:"+ex.getMessage()+"'}";
        }
        return result;
    }
    @RequestMapping("/getbuyingbeforeinfo")
    public static Object getbuyingbeforeinfo(){
        String result = "{}";
//        int payment_count = 0;
        try{
            DTable bllSemester=new DTable("arrangecourse");
            String a="1";
            Map<String,String> tblSemester =bllSemester.where("1=1 and is_now=?",new ArrayList<String>(){{add(a);}}).find();
            //获取当前学期
            String semester=tblSemester.get("semester");
            //初始化,参数为数据库表名
            DTable bllMenu=new DTable("stuchoosecourse");
            // .where()是设置where条件,第一个参数是sql,需要替换的参数用?代替,第二个是ArrayList<String>使用sql参数的方式
            // .count()是查询出的条数
            int menu_count=bllMenu.where("iscomfirm='1' and term=? ", new ArrayList<String>(){{add(semester);}}).count();
//            count=Integer.toString(menu_count);
            if(menu_count>0) {
                // .where()是设置where条件,第一个参数是sql,需要替换的参数用?代替,第二个是ArrayList<String>使用sql参数的方式
                // .setOrder()是设置排序方式,可不设置
                // .setField()是设置查询的字段,可不设置,默认查询*所有
                // .findAll()是查询数据列表
                List<Hashtable<String, String>> lstMenu = bllMenu.reset().where("iscomfirm='1' and term like ?", new ArrayList<String>() {{
                    add(semester);
                }}).findAll();//获取当前学期的所有选课信息
                //教材发放表
                List<Map<String,String>> bookdistribution=new ArrayList<>();

                for (Hashtable<String, String> tblMenu : lstMenu) { //第n条选课记录
                    String studentId = tblMenu.get("studentId"); //第n条选课记录studentId
                    String courseId = tblMenu.get("courseId"); //第n条选课记录courseCode
                    DTable bllPaymentinfo = new DTable("paymentstatus");
                    Map<String, String> bllPaymentinf = bllPaymentinfo.where("1=1 and semester=? and studentId=?", new ArrayList<String>() {{
                        add(semester);
                        add(studentId);
                    }}).find();
                    //是否有该studentId的缴费表
                    int paymentinfo_count = bllPaymentinfo.where("1=1 and semester like ? and studentId like ?", new ArrayList<String>() {{
                        add(semester);
                        add(studentId);
                    }}).count();
                    DTable bllCourse=new DTable("course");
                    Map<String,String> tblCourse =bllCourse.where("1=1 and courseId=?",new ArrayList<String>(){{add(courseId);}}).find();
                    String issparecourse=tblCourse.get("issparecourse");
                    coursebookid="";
                    if(issparecourse.equals("1")){
                        coursebookid=tblCourse.get("sparecoursebookid");
                    } else{
                        coursebookid=tblCourse.get("coursebookid");
                    }
                    tblMenu.put("coursebookid",coursebookid);
                    tblMenu.put("booktotalnum","1");
                    tblMenu.put("repeatstatus","true");
                    tblMenu.put("semester",semester);
                    tblMenu.put("is_now","是");
//                    String chineseName=tblCourse.get("chineseName");
                    DTable bllCourseinfo = new DTable("teachingmaterials");
                    Map<String, String> tblCourseinfo = bllCourseinfo.where("1=1 and tmId like ?", new ArrayList<String>() {{
                        add(coursebookid);
                    }}).find();
                    float price = Float.parseFloat(tblCourseinfo.get("price"));
                    String books =tblCourseinfo.get("name");
                    //有该studentId的缴费表:把该条选课记录的书费加入缴费金额中
                    if (paymentinfo_count > 0) {
                        float shouldPay = Float.parseFloat(bllPaymentinf.get("shouldPay"));
                        String status=bllPaymentinf.get("status");
                        //注释了不管是否已缴费，都统计教材购买数量
//                        if(status.equals("已缴费")){
                            bookdistribution.add(tblMenu);
//                        }
                    }
                }
                List<Map<String,String>> newbookdistribution=ifRepeat(bookdistribution);
                Map<String, String> distributionUpdateData=new HashMap<>();
                distributionUpdateData.put("is_now","否");
                DTable updatedistribution = new DTable("bookdistribution");
                int resul = updatedistribution.update(distributionUpdateData, "is_now=?", new ArrayList<String>() {{
                    add("是");
                }});
                for (Map<String, String> aNewbookdistribution : newbookdistribution) {
                    Map<String, String> distributioninsertData = new HashMap<String, String>();
                    distributioninsertData.put("distributionId", UUID.randomUUID().toString());
                    distributioninsertData.put("className", aNewbookdistribution.get("class"));
                    distributioninsertData.put("booktotalnum", aNewbookdistribution.get("booktotalnum"));
                    distributioninsertData.put("semester", aNewbookdistribution.get("semester"));
                    distributioninsertData.put("is_now", aNewbookdistribution.get("is_now"));
                    distributioninsertData.put("is_giveout", "否");
                    distributioninsertData.put("bookid", aNewbookdistribution.get("coursebookid"));

                    DTable bookdistributioninfo = new DTable("bookdistribution");
                    int rest = bookdistributioninfo.insert(distributioninsertData);
                    result = "{'result':" + rest + ",'msg':'执行成功'}";
                }
            }
            result =  "{'msg':'执行成功'}";
        }catch (Exception ex){
            ex.printStackTrace();
            DLog.w(ex.getMessage());
            result= "{'result':0,'msg':'执行错误:"+ex.getMessage()+"'}";
        }
        return result;
    }
    //    去重 并增加 书本数量
    public static List<Map<String,String>> ifRepeat(List<Map<String,String>> arr){
        //遍历原数组
        for(int i = 0; i < arr.size(); i++){
            //声明一个标记，并每次重置
            boolean isTrue = true;
            //内层循环将原数组的元素逐个对比
            for(int j=i+1;j<arr.size();j++){
                if(arr.get(i).get("class").equals(arr.get(j).get("class")) && arr.get(i).get("repeatstatus").equals("true")){
                    int newNum=Integer.parseInt(arr.get(i).get("booktotalnum"))+1;
                    arr.get(i).put("booktotalnum",newNum+"");
                    arr.get(j).put("repeatstatus","false");
                }
            }
        }
        for (int k = 0; k <arr.size() ; k++) {
            if(arr.get(k).get("repeatstatus").equals("false")){
                arr.remove(k);
            }
        }
        return arr;
    }

}