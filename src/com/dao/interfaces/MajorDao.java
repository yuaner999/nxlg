package com.dao.interfaces;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 专业
 * @author NEU
 * Created by admin on 2017/4/19.
 */
@Repository
public interface MajorDao {
    /**
     *
     * @param map
     * @return
     */
    List<Map<String , Object>> getMajorlist(Map<String, Object> map, String searchStr);

    /**
     * 导出某个培养计划中的课程信息
     * @param map
     * @param searchStr
     * @return
     */
    List<Map<String , Object>> getEducatePlanMajorList(Map<String, Object> map, String searchStr,String college,String major,String grade);

    /**
     * 专业列表信息 zqy
     * @param map
     * @return
     */
    List<Map<String , Object>> selectMajorlist(Map<String, Object> map);

    List<Map<String , Object>> getCourselist(Map<String, Object> map, String searchStr,String teachCollege);

    /**
     *  zqy
     * 课程审核现有课程
     * */
    List<Map<String , Object>> getNowCourselist(Map<String, Object> map, String _classCode,String _className);

    /**
     *zqy
     *现有课程信息
     * */
    List<Map<String , Object>> teacherTerraceCourseList(Map<String, Object> map);

    List<Map<String , Object>> getArgmCourse(String userId,String thweekday,String teachodd);

    List<Map<String , Object>> getArgmCourseByTh(String tcId,String thweekday,String teachodd);

    List<Map<String , Object>> getArgmCourseByCr(String crid,String thweekday,String teachodd);

    List<Map<String , Object>> getBeforeBuyingInfo(@Param(value="collegeName")String collegeName, @Param(value="majorName")String majorName, @Param(value="className")String className);

    List<Map<String , Object>> exportWithdrawCourseInfo(@Param(value="searchStr")String searchStr, @Param(value="course")String course, @Param(value="semester")String semester, @Param(value="major")String major);

    List<Map<String , Object>> exportqueryTerraceCourse(@Param(value="type")String type,@Param(value="teachCollege")String teachCollege,@Param(value="collegeName")String collegeName,@Param(value="majorName")String majorName,@Param(value="terraceName")String terraceName,@Param(value="termName")String termName);

    List<Map<String , Object>> exportUnuseTeacherInfo(@Param(value="teachweek")String teachweek, @Param(value="teachodd")String teachodd,@Param(value="timeweek")String timeweek,@Param(value="timepitch")String timepitch);
    /**
     *zqy
     *空余学生查询导出
     * */
    List<Map<String , Object>> exportUnuseStudentInfo(@Param(value="teachweek")String teachweek, @Param(value="teachodd")String teachodd,@Param(value="timeweek")String timeweek,@Param(value="timepitch")String timepitch,@Param(value="studentGrade")String studentGrade,@Param(value="studentCollege")String studentCollege,@Param(value="studentMajor")String studentMajor);

    List<Map<String , Object>> exportUnuseClassroomInfo(@Param(value="teachweek")String teachweek, @Param(value="teachodd")String teachodd,@Param(value="timeweek")String timeweek,@Param(value="timepitch")String timepitch);

    List<Map<String , Object>> exportClassStudentInfo(Map<String, Object> map);

    List<Map<String , Object>> exportCourseStudentInfo(@Param(value="searchStr")String searchStr, @Param(value="tc_id")String tc_id);
}
