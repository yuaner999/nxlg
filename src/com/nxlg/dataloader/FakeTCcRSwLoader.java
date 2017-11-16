package com.nxlg.dataloader;

import com.nxlg.model.*;
import com.nxlg.rules.TCcRSwIndex;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by NEU on 2017/6/6.
 */
public class FakeTCcRSwLoader implements ITCcRSwLoader {
    @Override
    public Set<Teacher> loadTeachers() {
        Set<Teacher> teachers = new HashSet<>();
        teachers.add(new Teacher("zhang", "张", 3));
        teachers.add(new Teacher("li", "李", 3));
        teachers.add(new Teacher("zhao", "赵", 3));
        return teachers;
    }

    @Override
    public Set<Room> loadRooms() {
        Set<Room> dbRoomSet = new HashSet<>();
        dbRoomSet.add(new Room("1", "room1", 100, 0.5, "普通", "1"));
        dbRoomSet.add(new Room("2", "room2", 100, 0.5, "普通", "1"));
        dbRoomSet.add(new Room("3", "room2", 100, 0.5, "普通", "1"));
        dbRoomSet.add(new Room("4", "room2", 100, 0.5, "普通", "1"));
        dbRoomSet.add(new Room("5", "room2", 100, 0.5, "普通", "1"));
        dbRoomSet.add(new Room("6", "room2", 100, 0.5, "普通", "1"));
        dbRoomSet.add(new Room("7", "room2", 100, 0.5, "上机", "2"));
        dbRoomSet.add(new Room("8", "room2", 100, 0.5, "上机", "2"));
        dbRoomSet.add(new Room("9", "room3", 150, 0.5, "上机", "2"));
        return dbRoomSet;
    }

    @Override
    public Set<Course> loadCourse() {
        Set<Course> dbCourseSet = new HashSet<>();
        dbCourseSet.add(new Course("math1", 64));
        dbCourseSet.add(new Course("math2", 64));
        dbCourseSet.add(new Course("math3", 64));
        dbCourseSet.add(new Course("math4", 64));
        dbCourseSet.add(new Course("english1", 32));
        dbCourseSet.add(new Course("english2", 32));
        dbCourseSet.add(new Course("english3", 32));
        dbCourseSet.add(new Course("java1", 32));
        dbCourseSet.add(new Course("java2", 32));
        dbCourseSet.add(new Course("java3", 32));
        dbCourseSet.add(new Course("c#1", 32));
        return dbCourseSet;
    }

    @Override
    public Set<TeacherCourse> loadTeacherCourse(int week, String semesterId) {
        Set<TeacherCourse> dbTeacherCourseSet = new HashSet<>();
        if (week == 1) {
            dbTeacherCourseSet.add(new TeacherCourse("zm", "zhang", "math1", 67, "1|2", "普通", 4, 1, 16, 1, "1"));
            dbTeacherCourseSet.add(new TeacherCourse("zm1", "zhang", "math2", 67, "1|2", "普通", 4, 1, 16, 0, "1"));
            dbTeacherCourseSet.add(new TeacherCourse("zm2", "zhang", "math3", 67, "1|2", "普通", 4, 1, 16, 0, "1"));
            dbTeacherCourseSet.add(new TeacherCourse("wm2", "wang", "math2", 55, "1|2", "普通", 4, 1, 16, 1, ""));
            dbTeacherCourseSet.add(new TeacherCourse("lm", "li", "math1", 77, "3|4", "普通", 4, 1, 16, 1, ""));
            dbTeacherCourseSet.add(new TeacherCourse("zm3", "zhao", "math4", 88, "3|4", "普通", 4, 1, 16, 1, "2"));
            dbTeacherCourseSet.add(new TeacherCourse("we", "wang", "english1", 90, "3|4", "上机", 2, 1, 16, 0, "3"));
            dbTeacherCourseSet.add(new TeacherCourse("we1", "wang", "english2", 90, "3|4", "上机", 2, 1, 16, 0, "3"));
            dbTeacherCourseSet.add(new TeacherCourse("we2", "wang", "english3", 90, "3|4", "上机", 2, 1, 16, 1, "3"));
            dbTeacherCourseSet.add(new TeacherCourse("le1", "li", "english1", 88, "3|4", "上机", 2, 1, 16, 1, "4"));
            dbTeacherCourseSet.add(new TeacherCourse("ze", "zhang", "english1", 78, "3|4", "上机", 2, 1, 16, 1, "5"));
            dbTeacherCourseSet.add(new TeacherCourse("ze1", "zhang", "english2", 78, "3|4", "上机", 2, 1, 16, 1, "5"));
        } else if (week == 2) {
            dbTeacherCourseSet.add(new TeacherCourse("wm", "wang", "math1", 55, "1|2", "普通", 4, 2, 16, 2, "1"));
            dbTeacherCourseSet.add(new TeacherCourse("wm3", "wang", "math3", 55, "1|2", "普通", 4, 2, 16, 2, ""));
            dbTeacherCourseSet.add(new TeacherCourse("lm1", "li", "math2", 77, "3|4", "普通", 4, 2, 16, 2, "2"));
            dbTeacherCourseSet.add(new TeacherCourse("lm2", "li", "math3", 77, "3|4", "普通", 4, 2, 16, 2, "2"));
            dbTeacherCourseSet.add(new TeacherCourse("le2", "li", "english2", 88, "3|4", "上机", 2, 2, 16, 2, "4"));
            dbTeacherCourseSet.add(new TeacherCourse("le3", "li", "english3", 88, "3|4", "上机", 2, 2, 16, 2, "4"));
        }
        return dbTeacherCourseSet;
    }

    @Override
    public List<DbTCcRSw> loadArrangeCourse(String semesterId, TCcRSwIndex tCcRSwIndex, int weekdaysCnt, int daysections) {
        return null;
    }

    @Override
    public void loadSetData(String semesterId, int weekdasCnt, int daysectionsCnt, int schoolweekstart, int schoolweeekend) {

    }
}
