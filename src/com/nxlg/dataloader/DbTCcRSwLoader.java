package com.nxlg.dataloader;

import com.nxlg.model.*;
import com.nxlg.rules.TCcRSwIndex;
import com.nxlg.utils.DbUtils;

import javax.sql.DataSource;
import java.util.*;

/**
 * Created by NEU on 2017/6/6.
 */
public class DbTCcRSwLoader implements ITCcRSwLoader {

    private DataSource dataSource;

    @Override
    public void loadSetData(String semesterId, int weekdasCnt, int daysectionsCnt, int schoolweekstart, int schoolweeekend) {
        String sql = "SELECT * FROM arrangecourse WHERE is_now = '1'";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);

        for (Map<String, Object> row : rows) {
            semesterId = String.valueOf(row.get("acId"));
            weekdasCnt = Integer.parseInt(row.get("days").toString());
            daysectionsCnt = Integer.parseInt(row.get("lessonsMorning").toString()) + Integer.parseInt(row.get("lessonAfternoon").toString()) + Integer.parseInt(row.get("lessonNight").toString());
            schoolweekstart = Integer.parseInt(row.get("startWeek").toString());
            schoolweeekend = Integer.parseInt(row.get("endWeek").toString());
        }
    }

    @Override
    public List<DbTCcRSw> loadArrangeCourse(String semesterId, TCcRSwIndex tCcRSwIndex, int weekdaysCnt, int daysections) {
        List<DbTCcRSw> dbTCcRSwList = new ArrayList<>(Collections.nCopies(tCcRSwIndex.getRoomSize() * weekdaysCnt * daysections, new DbTCcRSw()));

        String sql = "SELECT * FROM arrangelesson WHERE acId = '" + semesterId + "'";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);
        Set<DbTCcRSw> dbTCcRSwSet = new HashSet<>();
        int i = 0;
        for (Map<String, Object> row : rows) {

            String dbTeCoId = String.valueOf(row.get("tc_id"));
            String roomId = String.valueOf(row.get("classroomId"));
            int section = Integer.parseInt(row.get("al_timepitch").toString());
            int weekday = Integer.parseInt(row.get("al_timeweek").toString());
            int dbweek = 0;
            int isSingleWeek = 0;
            int roomIndex = (tCcRSwIndex.getRoomIdByDbRoomId(roomId) - 1);
            i = roomIndex * (weekdaysCnt * daysections) + (weekday - 1) * daysections + (section - 1);
            dbTCcRSwList.set(i, new DbTCcRSw(dbTeCoId, roomId, section, weekday, dbweek, isSingleWeek));
        }
        return dbTCcRSwList;
    }

    @Override
    public Set<Teacher> loadTeachers() {
        String sql = "SELECT * FROM teacher";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);
        Set<Teacher> teachers = new HashSet<>();
        for (Map<String, Object> row : rows) {
            teachers.add(
                    new Teacher(
                            String.valueOf(row.get("teacherId")),
                            String.valueOf(row.get("teacherName")),
                            Integer.parseInt((row.get("mostClasses") == null||row.get("mostClasses").equals("")) ? "5" : row.get("mostClasses").toString())
                    )
            );
        }
        return teachers;
    }

    @Override
    public Set<Room> loadRooms() {
        String sql = "SELECT * FROM classroom WHERE campus = '宁夏理工学院' AND classroomStatus = '使用'";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);
        Set<Room> rooms = new HashSet<>();
        for (Map<String, Object> row : rows) {
            rooms.add(
                    new Room(
                            String.valueOf(row.get("classroomId")),
                            String.valueOf(row.get("classroomName") == null ? "" : row.get("classroomName").toString()),
                            Integer.parseInt(row.get("classroomCapacity") == null ? "80" : row.get("classroomCapacity").toString()),
                            Double.parseDouble(row.get("minCapacityRate") == null ? "0.5" : row.get("minCapacityRate").toString()),
                            String.valueOf(row.get("classroomType") == null ? "" : row.get("classroomType").toString()),
                            String.valueOf(row.get("building") == null ? "" : row.get("building").toString())
                    )
            );
        }
        return rooms;
    }

    @Override
    public Set<Course> loadCourse() {
        String sql = "SELECT * FROM course";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);
        Set<Course> courses = new HashSet<>();
        for (Map<String, Object> row : rows) {
            courses.add(
                    new Course(
                            String.valueOf(row.get("courseId")),
                            Integer.parseInt(row.get("totalTime").toString() == null ? "0" : row.get("totalTime").toString())
                    )
            );
        }
        return courses;
    }

    @Override
    public Set<TeacherCourse> loadTeacherCourse(int curweek, String semesterId) {
//        String sql = "SELECT * FROM teachtask LEFT JOIN course ON teachtask.tc_courseid = course.courseId WHERE tc_thweek_start = " + curweek;
        String sql = "SELECT * FROM teachtask WHERE tc_thweek_start = " + curweek + " AND tc_checkStatus = '已通过' AND tc_semester ='"
                + semesterId + "' AND tc_isDelete IS NULL";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);
        Set<TeacherCourse> teacherCourses = new HashSet<>();
        for (Map<String, Object> row : rows) {
            int teachodd = 0;
            if (row.get("tc_teachodd").toString() == "无") {
                teachodd = 0;
            } else if (row.get("tc_teachodd").toString() == "单周") {
                teachodd = 1;
            } else if (row.get("tc_teachodd").toString() == "双周") {
                teachodd = 2;
            }
            teacherCourses.add(
                    new TeacherCourse(
                            String.valueOf(row.get("tc_id")),
                            String.valueOf(row.get("tc_classteacherid")),
                            String.valueOf(row.get("tc_courseid")),
                            Integer.parseInt(row.get("tc_studentnum") == null ? "0" : row.get("tc_studentnum").toString()),
                            String.valueOf(row.get("scheduleTime") == null ? "1|2|" : row.get("scheduleTime").toString()),
                            String.valueOf(row.get("tc_teachway") == null ? "一般教室" : row.get("tc_teachway").toString()),
                            Integer.parseInt(row.get("tc_weekhours") == null ? "2" : row.get("tc_weekhours").toString()),
                            Integer.parseInt(row.get("tc_thweek_start") == null ? "1" : row.get("tc_thweek_start").toString()),
                            Integer.parseInt(row.get("tc_thweek_end") == null ? "16" : row.get("tc_thweek_end").toString()),
                            teachodd,
                            String.valueOf(row.get("tc_chooseway"))
                    )
            );
        }
        return teacherCourses;
    }


    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}
