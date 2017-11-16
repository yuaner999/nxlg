package com.nxlg.model;

/**
 * Created by NEU on 2017/5/31.
 * 染色体子结构—编码后
 */
public class TCcRSw {

    private int tecoId;
    private int classId;
    private int roomId;
    private int sectionId;
    private int weekDay;

    public TCcRSw() {
    }

    public TCcRSw(int tecoId, int roomId, int sectionId, int weekDay) {
        this.tecoId = tecoId;
       // this.classId = classId;
        this.roomId = roomId;
        this.sectionId = sectionId;
        this.weekDay = weekDay;
    }

    public int getTecoId() {
        return tecoId;
    }

    public void setTecoId(int tecoId) {
        this.tecoId = tecoId;
    }

    public int getClassId() {
        return classId;
    }

    public void setClassId(int classId) {
        this.classId = classId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getSectionId() {
        return sectionId;
    }

    public void setSectionId(int sectionId) {
        this.sectionId = sectionId;
    }

    public int getWeekDay() {
        return weekDay;
    }

    public void setWeekDay(int weekDay) {
        this.weekDay = weekDay;
    }
}
