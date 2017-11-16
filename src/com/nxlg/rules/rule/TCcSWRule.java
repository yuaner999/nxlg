package com.nxlg.rules.rule;

import com.nxlg.model.TCcRSw;

import java.util.List;

/**
 * Created by NEU on 2017/5/31.
 * 教室规则基础类
 */
public abstract class TCcSWRule extends RuleBase {

    protected List<TCcRSw> data;

    public void setData(List<TCcRSw> data){
        this.data = data;
    }

}
