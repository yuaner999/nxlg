package com.nxlg.dataloader;

import com.nxlg.model.Course;
import com.nxlg.model.Room;
import com.nxlg.model.Teacher;
import com.nxlg.model.TeacherCourse;

import java.util.Set;

/**
 * Created by NEU on 2017/6/6.
 */
public interface ITCcRSwLoader {

    Set<Teacher> loadTeachers();

    Set<Room> loadRooms();

    Set<Course> loadCourse();

    Set<TeacherCourse> loadTeacherCourse();


}
