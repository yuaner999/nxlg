package com.common;

import net.sf.json.JSONObject;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by Dugufeixue on 2016/7/29.
 */
public class DFunction {
    /**
     * 通过Map获取ArrayList
     *
     * @param data data
     * @return String
     */
    public static ArrayList<String> getArrayList(Map<String, String> data) {
        ArrayList<String> parameters=new ArrayList<>();
        Iterator iter = data.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
            Object key = entry.getKey();
            Object val = entry.getValue();
            parameters.add(val.toString());
        }
        return parameters;
    }

    public static JSONObject GetWrongJson(String msg) {
        String result="{'result':0,'msg':'"+msg+"'}";
        JSONObject json = JSONObject.fromObject(result);
        return json;
    }

    public static JSONObject GetSuccessJson(String msg) {
        String result="{'result':1,'msg':'"+msg+"'}";
        JSONObject json = JSONObject.fromObject(result);
        return json;
    }

    public static JSONObject SendSMS(String messagecontent, String user_tel){
        try{
//            DLog.w("发送短信:"+user_tel+"---"+messagecontent);
//            return JSONObject.fromObject("{'result':1,'msg':'已发送短信'}");
            String info = null;
            HttpClient httpclient = new HttpClient();
            PostMethod post = new PostMethod("http://sms.api.ums86.com:8899/sms/Api/Send.do");//
            post.getParams().setParameter(HttpMethodParams.HTTP_CONTENT_CHARSET,"gbk");
            post.addParameter("SpCode", "225786");
            post.addParameter("LoginName", "ln_fdjyjy");
            post.addParameter("Password", "fdjyjy123456");
            post.addParameter("MessageContent", messagecontent);
            post.addParameter("UserNumber", user_tel);
            post.addParameter("SerialNumber", "");
            post.addParameter("ScheduleTime", "");
            post.addParameter("ExtendAccessNum", "");
            post.addParameter("f", "1");
            httpclient.executeMethod(post);
            info = new String(post.getResponseBody(),"gbk");
            DLog.w("发送短信:"+user_tel+"---"+messagecontent+"----"+info);
            if(info.contains("result=0")){
                return JSONObject.fromObject("{'result':1,'msg':'已发送短信'}");
            }else{
                return JSONObject.fromObject("{'result':0,'msg':'发送短信失败'}");
            }

        }catch (Exception e) {
            e.printStackTrace();
            return JSONObject.fromObject("{'result':0,'msg':'发送短信失败'}");
        }
    }


}
