package com.nxlg.rules.ruleLoader;

import com.nxlg.utils.ReflectionUtils;
import org.json.JSONObject;

/**
 * Created by NEU on 2017/6/2.
 *
 */
public class JsonRuleLoader implements IRuleLoader {
/*    @Override
    public void loadConfig(IRule rule) {

    }*/

    //生成规则对象
    @Override
    public Object createObject(String sourceContext) {
        JSONObject jsonObject = new JSONObject(sourceContext);
        String clsname = jsonObject.getString("ClassName");
        Object obj = ReflectionUtils.newInstance(clsname);
        for(Object keyobj : jsonObject.keySet()){
            String key = (String) keyobj;
            Object value = jsonObject.get(key);
            ReflectionUtils.setPropertyValue(obj,key,value);
        }
        return obj;
    }
}
