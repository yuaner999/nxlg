package com.liuzg.jsweb.controllers;

import com.Services.interfaces.QuerymajorService;
import com.utils.ExcelUtil;
import com.utils.ExcelUtils;
import com.utils.ExcleArgmCour;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.persistence.metamodel.ListAttribute;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.*;

/**
 * 专业列表导出excel
 *
 * @author NEU
 *         Created by admin on 2017/4/19.
 */
@Controller
@RequestMapping("/export")
public class ExportToExcelController {
    @Autowired
    private QuerymajorService querymajorService;
    private Map argmCour;


    /**
     * 现有课程信息导出
     * zqy
     *
     * @param request
     * @param response
     */
    @RequestMapping("/teacherTerraceCourseList")
    public void teacherTerraceCourseList(HttpServletRequest request, HttpServletResponse response) {
        String fileName = "开课课程信息";
        ByteArrayOutputStream os = null;
        try {
            String type = (String) request.getSession().getAttribute("sessionUserType");
            if (type.equals("学生")) {
                throw new RuntimeException("该学生没有权限");
            }
            Map<String, String[]> parameterMap = request.getParameterMap();
            //为了能让map 修改  通过 request.getParameterMap(); 获得的map不可以修改
            Map<String, Object> newMap = new HashMap<>(36);
            Set<String> keys = parameterMap.keySet();
            for (String s : keys) {
                //取中map中每个元素（数组）的第一个，并放到新的map中  处理下才有值  负责全是地址
                // 用newmap处理  通过key获得value
                String[] value = parameterMap.get(s);
                if (value.length == 0) continue;
                value[0] = value[0].equals("undefined") ? "" : value[0];
                newMap.put(s, value[0]);
            }
            newMap.put("type", type);
            List<Map<String, Object>> list = querymajorService.teacherTerraceCourseList(newMap);

            String columnNames[] = {"年级", "学院", "专业", "培养层次", "平台", "课程", "课程类别三", "课程类别四", "课程类别五", "开课学期", "主修/辅修", "备注", "审核状态"};//列名
            String columnkeys[] = {"mtc_grade", "majorCollege", "majorName", "level", "terraceName", "chineseName", "courseCategory_3", "courseCategory_4", "courseCategory_5", "mtc_courseTerm", "mtc_majorWay", "mtc_note", "mtc_checkStatus"};//map中的key

            os = new ByteArrayOutputStream();

            ExcelUtil.createWorkBook(list, columnkeys, columnNames, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    /**
     * 导出excel报表
     *
     * @param request
     * @param response
     */
    //------------生成的表格只显示一行--------------------------------
    public void exportBuyOrderTest(HttpServletRequest request, HttpServletResponse response) {
        String searchStr = request.getParameter("searchStr");
        //String status=request.getParameter("status");
        String fileName = "专业列表";

        Map<String, Object> newMap = new HashMap<>(36);     //what?
        List<Map<String, Object>> result = null;
        result = querymajorService.getMajorlist(newMap, searchStr);

        String k = "majorId=专业ID, majorCollege=所属学院, internationalNum=国际专业个数, internationalCode=国际专业代码" +
                "majorCode=专业代码, majorName=专业名称, subject=所属学科, level=培养层次, length=学制" +
                "settingYear=设置年份, majorStatus=专业状态, checkStatus=审核状态,checkType=审核类别,checkMan=审核人,checkDate=审核时间";
        List<Map<String, Object>> list = gennerMajorInfo(result);
        ByteArrayOutputStream os = new ByteArrayOutputStream();

        try {
            com.utils.ExcelUtils.createWorkBook(list, k, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    /**
     * 导出excel报表
     * updateMan zqy
     *
     * @param request
     * @param response
     */
    //------------生成的表格没有合并的单元格，改为下面的方法--------------------------------
    @RequestMapping("/conditions")
    public void exportBuyOrder(HttpServletRequest request, HttpServletResponse response) {
        String fileName = "专业列表";

        Map<String, String[]> parameterMap = request.getParameterMap();
        //为了能让map 修改  通过 request.getParameterMap(); 获得的map不可以修改
        Map<String, Object> newMap = new HashMap<>(36);
        Set<String> keys = parameterMap.keySet();
        for (String s : keys) {
            //取中map中每个元素（数组）的第一个，并放到新的map中  处理下才有值  负责全是地址
            // 用newmap处理  通过key获得value
            String[] value = parameterMap.get(s);
            if (value.length == 0) continue;
            value[0] = value[0].equals("undefined") ? "" : value[0];
            newMap.put(s, value[0]);
        }
        List<Map<String, Object>> result = null;
        result = querymajorService.selectMajorlist(newMap);

        String columnNames[] = {"所属学院", "国际专业个数", "国际专业代码", "专业代码", "专业名称",
                "所属学科", "培养层次", "学制", "设置年份", "专业状态", "审核状态", "审核类别", "审核人", "审核时间"};//列名
        String columnkeys[] = {"majorCollege", "internationalNum", "internationalCode",
                "majorCode", "majorName", "subject", "level", "length", "settingYear", "majorStatus", "checkStatus", "checkType", "checkMan", "checkDate"};//map中的key

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            ExcelUtil.createWorkBook(result, columnkeys, columnNames, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    /**
     * 导出培养计划excel报表
     * updateMan zqy
     *
     * @param request
     * @param response
     */
    //------------生成的表格没有合并的单元格，改为下面的方法--------------------------------
    @RequestMapping("/exportEducatePlanMajor")
    public void exportEducatePlanMajor(HttpServletRequest request, HttpServletResponse response) {
        String fileName = "培养计划课程信息表";
        String searchStr = request.getParameter("searchStr");
        String college = request.getParameter("college");
        String major = request.getParameter("major");
        String grade = request.getParameter("grade");
        Map<String, String[]> parameterMap = request.getParameterMap();
        //为了能让map 修改  通过 request.getParameterMap(); 获得的map不可以修改
        Map<String, Object> newMap = new HashMap<>(36);
        Set<String> keys = parameterMap.keySet();
        for (String s : keys) {
            //取中map中每个元素（数组）的第一个，并放到新的map中  处理下才有值  负责全是地址
            // 用newmap处理  通过key获得value
            String[] value = parameterMap.get(s);
            if (value.length == 0) continue;
            value[0] = value[0].equals("undefined") ? "" : value[0];
            newMap.put(s, value[0]);
        }
        List<Map<String, Object>> result = null;
        result = querymajorService.selectEducatePlanMajorList(newMap,searchStr,college,major,grade);

        String columnNames[] = {"年级", "学院", "专业", "学期", "课程",
                "课程类别", "培养平台", "考核方式", "周时", "备注", "审核状态"};//列名
        String columnkeys[] = {"ep_grade", "ep_college", "ep_major",
                "ep_term", "ep_coursecode", "courseCategory_1", "ep_terrace", "ep_checkway", "ep_week", "ep_note", "ep_checkStatus"};//map中的key

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            ExcelUtil.createWorkBook(result, columnkeys, columnNames, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    private List<Map<String, Object>> gennerMajorInfo(List<Map<String, Object>> list) {
        List<Map<String, Object>> re = new ArrayList<>();
        Map<String, Object> temp = new HashMap<>();
        for (Map<String, Object> m : list) {
            String orderno = (String) m.get("ordernumber");
            Object o = temp.get(orderno);
            Map<String, Object> item = new HashMap<>();
            item.put("goodname", m.get("goodname"));
            item.put("spec", m.get("spec"));
            item.put("price", m.get("price"));
            item.put("count", m.get("count"));
            item.put("deliverscope", m.get("deliverscope"));
            if (o != null) {
                Map<String, Object> map = (Map) o;
                List items = (List) map.get("orderitems");
                if (items == null) items = new ArrayList<>();
                items.add(item);
                map.put("orderitems", items);
                temp.put(orderno, map);
            } else {
                List items = new ArrayList<>();
                items.add(item);
                m.put("orderitems", items);
                temp.put(orderno, m);
            }
        }
        Set<String> keys = temp.keySet();
        for (String s : keys) {
            re.add((Map<String, Object>) temp.get(s));
        }
        return re;
    }

    /*------------------------导出课程信息--------------------------------*/
    @RequestMapping("/conditions_1")
    public void exportCourse(HttpServletRequest request, HttpServletResponse response) {
        String searchStr = request.getParameter("searchStr");
        String teachCollege = request.getParameter("teachCollege");
        String fileName = "课程列表";

        Map<String, String[]> parameterMap = request.getParameterMap();
        //为了能让map 修改  通过 request.getParameterMap(); 获得的map不可以修改
        Map<String, Object> newMap = new HashMap<>(36);
        Set<String> keys = parameterMap.keySet();
        for (String s : keys) {
            //取中map中每个元素（数组）的第一个，并放到新的map中  处理下才有值  负责全是地址
            // 用newmap处理  通过key获得value
            String[] value = parameterMap.get(s);
            if (value.length == 0) continue;
            newMap.put(s, value[0]);
        }
        List<Map<String, Object>> result = null;
        result = querymajorService.getCourselist(newMap, searchStr, teachCollege);

        String columnNames[] = {"课程代码", "中文名称", "英文名称", "承担单位", "课程类别三",
                "课程类别四", "课程类别五", "总学分", "理论学分", "实践学分", "讲授学时", "实验学时", "上机学时", "其他学时", "总学时", "负责教师", "教材",
                "课程状态", "审核状态"};//列名
        String columnkeys[] = {"courseCode", "chineseName", "englishName",
                "assumeUnit", "courseCategory_3", "courseCategory_4", "courseCategory_5", "totalCredit", "theoreticalCredit", "practiceCredit",
                "teachingTime", "experimentalTime", "machineTime", "otherTime", "totalTime", "teacherName", "teachingmaterialname",
                "courseStatus", "checkStatus"};//map中的key

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            ExcelUtil.createWorkBook(result, columnkeys, columnNames, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    @RequestMapping("/exportNowCourse")
    public void exportNowCourse(HttpServletRequest request, HttpServletResponse response) {
        String searchStr = request.getParameter("searchStr");
        String _classCode = request.getParameter("_classCode");
        String _className = request.getParameter("_className");
        String fileName = "课程列表";
        System.out.print(_classCode);
        System.out.print(_className);
        Map<String, String[]> parameterMap = request.getParameterMap();
        Map<String, Object> newMap = new HashMap<>(36);
        Set<String> keys = parameterMap.keySet();
        for (String s : keys) {
            String[] value = parameterMap.get(s);
            if (value.length == 0) continue;
            newMap.put(s, value[0]);
        }
        List<Map<String, Object>> result = null;
        if((_classCode == null || _classCode == "" || _classCode == "undefined") && (_className != "" || _className != null || _className != "undefined")){
            _classCode = "一个不可能的值";
        }
        if((_className == null || _className == "" || _className == "undefined") && (_classCode != "" || _classCode != null || _classCode != "undefined")){
            _className = "一个不可能的值";
        }
        result = querymajorService.getNowCourselist(newMap, _classCode, _className);

        String columnNames[] = {"课程代码", "中文名称", "课程类别三",
                "课程类别四", "课程类别五", "学分", "学时", "负责教师", "教材", "课程状态", "审核类别", "审核状态"};//列名
        String columnkeys[] = {"courseCode", "chineseName",
                "courseCategory_3", "courseCategory_4", "courseCategory_5", "totalCredit", "totalTime", "teacherName",
                "name", "courseStatus", "checkType", "checkStatus"};//map中的key

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            ExcelUtil.createWorkBook(result, columnkeys, columnNames, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    @RequestMapping("/exportStuArgmCour")
    public void exportStuArgmCour(HttpServletRequest request, HttpServletResponse response) {
        String[] search = new String[4];
        search[0] = request.getParameter("userid");
        search[1] = request.getParameter("thweekday");
        search[2] = request.getParameter("teachodd");
        search[3] = request.getParameter("name");
        String fileName = (search[3] + "的课程表");

        List<Map<String, Object>> result = null;
        result = querymajorService.getArgmCourse(search[0], search[1], search[2]);

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            ExcleArgmCour.createWorkBook(result, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    @RequestMapping("/exportArgmCourseByTh")
    public void exportArgmCourseByTh(HttpServletRequest request, HttpServletResponse response) {
        String tcid = request.getParameter("tcid");
        String thweekday = request.getParameter("thweekday");
        String teachodd = request.getParameter("teachodd");
        String name = request.getParameter("name");
        String fileName = (name + "的课程表");
        List<Map<String, Object>> result = null;
        result = querymajorService.getArgmCourseByTh(tcid, thweekday, teachodd);

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            ExcleArgmCour.createWorkBook(result, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    @RequestMapping("/exportArgmCourseByCr")
    public void exportArgmCourseByCr(HttpServletRequest request, HttpServletResponse response) {
        String crid = request.getParameter("id");
        String thweekday = request.getParameter("thweekday");
        String teachodd = request.getParameter("teachodd");
        String name = request.getParameter("name");
        String fileName = (name + "的课程表");

        List<Map<String, Object>> result = null;
        result = querymajorService.getArgmCourseByCr(crid, thweekday, teachodd);

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            ExcleArgmCour.createWorkBook(result, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    @RequestMapping("/exportBeforeBuyingInfo")
    public void exportBeforeBuyingInfo(HttpServletRequest request, HttpServletResponse response, String collegeName, String majorName, String className) {
        String fileName = "教材预购信息表";
        collegeName = collegeName.equals("undefined") ? "" : collegeName;
        majorName = majorName.equals("undefined") ? "" : majorName;
        className = className.equals("undefined") ? "" : className;
        List<Map<String, Object>> result = querymajorService.getBeforeBuyingInfo(collegeName, majorName, className);
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        String k = "name=教材名称,booktotalnum=教材数量";
        try {
            ExcelUtils.createWorkBook(result, k, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    @RequestMapping("/exportWithdrawCourseInfo")
    public void exportWithdrawCourseInfo(HttpServletRequest request, HttpServletResponse response,
                                         String searchStr, String course, String semester, String major) {
        String fileName = "退课通过学生信息表";

        searchStr = (searchStr == null || searchStr.equals("undefined")) ? "" : searchStr;
        course = (course == null || course.equals("undefined")) ? "" : course;
        semester = (semester == null || semester.equals("undefined")) ? "" : semester;
        major = (major == null || major.equals("undefined")) ? "" : major;
        List<Map<String, Object>> result = querymajorService.exportWithdrawCourseInfo(searchStr, course, semester, major);
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        String k = "studentNum=学号,studentName=姓名,courseCode=课程代码,chineseName=课程名,terraceName=平台," +
                "class=所在班级,majorName=专业名称,teacherName=教师,term=学期,scc_status=状态,Areason=申请理由";
        try {
            ExcelUtils.createWorkBook(result, k, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    /**
     * 修改人：zqy
     * 修改时间：2017/9/21
     * */
    @RequestMapping("/exportqueryTerraceCourse")
    public void exportqueryTerraceCourse(HttpServletRequest request, HttpServletResponse response,
                                         String collegeName, String majorName, String terraceName, String termName, String teachCollege) {
        String fileName = "开课课程信息表";

        String type = (String) request.getSession().getAttribute("sessionUserType");
        collegeName = (collegeName == null || collegeName.equals("undefined")) ? "" : collegeName;
        majorName = (majorName == null || majorName.equals("undefined")) ? "" : majorName;
        terraceName = (terraceName == null || terraceName.equals("undefined")) ? "" : terraceName;
        termName = (termName == null || termName.equals("undefined")) ? "" : termName;
        teachCollege = (teachCollege == null || teachCollege.equals("undefined")) ? "" : teachCollege;
        List<Map<String, Object>> result = querymajorService.exportqueryTerraceCourse(type,teachCollege,collegeName, majorName, terraceName, termName);
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        String k = "majorCollege=学院,majorName=专业,level=培养层次,terraceName=平台,chineseName=课程," +
                "courseCategory_3=课程类别三,courseCategory_4=课程类别四,courseCategory_5=课程类别五,mtc_courseTerm=开课学期,mtc_majorWay=主修/辅修,mtc_note=备注,mtc_checkStatus=审核状态";
        try {
            ExcelUtils.createWorkBook(result, k, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    /**
     * 导出空闲教师信息
     *
     * @param teachweek
     * @param teachodd
     * @param timeweek
     * @param timepitch
     */
    @RequestMapping("/exportUnuseTeacherInfo")
    public void exportUnuseTeacherInfo(HttpServletRequest request, HttpServletResponse response,
                                       String teachweek, String teachodd, String timeweek, String timepitch) {
        String fileName = "空闲教师信息表";

        teachweek = (teachweek == null || teachweek.equals("undefined")) ? "" : teachweek;
        teachodd = (teachodd == null || teachodd.equals("undefined")) ? "" : teachodd;
        timeweek = (timeweek == null || timeweek.equals("undefined")) ? "" : timeweek;
        timepitch = (timepitch == null || timepitch.equals("undefined")) ? "" : timepitch;
        List<Map<String, Object>> result = querymajorService.exportUnuseTeacherInfo(teachweek, teachodd, timeweek, timepitch);
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        String k = "teacherNumber=教师工号,teacherName=教师姓名,department=所属部门,administrative=行政职务,teachUnit=任教单位,teachCollege=任教学院," +
                "teachMajor=任教专业,teachArea=从事领域,phone=联系电话,email=邮箱,spareTimes=每天空余时间," +
                "mostClassess=每天最多课程,teachStatus=任课状况,onGuard=是否在岗,status=状态";
        try {
            ExcelUtils.createWorkBook(result, k, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    /**
     * creater zqy
     * 导出空闲学生信息
     *
     * @param teachweek
     * @param teachodd
     * @param timeweek
     * @param timepitch
     * @param studentGrade
     * @param studentCollege
     * @param studentMajor
     */
    @RequestMapping("/exportUnuseStudentInfo")
    public void exportUnuseStudentInfo(HttpServletRequest request, HttpServletResponse response,
                                       String teachweek, String teachodd, String timeweek,
                                       String timepitch, String studentGrade, String studentCollege, String studentMajor) {
        String fileName = "空闲学生信息表";

        teachweek = (teachweek == null || teachweek.equals("undefined")) ? "" : teachweek;
        teachodd = (teachodd == null || teachodd.equals("undefined")) ? "" : teachodd;
        timeweek = (timeweek == null || timeweek.equals("undefined")) ? "" : timeweek;
        timepitch = (timepitch == null || timepitch.equals("undefined")) ? "" : timepitch;
        studentGrade = (studentGrade == null || studentGrade.equals("undefined")) ? "" : studentGrade;
        studentCollege = (studentCollege == null || studentCollege.equals("undefined")) ? "" : studentCollege;
        studentMajor = (studentMajor == null || studentMajor.equals("undefined")) ? "" : studentMajor;

        List<Map<String, Object>> result = querymajorService.exportUnuseStudentInfo(teachweek, teachodd, timeweek, timepitch, studentGrade, studentCollege, studentMajor);
//
//        String k = "studentNum=学生学号,studentName=学生姓名,studentPhone=手机号,studentEmail=邮箱号,entranceDate=入学日期,studentGrade=年级," +
//                "studentCollege=学院,studentMajor=专业,otherMajor=辅修,studentClass=班级,studentLevel=培养层次," +
//                "studentLength=学制,studentForm=学习形式,studentSchoolAddress=校区,isDelete=是否删除";

        String columnNames[] = {"学生学号", "学生姓名", "手机号",
                "邮箱号", "入学日期", "年级", "学院", "专业", "辅修", "班级", "培养层次", "学制", "学习形式", "校区", "是否删除"};//列名
        String columnkeys[] = {"studentNum", "studentName",
                "studentPhone", "studentEmail","entranceDate", "studentGrade", "studentCollege", "studentMajor", "otherMajor",
                "studentClass", "studentLevel", "studentLength", "studentForm", "studentSchoolAddress", "isDelete"};//map中的key

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        try {
            ExcelUtil.createWorkBook(result, columnkeys, columnNames, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    /**
     * 导出空闲教室信息
     *
     * @param teachweek
     * @param teachodd
     * @param timeweek
     * @param timepitch
     */
    @RequestMapping("/exportUnuseClassroomInfo")
    public void exportUnuseClassroomInfo(HttpServletRequest request, HttpServletResponse response,
                                         String teachweek, String teachodd, String timeweek, String timepitch) {
        String fileName = "空闲教室信息表";

        teachweek = (teachweek == null || teachweek.equals("undefined")) ? "" : teachweek;
        teachodd = (teachodd == null || teachodd.equals("undefined")) ? "" : teachodd;
        timeweek = (timeweek == null || timeweek.equals("undefined")) ? "" : timeweek;
        timepitch = (timepitch == null || timepitch.equals("undefined")) ? "" : timepitch;
        List<Map<String, Object>> result = querymajorService.exportUnuseClassroomInfo(teachweek, teachodd, timeweek, timepitch);
        ByteArrayOutputStream os = new ByteArrayOutputStream();

        String k = "campus=校区,building=教学楼,floor=楼层,classroomNum=教室号,classroomName=教室名称," +
                "classroomType=教室类型,classroomCapacity=教室容量,classroomArea=教室面积,classroomStatus=状态";
        try {
            ExcelUtils.createWorkBook(result, k, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    @RequestMapping("/exportClassStudentInfo")
    public void exportClassStudentInfo(HttpServletRequest request, HttpServletResponse response, String searchStr, String tc_id, String studentNum,
                                       String studentName, String studentGrade, String studentCollege, String studentMajor, String studentClass, String studentSchoolAddress) {
        String fileName = "班级学生信息表";

        searchStr = (searchStr == null || searchStr.equals("undefined")) ? "" : searchStr;
        tc_id = (tc_id == null || tc_id.equals("undefined")) ? "" : tc_id;
        studentNum = (studentNum == null || studentNum.equals("undefined")) ? "" : studentNum;
        studentName = (studentName == null || studentName.equals("undefined")) ? "" : studentName;
        studentGrade = (studentGrade == null || studentGrade.equals("undefined")) ? "" : studentGrade;
        studentCollege = (studentCollege == null || studentCollege.equals("undefined")) ? "" : studentCollege;
        studentMajor = (studentMajor == null || studentMajor.equals("undefined")) ? "" : studentMajor;
        studentClass = (studentClass == null || studentClass.equals("undefined")) ? "" : studentClass;
        studentSchoolAddress = (studentSchoolAddress == null || studentSchoolAddress.equals("undefined")) ? "" : studentSchoolAddress;
        Map<String, Object> map = new HashMap<>();
        map.put("searchStr", searchStr);
        map.put("tc_id", tc_id);
        map.put("studentNum", studentNum);
        map.put("studentName", studentName);
        map.put("studentGrade", studentGrade);
        map.put("studentCollege", studentCollege);
        map.put("studentMajor", studentMajor);
        map.put("studentClass", studentClass);
        map.put("studentSchoolAddress", studentSchoolAddress);
        List<Map<String, Object>> result = querymajorService.exportClassStudentInfo(map);
        ByteArrayOutputStream os = new ByteArrayOutputStream();

        String k = "studentNum=学号,studentName=姓名,studentGender=性别,studentPhone=手机,studentEmail=邮箱," +
                "studentGrade=年级,studentCollege=学院,studentMajor=专业,studentClass=班级" +
                ",studentLevel=培养层次,studentForm=学习形式,studentSchoolAddress=所在校区";
        try {
            ExcelUtils.createWorkBook(result, k, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }

    @RequestMapping("/exportCourseStudentInfo")
    public void exportCourseStudentInfo(HttpServletRequest request, HttpServletResponse response, String searchStr, String tc_id) {
        String fileName = "课程选修学生信息表";

        searchStr = (searchStr == null || "null".equals(searchStr) || searchStr.equals("undefined")) ? "" : searchStr;
        tc_id = (tc_id == null || tc_id.equals("undefined")) ? "" : tc_id;

        List<Map<String, Object>> result = querymajorService.exportCourseStudentInfo(searchStr, tc_id);
        ByteArrayOutputStream os = new ByteArrayOutputStream();

        String k = "studentNum=学号,studentName=姓名,studentGender=性别,studentNation=民族,studentGrade=年级," +
                "studentCollege=学院,studentMajor=专业,studentClass=班级,studentLevel=培养层次,studentForm=学习形式,studentSchoolAddress=校区";
        try {
            ExcelUtils.createWorkBook(result, k, fileName).write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }
        ExcelUtil.sendExcel(response, os, fileName);
    }
}
