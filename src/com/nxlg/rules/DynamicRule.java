package com.nxlg.rules;

import com.nxlg.model.DbTCcRSw;
import com.nxlg.model.TCcRSw;
import com.nxlg.rules.rule.RuleBase;

import java.util.List;

/**
 * Created by NEU on 2017/6/6.
 * 动态规则：下一周动态的规则
 */
public class DynamicRule extends RuleBase {

    protected List<DbTCcRSw> lastweekdata;   //上一周课程
    protected List<TCcRSw> curweekdata;     //当前课程
    protected int curweek;
    protected int weekdaysCnt;
    protected int daysectionsCnt;

    @Override
    public void setData(List<TCcRSw> data) {
        this.curweekdata = data;
    }

    public void setLastweekdata(List<DbTCcRSw> lastweekdata) {
        this.lastweekdata = lastweekdata;
    }

    public void setCurweek(int curweek) {
        this.curweek = curweek;
    }

    public void setWeekdaysCnt(int weekdaysCnt) {
        this.weekdaysCnt = weekdaysCnt;
    }

    public void setDaysectionsCnt(int daysectionsCnt) {
        this.daysectionsCnt = daysectionsCnt;
    }

    @Override
    public double calculatePunishValue() {
        int cnt = 0;
        //当前为第一周课程，此规则无惩罚
        if (lastweekdata.size() == 0) return 0;

        int index = 0;
        for (TCcRSw curtCcRSw : curweekdata) {
            if (curtCcRSw.getTecoId() != 0) {      //如果本节安排课程
                index = (curtCcRSw.getRoomId() - 1) * (weekdaysCnt * daysectionsCnt) + (curtCcRSw.getWeekDay() - 1) * daysectionsCnt + (curtCcRSw.getSectionId() - 1);
                //获取上一周相应节次的课程
                DbTCcRSw lastTCcRSw = lastweekdata.get(index);
                if (lastTCcRSw.getDbTeCoId() == "" || lastTCcRSw.getDbTeCoId() == null) {  //上周本节课未安排课程
                    continue;
                } else {
                    int isSingleDoubleWeek = lastTCcRSw.getIsSingleDoubleWeek();
                    if (isSingleDoubleWeek == 0) cnt += 1;      //判断是否是非单双周
                }
            }
        }

        return punishValue * cnt;
    }

    @Override
    public boolean isOk() {
        return false;
    }
}
