package com.nxlg.rules;

import com.nxlg.model.TCcRSw;
import com.nxlg.rules.rule.TCcSWRule;
import com.nxlg.utils.PrjUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by NEU on 2017/6/3.
 * 教室规则：隔天
 */
public class SameCourseNeighbordays extends TCcSWRule {

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
        int repeatCnt = 0;
        List<TCcRSw> day1 = new ArrayList<>();
        List<TCcRSw> day2 = new ArrayList<>();

        for (int i = 0; i < weekdayscount - 1; i++) {
            day1 = PrjUtils.divideChromosome(data, i * daysectioncount, daysectioncount);
            day2 = PrjUtils.divideChromosome(data, (i + 1) * daysectioncount, daysectioncount);

            //判断相邻两天是否有重复课程
            repeatCnt = repeatCnt + PrjUtils.CourseCntTwoList(day1, day2);
        }
        return punishValue * repeatCnt;
    }

    @Override
    public boolean isOk() {
       /* List<TCcRSw> day1 = new ArrayList<>();
        List<TCcRSw> day2 = new ArrayList<>();

        for (int i = 0; i < weekdayscount - 1; i++) {
            day1 = PrjUtils.divideChromosome(data, i * dayssectioncount, dayssectioncount);
            day2 = PrjUtils.divideChromosome(data, (i + 1) * dayssectioncount, dayssectioncount);

            //判断相邻两天是否有重复课程
            return  !PrjUtils.IsContainSameCourse(day1, day2);
        }
        return true;*/
        return true;
    }

}
