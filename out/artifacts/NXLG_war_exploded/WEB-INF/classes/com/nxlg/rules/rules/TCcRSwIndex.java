package com.nxlg.rules;

import com.nxlg.model.Course;
import com.nxlg.model.Room;
import com.nxlg.model.Teacher;
import com.nxlg.model.TeacherCourse;
import com.nxlg.utils.SetIndexUtils;

import java.util.*;

/**
 * Created by NEU on 2017/6/2.
 */
public class TCcRSwIndex implements ITCcRSwIndex {
    private Set<Teacher> dbTeacherIdSet = new HashSet<>();
    private Set<Course> dbCourseSet = new HashSet<>();
    private Set<String> dbClassIdSet = new HashSet<>();
    private Set<Room> dbRoomSet = new HashSet<>();
    private Set<TeacherCourse> dbTeacherCourseSet = new HashSet<>();

    private Map<Integer, Teacher> ga_db_teacherIdMap = new HashMap<>();
    private Map<Teacher, Integer> db_ga_teacherIdMap = new HashMap<>();
    private Set<Integer> teacherIdSet = new HashSet<>();

    private Map<Integer, Course> ga_db_courseIdMap = new HashMap<>();
    private Map<Course, Integer> db_ga_courseIdMap = new HashMap<>();
    private Set<Integer> courseIdSet = new HashSet<>();

    private Map<Integer, String> ga_db_classIdMap = new HashMap<>();
    private Map<String, Integer> db_ga_classIdMap = new HashMap<>();
    private Set<Integer> classIdSet = new HashSet<>();

    private Map<Integer, Room> ga_db_roomMap = new HashMap<>();
    private Map<Room, Integer> db_ga_roomMap = new HashMap<>();
    private Set<Integer> roomSet = new HashSet<>();

    private Map<Integer, TeacherCourse> ga_db_teacherCourseMap = new HashMap<>();
    private Map<TeacherCourse, Integer> db_ga_teacherCourseMap = new HashMap<>();
    private Set<Integer> teacherCourseSet = new HashSet<>();

    public void setDbTeacherIdSet(Set<Teacher> dbTeacherIdSet) {
        this.dbTeacherIdSet = dbTeacherIdSet;
    }

    public void setDbCourseSet(Set<Course> dbCourseSet) {
        this.dbCourseSet = dbCourseSet;
    }

    public void setDbRoomSet(Set<Room> dbRoomSet) {
        this.dbRoomSet = dbRoomSet;
    }

    public void setDbTeacherCourseSet(Set<TeacherCourse> dbTeacherCourseSet) {
        this.dbTeacherCourseSet = dbTeacherCourseSet;
    }

    @Override
    public void registDbTeacher(String dbTeacherId, String dbTeacherName, int mostLessionCnt) {
        dbTeacherIdSet.add(new Teacher(dbTeacherId, dbTeacherName, mostLessionCnt));
    }

    @Override
    public void registDbCourse(Course course) {
        dbCourseSet.add(course);
    }

    @Override
    public void registDbClass(String dbclassId) {
        dbClassIdSet.add(dbclassId);
    }

    @Override
    public void registDbRoom(Room room) {
        dbRoomSet.add(room);
    }

    @Override
    public void registDbTeacherCourse(String dbTeCoId, String dbTeacherId, String dbCourseId, int dbstuNum, String section, String roomType, int weekhours, int weekstart, int weekend, String specialtyId) {
        dbTeacherCourseSet.add(new TeacherCourse(dbTeCoId, dbTeacherId, dbCourseId, dbstuNum, section, roomType, weekhours, weekstart, weekend, specialtyId));
    }

    @Override
    public void buildGAIndex() {
        SetIndexUtils.buildSetIndex(dbTeacherIdSet, db_ga_teacherIdMap, ga_db_teacherIdMap, teacherIdSet, 1);
        SetIndexUtils.buildSetIndex(dbCourseSet, db_ga_courseIdMap, ga_db_courseIdMap, courseIdSet, 1);
        // this.classIdSet = SetIndexUtils.buildSetIndex(dbClassIdSet,db_ga_classIdMap,ga_db_classIdMap,classIdSet,1);
        SetIndexUtils.buildSetIndex(dbTeacherCourseSet, db_ga_teacherCourseMap, ga_db_teacherCourseMap, teacherCourseSet, 1);
        SetIndexUtils.buildSetIndex(dbRoomSet, db_ga_roomMap, ga_db_roomMap, roomSet, 1);
    }


    //通过教师Id获取教师索引
    @Override
    public int getTeacherIdByDbTeacherId(String dbTeacherId) {
        return db_ga_teacherIdMap.get(dbTeacherId);
    }

    //通过课程Id获取课程索引
    @Override
    public int getCourseIdByDbCourseId(String dbCourseId) {
        return db_ga_courseIdMap.get(dbCourseId);
    }

    //通过教室Id获取教室索引
    @Override
    public int getRoomIdByDbRoomId(String dbRoomId) {
        return db_ga_roomMap.get(dbRoomId);
    }

    @Override
    public int getClassIdByDbClassId(String dbClassId) {
        return db_ga_classIdMap.get(dbClassId);
    }

    //通过教学班级Id获取教学班级索引
    @Override
    public int getTeCoIdByDbTeCoId(String dbTeCoId) {
        return db_ga_teacherCourseMap.get(dbTeCoId);
    }

    //通过教师索引获取教师
    @Override
    public Teacher getDbTeacherByTeacherId(int teacherId) {
        return ga_db_teacherIdMap.get(teacherId);
    }

    //通过课程索引获取课程
    @Override
    public Course getCourseByCourseId(int courseId) {
        return ga_db_courseIdMap.get(courseId);
    }

    //通过教室索引获取教室Id
    @Override
    public String getDbRoomIdByRoomId(int roomId) {
        return ga_db_roomMap.get(roomId).getDbRoomId();
    }

    //通过
    @Override
    public String getDbClassIdByClassId(int classId) {
        return ga_db_classIdMap.get(classId);
    }

    //通过教室索引获取教室
    @Override
    public Room getRoomByRoomId(int roomId) {
        return ga_db_roomMap.get(roomId);
    }

    //通过教学班级索引值获取教学班级
    @Override
    public TeacherCourse getTeacerCourseByteacherCourse(int teacherCourse) {
        return ga_db_teacherCourseMap.get(teacherCourse);
    }

    //获取教学班级大小
    @Override
    public int getTeachercourseSize() {
        return dbTeacherCourseSet.size();
    }

    //获取教室数量
    @Override
    public int getRoomSize() {
        return dbRoomSet.size();
    }

    @Override
    public int getTeacherByDbteacherId(String dbTeacherId) {
        int cnt = 0;
        for (Teacher teacherobj : dbTeacherIdSet) {
            if (Objects.equals(teacherobj.getDbTeacherId(), dbTeacherId)) cnt = teacherobj.getMostLessionsCnt();
        }
        return cnt;
    }
}
