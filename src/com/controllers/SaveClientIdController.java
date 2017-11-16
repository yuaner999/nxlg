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
@RequestMapping(value = "/SaveClientId")
public class SaveClientIdController {
    @RequestMapping(value = "/SaveClientIdInfo", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject SaveClientIdInfo(HttpServletRequest request) {
        String loginName= request.getParameter("loginName");
        String clientid= request.getParameter("clientid");
        String resultStr="";
        try {
            Map<String, String> updateData = new HashMap<String, String>();
            updateData.put("user_clientid", clientid);
            DTable bllMenu=new DTable("user");
            //调用update方法往数据库修改数据
            int res=bllMenu.update(updateData,"userName=?",new ArrayList<String>(){{add(loginName);}});
            resultStr= "{'status':"+res+",'result':'执行成功'}";
        } catch (Exception ex) {
            DLog.w(ex.getMessage());
            resultStr= "{'status':0,'result':'执行错误:"+ex.getMessage()+"'}";
        }
        JSONObject jsonObject = JSONObject.fromObject(resultStr);
        return jsonObject;
    }

    @RequestMapping(value = "/checkLogin", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject checkLogin(HttpServletRequest request) {
        String loginName= request.getParameter("loginName");
        String resultStr="";
        try {
            DTable bllF=new DTable("user");
            Map<String, String> tblUser=bllF.where("1=1 and userName = ?",new ArrayList<String>(){{add(loginName);}}).find();
            if(tblUser!=null){
                String user_clientid=tblUser.get("user_clientid");
                if(user_clientid.equals(""))
                {
                    resultStr="{'status':0,'result':0}";
                }else {
                    JSONObject json = JSONObject.fromObject(tblUser);
                    resultStr= "{'status':1,'result':"+json.toString()+"}";
                }
            }else{
                resultStr="{'status':0,'result':0}";
            }
        } catch (Exception ex) {
            DLog.w(ex.getMessage());
            resultStr= "{'status':0,'result':'执行错误:"+ex.getMessage()+"'}";
        }
        JSONObject jsonObject = JSONObject.fromObject(resultStr);
        return jsonObject;
    }
}
