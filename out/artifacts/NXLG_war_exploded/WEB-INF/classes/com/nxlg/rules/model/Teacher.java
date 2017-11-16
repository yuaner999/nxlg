package com.nxlg.model;

/**
 * Created by NEU on 2017/6/6.
 */
public class Teacher {

    private String dbTeacherId;

    private String dbTeacherName;

    private int mostLessionsCnt;

    public Teacher() {
    }

    public Teacher(String dbTeacherId, String dbTeacherName, int mostLessionsCnt) {
        this.dbTeacherId = dbTeacherId;
        this.dbTeacherName = dbTeacherName;
        this.mostLessionsCnt = mostLessionsCnt;
    }

    public String getDbTeacherId() {
        return dbTeacherId;
    }

    public void setDbTeacherId(String dbTeacherId) {
        this.dbTeacherId = dbTeacherId;
    }

    public String getDbTeacherName() {
        return dbTeacherName;
    }

    public void setDbTeacherName(String dbTeacherName) {
        this.dbTeacherName = dbTeacherName;
    }

    public int getMostLessionsCnt() {
        return mostLessionsCnt;
    }

    public void setMostLessionsCnt(int mostLessionsCnt) {
        this.mostLessionsCnt = mostLessionsCnt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Teacher teacher = (Teacher) o;

        if (mostLessionsCnt != teacher.mostLessionsCnt) return false;
        if (!dbTeacherId.equals(teacher.dbTeacherId)) return false;
        return dbTeacherName.equals(teacher.dbTeacherName);
    }

    @Override
    public int hashCode() {
        int result = dbTeacherId.hashCode();
        result = 31 * result + dbTeacherName.hashCode();
        result = 31 * result + mostLessionsCnt;
        return result;
    }
    
}
