package com.nxlg.rules.rule;

import com.nxlg.model.TCcRSw;

import java.util.List;

/**
 * Created by NEU on 2017/6/3.
 * 天规则
 */
public abstract class TCcRSRule extends RuleBase {

    protected List<TCcRSw> data;

    public List<TCcRSw> getData() {
        return data;
    }

    @Override
    public void setData(List<TCcRSw> data) {
        this.data = data;
    }

    @Override
    public boolean isOk() {
        return false;
    }
}
