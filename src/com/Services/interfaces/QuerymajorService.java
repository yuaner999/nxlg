package com.Services.interfaces;

import java.util.List;
import java.util.Map;

/**
 * 专业列表
 * @author NEU
 * Created by admin on 2017/4/19.
 */
public interface QuerymajorService {
    /**
     * 专业
     * @param map
     * @return
     */
    List<Map<String , Object>>  getMajorlist(Map<String, Object> map, String searchStr);

    /**
     * 导出某个培养计划中的课程信息
     * @param map
     * @param searchStr
     * @return
     */
    List<Map<String , Object>>  selectEducatePlanMajorList(Map<String, Object> map, String searchStr,String college,String major,String grade);

    /**
     * 专业列表信息 zqy
     * @param map
     * @return
     */
    List<Map<String , Object>> selectMajorlist(Map<String, Object> map);

    /**
     * 课程
     * @param map
     * @return
     */
    List<Map<String , Object>>  getCourselist(Map<String, Object> map, String searchStr,String teachCollege);

    /**
     * zqy
     * 课程审核现有课程
     * */
    List<Map<String , Object>> getNowCourselist(Map<String, Object> map, String _classCode,String _className);

    /**
     *zqy
     *现有课程信息
     * */
    List<Map<String , Object>> teacherTerraceCourseList(Map<String, Object> map);

    /**
     * 课程
     * @return
     */
    List<Map<String , Object>>  getArgmCourse(String userId,String thweekday,String teachodd);

    /**
     * 课程
     * @return
     */
    List<Map<String , Object>>  getArgmCourseByTh(String tcid,String thweekday,String teachodd);

    /**
     * 课程
     * @return
     */
    List<Map<String , Object>>  getArgmCourseByCr(String crid,String thweekday,String teachodd);

    /**
     * 教材预购信息
     * @param collegeName
     * @param majorName
     * @param className
     * @return
     */
    List<Map<String , Object>>  getBeforeBuyingInfo(String collegeName,String majorName,String className);

    /**
     * 退课通过学生信息
     * @param searchStr
     * @param course
     * @param semester
     * @param major
     * @return
     */
    List<Map<String , Object>>  exportWithdrawCourseInfo(String searchStr,String course,String semester,String major);

    /**
     * 开课课程信息表
     * @param collegeName
     * @param majorName
     * @param terraceName
     * @param termName
     * @return
     */
    List<Map<String , Object>>  exportqueryTerraceCourse(String type,String teachCollege,String collegeName,String majorName,String terraceName,String termName);

    /**
     *导出空闲教师信息
     * @param teachweek
     * @param teachodd
     * @param timeweek
     * @param timepitch
     * @return
     */
    List<Map<String , Object>>  exportUnuseTeacherInfo( String teachweek, String teachodd,String timeweek,String timepitch);

    /**
     *导出空闲学生信息
     * @param teachweek
     * @param teachodd
     * @param timeweek
     * @param timepitch
     * @param studentGrade
     * @param studentCollege
     * @param studentMajor
     * @return
     */
    List<Map<String , Object>>  exportUnuseStudentInfo( String teachweek, String teachodd,String timeweek,String timepitch, String studentGrade, String studentCollege, String studentMajor);
    /**
     *导出空闲教室信息
     * @param teachweek
     * @param teachodd
     * @param timeweek
     * @param timepitch
     * @return
     */
    List<Map<String , Object>>  exportUnuseClassroomInfo( String teachweek, String teachodd,String timeweek,String timepitch);

    /**
     * 导出班级学生
     * @param map
     * @return
     */
    List<Map<String , Object>>  exportClassStudentInfo( Map<String, Object> map);

    /**
     * 导出课程选修学生信息
     * @param searchStr
     * @param tc_id
     * @return
     */
    List<Map<String , Object>>  exportCourseStudentInfo(String searchStr, String tc_id);
}
