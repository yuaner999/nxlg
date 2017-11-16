package com.nxlg.rules.rule;

import com.nxlg.model.TCcRSw;

import java.util.List;

/**
 * Created by NEU on 2017/5/31.
 * 全局规则
 */
public abstract class TCcRSWRule extends RuleBase {

    protected List<TCcRSw> data;

    @Override
    public void setData(List<TCcRSw> data) {
        this.data = data;
    }


    @Override
    public boolean isOk() {
        return false;
    }

}
