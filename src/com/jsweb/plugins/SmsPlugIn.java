package com.jsweb.plugins;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;

/**
 * Created by NEU on 2017/4/13.
 */
public class SmsPlugIn {
    String serviceUrl="http://utf8.sms.webchinese.cn";
    String uid;
    String key;
    public String sendSms(String targetusers,String smsContent){
        try{
            HttpClient client = new HttpClient();
            PostMethod post = new PostMethod(serviceUrl);
            post.addRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=UTF-8");//在头文件中设置转码
            NameValuePair[] data ={ new NameValuePair("Uid", uid),new NameValuePair("Key", key),new NameValuePair("smsMob",targetusers),new NameValuePair("smsText",smsContent)};
            post.setRequestBody(data);

            client.executeMethod(post);
            Header[] headers = post.getResponseHeaders();
            int statusCode = post.getStatusCode();
            if(statusCode==200){
                String result = new String(post.getResponseBodyAsString().getBytes("UTF-8"));
                post.releaseConnection();
                return result; //打印返回消息状态
            }else{
                return "error";
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return "";
    }

    public void setServiceUrl(String serviceUrl) {
        this.serviceUrl = serviceUrl;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public void setKey(String key) {
        this.key = key;
    }
}
