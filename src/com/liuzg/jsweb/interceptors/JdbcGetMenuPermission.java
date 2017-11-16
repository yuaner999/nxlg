package com.liuzg.jsweb.interceptors;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by NEUNB_Lisy on 2017/7/3.
 */
public class JdbcGetMenuPermission{

    private DataSource dataSource;

    public List<Map<String, Object>> searchAllMenu(){
        Connection connection=null;
        List<Map<String, Object>> menulist=new ArrayList<>();
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            menulist = getAllMenu(connection);
            connection.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            if (connection!=null){
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                ;
            }
        }
        return menulist;
    }

    /**
     * 查询该用户具有的权限
     * author Lisy
     * @param userId
     * */
    public List<Map<String, Object>> searchMenuPermission(String userId) {
        Connection connection=null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            list = getMenuPermission(connection,userId);
            connection.commit();
        } catch (SQLException e ) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return list;
    }

    /**
     * 查询jsapi的是否有权限控制
     * author Lisy
     * @param menuId
     * */
    public List<Map<String, Object>> searchMenuJsapis(String menuId) {
        Connection connection=null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            list = getMenuJsapisPermission(connection,menuId);
            connection.commit();
        } catch (SQLException e ) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return list;
    }

    /**
     * 查询jsapi的权限
     * author Lisy
     * @param menuId
     * */
    public List<Map<String, Object>> searchMenuJsapisPermission(String menuId,String userId) {
        Connection connection=null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        try {
            connection = dataSource.getConnection();
            connection.setAutoCommit(false);
            list = getMenuJsapisPermission(connection,menuId,userId);
            connection.commit();
        } catch (SQLException e ) {
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return list;
    }

    private List<Map<String , Object>> getAllMenu(Connection connection){
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<Map<String , Object>> menulist = new ArrayList<>();
        String sql = "SELECT `menu`.* FROM `menu`";
        try {
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();
            menulist = ResultSetToList(rs);
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menulist;
    }

    /**
     * author Lisy
     * @param connection
     * @param userId
     * */
    private List<Map<String, Object>> getMenuPermission(Connection connection,String userId){
        PreparedStatement ps=null;
        ResultSet rs=null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        String sql="SELECT "+
                "`menu`.* " +
                "FROM" +
                "`menu`" +
                "LEFT JOIN `nxlg`.`role_menu`" +
                "ON (`role_menu`.`menuId`=`menu`.`menuId`)" +
                "LEFT JOIN `nxlg`.`role`" +
                "ON (`role`.`roleId`=`role_menu`.`roleId`)" +
                "LEFT JOIN `nxlg`.`user`" +
                "ON (`user`.`roleId`=`role`.`roleId`)" +
                "WHERE `user`.`userId`= ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1,userId);
            rs = ps.executeQuery();
            list = ResultSetToList(rs);
            ps.close();
//            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
        }
        return list;
    }

    private List<Map<String, Object>> getMenuJsapisPermission(Connection connection,String menuId){
        PreparedStatement ps=null;
        ResultSet rs=null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        String sql="SELECT "+
                "`menu_jsapi`.* " +
                "FROM" +
                "`menu_jsapi`" +
                "WHERE `menu_jsapi`.`jsapis_name`= ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1,menuId);
            rs = ps.executeQuery();
            list = ResultSetToList(rs);
            ps.close();
//            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
        }
        return list;
    }

    private List<Map<String, Object>> getMenuJsapisPermission(Connection connection,String menuId,String userId){
        PreparedStatement ps=null;
        ResultSet rs=null;
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        String sql="SELECT "+
                "`menu_jsapi`.* " +
                "FROM" +
                "`menu_jsapi`" +
                "LEFT JOIN `nxlg`.`role_menu`" +
                "ON (`role_menu`.`menuId`=`menu_jsapi`.`menuId`)" +
                "LEFT JOIN `nxlg`.`role`" +
                "ON (`role`.`roleId`=`role_menu`.`roleId`)" +
                "LEFT JOIN `nxlg`.`user`" +
                "ON (`user`.`roleId`=`role`.`roleId`)" +
                "WHERE `menu_jsapi`.`jsapis_name`= ? and `user`.`userId`= ?";
        try {
            ps = connection.prepareStatement(sql);
            ps.setString(1,menuId);
            ps.setString(2,userId);
            rs = ps.executeQuery();
            list = ResultSetToList(rs);
            ps.close();
//            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
        }
        return list;
    }

    private static List<Map<String,Object>> ResultSetToList(ResultSet rs) throws SQLException{
        List list = new ArrayList();

        ResultSetMetaData md = rs.getMetaData();

        int columnCount = md.getColumnCount(); //Map rowData;

        while (rs.next()) { //rowData = new HashMap(columnCount);

            Map rowData = new HashMap();

            for (int i = 1; i <= columnCount; i++) {

                rowData.put(md.getColumnName(i), rs.getObject(i));

            }

            list.add(rowData);

        } return list;
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}
