package com.nxlg.model;

/**
 * Created by NEU on 2017/6/1.
 * 教学班级：教室-课程
 */
public class TeacherCourse {

    private String dbTeCoId;
    private String dbTeacherId;
    private String dbCourseId;
    private int dbstuNum;     //学生人数
    private String section;
    private String roomType;
    private int weekhours;     //周学时
    private int weekstart;
    private int weekend;
    private String specialtyId;   //所属专业

    public TeacherCourse() {
    }

    public TeacherCourse(String dbTeCoId, String dbTeacherId, String dbCourseId, int dbstuNum, String section, String roomType, int weekhours, int weekstart, int weekend,String specialtyId) {
        this.dbTeCoId = dbTeCoId;
        this.dbTeacherId = dbTeacherId;
        this.dbCourseId = dbCourseId;
        this.dbstuNum = dbstuNum;
        this.section = section;
        this.roomType = roomType;
        this.weekhours = weekhours;
        this.weekstart = weekstart;
        this.weekend = weekend;
        this.specialtyId =specialtyId;
    }

    public String getDbTeCoId() {
        return dbTeCoId;
    }

    public void setDbTeCoId(String dbTeCoId) {
        this.dbTeCoId = dbTeCoId;
    }

    public String getDbTeacherId() {
        return dbTeacherId;
    }

    public void setDbTeacherId(String dbTeacherId) {
        this.dbTeacherId = dbTeacherId;
    }

    public String getDbCourseId() {
        return dbCourseId;
    }

    public void setDbCourseId(String dbCourseId) {
        this.dbCourseId = dbCourseId;
    }

    public int getDbstuNum() {
        return dbstuNum;
    }

    public void setDbstuNum(int dbstuNum) {
        this.dbstuNum = dbstuNum;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public int getWeekhours() {
        return weekhours;
    }

    public void setWeekhours(int weekhours) {
        this.weekhours = weekhours;
    }

    public int getWeekstart() {
        return weekstart;
    }

    public void setWeekstart(int weekstart) {
        this.weekstart = weekstart;
    }

    public int getWeekend() {
        return weekend;
    }

    public void setWeekend(int weekend) {
        this.weekend = weekend;
    }

    public String getSpecialtyId() {
        return specialtyId;
    }

    public void setSpecialtyId(String specialtyId) {
        this.specialtyId = specialtyId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        TeacherCourse that = (TeacherCourse) o;

        if (dbstuNum != that.dbstuNum) return false;
        if (weekhours != that.weekhours) return false;
        if (weekstart != that.weekstart) return false;
        if (weekend != that.weekend) return false;
        if (!dbTeCoId.equals(that.dbTeCoId)) return false;
        if (!dbTeacherId.equals(that.dbTeacherId)) return false;
        if (!dbCourseId.equals(that.dbCourseId)) return false;
        if (!section.equals(that.section)) return false;
        if (!roomType.equals(that.roomType)) return false;
        return specialtyId.equals(that.specialtyId);

    }

    @Override
    public int hashCode() {
        int result = dbTeCoId.hashCode();
        result = 31 * result + dbTeacherId.hashCode();
        result = 31 * result + dbCourseId.hashCode();
        result = 31 * result + dbstuNum;
        result = 31 * result + section.hashCode();
        result = 31 * result + roomType.hashCode();
        result = 31 * result + weekhours;
        result = 31 * result + weekstart;
        result = 31 * result + weekend;
        result = 31 * result + specialtyId.hashCode();
        return result;
    }
}
