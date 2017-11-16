package com.nxlg.model;

/**
 * Created by NEU on 2017/6/1.
 * 教室
 */
public class Room {
    private String dbRoomId;
    private String roomName;
    private int roomCapacity;
    private double minCapacityRate;
    private String roomType;
    private String roomBuildingId;

    public Room() {
    }

    public Room(String dbRoomId, String roomName, int roomCapacity, double minCapacityRate, String roomType, String roomBuildingId) {
        this.dbRoomId = dbRoomId;
        this.roomName = roomName;
        this.roomCapacity = roomCapacity;
        this.minCapacityRate = minCapacityRate;
        this.roomType = roomType;
        this.roomBuildingId = roomBuildingId;
    }

    public Room(String dbRoomId, String roomName, int roomCapacity, double minCapacityRate, String roomBuildingId) {
        this.dbRoomId = dbRoomId;
        this.roomName = roomName;
        this.roomCapacity = roomCapacity;
        this.minCapacityRate = minCapacityRate;
        this.roomBuildingId = roomBuildingId;
    }

    public String getDbRoomId() {
        return dbRoomId;
    }

    public void setDbRoomId(String dbRoomId) {
        this.dbRoomId = dbRoomId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public int getRoomCapacity() {
        return roomCapacity;
    }

    public void setRoomCapacity(int roomCapacity) {
        this.roomCapacity = roomCapacity;
    }

    public String getRoomBuildingId() {
        return roomBuildingId;
    }

    public void setRoomBuildingId(String roomBuildingId) {
        this.roomBuildingId = roomBuildingId;
    }

    public double getMinCapacityRate() {
        return minCapacityRate;
    }

    public void setMinCapacityRate(double minCapacityRate) {
        this.minCapacityRate = minCapacityRate;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Room room = (Room) o;

        if (roomCapacity != room.roomCapacity) return false;
        if (Double.compare(room.minCapacityRate, minCapacityRate) != 0) return false;
        if (!dbRoomId.equals(room.dbRoomId)) return false;
        if (!roomName.equals(room.roomName)) return false;
        return roomBuildingId.equals(room.roomBuildingId);

    }

    @Override
    public int hashCode() {
        int result;
        long temp;
        result = dbRoomId.hashCode();
        result = 31 * result + roomName.hashCode();
        result = 31 * result + roomCapacity;
        temp = Double.doubleToLongBits(minCapacityRate);
        result = 31 * result + (int) (temp ^ (temp >>> 32));
        result = 31 * result + roomBuildingId.hashCode();
        return result;
    }
}
