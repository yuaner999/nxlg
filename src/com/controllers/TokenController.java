/*
*Created by liulei on 2016/4/25.
*/
package com.controllers;

import com.common.D;
import com.common.DLog;
import com.common.DTable;
import com.utils.PwdUtil;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * Created by liulei on 2016/4/25.
 */
@Controller
@RequestMapping(value = "/Token")
public class TokenController {
    @RequestMapping(value = "/getTime", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject GetTime(HttpServletRequest request) {
        String resultStr="";
        try {
            resultStr= "{'status':1,'time':" + System.currentTimeMillis() + "}";
        } catch (Exception ex) {
            DLog.w(ex.getMessage());
            resultStr= "{'status':0,'time':0}";
        }
        JSONObject jsonObject = JSONObject.fromObject(resultStr);
        return jsonObject;
    }

    @RequestMapping(value = "/getTokenId", method = RequestMethod.POST)
    @ResponseBody
    public JSONObject GetTokenId(HttpServletRequest request) {
        String resultStr="";
        long sendTime=Long.parseLong(request.getParameter("sendTime"));
        String username=request.getParameter("username");
        String hash=request.getParameter("hash");
        long now = System.currentTimeMillis();//系统当前时间，毫秒数
        if (Math.abs(sendTime - now) > 300000)//请求时间超时，超过5分钟
        {
            resultStr= "{'status':0,'result':'请求超时'}";
            JSONObject jsonObject = JSONObject.fromObject(resultStr);
            return jsonObject;
        }

        try
        {
            DTable bllF=new DTable("user");
            Map<String, String> tblUser=bllF.setField("DECODE(`password`,'371df050-00b3-11e7-829b-00ac2794c53f') userpassword").where("1=1 and userName = ?",new ArrayList<String>(){{add(username);}}).find();
            if(tblUser!=null) {
                String password = (tblUser.get("userpassword")).toLowerCase();
                String hashStr = username + password + sendTime;

                if (hash.equals(PwdUtil.getPassMD5(hashStr).toLowerCase()))//如果hash值正确
                {
                    String tokenId = UUID.randomUUID().toString();
                    long tokenExpireTime = sendTime + 7200000;//Token过期时间，2个小时

                    DTable bllToken=new DTable("token");
                    Map<String, String> insertData = new HashMap<String, String>();
                    insertData.put("tokenId", tokenId);
                    insertData.put("tokenUserId", username);
                    insertData.put("tokenCreateTime", Long.toString(sendTime));
                    insertData.put("tokenExpireTime", Long.toString(tokenExpireTime));
                    insertData.put("createTime", D.CURRENT_DATETIME());
                    //调用insert方法往数据库增加数据
                    int res = bllToken.insert(insertData);

                        if (res == 1)//插入成功
                        {
                            resultStr= "{'status':1,'result':'"+tokenId+"'}";
                        }
                        else//插入失败
                        {
                            resultStr= "{'status':0,'result':'写入失败'}";

                        }
                }
                else//如果不正确
                {
                    resultStr= "{'status':0,'result':'hash值错误'}";
                }
            }
            else//用户不存在
            {
                resultStr= "{'status':0,'result':'用户不存在'}";
            }
        }
        catch (Exception e)
        {
            resultStr= "{'status':0,'result':'系统异常'}";
        }
        JSONObject jsonObject = JSONObject.fromObject(resultStr);
        return jsonObject;
    }
}
