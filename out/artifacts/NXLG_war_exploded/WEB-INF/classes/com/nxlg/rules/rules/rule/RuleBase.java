package com.nxlg.rules.rule;

import com.nxlg.model.TCcRSw;
import com.nxlg.rules.ITCcRSwIndex;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by NEU on 2017/5/31.
 * 规则基础类
 */
public abstract class RuleBase implements IRule {

    protected double punishValue;
    protected ITCcRSwIndex tCcRSwIndex;

    private List<TCcRSw> data = new ArrayList<>();

    public void setData(List<TCcRSw> data){
        this.data = data;
    }

    @Override
    public double getPunishValue() {
        return punishValue;
    }

    @Override
    public void setPunishValue(double value) {
        punishValue = value;
    }

    @Override
    public void settCcRSwIndex(ITCcRSwIndex tCcRSwIndex) {
        this.tCcRSwIndex = tCcRSwIndex;
    }

    @Override
    public ITCcRSwIndex getTCcRSwIndex() {
        return this.tCcRSwIndex;
    }
}
