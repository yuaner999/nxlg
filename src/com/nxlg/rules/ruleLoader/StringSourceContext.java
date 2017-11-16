package com.nxlg.rules.ruleLoader;

/**
 * Created by NEU on 2017/6/1.
 */
public abstract class StringSourceContext implements SourceContext {
    private String data;

    public void setStringData(String data){
        this.data = data;
    }

    public String getData() {
        return data;
    }
}
