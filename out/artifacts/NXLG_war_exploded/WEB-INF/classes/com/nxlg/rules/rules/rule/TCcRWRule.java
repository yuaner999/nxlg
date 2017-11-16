package com.nxlg.rules.rule;

import com.nxlg.model.TCcRSw;

/**
 * Created by NEU on 2017/6/4.
 * 节课程规则基础类
 */
public abstract class TCcRWRule extends RuleBase {

    protected TCcRSw tCcRSw;
    public void setData(TCcRSw tCcRSw) {
        this.tCcRSw = tCcRSw;
    }

    @Override
    public boolean isOk() {
        return false;
    }

}
