package com.liuzg.jsweb.interceptors;

import com.zaxxer.hikari.HikariDataSource;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Created by NEUNB_Lisy on 2017/7/10.
 */
public class IsAllow {

    private List forbiddenloginparameters;
    private HikariDataSource isAllow;
    private JdbcGetMenuPermission searchMenu;

    String jspNow = "0";
    List<Map<String, Object>> menulist = null;
    List<Map<String, Object>> list = null;
    List<Map<String, Object>> menuJsapislist = null;

    public boolean unLogin(HttpServletRequest request, HttpServletResponse response, Object o, String uri) throws IOException {
        if(!uri.equals(request.getContextPath()+"/login.form") && !uri.equals(request.getContextPath()+"/views/login.form")
                && !uri.equals(request.getContextPath()+"/forgetpassword.form") && !uri.equals(request.getContextPath()+"/views/forgetpassword.form")
                && !uri.equals(request.getContextPath()+"/loginStudent.form") && !uri.equals(request.getContextPath()+"/SaveClientId/SaveClientIdInfo.form")
                && !uri.equals(request.getContextPath()+"/AutoUpdate/getVersion.form") && !uri.equals(request.getContextPath()+"/Token/getTime.form")
                && !uri.equals(request.getContextPath()+"/Token/getTokenId.form") ){
            response.sendRedirect(request.getContextPath()+"/views/login.form");
            response.getWriter().close();
            return false;
        }
        return true;
    }

    public boolean checkRole(HttpServletRequest request, HttpServletResponse response, Object o, String uri, String userId) throws IOException {

        Boolean flag=false;

        String[] urls = uri.split("/");
        menulist = searchMenu.searchAllMenu();
        list = searchMenu.searchMenuPermission(userId);

        for (Map<String, Object> menuMap:menulist){
            String[] menuMapUrls = menuMap.get("menuUrl").toString().split("/");
            if (urls[urls.length-1].equals(menuMapUrls[menuMapUrls.length-1])){
                for (Map<String , Object> map:list){
                    String[] menuurls=map.get("menuUrl").toString().split("/");
                    String menuMapid = map.get("menuId").toString();
                    jspNow = menuMapid;
                    if (urls[urls.length-1].equals(menuurls[menuurls.length-1])){
                        flag=true;
                        break;
                    }
                }
                if(flag){
                    return true;
                }else {
                    response.getWriter().write("您没有该页面的权限！");
                    request.setAttribute("menuErr","您没有该页面的权限!");
                    response.sendRedirect(request.getContextPath()+"/views/index.form");
                    response.getWriter().close();
                    return false;
                }
            }
        }

        return true;
    }

    public boolean checkJs(HttpServletRequest request, HttpServletResponse response, Object o, String uri,String userId) throws IOException {

        String[] urls = uri.split("/");
        if(urls.length>1) {
            String form=urls[urls.length - 1];
            String[] formname=form.split("\\.");
            if(formname.length>0) {
                menuJsapislist = searchMenu.searchMenuJsapis(formname[0]);

                if(menuJsapislist.size()>0){
                    List<Map<String, Object>> menuJsapi= searchMenu.searchMenuJsapisPermission(formname[0], userId);
                    if(menuJsapi.size()>0){
                        return true;
                    }else
                    {
                        return false;
                    }
                }else {
                    return true;
                }
            }
            else{
                return true;
            }
        }
        else{
            return true;
        }
    }

    public void setIsAllow(HikariDataSource isAllow) {
        this.isAllow = isAllow;
    }

    public HikariDataSource getIsAllow() {
        return isAllow;
    }

    public void searchMenu(HikariDataSource isAllow) {
        this.searchMenu = searchMenu;
    }

    public JdbcGetMenuPermission searchMenu() {
        return searchMenu;
    }

    public void setSearchMenu(JdbcGetMenuPermission searchMenu) {
        this.searchMenu = searchMenu;
    }

    public JdbcGetMenuPermission getSearchMenu() {
        return searchMenu;
    }
}
