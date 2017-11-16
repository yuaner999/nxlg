package com.nxlg.rules;

import com.nxlg.model.TCcRSw;
import com.nxlg.rules.rule.TCcSWRule;
import com.nxlg.utils.PrjUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/6/4.
 * 教室：错节
 */
public class SameSectionOneCourseOneWeek extends TCcSWRule {

    private int  daysectioncount;
    private int  weekdayscount;

    public int getDaysectioncount() {
        return daysectioncount;
    }

    public void setDaysectioncount(int daysectioncount) {
        this.daysectioncount = daysectioncount;
    }

    public int getWeekdayscount() {
        return weekdayscount;
    }

    public void setWeekdayscount(int weekdayscount) {
        this.weekdayscount = weekdayscount;
    }

    @Override
    public double calculatePunishValue() {
        int cnt = 0;
        List<List<TCcRSw>> sectionList = new ArrayList<>();
        //获取节次课程表
        for (int i = 0; i < daysectioncount; i++) {
            List<TCcRSw> sectiondays = new ArrayList<>();
            for (int j = 0; j < weekdayscount; j++) {
                sectiondays.add(data.get(j * daysectioncount + i));
            }
            sectionList.add(sectiondays);
        }
        //节次循环
        for (int index = 0; index < sectionList.size(); index++) {
            Map<Integer, Integer> map = new HashMap<Integer, Integer>();
            //每个节次列表中计算重复课程出现的次数
            map = PrjUtils.CouseCntOneList(sectionList.get(index));
            for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
                //课程重复一次计算一次
                if (entry.getValue() > 1 && entry.getKey() != 0) cnt = cnt + (entry.getValue() - 1);
            }
        }
        return punishValue * cnt;
    }

    @Override
    public boolean isOk() {
       /* double val = punishValue;
        List<List<TCcRSw>> sectionList = new ArrayList<>();
        //获取节次课程表
        for (int i = 0; i < dayssectioncount; i++) {
            List<TCcRSw> sectiondays = new ArrayList<>();
            for (int j = 0; j < weekdayscount; j++) {
                sectiondays.add(data.get(j * dayssectioncount + i));
            }
            sectionList.add(sectiondays);
        }
        for (int index = 0; index < sectionList.size(); index++) {
            if (PrjUtils.IsHasSameCourse(sectionList.get(index))) punishValue += val;
        }
        if (punishValue > val) return false;
        else return true;*/
        return true;
    }
}
