package com.utils;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by admin on 2016/8/1.
 */
public class Utils {

    /**
     * 把map 转换成对象 (调用set方法，方便加密)
     * @param map 需要转换的map
     * @param c 要转换成对象的class
     * @return
     */
    public static Object mapToObj(Map map, Class c) throws Exception {
        Object o=null;
        o=c.newInstance();
        Method[] methods=c.getMethods();
        for(Method m:methods){
            m.setAccessible(true);
            String methodName=m.getName();
            if(!methodName.contains("set")) continue;   //如果不是set方法则跳过
            Class paraType=m.getParameterTypes()[0];
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
            String value=(String)map.get(methodName.substring(3,4).toLowerCase()+methodName.substring(4));      //把方法名中的set字符去掉，然后第一个字母转小写，就是bean属性，以此为key从map 中取值
            if(value==null || value.equals(""))continue;    //根据bean属性在map中获取不到值则跳过
            if( paraType== java.sql.Date.class){       //如果该set方法的参数类型是date 或者 timestamp
                m.invoke(o,new java.sql.Date(sdf.parse(value).getTime()));
            }else if(paraType==Date.class ){
                m.invoke(o,new Date(sdf.parse(value).getTime()));
            }else if( paraType== Timestamp.class){
                m.invoke(o,new Timestamp(sdf.parse(value).getTime()));
            }else if(paraType== int.class){                   //如果该set方法的参数类型是int
                m.invoke(o,Integer.parseInt(value));
            }else if(paraType== BigDecimal.class){
                m.invoke(o,new BigDecimal(value));
            }else if(paraType==String.class) {                //如果该set方法的参数类型是 string
                m.invoke(o,value);
            }
        }
        return o;
    }

    /**
     * 对象转换成map
     * @param obj
     * @return
     */
    public static Map<String ,Object> ObjToMap(Object obj){
        Map<String ,Object> map=new HashMap<>();
        Field[] fields=obj.getClass().getDeclaredFields();
        for(Field f:fields){
            f.setAccessible(true);
            String name=f.getName();
            try {
                map.put(name,f.get(obj));
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        return map;
    }
}
