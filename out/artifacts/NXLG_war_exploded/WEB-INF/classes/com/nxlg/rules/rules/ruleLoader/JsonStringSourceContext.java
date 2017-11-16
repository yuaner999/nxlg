package com.nxlg.rules.ruleLoader;


import org.apache.commons.io.IOUtils;

import java.io.IOException;
import java.io.InputStream;

/**
 * Created by NEU on 2017/6/1.
 */
public class JsonStringSourceContext extends StringSourceContext {
    //从json文件中读取字符串
    public void loadSourceFromResources(String resourcepath) throws IOException {
        InputStream stream = this.getClass().getResourceAsStream(resourcepath);
        String str = IOUtils.toString(stream, "UTF-8");
        this.setStringData(str);
    }

    //
    public void loadSource(String classpath) throws IOException {
        this.setStringData(classpath);
    }
}
