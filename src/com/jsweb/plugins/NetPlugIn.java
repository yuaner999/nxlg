package com.jsweb.plugins;


import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.RequestEntity;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.apache.commons.httpclient.methods.multipart.FilePart;
import org.apache.commons.httpclient.methods.multipart.MultipartRequestEntity;
import org.apache.commons.httpclient.methods.multipart.Part;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;

import java.io.File;
import java.io.InputStream;
import java.util.*;

/**
 * Created by liuzg on 2017/2/21.
 */
public class NetPlugIn {

    public Object postForm(String url, Map<String,Object> formData){
        Date before = new Date();
        HttpClient httpClient = new DefaultHttpClient();
        HttpPost method = new HttpPost(url);
        byte[] content = null;
        int statusCode = -1;
        try{
            List<NameValuePair> params=new ArrayList<NameValuePair>();
            //建立一个NameValuePair数组，用于存储欲传送的参数
            for(Map.Entry<String,Object> entry :formData.entrySet()){
                String key = entry.getKey();
                Object value = entry.getValue();
                if(value==null) value="";
                params.add(new BasicNameValuePair(key,value.toString()));
            }
            method.setEntity(new UrlEncodedFormEntity(params, HTTP.UTF_8));


            //设置编码
            HttpResponse response=httpClient.execute(method);
            InputStream contentStream = response.getEntity().getContent();
            content = IOUtils.toByteArray(contentStream);
            statusCode = response.getStatusLine().getStatusCode();

        }catch (Exception e){
            e.printStackTrace();
        }

        Date end = new Date();
        long diff = end.getTime() - before.getTime();
        Map<String,Object> result = new HashMap<>();
        result.put("status",statusCode);//响应状态
        result.put("content",content);//响应内容 比特
        result.put("responseduration",diff);//响应时间
        return result;
    }

    public Object postString(String url,String data){


        Date before = new Date();
        org.apache.commons.httpclient.HttpClient httpClient = new org.apache.commons.httpclient.HttpClient();
        PostMethod method = new PostMethod(url);
        byte[] content = null;
        int statusCode = -1;
        try{
            RequestEntity entity = new StringRequestEntity(data, "text/xml",
                    "utf-8");
            method.setRequestEntity(entity);
            method.setRequestEntity(entity);
            httpClient.executeMethod(method);
            statusCode = method.getStatusCode();
            if (statusCode == HttpStatus.SC_OK)
                content = method.getResponseBody();
        }catch (Exception e){
            e.printStackTrace();
        }

        Date end = new Date();
        long diff = end.getTime() - before.getTime();
        Map<String,Object> result = new HashMap<>();
        result.put("status",statusCode);//响应状态
        result.put("content",content);//响应内容 比特
        result.put("responseduration",diff);//响应时间
        return result;
    }

    public Object postFile(String url ,String filepath,Map<String,Object> map){

        Date before = new Date();
        File file = new File(filepath);
        PostMethod filePost = new PostMethod(url);
        org.apache.commons.httpclient.HttpClient client = new org.apache.commons.httpclient.HttpClient();
        byte[] content = null;
        int statusCode = -1;
        try {
            // 通过以下方法可以模拟页面参数提交
            for(Map.Entry<String,Object> entry : map.entrySet()){
                filePost.setParameter(entry.getKey(),entry.getValue().toString());
            }
            Part[] parts = { new FilePart(file.getName(), file) };
            filePost.setRequestEntity(new MultipartRequestEntity(parts, filePost.getParams()));
            client.getHttpConnectionManager().getParams().setConnectionTimeout(5000);

            statusCode = client.executeMethod(filePost);

            if (statusCode == HttpStatus.SC_OK) {
                content = filePost.getResponseBody();
            }
        }catch(Exception e){
            e.printStackTrace();
        }

        Date end = new Date();
        Long differ = end.getTime() - before.getTime();

        Map<String,Object> result = new HashMap<>();
        result.put("status",statusCode);//响应状态
        result.put("content",content);//响应内容 比特
        result.put("responseduration",differ);//响应时间
        return result;
    }

    public Object getForm(String url,Map<String,Object> urlparams){

        Date before = new Date();
        HttpClient client = new DefaultHttpClient();
        HttpGet method = null;
        String params = "";
        int statusCode = -1;
        byte[] content = null;
        try{
            if(urlparams != null && urlparams.size() > 0){
                for(Map.Entry<String,Object> entry : urlparams.entrySet()){
                    String key = entry.getKey();
                    Object value = entry.getValue();
                    params += "&" + key + "=" + value;
                }
                params = params.substring(1,params.length());
                url = url + "?" + params;
            }
            method = new HttpGet(url);
            HttpResponse response = client.execute(method);
            InputStream contentStream = response.getEntity().getContent();
            content = IOUtils.toByteArray(contentStream);
            statusCode = response.getStatusLine().getStatusCode();
        }catch (Exception e){
            e.printStackTrace();
        }
        Date end = new Date();
        long diff = end.getTime() - before.getTime();
        Map<String,Object> result = new HashMap<>();
        result.put("status",statusCode);//响应状态
        result.put("content",content);//响应内容 比特
        result.put("responseduration",diff);//响应时间
        return result;
    }

    public String bytesToString(byte[] data){

        return  "";
    }



}
