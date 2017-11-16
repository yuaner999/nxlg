package com.nxlg.utils;

import java.lang.reflect.Method;
import java.util.Objects;

/**
 * Created by NEU on 2017/6/1.
 */
public class ReflectionUtils {

    public static Object newInstance(String classname){
        try{
            Class<?> cls = Class.forName(classname);
            Object obj = cls.newInstance();
            return obj;
        }catch (Exception e){}
        return null;
    }

    public static boolean setPropertyValue(Object obj,String propertyName,Object value){
        Class<? extends Object> cls = obj.getClass();
        try{
            Method setpropertymethod = getMethodByName(cls,"set"+propertyName,true);
            if(setpropertymethod==null) return false;
            setpropertymethod.invoke(obj, value);
            return true;
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    private static Method getMethodByName(Class<?> cls,String methodname,boolean ignorecase){
        for(Method method:cls.getMethods()){
            String t1 = ignorecase? method.getName().toLowerCase():method.getName();
            String t2 = ignorecase? methodname.toLowerCase():methodname;
            if(Objects.equals(t1,t2)){
                return method;
            }
        }
        return null;
    }

}
