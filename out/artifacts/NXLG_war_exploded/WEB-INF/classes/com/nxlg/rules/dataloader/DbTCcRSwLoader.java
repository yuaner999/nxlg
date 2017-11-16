package com.nxlg.dataloader;

import com.nxlg.model.Course;
import com.nxlg.model.Room;
import com.nxlg.model.Teacher;
import com.nxlg.model.TeacherCourse;
import com.nxlg.utils.DbUtils;

import javax.sql.DataSource;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by NEU on 2017/6/6.
 */
public class DbTCcRSwLoader implements ITCcRSwLoader {

    private DataSource dataSource;

    @Override
    public Set<Teacher> loadTeachers() {
        String sql = "SELECT * FROM teacher";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);
        Set<Teacher> teachers = new HashSet<>();
        for (Map<String, Object> row : rows) {
            teachers.add(new Teacher(String.valueOf(row.get("teacherId")), String.valueOf(row.get("teacherName")), Integer.parseInt(row.get("mostClasses")==null?"5":row.get("mostClasses").toString())));
        }
        return teachers;
    }

    @Override
    public Set<Room> loadRooms() {
        String sql = "SELECT * FROM classroom";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);
        Set<Room> rooms = new HashSet<>();
        for (Map<String, Object> row : rows) {
            rooms.add(
                    new Room(
                            String.valueOf(row.get("classroomId")),
                            String.valueOf(row.get("classroomName")),
                            Integer.parseInt(row.get("classroomCapacity").toString()),
                            Double.parseDouble(row.get("minCapacityRate").toString()),
                            String.valueOf(row.get("classroomType")),
                            String.valueOf(row.get("building"))
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
                            Integer.parseInt(row.get("totalTime").toString())
                    )
            );
        }
        return courses;
    }

    @Override
    public Set<TeacherCourse> loadTeacherCourse() {
        String sql = "SELECT * FROM teachtask LEFT JOIN course ON teachtask.tc_courseid = course.courseId";
        List<Map<String, Object>> rows = DbUtils.queryList(dataSource, sql);
        Set<TeacherCourse> teacherCourses = new HashSet<>();
        for (Map<String, Object> row : rows) {
            teacherCourses.add(
                    new TeacherCourse(
                            String.valueOf(row.get("tc_id")),
                            String.valueOf(row.get("tc_classteacherid")),
                            String.valueOf(row.get("tc_courseid")),
                            Integer.parseInt(row.get("tc_studentnum")==null?"0":row.get("tc_studentnum").toString()),
                            String.valueOf(row.get("scheduleTime")),
                            String.valueOf(row.get("tc_teachway")),
                            Integer.parseInt(row.get("tc_weekhours")==null?"1":row.get("tc_weekhours").toString()),
                            Integer.parseInt(row.get("tc_thweek_start")==null?"1":row.get("tc_thweek_start").toString()),
                            Integer.parseInt(row.get("tc_thweek_end")==null?"16":row.get("tc_thweek_end").toString()),
                            String.valueOf(row.get("tc_majorId"))

                    )
            );
        }
        return teacherCourses;
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}
