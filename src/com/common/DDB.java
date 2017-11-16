package com.common;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;


/**
 * FDB
 * Created by szy on 15/10/6.
 */
public class DDB {
    static private DDB instance;
    static private Connection conn;
    protected String tablePre = "";
    private String dbUrl;
    private String dbUser;
    private String dbPwd;
    private int timeOut = 2;
    private String lastSql = "";

    public DDB() {
    }

    public static synchronized DDB getInstance() {
        if (instance == null) {
            instance = new DDB();
            instance.init();
        }
        return instance;
    }

    public DDB init() {
        if(DConfig.get("db.db_type")!=null&& (DConfig.get("db.db_type").equals("ORACLE")|| DConfig.get("db.db_type").equals("SQLSERVER"))){
            dbUrl = (DConfig.get("db.url") + "").trim();
            dbUser = (DConfig.get("db.username") + "").trim();
            dbPwd = (DConfig.get("db.password") + "").trim();
            tablePre = (DConfig.get("db.table_pre") + "").trim();
        }else{
            int _timeOut = DConfig.get("db.time_out") == null ? 0 : Integer.parseInt((DConfig.get("db.time_out") + "").trim());
            if (_timeOut > 0) {
                timeOut = _timeOut;
            }
            dbUrl = "jdbc:mysql://" + (DConfig.get("db.host") + "").trim() + "/"
                    + (DConfig.get("db.db") + "").trim() + "?connectTimeout=" + timeOut * 1000
                    + "&useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull";
            dbUser = (DConfig.get("db.user") + "").trim();
            dbPwd = (DConfig.get("db.pwd") + "").trim();
            tablePre = (DConfig.get("db.table_pre") + "").trim();
        }
        return this;
    }

    public synchronized Connection connect() {

        try {
            if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("ORACLE")) {
                Class.forName("oracle.jdbc.driver.OracleDriver");
            }else if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("SQLSERVER")){
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            }else {
                Class.forName("com.mysql.jdbc.Driver");
            }
        } catch (ClassNotFoundException e) {
            DLog.error(e,"DDB.connect()");
        }
        DriverManager.setLoginTimeout(timeOut);
        try {
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPwd);
        } catch (SQLException e) {
            DLog.w("数据库连接不上：" + e.getMessage());

        }
//        System.out.println("数据库创建连接");

        return conn;
    }

    public static Connection getConnection() {

        try {
            if (conn == null || conn.isClosed()) {
                conn = DDB.getInstance().connect();
            }
        } catch (SQLException e) {
            conn = DDB.getInstance().connect();
        }

        return conn;
    }

    /**
     * 得到链接
     *
     * @param createNew 是否新实例
     * @return 带事务的链接
     */
    public static Connection getConnection(boolean createNew) {

        if (createNew) {
            return new DDB().init().connect();
        } else {
            return getConnection();
        }
    }

    public static int insert(String table, Map<String, String> data) {
        DTable aa = new DTable(table);
        return aa.insert(data);
    }

    public static int update(String table, Map<String, String> data, String where) {
//        if (data == null || data.size() == 0) {
//            System.err.println("更新 " + table + "出错! data 数组为空!");
//            return 0;
//        }

        DTable aa = new DTable(table);
        return aa.update(data, where,new ArrayList<String>());
    }

    public static int update(String table, Map<String, String> data, Hashtable<String, String> where) {
        String strWhere = "";
        for (Map.Entry<String, String> entry : where.entrySet()) {
            strWhere += entry.getKey() + "='" + entry.getValue() + "' AND ";
        }

        return update(table, data, strWhere.substring(0, strWhere.lastIndexOf(" AND ")));
    }
    @Deprecated
    public static Hashtable<String, String> fetchFirst(String sql) {
        return (getInstance().query(sql)).get(0);
    }
    @Deprecated
    public static List<Hashtable<String, String>> fetch(String sql) {
        return DDB.getInstance().query(sql);
    }

    public static Hashtable<String, String> fetchFirst(String sql,ArrayList<String> parameters) {
        return (getInstance().query(sql,parameters)).get(0);
    }

    public static List<Hashtable<String, String>> fetch(String sql,ArrayList<String> parameters) {
        return DDB.getInstance().query(sql,parameters);
    }

    public static int remove(String table, String where) {
        DTable aa = new DTable(table);
        return aa.delete(where,new ArrayList<String>());
    }

    public String getTablePre() {
        return tablePre;
    }

    public void logSql(String sql) {
        DLog.w(sql);
    }

    public void logErrSql(String sql) {
        DLog.error(sql);
    }

    public void logSql(String sql, Exception e) {
        logErrSql(sql + "; -- 执行失败 : " + e.getMessage());
    }

    public void logSql(String sql, long timeStart) {
        logSql(sql + "; -- 执行时间：" + (System.currentTimeMillis() - timeStart) / 1000f + " (S)");
    }

    @Deprecated
    public List<Hashtable<String, String>> query(String sql) {
        List<Hashtable<String, String>> retList = null;

        try {
            long timeStart = System.currentTimeMillis();

            conn = getConnection();

            PreparedStatement pst = conn.prepareStatement(sql);//准备执行语句
            ResultSet ret = pst.executeQuery();//执行语句，得到结果集
            ResultSetMetaData rsMe = pst.getMetaData();
            int colCount = rsMe.getColumnCount();//取得全部列数

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            retList = new Vector<Hashtable<String, String>>();

            while (ret.next()) {
                Hashtable<String, String> aab = new Hashtable<String, String>();
                for (int i = 1; i <= colCount; i++) {
                    String colType = rsMe.getColumnTypeName(i);
                    if (colType.equalsIgnoreCase("timestamp") || colType.equalsIgnoreCase("datetime")) {
                        long bb = 0;
                        try {
                            bb = ret.getTimestamp(i).getTime();
                        } catch (Exception ignored) {
                        }

                        aab.put(rsMe.getColumnLabel(i), bb > 0 ? sdf.format(bb) : "");
                    } else {
                        String bb = ret.getString(i);
                        if (bb == null) bb = "";
                        aab.put(rsMe.getColumnLabel(i), bb);
                    }
                }
                retList.add(aab);
            }
            ret.close();
            pst.close();//关闭连接

            logSql(sql, timeStart);

        } catch (SQLException e) {
            logSql(sql, e);
        }finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException ignored) {
            }
        }

        return (retList != null && retList.size() > 0) ? retList : null;
    }

    public List<Hashtable<String, String>> query(String sql,ArrayList<String> sqlParameters) {
        List<Hashtable<String, String>> retList = null;

        try {
            long timeStart = System.currentTimeMillis();

            conn = getConnection();

            PreparedStatement pst = conn.prepareStatement(sql);//准备执行语句
            if(sqlParameters!=null){
                for(int i=1;i<=sqlParameters.size();i++){
                    pst.setString(i,sqlParameters.get(i-1));
                    sql=sql.replaceFirst("\\?","'"+sqlParameters.get(i-1)+"'");
                }
            }
            ResultSet ret = pst.executeQuery();//执行语句，得到结果集
            ResultSetMetaData rsMe = pst.getMetaData();
            int colCount = rsMe.getColumnCount();//取得全部列数

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            retList = new Vector<Hashtable<String, String>>();

            while (ret.next()) {
                Hashtable<String, String> aab = new Hashtable<String, String>();
                for (int i = 1; i <= colCount; i++) {
                    String colType = rsMe.getColumnTypeName(i);
                    if (colType.equalsIgnoreCase("timestamp") || colType.equalsIgnoreCase("datetime")) {
                        long bb = 0;
                        try {
                            bb = ret.getTimestamp(i).getTime();
                        } catch (Exception ignored) {
                        }

                        aab.put(rsMe.getColumnLabel(i), bb > 0 ? sdf.format(bb) : "");
                    } else {
                        String bb = ret.getString(i);
                        if (bb == null) bb = "";
                        aab.put(rsMe.getColumnLabel(i), bb);
                    }
                }
                retList.add(aab);
            }
            ret.close();
            pst.close();//关闭连接

            logSql(sql, timeStart);

        } catch (SQLException e) {
            logSql(sql, e);
        }finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException ignored) {
            }
        }

        return (retList != null && retList.size() > 0) ? retList : null;
    }

    /**
     * 执行一条语句。返回自增ID
     *
     * @param sql sql
     * @return 自增ID 出错返回 -1 ，没有自增ID，返回 -2
     */
    @Deprecated
    public int execute(String sql) {
        int effectRow;

        long startTime = System.currentTimeMillis();

        PreparedStatement st;
        Connection connect = null;
        try {
            connect = getConnection(false);

            if (connect == null) {
                DLog.error("数据库链接失败");
                return -1;
            }


            connect.setAutoCommit(false);
            st = connect.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            effectRow = st.executeUpdate();

            connect.commit();
            logSql(sql, startTime);
        } catch (Exception e) {
            logSql(sql, e);

            effectRow = -1;
            try {
                if (connect != null) {
                    connect.rollback();
                }
            } catch (Exception ignored) {
            }
        } finally {
            try {
                if (connect != null) connect.close();
            } catch (SQLException ignored) {
            }
        }
        logSql("结果:"+effectRow,System.currentTimeMillis());
        return effectRow;
    }

    /**
     * 事务执行多条，失败返回 -1
     *
     * @param sqlArr 多条 sql
     * @return 影响行数
     */
    @Deprecated
    public int execute(String[] sqlArr) {
        int effectRows = 0;
        String sql="";
        PreparedStatement st;
        Connection connect = null;
        try {
            connect = getConnection(false);
            connect.setAutoCommit(false);
            for (String aSqlArr : sqlArr) {
                sql=aSqlArr;
                long startTime = System.currentTimeMillis();
                st = connect.prepareStatement(aSqlArr);
                effectRows += st.executeUpdate();
                logSql(sql,startTime);
            }
            connect.commit();
        } catch (Exception e) {
            logSql(sql, e);
            effectRows = -1;
            try {
                if (connect != null) {
                    connect.rollback();
                }
            } catch (Exception ignored) {
            }
        } finally {
            try {
                connect.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        logSql("执行结果:"+effectRows,System.currentTimeMillis());
        return effectRows;
    }

    /**
     * 执行一条语句。返回自增ID
     *
     * @param sql sql
     * @param sqlParameters 参数
     * @return 自增ID 出错返回 -1 ，没有自增ID，返回 -2
     */
    public int execute(String sql,ArrayList<String> sqlParameters) {
        int effectRow;

        long startTime = System.currentTimeMillis();

        PreparedStatement st;
        Connection connect = null;
        try {
            connect = getConnection(false);

            if (connect == null) {
                DLog.error("数据库链接失败");
                return -1;
            }


            connect.setAutoCommit(false);
            st = connect.prepareStatement(sql);
            if(sqlParameters!=null){
                for(int i=1;i<=sqlParameters.size();i++){
                    st.setString(i,sqlParameters.get(i-1));
                    sql=sql.replaceFirst("\\?","'"+sqlParameters.get(i-1)+"'");
                }
            }
            effectRow = st.executeUpdate();
            connect.commit();
            logSql(sql, startTime);
        } catch (Exception e) {
            logSql(sql, e);
            effectRow = -1;
            try {
                if (connect != null) {
                    connect.rollback();
                }
            } catch (Exception ignored) {
            }
        } finally {
            try {
                if (connect != null) connect.close();
            } catch (SQLException ignored) {
            }
        }
        logSql("结果:"+effectRow,System.currentTimeMillis());
        return effectRow;
    }

    /**
     * 事务执行多条，失败返回 -1
     *
     * @param sqlAndParameters 多条 sql+参数
     * @return 影响行数
     */
    public int execute(HashMap<String,ArrayList<String>> sqlAndParameters) {
        int effectRows = 0;
        String sql="";
        PreparedStatement st;
        Connection connect = null;
        try {
            connect = getConnection(false);
            connect.setAutoCommit(false);

            Iterator iter = sqlAndParameters.entrySet().iterator();
            while (iter.hasNext()) {
                Map.Entry entry = (Map.Entry) iter.next();
                Object key = entry.getKey();
                Object val = entry.getValue();

                sql=key.toString();
                long startTime = System.currentTimeMillis();
                st = connect.prepareStatement(sql);
                if(val!=null){
                    ArrayList<String> sqlParameters=(ArrayList<String>)val;
                    for(int i=1;i<=sqlParameters.size();i++){
                        st.setString(i,sqlParameters.get(i-1));
                        sql=sql.replaceFirst("\\?","'"+sqlParameters.get(i-1)+"'");
                    }
                }
                effectRows += st.executeUpdate();
                logSql(sql,startTime);
            }
            connect.commit();
        } catch (Exception e) {
            logSql(sql, e);
            effectRows = -1;
            try {
                if (connect != null) {
                    connect.rollback();
                }
            } catch (Exception ignored) {
            }
        } finally {
            try {
                connect.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        logSql("执行结果:"+effectRows,System.currentTimeMillis());
        return effectRows;
    }
}