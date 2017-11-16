package com.jsweb.plugins;

import com.common.DLog;

import java.io.IOException;
import java.util.Map;

/**
 * Created by Administrator on 2017/1/9.
 */
public class SystemLogPlugIn {
    public String writeSql(Map<String,String> params, String sql) throws IOException {
        try {
            sql=sql.replaceAll("\\$", "");
            sql=sql.replaceAll("\r\n", " ");
            sql=sql.replaceAll("\\r\\n", " ");
            sql=sql.replaceAll("\\\\r\\\\n", " ");
            for (Map.Entry<String, String> entity : params.entrySet()) {
                String key = entity.getKey();
                if(sql.contains("{" + key + "}")) {
                    Object value = entity.getValue();
                    String replace = "";
                    if (value == null) {
                        replace = "null";
                    } else {
                        replace = "'" + value.toString() + "'";
                    }
                    String a1="\\{" + key + "\\}";
                    sql=sql.replaceAll(a1, replace);
                }
            }
            DLog.w(sql);
            return "写记录结束";
        }
        catch (Exception ex){
            return "写记录错误:"+ex.getMessage();
        }
    }
}
