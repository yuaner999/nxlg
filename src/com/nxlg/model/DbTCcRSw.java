package com.nxlg.model;

/**
 * Created by NEU on 2017/5/31.
 * 染色体子结构—解码后（数据库数据）
 */
public class DbTCcRSw {

    private String dbTeCoId;
    private String dbRoomId;
    private int sectionId;
    private int weekDay;
    private int dbWeek;
    private int isSingleDoubleWeek;

    public DbTCcRSw() {
    }

    public DbTCcRSw(String dbTeCoId, String dbRoomId, int sectionId, int weekDay, int dbWeek, int isSingleDoubleWeek) {
        this.dbTeCoId = dbTeCoId;
        this.dbRoomId = dbRoomId;
        this.sectionId = sectionId;
        this.weekDay = weekDay;
        this.dbWeek = dbWeek;
        this.isSingleDoubleWeek = isSingleDoubleWeek;
    }

    public String getDbTeCoId() {
        return dbTeCoId;
    }

    public void setDbTeCoId(String dbTeCoId) {
        this.dbTeCoId = dbTeCoId;
    }

    public String getDbRoomId() {
        return dbRoomId;
    }

    public void setDbRoomId(String dbRoomId) {
        this.dbRoomId = dbRoomId;
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

    public int getDbWeek() {
        return dbWeek;
    }

    public void setDbWeek(int dbWeek) {
        this.dbWeek = dbWeek;
    }

    public int getIsSingleDoubleWeek() {
        return isSingleDoubleWeek;
    }

    public void setIsSingleDoubleWeek(int isSingleDoubleWeek) {
        this.isSingleDoubleWeek = isSingleDoubleWeek;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        DbTCcRSw dbTCcRSw = (DbTCcRSw) o;

        if (sectionId != dbTCcRSw.sectionId) return false;
        if (weekDay != dbTCcRSw.weekDay) return false;
        if (dbWeek != dbTCcRSw.dbWeek) return false;
        if (isSingleDoubleWeek != dbTCcRSw.isSingleDoubleWeek) return false;
        if (!dbTeCoId.equals(dbTCcRSw.dbTeCoId)) return false;
        return dbRoomId.equals(dbTCcRSw.dbRoomId);

    }

    @Override
    public int hashCode() {
        int result = dbTeCoId.hashCode();
        result = 31 * result + dbRoomId.hashCode();
        result = 31 * result + sectionId;
        result = 31 * result + weekDay;
        result = 31 * result + dbWeek;
        result = 31 * result + isSingleDoubleWeek;
        return result;
    }
}
