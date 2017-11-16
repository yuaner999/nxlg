package com.nxlg.utils;

import com.nxlg.model.DbTCcRSw;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/6/6.
 */
public class DbUtils {

    //查询
    public static List<Map<String, Object>> queryList(DataSource dataSource, String sql) {
        List<Map<String, Object>> result = new ArrayList<>();
        try {
            Connection con = dataSource.getConnection();
            PreparedStatement stat = con.prepareStatement(sql);
            ResultSet resultSet = stat.executeQuery();
            ResultSetMetaData meta = resultSet.getMetaData();       //获取元数据

            while (resultSet.next()) {
                Map<String, Object> rowobj = new HashMap<>();
                for (int i = 1; i <= meta.getColumnCount(); i++) {
                    String colname = meta.getColumnLabel(i);
                    Object value = resultSet.getObject(colname);
                    rowobj.put(colname, value);
                }
                result.add(rowobj);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    //插入
    public static boolean insertArrangeCourse(DataSource dataSource, List<DbTCcRSw> dbresult, String semesterId) {
        try {
            Connection con = dataSource.getConnection();
            PreparedStatement statement = null;
            for (int i = 0; i < dbresult.size(); i++) {
                List<Map<String, Object>> rows = null;
                String sql=null;
                sql="select * from classroom where classroomId='" + dbresult.get(i).getDbRoomId() + "'";
                rows = queryList(dataSource, sql);
                String classroomName = "";
                if (rows.size()>0){
                    classroomName=String.valueOf(rows.get(0).get("classroomName"));
                }
                sql="select * from teachtask where tc_id='" + dbresult.get(i).getDbTeCoId() + "'";
                rows = queryList(dataSource, sql);
                String courseId = "";
                if (rows.size()>0){
                    courseId=String.valueOf(rows.get(0).get("tc_courseid"));
                }
                if (dbresult.get(i).getDbTeCoId() != null && dbresult.get(i).getDbTeCoId() != "") {
//                    String sql = "INSERT INTO `arrangelesson` (`al_Id`,`al_timeweek`,`al_timepitch`,`acId`,`courseId`,`classroomId`,`classroomName`,`tc_id`) VALUE ( '"+i+"','"+dbresult.get(i).getWeekDay()+"','"+dbresult.get(i).getSectionId()+"','"+acId+"','"+courseId+"','"+dbresult.get(i).getDbRoomId()+"','"+classroomname+"','"+dbresult.get(i).getDbTeCoId()+"')";
                    String sqlInsert = "INSERT INTO `arrangelesson` (`al_Id`,`al_timeweek`,`al_timepitch`,`acId`,`courseId`,`classroomId`,`classroomName`,`tc_id`) VALUE (UUID(),?,?,?,?,?,?,?)";
                    statement = con.prepareStatement(sqlInsert);
                    statement.setObject((int) 1, dbresult.get(i).getWeekDay());
                    statement.setObject((int) 2, dbresult.get(i).getSectionId());
                    statement.setObject((int) 3, semesterId);
                    statement.setObject((int) 4, courseId);
                    statement.setObject((int) 5, dbresult.get(i).getDbRoomId());
                    statement.setObject((int) 6, classroomName);
                    statement.setObject((int) 7, dbresult.get(i).getDbTeCoId());
                    statement.execute();
                }
            }
            con.commit();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }

    //清空排课结果
    public static void clearCourses(DataSource dataSource){
        try {
            Connection con = dataSource.getConnection();
            PreparedStatement truncate = con.prepareStatement("TRUNCATE TABLE `arrangelesson`");
            truncate.execute();
            con.commit();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
