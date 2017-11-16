package com.common;

import org.dom4j.io.SAXReader;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.*;

/**
 * Created by szy on 15/11/16.
 */
public class DConfig {
    static private Map<String, Object> instance = new Hashtable<String, Object>();
    static private Map<String, Object> config = new Hashtable<String, Object>();
    static private List<String> loadedConfigKey = new Vector<String>();

    public static DConfig getInstance(String ins) {

        if (instance.containsKey(ins)) {
            return (DConfig) instance.get(ins);
        }

        DConfig DConfig = new DConfig();
        instance.put(ins, DConfig);
        return DConfig;
    }

    public static DConfig getInstance() {

        String ins = "main";

        if (instance.containsKey(ins)) {
            return (DConfig) instance.get(ins);
        }

        DConfig DConfig = new DConfig();
        instance.put(ins, DConfig);
        return DConfig;
    }

    public static String get(String key) {
        return (String) DConfig.getInstance()._get(key);
    }

    public void _set(String key, Object value) {
        if (config.containsKey("key")) {
            config.replace(key, value);
        } else {
            config.put(key, value);
        }
    }

    public Object _get(String key) {
        Object value = null;

        value = config.get(key);

        if (value != null) return value;

        String[] key_arr = {};

        if (key.contains(".")) {
            key_arr = key.split("\\.");
        }

        if (key_arr.length < 1) {
            return null;
        } else {
            Properties configPro = new Properties();
            InputStream in;
            try {
                String root_dir=D.WEB_ROOT_DIR;
                if(D.WEB_ROOT_DIR.isEmpty()){
                    root_dir =getClass().getProtectionDomain().getCodeSource().getLocation().getPath();
                    SAXReader saxReader = new SAXReader();
                    if(root_dir.indexOf("WEB-INF")>0){
                        root_dir = root_dir.substring(0,root_dir.indexOf("WEB-INF/classes"));
                    }
                    D.WEB_ROOT_DIR=root_dir;
                    D.WEB_ROOT_DIR=D.WEB_ROOT_DIR.replaceAll("%20"," ");
                }

                in = new FileInputStream(new File( root_dir + "WEB-INF/config/" + key_arr[0] + ".properties"));
                configPro.load(in);
            } catch (Exception e) {
                if (D.WEB_ROOT_DIR.isEmpty()) {
                    System.err.println("----------------------------------------------------\n" +
                            "D.WEB_ROOT_DIR 不能为空, 程序退出\n" +
                            "---------------------------------------------------\n" +
                            "读取配置(" + key + ")失败:" + e +"\n" +
                            "----------------------------------------------------\n");
                    DLog.w("读取配置(" + key + ")失败:" + e +"\n");
//                    System.exit(-1);
                }
                return null;
            }

            value = configPro.getProperty(key_arr[1]);
            _set(key, value);
            return value;
        }
    }
}
