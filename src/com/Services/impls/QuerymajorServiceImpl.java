package com.Services.impls;

import com.Services.interfaces.QuerymajorService;
import com.dao.interfaces.MajorDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author NEU
 *         Created by admin on 2017/4/19.
 */
@Service
public class QuerymajorServiceImpl implements QuerymajorService {
    @Autowired
    private MajorDao majorDao;

    @Override
    public List<Map<String, Object>> getMajorlist(Map<String, Object> map, String searchStr) {
        return majorDao.getMajorlist(map, searchStr);
    }

    @Override
    public List<Map<String, Object>> selectEducatePlanMajorList(Map<String, Object> map, String searchStr,String college,String major,String grade) {
        return majorDao.getEducatePlanMajorList(map, searchStr,college,major,grade);
    }

    @Override
    public List<Map<String, Object>> selectMajorlist(Map<String, Object> map) {
        return majorDao.selectMajorlist(map);
    }

    @Override
    public List<Map<String, Object>> getCourselist(Map<String, Object> map, String searchStr, String teachCollege) {
        return majorDao.getCourselist(map, searchStr, teachCollege);
    }

    @Override
    public List<Map<String, Object>> getNowCourselist(Map<String, Object> map, String _classCode,String _className) {
        return majorDao.getNowCourselist(map, _classCode,_className);
    }

    @Override
    public List<Map<String, Object>> teacherTerraceCourseList(Map<String, Object> map) {
        return majorDao.teacherTerraceCourseList(map);
    }

    @Override
    public List<Map<String, Object>> getArgmCourse(String userId, String thweekday, String teachodd) {
        return majorDao.getArgmCourse(userId, thweekday, teachodd);
    }

    @Override
    public List<Map<String, Object>> getArgmCourseByTh(String tcid, String thweekday, String teachodd) {
        return majorDao.getArgmCourseByTh(tcid, thweekday, teachodd);
    }

    @Override
    public List<Map<String, Object>> getArgmCourseByCr(String crid, String thweekday, String teachodd) {
        return majorDao.getArgmCourseByCr(crid, thweekday, teachodd);
    }

    @Override
    public List<Map<String, Object>> getBeforeBuyingInfo(String collegeName, String majorName, String className) {
        return majorDao.getBeforeBuyingInfo(collegeName, majorName, className);
    }

    @Override
    public List<Map<String, Object>> exportWithdrawCourseInfo(String searchStr, String course, String semester, String major) {
        return majorDao.exportWithdrawCourseInfo(searchStr, course, semester, major);
    }

    @Override
    public List<Map<String, Object>> exportqueryTerraceCourse(String type,String teachCollege,String collegeName, String majorName, String terraceName, String termName) {
        return majorDao.exportqueryTerraceCourse(type,teachCollege,collegeName, majorName, terraceName, termName);
    }

    @Override
    public List<Map<String, Object>> exportUnuseTeacherInfo(String teachweek, String teachodd, String timeweek, String timepitch) {
        return majorDao.exportUnuseTeacherInfo(teachweek, teachodd, timeweek, timepitch);
    }

    @Override
    public List<Map<String, Object>> exportUnuseStudentInfo(String teachweek, String teachodd, String timeweek, String timepitch, String studentGrade, String studentCollege, String studentMajor) {
        return majorDao.exportUnuseStudentInfo(teachweek, teachodd, timeweek, timepitch, studentGrade, studentCollege, studentMajor);
    }

    @Override
    public List<Map<String, Object>> exportUnuseClassroomInfo(String teachweek, String teachodd, String timeweek, String timepitch) {
        return majorDao.exportUnuseClassroomInfo(teachweek, teachodd, timeweek, timepitch);
    }

    @Override
    public List<Map<String, Object>> exportClassStudentInfo(Map<String, Object> map) {
        return majorDao.exportClassStudentInfo(map);
    }

    @Override
    public List<Map<String, Object>> exportCourseStudentInfo(String searchStr, String tc_id) {
        return majorDao.exportCourseStudentInfo(searchStr, tc_id);
    }
}
