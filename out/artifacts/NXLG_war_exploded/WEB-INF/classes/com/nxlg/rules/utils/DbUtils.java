package com.nxlg.utils;

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
    public static List<Map<String,Object>> queryList(DataSource dataSource,String sql) {
        List<Map<String,Object>> result = new ArrayList<>();
        try{
            Connection con = dataSource.getConnection();
            PreparedStatement stat = con.prepareStatement(sql);
            ResultSet resultSet = stat.executeQuery();
            ResultSetMetaData meta = resultSet.getMetaData();       //获取元数据

            while (resultSet.next()){
                Map<String,Object> rowobj = new HashMap<>();
                for(int i=1;i<=meta.getColumnCount();i++){
                    String colname = meta.getColumnLabel(i);
                    Object value = resultSet.getObject(colname);
                    rowobj.put(colname,value);
                }
                result.add(rowobj);
            }
            con.close();
        }catch (Exception e){
            e.printStackTrace();
        }

        return result;
    }

    //按条件查询
    public static List<Map<String,Object>> queryListByCondition(DataSource dataSource,String sql,String[] condition) {
        List<Map<String,Object>> result = new ArrayList<>();
        try{
            Connection con = dataSource.getConnection();
            PreparedStatement stat = con.prepareStatement(sql);
            for (int i=0;i<condition.length;i++){
                stat.setObject((i+1),condition[i]);
            }
            ResultSet resultSet = stat.executeQuery();
            ResultSetMetaData meta = resultSet.getMetaData();       //获取元数据

            while (resultSet.next()){
                Map<String,Object> rowobj = new HashMap<>();
                for(int i=1;i<=meta.getColumnCount();i++){
                    String colname = meta.getColumnLabel(i);
                    Object value = resultSet.getObject(colname);
                    rowobj.put(colname,value);
                }
                result.add(rowobj);
            }
            con.close();
        }catch (Exception e){
            e.printStackTrace();
        }

        return result;
    }

}
