package com.nxlg.model;

/**
 * Created by NEU on 2017/6/3.
 * 课程
 */
public class Course {
    private String dbCourseId;
    private int schoolhours;

    public Course(String dbCourseId, int schoolhours) {
        this.dbCourseId = dbCourseId;
        this.schoolhours = schoolhours;
    }

    public String getDbCourseId() {
        return dbCourseId;
    }

    public void setDbCourseId(String dbCourseId) {
        this.dbCourseId = dbCourseId;
    }

    public int getSchoolhours() {
        return schoolhours;
    }

    public void setSchoolhours(int schoolhours) {
        this.schoolhours = schoolhours;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Course course = (Course) o;

        if (schoolhours != course.schoolhours) return false;
        return dbCourseId.equals(course.dbCourseId);

    }

    @Override
    public int hashCode() {
        int result = dbCourseId.hashCode();
        result = 31 * result + schoolhours;
        return result;
    }
}
