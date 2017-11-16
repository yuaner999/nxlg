package com.controllers;

import com.Services.interfaces.DispensingService;
import com.common.DLog;
import com.common.DTable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/5/23.
 */
@Controller
@RequestMapping("/nxlg")
public class AutoDispensingController {
    @Autowired
    private DispensingService DispensingService;
    @RequestMapping("/Dispensing")
    @ResponseBody
    public Object Dispensing() {
        String result = "{}";
        try {
            DTable bllSemester=new DTable("arrangecourse");
            String a="1";
            Map<String,String> tblSemester =bllSemester.where("1=1 and is_now=?",new ArrayList<String>(){{add(a);}}).find();
            String semester=tblSemester.get("semester");
            //以课程为单位 找到需要排的课程
            boolean flag3=true;
            List<Map<String, Object>> totaltiaojilist = DispensingService.gettotaltiaojipeople(semester);//1
            for(int i=0;i<totaltiaojilist.size();i++) {
                String courseId = (String) totaltiaojilist.get(i).get("courseId");
                //找開課列表中的這門課剩餘人數 剩餘班級
                List<Map<String, Object>> kaikecourseleft = DispensingService.getkaikeleft(courseId, semester);//2
                int kaikecourseleftlength = kaikecourseleft.size();
                for (int j = 0; j < kaikecourseleft.size(); j++) {
                    boolean flag2 = true;
                    double leftpeople = (double) kaikecourseleft.get(j).get("leftpeople");
                    //剩餘人數為0
                    if(leftpeople==0 ){continue;}
                    String tc_class = (String) kaikecourseleft.get(j).get("tc_class");
                    String tc_id = (String) kaikecourseleft.get(j).get("tc_id");
                    String teacherName = (String) kaikecourseleft.get(j).get("teacherName");
                    List<Map<String, Object>> getDispensingpeople = null;
                    //3.第i个班的符合年级要求的人时间要求的人调到2.内的班级
                    // 找到这个班级对应的专业可选
                    // 找到对应可以调剂的人  就是也选了这个专业的英语的人
                    // 和选了别的班级英语 但是他的专业这个英语班级对应的专业不一样（说明他们专业没有开这个课）
                    getDispensingpeople = DispensingService.getDispensingpeople1(courseId, semester,tc_id);//3
                    //上述人去掉时间冲突的
                    //9.查找这个课这个班的开课时间
                    List<Map<String, Object>> classgettime = DispensingService.gettime(courseId, tc_class,semester,tc_id);//9
                    int tc_thweek_startthis = Integer.parseInt(kaikecourseleft.get(j).get("tc_thweek_start").toString());
                    int tc_thweek_endthis = Integer.parseInt(kaikecourseleft.get(j).get("tc_thweek_end").toString());
                    //学生中这些时间(确认上课的)有课的移除
                    boolean flag = true;
                    for (int z = 0; z < getDispensingpeople.size(); z++) {
                        String studentId = (String) getDispensingpeople.get(z).get("studentId");
                        List<Map<String, Object>> stutime = DispensingService.stutime(studentId, semester);//10
                        for (int x = 0; x < stutime.size(); x++) {
                            int tc_thweek_start = Integer.parseInt(stutime.get(x).get("tc_thweek_start").toString());
                            int tc_thweek_end = Integer.parseInt(stutime.get(x).get("tc_thweek_end").toString());
                            if ( tc_thweek_startthis<= tc_thweek_end && tc_thweek_endthis>=tc_thweek_start) {
                                if (kaikecourseleft.get(j).get("tc_teachodd").equals("无")
                                        || stutime.get(x).get("tc_teachodd").equals("无")
                                        || (kaikecourseleft.get(j).get("tc_teachodd").equals(stutime.get(x).get("tc_teachodd")))) {
                                    for (int e = 0; e < classgettime.size(); e++) {
                                        if (classgettime.get(e).get("al_timeweek").equals(stutime.get(x).get("al_timeweek"))
                                                && classgettime.get(e).get("al_timepitch").equals(stutime.get(x).get("al_timepitch"))) {
                                            {   //删除这个学生，测试下一个学生
                                                getDispensingpeople.remove(z);
                                                flag = false;
                                                break;
                                            }
                                        }
                                    }
                                    if (flag == false) {
                                        break;
                                    }
                                }
                            }
                        }
                        if (flag == false) {
                            continue;
                        }
                    }//人 构建完成
                    // 当人数不够leftpeople 时，更新人数为getDispensingpeople.size() 否则则为剩余人数，人数超出，进入下一门班级
                    //当人数为0时，进入下一个课
                    int getDispensingsize = getDispensingpeople.size();
                    if (leftpeople >= getDispensingpeople.size()) {
                        leftpeople = getDispensingsize;
                    }
                    for (int r = 0; r < leftpeople; r++) {
                        // if(r>getDispensingpeople.size()){continue;}
                        String nowstudentId = getDispensingpeople.get(r).get("studentId").toString();
                        int res = DispensingService.DispensingCourse(tc_class, nowstudentId, courseId, semester,tc_id,teacherName);
                        if (res == 1) {
                            getDispensingsize--;
                            String context="成功调剂到"+tc_class;
                            int res2 = DispensingService.insertmessage(nowstudentId,context);
                            if (res == 1 && res2 == 1) {
                              /* result = "{'result':1,'msg':'执行成功'}";*/

                            } else {
                                result = "{'result':0,'msg':'执行失败'}";
                            }
                        } else {
                            String context="部分课程调剂失败error";
                            int res2 = DispensingService.insertmessage2(nowstudentId,context);
                            result = "{'result':0,'msg':'执行失败'}";
                        }
                        if (r == leftpeople - 1 && getDispensingsize != 0) {
                            //下一个班级
                            flag2 = false;
                            break;
                        }
                        if (getDispensingsize == 0) {
                            //下一门课
                            flag3 = false;
                            break;
                        }
                    }
                    if (flag2 == false) {
                        continue;
                    }
                    if (flag3 == false) {
                        break;
                    }
                }
                if (flag3 == false) {
                    continue;
                }
                //开课课程选完了
                //6.继续填未达到开课人数的这门课班级
                List<Map<String, Object>> getunkaikecha = DispensingService.getunkaikecha(courseId, semester);//6
                boolean flag5=true;
                for (int t = getunkaikecha.size() - 1; t >= 0; t--) {
                    String class2 = (String) getunkaikecha.get(t).get("tc_class");
                    String tc_id2 = (String) getunkaikecha.get(t).get("tc_id");
                    String teacherName2 = (String) getunkaikecha.get(t).get("teacherName");
                    List<Map<String, Object>> getDispensingpeople2 = null;
                    //5.判断这门课这个班还剩多少时间不冲突合适的人 没调剂 人數為0 调剂下一门课
                    getDispensingpeople2 = DispensingService.getDispensingpeople1(courseId, semester, tc_id2);//3
                    //上述人去掉时间冲突的
                    //9.查找这个课这个班的开课时间
                    List<Map<String, Object>> classgettime2 = DispensingService.gettime(courseId, class2,semester,tc_id2);//9
                    int tc_thweek_startthis = Integer.parseInt(getunkaikecha.get(t).get("tc_thweek_start").toString());
                    int tc_thweek_endthis = Integer.parseInt(getunkaikecha.get(t).get("tc_thweek_end").toString());
                    //学生中这些时间有课的移除
                    boolean flag4 = true;
                    for (int z = 0; z < getDispensingpeople2.size(); z++) {
                        String studentId1 = (String) getDispensingpeople2.get(z).get("studentId");
                        List<Map<String, Object>> stutime2 = DispensingService.stutime(studentId1, semester);//10
                        for (int x = 0; x < stutime2.size(); x++) {
                            int tc_thweek_start = Integer.parseInt(stutime2.get(x).get("tc_thweek_start").toString());
                            int tc_thweek_end = Integer.parseInt(stutime2.get(x).get("tc_thweek_end").toString());
                            if (tc_thweek_startthis<= tc_thweek_end && tc_thweek_endthis>=tc_thweek_start) {
                                if (getunkaikecha.get(t).get("tc_teachodd").equals("无")
                                        || stutime2.get(x).get("tc_teachodd").equals("无")
                                        || (getunkaikecha.get(t).get("tc_teachodd").equals(stutime2.get(x).get("tc_teachodd")))) {
                                    for (int e = 0; e < classgettime2.size(); e++) {
                                        if (classgettime2.get(e).get("al_timeweek").equals(stutime2.get(x).get("al_timeweek"))
                                                && classgettime2.get(e).get("al_timepitch").equals(stutime2.get(x).get("al_timepitch"))) {
                                            {   //删除这个学生，测试下一个学生
                                                getDispensingpeople2.remove(z);
                                                flag4 = false;
                                                break;
                                            }
                                        }
                                    }
                                    if (flag4 == false) {
                                        break;
                                    }
                                }
                            }
                        }
                        if (flag4 == false) {
                            continue;
                        }
                    }
                    //人 构建完成
                    int total = getDispensingpeople2.size();
                    //如果合格人数<最小人数 不是最后一个班级时  那么就下一个班级
                    //如果合格人数<最小人数  最后一个班级   那么就发送通知失败 然后下一门课
                    if (getDispensingpeople2.size() <
                            Integer.parseInt( getunkaikecha.get(t).get("tc_studentnum").toString()) &&t > 0){
                        continue;
                    }else if (t == 0 && getDispensingpeople2.size() <
                            Integer.parseInt( getunkaikecha.get(t).get("tc_studentnum").toString()) ) {
                        break;
                    }
                    int size=total;
                    //如果人数大于等于最小人数 把小于等于最大人数的人 插入这个班 那么更新选课表 发送信息 total人数--  如果人数不等于0 进入下一个班级
                    //人数不等于0 班级等于0 发送失败 进入下一门课
                    //如果人数等于0 进入下一门课
                    int tc_numrange=Integer.parseInt( getunkaikecha.get(t).get("tc_numrange").toString());
                    if(total>=tc_numrange){
                        size=tc_numrange;
                    }
                    for (int m = 0; m < size; m++) {
                        String studentId1 = (String) getDispensingpeople2.get(m).get("studentId");
                       int res = DispensingService.DispensingCourse(class2, studentId1, courseId, semester,tc_id2,teacherName2);
                        if(res==1){
                            total--;
                            String context="成功调剂到"+class2;
                            int res2 = DispensingService.insertmessage(studentId1,context);
                            if (res == 1 && res2 == 1) {
                                //result = "{'result':1,'msg':'执行成功'}";

                            } else {
                                result = "{'result':0,'msg':'执行失败'}";
                            }
                        } else {
                            String context="部分课程调剂失败error";
                            int res2 = DispensingService.insertmessage2(studentId1,context);
                            result = "{'result':0,'msg':'执行失败'}";
                        }
                        if (total == 0) {
                            //下一个课
                            flag3=false;
                            break;
                        }
                        if (m == size - 1 && total != 0 && t > 0) {
                            //下一个班级
                            flag5 = false;
                            break;
                        }
                        if(t==0 && total != 0 && m == size - 1 ){
                            flag3=false;
                            break;
                        }
                    }
                    if (flag5 == false) {
                        continue;
                    }
                    if (flag3 == false) {
                        break;
                    }

                }
            }
            //同意發送消息失敗
            List<Map<String, Object>> Dispensingtotalpeople5 = DispensingService.Dispensingtotalpeople5(semester);//5
            if (Dispensingtotalpeople5.size() != 0) {
                //发送调剂失败
                for (int n = 0; n < Dispensingtotalpeople5.size(); n++) {
                    String studentId2 = (String) Dispensingtotalpeople5.get(n).get("studentId");
                    String context="部分课程调剂失败";
                    int res2 = DispensingService.insertmessage2(studentId2,context);

                }
            }
        }catch (Exception ex){
            ex.printStackTrace();
            DLog.w(ex.getMessage());
            result= "{'result':0,'msg':'执行错误:"+ex.getMessage()+"'}";
        }
        if(!result.equals("'result':0,'msg':'执行失败'")){
            result = "{'result':1,'msg':'执行成功'}";
        }
        return result;
    }
}

