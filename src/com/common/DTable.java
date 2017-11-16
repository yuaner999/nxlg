package com.common;


import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

/**
 * DTable
 * Created by szy on 15/11/7.
 */
public class DTable extends DDB {
    static String sql = null;
    public Connection conn = null;
    private String table = "";
    private String where = null;
    private ArrayList<String> where_parameters = null;
    private int page = 0;
    private int limit = 0;
    private String order;
    private String field = null;
    private String left = null;
    private String table_raw = "";
    private String column_tag_pre="";
    private String column_tag_end="";

    public DTable(String table) {
        this.table_raw = table;
        init();
        if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("ORACLE")){
            column_tag_pre="";
            column_tag_end="";
        }else if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("SQLSERVER")){
            column_tag_pre="[";
            column_tag_end="]";
        }else if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("MYSQL")){
            column_tag_pre="`";
            column_tag_end="`";
        }else{
            column_tag_pre="";
            column_tag_end="";
        }
        this.table = getTablePre() + table;
    }

    public DTable(String table, Boolean tablePre) {
        this.table_raw = table;

        init();
        if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("ORACLE")){
            column_tag_pre="";
            column_tag_end="";
        }else if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("SQLSERVER")){
            column_tag_pre="[";
            column_tag_end="]";
        }else if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("MYSQL")){
            column_tag_pre="`";
            column_tag_end="`";
        }else{
            column_tag_pre="";
            column_tag_end="";
        }
        if (tablePre) {
            this.table = getTablePre() + table;
        } else {
            this.table = table;
        }
    }

    public String getOrder() {
        return order;
    }

    public DTable setOrder(String order) {
        this.order = order;
        return this;
    }

    public int getPageSize() {
        return limit;
    }

    public DTable setPageSize(int limit) {
        this.limit = limit;
        return this;
    }

    public int getPageNo() {
        return page;
    }

    public DTable setPageNo(int page) {
        this.page = page;
        return this;
    }

    public DTable setField(String field) {
        this.field = field;
        return this;
    }

    public String getLeft() {
        return left;
    }

    public DTable setLeft(String left) {
        return setLeft(left, "");
    }

    public DTable setLeft(String left, String on) {
        return setLeft(left, on,true);
    }

    public DTable setLeft(String left, String on, boolean tablePre){
        if (null == this.left) {
            this.left = "";
        }
        if (tablePre) {
            this.left = this.left + " left join " + getTablePre()  + left + " ";
        } else {
            this.left = this.left + " left join "  + left + " ";
        }
        if (null != on && !"".equals(on.trim())) {
            this.left = this.left + " on " + on + " ";
        }
        return this;

    }

    public DTable where(String where, ArrayList<String> where_parameters) {
        this.where = where;
        this.where_parameters = where_parameters;
        setOrder(null);
        this.setPageSize(0);
        this.setPageNo(0);
        return this;
    }

    protected String buildSQL() {
        if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("ORACLE")){//预留未完成
            return buildSQL_Oracle();
        }else if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("SQLSERVER")){
            return buildSQL_SqlServer();
        }
        String sql = "SELECT * FROM " + this.table;
        if (null != this.field && !"".equals(this.field.trim())) {
            sql = "SELECT " + this.field + " FROM " + this.table;
        }
        if (null != this.left && !"".equals(this.left.trim())) {
            sql += this.left;
        }
        if (this.where != null) {
            sql += " WHERE " + this.where;
        }

        if (this.order != null && !"".equals(this.order)) {
            sql += " ORDER BY " + this.order;
        }

        if (this.page > 0) {
            sql += " LIMIT " + (this.page - 1) * this.limit + ", " + this.limit;
        } else if (this.limit > 0) {
            sql += " LIMIT " + this.limit;

        }

        return sql;
    }

    protected String buildSQL_SqlServer() {
        String sql="";
        if (this.page > 0) {
            if (this.order == null || "".equals(this.order)) {
                return  "select '分页查询必须设置排序方式'";
            }
            int startNo = 1;
            int endNo = 1;
            startNo = (this.page - 1) * this.limit + 1;
            endNo = this.page * this.limit;

            sql = "select * from(select *,ROW_NUMBER() over (ORDER BY " + this.order + ") rankno from" + this.table;
            if (null != this.field && !"".equals(this.field.trim())) {
                sql = "select * from(select "+this.field+",ROW_NUMBER() over (ORDER BY " + this.order + ") rankno  FROM " + this.table;
            }
            if (null != this.left && !"".equals(this.left.trim())) {
                sql += this.left;
            }
            if (this.where != null) {
                sql += " WHERE " + this.where;
            }
            sql+=" )t where t.RANKNO BETWEEN " + startNo + " and " + endNo + " ";
        }else{
            sql = "SELECT ";
            if (this.limit > 0) {
                sql += " top " + this.limit;
            }
            sql+=" * FROM " + this.table;
            if (null != this.field && !"".equals(this.field.trim())) {
                sql = "SELECT ";
                if (this.limit > 0) {
                    sql += " top " + this.limit+" ";
                }
                sql+=this.field + " FROM " + this.table;
            }
            if (null != this.left && !"".equals(this.left.trim())) {
                sql += this.left;
            }
            if (this.where != null) {
                sql += " WHERE " + this.where;
            }

            if (this.order != null && !"".equals(this.order)) {
                sql += " ORDER BY " + this.order;
            }
        }
        return sql;

    }

    protected String buildSQL_Oracle() {
        String sql="";
        if (this.limit > 0) {
            if (this.order == null || "".equals(this.order)) {
                return  "select '分页查询必须设置排序方式'";
            }
            if(this.page<1){
                this.page=1;
            }
            int startNo = 1;
            int endNo = 1;
            startNo = (this.page - 1) * this.limit + 1;
            endNo = this.page * this.limit;

            sql = "SELECT * FROM (SELECT tt.*, ROWNUM AS rowno FROM (  SELECT t.* from" + this.table;
            if (null != this.field && !"".equals(this.field.trim())) {
                sql = "SELECT * FROM (SELECT tt.*, ROWNUM AS rowno FROM (  SELECT t."+this.field+"  FROM " + this.table;
            }
            if (null != this.left && !"".equals(this.left.trim())) {
                sql += this.left;
            }
            if (this.where != null) {
                sql += " WHERE " + this.where;
            }
            sql+=" ) tt WHERE ROWNUM <= "+endNo+") table_alias WHERE table_alias.rowno >= "+startNo+";";
        }else{
            sql = "SELECT * FROM " + this.table;
            if (null != this.field && !"".equals(this.field.trim())) {
                sql = "SELECT "+this.field + " FROM " + this.table;
            }
            if (null != this.left && !"".equals(this.left.trim())) {
                sql += this.left;
            }
            if (this.where != null) {
                sql += " WHERE " + this.where;
            }

            if (this.order != null && !"".equals(this.order)) {
                sql += " ORDER BY " + this.order;
            }
        }
        return sql;

    }

    public int count() {
        int count = 0;


        sql = "SELECT COUNT(1) AS "+column_tag_pre+"count"+column_tag_end+" FROM " + this.table;
        if (null != this.left && !"".equals(this.left.trim())) {
            sql += this.left;
        }
        if (this.where != null) {
            sql += " WHERE " + this.where;
        }

        List<Hashtable<String, String>> lRet = super.query(sql,this.where_parameters);

        if (lRet != null) {
            count = Integer.valueOf(lRet.get(0).get("count") + "");
        }

        return count;
    }

    public Double sum(String field) {
        Double sum = 0.0;
        String ifnull="ifnull";
        if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("ORACLE")){
            ifnull="nvl";
        }else if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("SQLSERVER")){
            ifnull="isnull";
        }else if(DConfig.get("db.db_type")!=null&& DConfig.get("db.db_type").equals("MYSQL")){
            ifnull="ifnull";
        }else{
            ifnull="ifnull";
        }

        sql = "SELECT "+ifnull+"(sum("+field+"),0) AS "+column_tag_pre+"sum"+column_tag_end+" FROM " + this.table;
        if (null != this.left && !"".equals(this.left.trim())) {
            sql += this.left;
        }
        if (this.where != null) {
            sql += " WHERE " + this.where;
        }

        List<Hashtable<String, String>> lRet = super.query(sql,this.where_parameters);

        if (lRet != null) {
            sum = Double.valueOf(lRet.get(0).get("sum") + "");
        }

        return sum;
    }
    @Deprecated
    public int countSql(String sql) {
        int count = 0;

        List<Hashtable<String, String>> lRet = super.query(sql);

        if (lRet != null) {
            count = Integer.valueOf(lRet.get(0).get("count") + "");
        }

        return count;
    }

    public int countSql(String sql,ArrayList<String> parameters) {
        int count = 0;

        List<Hashtable<String, String>> lRet = super.query(sql,parameters);

        if (lRet != null) {
            count = Integer.valueOf(lRet.get(0).get("count") + "");
        }

        return count;
    }

    public Map<String, String> find() {
        setPageSize(1);

        List<Hashtable<String, String>> aab = findAll();

        if (aab != null) {
            return aab.get(0);
        }

        return null;
    }

    public Object find(String where,ArrayList<String> sqlParameters, Object objOri) {
        this.where = where;
        long startTime = System.currentTimeMillis();
        Class<?> cClass = objOri.getClass();

        try {
            conn = getConnection();
            sql = this.buildSQL();

            PreparedStatement pst = conn.prepareStatement(sql);//准备执行语句
            if(sqlParameters!=null){
                for(int i=1;i<=sqlParameters.size();i++){
                    pst.setString(i,sqlParameters.get(i-1));
                    sql=sql.replaceFirst("\\?","'"+sqlParameters.get(i-1)+"'");
                }
            }
            ResultSet rs = pst.executeQuery();//执行语句，得到结果集
            logSql(sql, startTime);
            Field[] fields = cClass.getDeclaredFields();//得到对象中的字段

            while (rs.next()) {
                for (Field field : fields) {
                    String fieldName = field.getName();
                    Object value = null;
                    //根据字段类型决定结果集中使用哪种get方法从数据中取到数据
                    if (field.getType().equals(String.class)) {
                        value = rs.getString(fieldName);
                        if (value == null) {
                            value = "";
                        }
                    }
                    if (field.getType().equals(int.class)) {
                        value = rs.getInt(fieldName);
                    }
                    if (field.getType().equals(double.class)) {
                        value = rs.getDouble(fieldName);
                    }
                    if (field.getType().equals(Date.class)) {
                        value = rs.getDate(fieldName);
                    }
                    if (field.getType().equals(byte.class)) {
                        value = rs.getByte(fieldName);
                    }
                    if (value == null) {
                        continue;
                    }
                    // 获得属性的首字母并转换为大写，与setXXX对应
                    String setMethodName = "set" + DString.toBigCamelCase(fieldName);
                    Method setMethod = cClass.getMethod(setMethodName, field.getType());
                    setMethod.invoke(objOri, value);
                }
            }
            rs.close();
            pst.close();//关闭连接

        } catch (Exception e) {
            logSql(sql, e);
            e.printStackTrace();
        }

        return objOri;
    }

    public List<Hashtable<String, String>> findAll() {
        sql = this.buildSQL() + "";
        return findAll(sql,this.where_parameters);
    }

    public List<Hashtable<String, String>> findAll(String sql,ArrayList<String> sqlParameters) {
        return super.query(sql,sqlParameters);
    }

    public DTable reset() {
        return new DTable(table_raw);
    }

    @Deprecated
    public int executeSQLUnsafe(String sql) {
        return super.execute(sql);
    }

    public int executeSQL(String sql,ArrayList<String> parameters) {
        return super.execute(sql,parameters);
    }

    //执行多条sql语句,存在被影响的行数才为真
    @Deprecated
    public boolean executeMulSQLExistUnsafe(ArrayList<String> listSql) {
        String[] values = listSql.toArray(new String[listSql.size()]);
        return executeMulSQLExistUnsafe(values);
    }
    //执行多条sql语句,存在被影响的行数才为真
    @Deprecated
    public boolean executeMulSQLExistUnsafe(String[] sqlArr) {
        return super.execute(sqlArr) > 0;
    }
    //执行多条sql语句,只要不出错就为真
    @Deprecated
    public boolean executeMulSQLUnsafe(ArrayList<String> listSql) {
        String[] values = listSql.toArray(new String[listSql.size()]);
        return executeMulSQLUnsafe(values);
    }
    //执行多条sql语句,只要不出错就为真
    @Deprecated
    public boolean executeMulSQLUnsafe(String[] sqlArr) {
        return super.execute(sqlArr) >= 0;
    }

    //执行多条sql语句,存在被影响的行数才为真
    public boolean executeMulSQLExist(HashMap<String,ArrayList<String>> sqlAndParameters) {
        return super.execute(sqlAndParameters) > 0;
    }
    //执行多条sql语句,只要不出错就为真
    public boolean executeMulSQL(HashMap<String,ArrayList<String>> sqlAndParameters) {
        return super.execute(sqlAndParameters) >= 0;
    }

    protected String buildSetterSQL(Map<String, String> data) {
        String setStr = "";
        for (Map.Entry<String, String> entry : data.entrySet()) {
            Object value=entry.getValue();
            setStr += ","+column_tag_pre + entry.getKey() +column_tag_end+"='" + value.toString() + "'";
        }
        return setStr.substring(1);
    }

    protected String buildSetterSQLByParameters(Map<String, String> data) {
        String setStr = "";
        for (Map.Entry<String, String> entry : data.entrySet()) {
            Object value=entry.getValue();
            setStr += ","+column_tag_pre + entry.getKey()+column_tag_end + "=?";
        }
        return setStr.substring(1);
    }

    protected String buildUpdateSQL(Map<String, String> data) {
        String sql = "UPDATE " + this.table + " SET ";
        sql += buildSetterSQL(data);
        return sql;
    }

    protected String buildInsertSQL(Map<String, String> data) {
        String sql = "INSERT INTO " + this.table + " SET ";
        sql += buildSetterSQL(data);
        return sql;
    }

    protected String buildInsertSQLByParameters(Map<String, String> data) {
        String sql = "INSERT INTO " + this.table + " SET ";
        sql += buildSetterSQLByParameters(data);
        return sql;
    }

    protected String buildInsertSQL_SqlServer(Map<String, String> data) {
        String columns="";
        String values="";
        for (Map.Entry<String, String> entry : data.entrySet()) {
            Object value=entry.getValue();
            columns += ","+column_tag_pre + entry.getKey() +column_tag_end;
            values +=",'" + value.toString() + "'";
        }
        columns=columns.substring(1);
        values=values.substring(1);
        String sql = "INSERT INTO " + this.table + "("+columns+") values("+values+")";
        return sql;
    }

    protected String buildInsertSQLByParameters_SqlServer(Map<String, String> data) {
        String columns="";
        String values="";
        for (Map.Entry<String, String> entry : data.entrySet()) {
            Object value=entry.getValue();
            columns += ","+column_tag_pre + entry.getKey() +column_tag_end;
            values +=",?";
        }
        columns=columns.substring(1);
        values=values.substring(1);
        String sql = "INSERT INTO " + this.table + "("+columns+") values("+values+")";
        return sql;
    }

    public int insert(Map<String, String> data) {
        String sql = "";
        if(DConfig.get("db.db_type")!=null&& (DConfig.get("db.db_type").equals("SQLSERVER")|| DConfig.get("db.db_type").equals("ORACLE"))){
            sql = buildInsertSQLByParameters_SqlServer(data);
        }else{
            sql = buildInsertSQLByParameters(data);
        }
        ArrayList<String> parameters=new ArrayList<>();
        Iterator iter = data.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
            Object key = entry.getKey();
            Object val = entry.getValue();
            parameters.add(val.toString());
        }
        return super.execute(sql,parameters);
    }

    @Deprecated
    public int insertUnsafe(Map<String, String> data) {
        String sql = "";
        if(DConfig.get("db.db_type")!=null&& (DConfig.get("db.db_type").equals("SQLSERVER")|| DConfig.get("db.db_type").equals("ORACLE"))){
            sql = buildInsertSQL_SqlServer(data);
        }else{
            sql = buildInsertSQL(data);
        }

        return super.execute(sql);
    }

    /**
     * 获取添加操作的sql
     *
     * @param data data
     * @return String
     */
    public String getInsertSql(Map<String, String> data) {

        if(DConfig.get("db.db_type")!=null&& (DConfig.get("db.db_type").equals("SQLSERVER")|| DConfig.get("db.db_type").equals("ORACLE"))){
            return buildInsertSQLByParameters_SqlServer(data);
        }else{
            return buildInsertSQLByParameters(data);
        }

    }


    /**
     * 获取添加操作的sql
     *
     * @param data data
     * @return String
     */
    public String getInsertSqlUnsafe(Map<String, String> data) {
        if(DConfig.get("db.db_type")!=null&& (DConfig.get("db.db_type").equals("SQLSERVER")|| DConfig.get("db.db_type").equals("ORACLE"))){
            return buildInsertSQL_SqlServer(data);
        }else{
            return buildInsertSQL(data);
        }
    }
    /**
     * 获取添加操作的sql,仅mysql可用
     *
     * @param set Set
     * @return String
     */
    public String getInsertSqlWithSet(String set) {
        sql = "INSERT INTO " + this.table + " SET " + set + " ";
        return sql;
    }

    /**
     * 获取更新操作的sql，必须有 where ，否则不安全
     *
     * @param updateData 要更新的数据
     * @return sql
     */
    public String getUpdateSql(Map<String, String> updateData) {
        if (updateData.size() == 0 || this.where.isEmpty()) return "";
        sql = "UPDATE " + this.table + " SET ";
        sql += buildSetterSQL(updateData);

        sql += " WHERE " + this.where;

        return sql;
    }

    /**
     * 获取更新操作的sql，必须有 where ，否则不安全
     *
     * @param updateData 要更新的数据
     * @param where      where
     * @return sql
     */
    public String getUpdateSql(Map<String, String> updateData, String where) {
        if (updateData.size() == 0) return "";
        sql = "UPDATE " + this.table + " SET ";
        sql += buildSetterSQL(updateData);
        sql += " WHERE " + where;
        return sql;
    }

    /**
     * 获取更新操作的sql，必须有 where ，否则不安全
     *
     * @param field 字段
     * @param value 数值
     * @return String
     */
    public String getUpdateSql(String field, String value) {
        sql = "UPDATE " + this.table + " SET " + " "+column_tag_pre + field+column_tag_end + "='" + value + "'";
        if (this.where != null) {
            sql += " WHERE " + this.where;
        }
        return sql;
    }

    /**
     * 获取更新操作的sql,自己拼set语句,如果有客户输入,尽量不要使用该方法，必须有 where ，否则不安全
     *
     * @param set Set
     * @return String
     */
    public String getUpdateSqlWithSet(String set) {
        sql = "UPDATE " + this.table + " SET " + set + " ";
        if (this.where != null) {
            sql += " WHERE " + this.where;
        }
        return sql;
    }

    /**
     * 获取删除操作的sql，必须有 where ，否则不安全
     *
     * @param where where
     * @return sql
     */
    public String getDeleteSql(String where) {
        sql = "DELETE FROM " + this.table + " WHERE " + where;
        return sql;
    }

    /**
     * 更新数据方法
     *
     * @param updateData 要更新的数据
     * @param where      where
     * @return 影响的行数
     */
    public int update(Map<String, String> updateData, Map<String, String> where) {
        if (updateData.size() == 0) return 0;
        sql = "UPDATE " + this.table + " SET ";
        sql += buildSetterSQLByParameters(updateData);
        sql += " WHERE ";
        sql += buildWhereSQLByParameters(where);
        ArrayList<String> parameters=new ArrayList<>();
        Iterator iter2 = updateData.entrySet().iterator();
        while (iter2.hasNext()) {
            Map.Entry entry = (Map.Entry) iter2.next();
            Object key = entry.getKey();
            Object val = entry.getValue();
            parameters.add(val.toString());
        }
        Iterator iter = where.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
            Object key = entry.getKey();
            Object val = entry.getValue();
            parameters.add(val.toString());
        }
        return super.execute(sql,parameters);
    }

    /**
     * 更新数据方法
     *
     * @param updateData 要更新的数据
     * @param where      where
     * @return 影响的行数
     */
    public int update(Map<String, String> updateData, String whereStr, ArrayList<String> where) {
        if (updateData.size() == 0) return 0;
        sql = "UPDATE " + this.table + " SET ";
        sql += buildSetterSQLByParameters(updateData);
        sql += " WHERE "+whereStr;
        ArrayList<String> parameters=new ArrayList<>();
        Iterator iter2 = updateData.entrySet().iterator();
        while (iter2.hasNext()) {
            Map.Entry entry = (Map.Entry) iter2.next();
            Object key = entry.getKey();
            Object val = entry.getValue();
            parameters.add(val.toString());
        }
        for(int i=1;i<=where.size();i++){
            parameters.add(where.get(i-1));
        }

        return super.execute(sql,parameters);
    }

    /**
     * 更新数据方法
     *
     * @param updateData 要更新的数据
     * @param where      where
     * @return 影响的行数
     */
    @Deprecated
    public int updateUnsafe(Map<String, String> updateData, String where) {
        if (updateData.size() == 0) return 0;
        sql = "UPDATE " + this.table + " SET ";
        sql += buildSetterSQL(updateData);
        sql += " WHERE " + where;
        return super.execute(sql);
    }

    /**
     * 更新某一个字段
     *
     * @param field 字段
     * @param value 数值
     * @return int 影响行数
     */
    public int update(String field, String value) {
        return update(field, value, this.where,this.where_parameters);
    }


    /**
     * @param field 字段
     * @param value 数值
     * @param where 更新条件
     * @return int 影响行数
     */
    public int update(String field, String value, Map<String, String> where) {
        sql = "UPDATE " + this.table + " SET " + " "+column_tag_pre + field+column_tag_end + "=?";
        sql += " WHERE ";
        sql += buildWhereSQLByParameters(where);
        ArrayList<String> parameters=new ArrayList<>();
        parameters.add(value);
        Iterator iter = where.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
            Object key = entry.getKey();
            Object val = entry.getValue();
            parameters.add(val.toString());
        }
        return super.execute(sql,parameters);
    }

    /**
     * @param field 字段
     * @param value 数值
     * @param where 更新条件
     * @return int 影响行数
     */
    public int update(String field, String value, String whereStr, ArrayList<String> where) {
        sql = "UPDATE " + this.table + " SET " + " "+column_tag_pre + field+column_tag_end + "='?'";
        sql += " WHERE " + whereStr;
        where.add(0,value);
        return super.execute(sql,where);
    }

    /**
     * @param field 字段
     * @param value 数值
     * @param where 更新条件
     * @return int 影响行数
     */
    @Deprecated
    public int updateUnsafe(String field, String value, String where) {
        sql = "UPDATE " + this.table + " SET " + " "+column_tag_pre + field+column_tag_end + "='?'";
        sql += " WHERE " + where;
        ArrayList<String> parameters=new ArrayList<>();
        parameters.add(value);
        return super.execute(sql,parameters);
    }

    public int delete(Map<String, String> where) {
        sql = "DELETE FROM " + this.table + " WHERE ";
        sql += buildWhereSQLByParameters(where);
        ArrayList<String> parameters=new ArrayList<>();
        Iterator iter = where.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
            Object key = entry.getKey();
            Object val = entry.getValue();
            parameters.add(val.toString());
        }
        return super.execute(sql,parameters);
    }

    public int delete(String whereStr,ArrayList<String> parameters) {
        sql = "DELETE FROM " + this.table + " WHERE "+whereStr;
        return super.execute(sql,parameters);
    }

    protected String buildWhereSQLByParameters(Map<String, String> where) {
        String setStr = "";
        for (Map.Entry<String, String> entry : where.entrySet()) {
            Object value=entry.getValue();
            setStr += "and "+column_tag_pre + entry.getKey()+column_tag_end + "=?";
        }
        return setStr.substring(3);
    }
    @Deprecated
    public int deleteUnsafe(String where) {
        sql = "DELETE FROM " + this.table + " WHERE " + where;
        return super.execute(sql);
    }

    public Map<String, String> find(String where,ArrayList<String> parameters) {
        this.where = where;
        this.where_parameters = parameters;
        return find();
    }
}
