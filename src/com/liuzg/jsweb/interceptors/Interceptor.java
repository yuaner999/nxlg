package com.liuzg.jsweb.interceptors;

import com.common.DLog;
import com.common.DTable;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

/**
 * Created by liulei on 2017/1/9.
 */
public class Interceptor implements HandlerInterceptor {

    private List forbiddenloginparameters;
    private JdbcGetMenuPermission searchMenu;
    private IsAllow isAllow;
    private String checkJs;

    /**
 * 共有两个判断，第一个是判断用户未登录时；第二个是判断用户已登录时。
 * @author Lisy
 * @param request
 * @param response
 * @param o
 * @return ture或者false 用来判断该用户是否有权限访问。
 * */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
        DTable dt=new DTable("user");
        HttpServletRequest httpServletRequest = (HttpServletRequest)request;
        HttpServletResponse httpServletResponse = (HttpServletResponse)response;
        httpServletResponse.setHeader("Access-Control-Allow-Origin", "*");
        httpServletResponse.setHeader("Access-Control-Allow-Methods", "POST, GET");
        httpServletResponse.setHeader("Access-Control-Max-Age", "0");
        httpServletResponse.setHeader("Access-Control-Allow-Headers", "Origin, No-Cache, X-Requested-With, If-Modified-Since, Pragma, Last-Modified, Cache-Control, Expires, Content-Type, X-E4M-With,userId,token");
        httpServletResponse.setHeader("Access-Control-Allow-Credentials", "true");
        httpServletResponse.setHeader("XDomainRequestAllowed","1");
        String uri = request.getRequestURI();//请求路径
//        if(request.getHeader("Origin")!=null&&!request.getHeader("Origin").startsWith("http://localhost")&&false){//如果是跨域
//            switch (uri){
//                case "/loginStudent.form":
//                case "/SaveClientId/SaveClientIdInfo.form":
//                case "/AutoUpdate/getVersion.form":
//                case "/Token/getTime.form":
//                case "/Token/getTokenId.form":
//                    break;
//                default:
//                    String now = Long.toString(System.currentTimeMillis());//系统当前时间，毫秒数
//                    //从数据库里读出TokenId
//                    try
//                    {
//                        DTable bllF=new DTable("token");
//                        String tokenid=request.getParameter("tokenId");
//                        if(tokenid==null||tokenid.equals("")){
//                            return false;
//                        }
//                        Map<String, String> tblUser=bllF.where("1=1 and tokenId=@tokenId and tokenExpireTime > ?",new ArrayList<String>(){{add(tokenid);add(now);}}).find();
//                        if(tblUser!=null) {
//                        }else{
//                            return false;
//                        }
//                    }
//                    catch(Exception ex)
//                    {
//                        return false;
//                    }
//                    break;
//            }
//        }

        String[] urls = uri.split("/");
        String userId = (String) request.getSession().getAttribute("sessionUserID");
        Boolean flag = true;
        DLog.w(uri);
        if(uri.contains("views")){
            if ((userId == null || userId == "" )){
                flag = isAllow.unLogin(request, response, o, uri);
            }else{
                flag = isAllow.checkRole(request, response, o, uri, userId);
            }
        }else {
//            flag = true;
            flag = isAllow.checkJs(request, response, o, uri,userId);
        }
        return flag;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }

    public void setForbiddenloginparameters(List forbiddenloginparameters) {
        this.forbiddenloginparameters = forbiddenloginparameters;
    }


    public void setSearchMenu(JdbcGetMenuPermission searchMenu) {
        this.searchMenu = searchMenu;
    }

    public void setIsAllow(IsAllow isAllow) {
        this.isAllow = isAllow;
    }

    public IsAllow getIsAllow() {
        return isAllow;
    }

    public void setCheckJs(String checkJs) {
        this.checkJs = checkJs;
    }
}
