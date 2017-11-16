/*
*Created by liulei on 2016/4/25.
*/
package com.controllers;

import com.common.D;
import com.common.DFunction;
import com.common.DLog;
import com.common.DTable;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * Created by liulei on 2016/4/25.
 */
@Controller
@RequestMapping(value = "/Test")
public class TestController {
    @RequestMapping(value = "/test", method = RequestMethod.GET)
    @ResponseBody
    public JSONObject Test(HttpServletRequest request, HttpSession session) {
        long timeDifference = System.currentTimeMillis() - Long.valueOf("1474992240000");
        JSONObject jsonObject = JSONObject.fromObject("{'result':1,'total':5}");
        return jsonObject;
    }

    /**
     * 获取系统菜单管理的所有菜单
     * @return
     */
    @RequestMapping(value = "/getSysMenuList",method= RequestMethod.POST)
    @ResponseBody
    public JSONObject getSysMenuList(){

        String result = "{}";
        String json = "";
        String count = "0";
        try{
            //初始化,参数为数据库表名
            DTable bllMenu=new DTable("sysmenu");
            // .where()是设置where条件,第一个参数是sql,需要替换的参数用?代替,第二个是ArrayList<String>使用sql参数的方式
            // .count()是查询出的条数
            int menu_count=bllMenu.where("1=1",null).count();
            count=Integer.toString(menu_count);
            if(menu_count>0) {
                String updateMan = "";
                String updateDate = "";
                // .where()是设置where条件,第一个参数是sql,需要替换的参数用?代替,第二个是ArrayList<String>使用sql参数的方式
                // .setOrder()是设置排序方式,可不设置
                // .setField()是设置查询的字段,可不设置,默认查询*所有
                // .findAll()是查询数据列表
                List<Hashtable<String, String>> lstMenu = bllMenu.reset().where("1=1",null).setOrder("is_sysmanage_menu,sort").setField("*,parent_menuid as parentId").findAll();
                for (Hashtable<String, String> tblMenu : lstMenu) {
                    if (tblMenu.get("update_man") == null) {
                        updateMan = "";
                    } else {
                        updateMan = tblMenu.get("update_man");
                    }
                    if (tblMenu.get("update_date") == null) {
                        updateDate = "";
                    } else {
                        updateDate = tblMenu.get("update_date");
                    }

                    json += "{'sysmenuurl':'" + tblMenu.get("sysmenu_url") + "'," +
                            "'updateman':'" + updateMan + "'," +
                            "'issysmanagemenu':'" + tblMenu.get("is_sysmanage_menu") + "'," +
                            "'createman':'" + tblMenu.get("create_man") + "'," +
                            "'updatedate':'" + updateDate + "'," +
                            "'sysmenuname':'" + tblMenu.get("sysmenu_name") + "'," +
                            "'createdate':'" + tblMenu.get("create_date") + "'," +
                            "'remark':'" + tblMenu.get("remark") + "'," +
                            "'sort':'" + tblMenu.get("sort") + "'," +
                            "'sysmenuid':'" + tblMenu.get("sysmenu_id") + "',";
                    if (tblMenu.get("parentId") != null) {
                        if (!tblMenu.get("parent_menuid").toString().equals("")) {
                            json += "'parentId':'" + tblMenu.get("parent_menuid").toString() + "',";
                        }
                    }
                    json += "'parentmenuid':'" + tblMenu.get("parent_menuid").toString() + "'},";
                }
            }else{
                json = "{}";
            }
            json = json.substring(0,json.length()-1);
            result = "{'result':1,'total':"+count+",'rows':["+json+"]}";
        }catch (Exception ex){
            DLog.w(ex.getMessage());
            result= "{'result':0,'msg':'执行错误:"+ex.getMessage()+"'}";
        }

        JSONObject jsonObject = JSONObject.fromObject(result);
        return jsonObject;

//        JdbcFactory factory = SpringUtils.getBean(JdbcFactory.class);
//        try {
//            Connection connection = factory.createConnection();
//            String sql = "select count(*) as count FROM sysmenu";
//            PreparedStatement preparedStatement = connection.prepareStatement(sql);
//            ResultSet resultSet = preparedStatement.executeQuery();
//            if(resultSet.next()){
//                count = resultSet.getString("count").toString();
//                sql = "SELECT *,parent_menuid as parentId FROM sysmenu order by is_sysmanage_menu,sort";
//                preparedStatement = connection.prepareStatement(sql);
//                resultSet = preparedStatement.executeQuery();
//                String updateMan = "";
//                String updateDate = "";
//                while (resultSet.next()){
//
//                    if(resultSet.getString("update_man")==null){
//                        updateMan = "";
//                    }else {
//                        updateMan = resultSet.getString("update_man");
//                    }
//                    if(resultSet.getString("update_date")==null){
//                        updateDate = "";
//                    }else {
//                        updateDate = resultSet.getString("update_date");
//                    }
//
//                    json += "{'sysmenuurl':'"+resultSet.getString("sysmenu_url")+"'," +
//                            "'updateman':'"+updateMan+"'," +
//                            "'issysmanagemenu':'"+resultSet.getString("is_sysmanage_menu")+"'," +
//                            "'createman':'"+resultSet.getString("create_man")+"'," +
//                            "'updatedate':'"+updateDate+"'," +
//                            "'sysmenuname':'"+resultSet.getString("sysmenu_name")+"'," +
//                            "'createdate':'"+resultSet.getString("create_date")+"'," +
//                            "'remark':'"+resultSet.getString("remark")+"'," +
//                            "'sort':'"+resultSet.getString("sort")+"'," +
//                            "'sysmenuid':'"+resultSet.getString("sysmenu_id")+"',";
//                    if(resultSet.getString("parentId")!=null){
//                        if(!resultSet.getString("parentId").toString().equals("")){
//                            json += "'parentId':'"+resultSet.getString("parentId").toString()+"',";
//                        }
//                    }
//                    json += "'parentmenuid':'"+resultSet.getString("parent_menuid").toString()+"'},";
//                }
//            }else{
//                json = "{}";
//            }
//            json = json.substring(0,json.length()-1);
//            result = "{'total':"+count+",'rows':["+json+"]}";
//            resultSet.close();
//            preparedStatement.close();
//            connection.close();
//        } catch (ClassNotFoundException e) {
//            e.printStackTrace();
//        } catch (IllegalAccessException e) {
//            e.printStackTrace();
//        } catch (InstantiationException e) {
//            e.printStackTrace();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        JSONObject jsonObject = JSONObject.fromObject(result);
//        return jsonObject;
    }

    /**
     * 使用事务处理
     * @return
     */
    @RequestMapping(value = "/Database_Transaction",method= RequestMethod.POST)
    @ResponseBody
    public JSONObject Database_Transaction(HttpServletRequest request, HttpSession session){

        String result = "{}";
        try{
            //初始化,参数为数据库表名
            DTable bllF=new DTable("sysuser");
            //.where()是设置where条件,第一个参数是sql,需要替换的参数用?代替,第二个是ArrayList<String>使用sql参数的方式
            // .find()是查询出第一条数据
            // 此处仅为示例,跟事务没有关系
            Map<String, String> tblUser=bllF.where("1=1 and username like ?",new ArrayList<String>(){{add("%adm%");}}).find();
            String user_name=tblUser.get("username");

            //多条sql语句和它们的参数,
            HashMap<String,ArrayList<String>> sqlAndParameters=new HashMap<String,ArrayList<String>>();
            //要修改的字段及值
            Map<String,String> tbl_upd=new HashMap<String, String>();
            tbl_upd.put("username","222");
            //获取update的sql语句,sql参数用?代替
            String sql1=bllF.getUpdateSql(tbl_upd,"sysuser_id=?");
            //sql参数(?所代替的值)
            ArrayList<String> parameters=new ArrayList<String>();
            parameters.add("123");
            //将sql语句和sql参数放入HashMap中
            sqlAndParameters.put(sql1,parameters);

            //要新增的字段及值
            Map<String, String> insertData = new HashMap<String, String>();
            String sysmenuid = UUID.randomUUID().toString();
            String sysmenuname= "Test";
            String sysmenuurl= "Test.form";
            String parentmenuid= "51bc2525-48cb-11e6-981a-00ac33669788";
            String sort= "20";
            String loginName = session.getAttribute("loginName")==null?"":session.getAttribute("loginName").toString();
            String remark= "Remark";
            insertData.put("sysmenu_id", sysmenuid);
            insertData.put("sysmenu_name", sysmenuname);
            insertData.put("sysmenu_url", sysmenuurl);
            insertData.put("parent_menuid", parentmenuid);
            insertData.put("is_sysmanage_menu", "否");
            insertData.put("sort", sort);
            insertData.put("create_date", D.CURRENT_DATETIME());
            insertData.put("create_man", loginName);
            insertData.put("remark", remark);
            //初始化,参数为数据库表名
            DTable bllMenu=new DTable("sysmenu");
            //得到insert的sql语句
            String sql2=bllMenu.getInsertSql(insertData);
            //得到sql参数集合
            ArrayList<String> parameters2= DFunction.getArrayList(insertData);
            //将sql语句和sql参数放入HashMap中
            sqlAndParameters.put(sql2,parameters2);

            //该语句用来判断某些条件下让事务出错回滚
            String sql_wrong = bllF.reset().where("sysuser_id='1f97b97e-a665-4d46-9ea6-59b1cbfa3873' and exists(select 1 from sysrole where ruler_level>4 )",null).getUpdateSqlWithSet("create_date=null");
            //将sql语句和sql参数放入HashMap中
            sqlAndParameters.put(sql_wrong,null);

            //使用事务的方式执行多条sql语句
            boolean final_result=bllF.executeMulSQL(sqlAndParameters);
            if(final_result){
                result= "{'result':1,'msg':'执行完成'}";
            }else{
                result= "{'result':0,'msg':'执行失败'}";
            }
        }
        catch (Exception ex){
        }
        JSONObject jsonObject = JSONObject.fromObject(result);
        return jsonObject;
    }


    /**
     * 保存菜单的新增
     * @param request
     * @return
     */
    @RequestMapping(value = "/addMenu",method = RequestMethod.POST)
    @ResponseBody
    public JSONObject addMenu(HttpServletRequest request, HttpSession session){
        String resultStr="";
        String sysmenuid = UUID.randomUUID().toString();
        String sysmenuname= request.getParameter("sysmenuname");
        String sysmenuurl= request.getParameter("sysmenuurl");
        String parentmenuid= request.getParameter("parentmenuid");
        String sort= request.getParameter("sort");
        String loginName = session.getAttribute("loginName")==null?"":session.getAttribute("loginName").toString();
        String remark= request.getParameter("remark");

        try {
            Map<String, String> insertData = new HashMap<String, String>();
            insertData.put("sysmenu_id", sysmenuid);
            insertData.put("sysmenu_name", sysmenuname);
            insertData.put("sysmenu_url", sysmenuurl);
            insertData.put("parent_menuid", parentmenuid);
            insertData.put("is_sysmanage_menu", "否");
            insertData.put("sort", sort);
            insertData.put("create_date", D.CURRENT_DATETIME());
            insertData.put("create_man", loginName);
            insertData.put("remark", remark);
            DTable bllMenu=new DTable("sysmenu");
            //调用insert方法往数据库增加数据
            int res=bllMenu.insert(insertData);
            resultStr= "{'result':"+res+",'msg':'执行成功'}";
        } catch (Exception ex) {
            DLog.w(ex.getMessage());
            resultStr= "{'result':0,'msg':'执行错误:"+ex.getMessage()+"'}";
        }
        JSONObject jsonObject = JSONObject.fromObject(resultStr);
        return jsonObject;
    }

    /**
     * 保存菜单的更改
     * @param request
     * @return
     */
    @RequestMapping(value = "/editMenu",method = RequestMethod.POST)
    @ResponseBody
    public JSONObject editMenu(HttpServletRequest request, HttpSession session){
        String resultStr = "";
        String sysmenuid = request.getParameter("sysmenuid");
        if(sysmenuid.isEmpty()){
            return JSONObject.fromObject("{'result':0,'msg':'执行错误'}");
        }
        String sysmenuname= request.getParameter("sysmenuname");
        String sysmenuurl= request.getParameter("sysmenuurl");
        String parentmenuid= request.getParameter("parentmenuid");
        String sort= request.getParameter("sort");
        String loginName= session.getAttribute("loginName")==null?"":session.getAttribute("loginName").toString();
        String remark= request.getParameter("remark");

        try {
            Map<String, String> updateData = new HashMap<String, String>();
            updateData.put("sysmenu_name", sysmenuname);
            updateData.put("sysmenu_url", sysmenuurl);
            updateData.put("parent_menuid", parentmenuid);
            updateData.put("sort", sort);
            updateData.put("update_date", D.CURRENT_DATETIME());
            updateData.put("update_man", loginName);
            updateData.put("remark", remark);
            DTable bllMenu=new DTable("sysmenu");
            //调用update方法往数据库修改数据
            int res=bllMenu.update(updateData,"sysmenu_id=? and sysmenu_id!='2c659331-0d1a-11e6-b867-0025b6dd0800'",new ArrayList<String>(){{add(sysmenuid);}});
            resultStr= "{'result':"+res+",'msg':'执行成功'}";
        } catch (Exception ex) {
            DLog.w(ex.getMessage());
            resultStr= "{'result':0,'msg':'执行错误:"+ex.getMessage()+"'}";
        }
        JSONObject jsonObject = JSONObject.fromObject(resultStr);
        return jsonObject;
    }

    /**
     * 批量删除菜单
     * @param request
     * @param menuIdList
     * @return
     */
    @RequestMapping(value = "/deleteMenu",method = RequestMethod.POST)
    @ResponseBody
    public String deleteMenu(HttpServletRequest request, @RequestParam(value = "menuIdList[]") String[] menuIdList){
        String result = "-1";
        DTable bllMenu=new DTable("sysmenu");
        HashMap<String,ArrayList<String>> sqlAndParameters=new HashMap<String,ArrayList<String>>();
        for (String sysmenuId:menuIdList) {
            String sql = bllMenu.getDeleteSql("sysmenu_id=? and is_sysmanage_menu='否'");
            ArrayList<String> parameters=new ArrayList<String>();
            parameters.add(sysmenuId);
            sqlAndParameters.put(sql,parameters);
        }
        //使用执行多条sql语句的方式执行删除操作
        boolean res=bllMenu.executeMulSQL(sqlAndParameters);
        if(res){
            result="1";
        }
//        JdbcFactory factory = SpringUtils.getBean(JdbcFactory.class);
//        try {
//            Connection connection = factory.createConnection();
//            String sql = "DELETE FROM sysmenu WHERE sysmenu_id=? and is_sysmanage_menu='否'";
//            PreparedStatement preparedStatement = connection.prepareStatement(sql);
//            for (String sysmenuId:menuIdList) {
//                preparedStatement.setString(1,sysmenuId);
//                preparedStatement.addBatch();
//            }
//            preparedStatement.executeBatch();
//            result = "1";
//        } catch (IllegalAccessException e) {
//            e.printStackTrace();
//        } catch (InstantiationException e) {
//            e.printStackTrace();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        } catch (ClassNotFoundException e) {
//            e.printStackTrace();
//        }
        return result;
    }
}
