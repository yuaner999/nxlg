package com.nxlg.dataloader;

import com.nxlg.model.*;
import com.nxlg.rules.TCcRSwIndex;

import java.util.List;
import java.util.Set;

/**
 * Created by NEU on 2017/6/6.
 */
public interface ITCcRSwLoader {

    Set<Teacher> loadTeachers();

    Set<Room> loadRooms();

    Set<Course> loadCourse();

    Set<TeacherCourse> loadTeacherCourse(int curweek, String semesterId);

    List<DbTCcRSw> loadArrangeCourse(String semesterId, TCcRSwIndex tCcRSwIndex, int weekdaysCnt, int daysections);
    void loadSetData(String semesterId,int weekdasCnt,int daysectionsCnt,int schoolweekstart,int schoolweeekend);
}
