package com.nxlg.rules;

import com.nxlg.model.Course;
import com.nxlg.model.Room;
import com.nxlg.model.Teacher;
import com.nxlg.model.TeacherCourse;

import java.util.Set;

/**
 * Created by NEU on 2017/6/2.
 * 染色体子结构索引接口
 */
public interface ITCcRSwIndex {

    int getDaysectioncount();

    void setDaysectioncount(int daysectioncount);

    int getWeekdayscount();

    void setWeekdayscount(int weekdayscount);

    void registDbTeacher(String dbTeacherId, String dbTeacherName, int mostLessionCnt);

    void registDbCourse(Course course);

    void registDbClass(String dbclassId);

    void registDbRoom(Room room);

    void registDbTeacherCourse(String dbTeCoId, String dbTeacherId, String dbCourseId, int dbstuNum, String section, String roomType, int weekhours, int weekstart, int weekend, int IsSingleDoubleWeek, String specialtyId);

    void buildTeachCourseIndex();

    void buildIndex();

    int getTeacherIdByDbTeacherId(String dbTeacherId);

    int getCourseIdByDbCourseId(String dbCourseId);

    int getRoomIdByDbRoomId(String dbRoomId);

    int getClassIdByDbClassId(String dbClassId);

    int getTeCoIdByDbTeCoId(String dbTeCoId);

    void setTeacherCourseSet(Set<Integer> teacherCourseSet);

    Set<Integer> getTeacherCourseSet();

    Set<Integer> getRoomSet();

    void setRoomSet(Set<Integer> roomSet);

    Teacher getDbTeacherByTeacherId(int teacherId);

    String getDbRoomIdByRoomId(int roomId);

    String getDbClassIdByClassId(int classId);

    Room getRoomByRoomId(int roomId);

    Course getCourseByCourseId(int courseId);

    TeacherCourse getTeacerCourseByteacherCourse(int teacherCourse);

    int getTeachercourseSize();

    int getRoomSize();

    void setDbTeacherIdSet(Set<Teacher> dbTeacherIdSet);

    void setDbCourseSet(Set<Course> dbCourseSet);

    void setDbRoomSet(Set<Room> dbRoomSet);

    void setDbTeacherCourseSet(Set<TeacherCourse> dbTeacherCourseSet);

    int getTeacherByDbteacherId(String dbTeacherId);
}
