package com.nxlg.rules;

import com.nxlg.model.TCcRSw;
import com.nxlg.rules.rule.TCcRSWRule;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/6/5.
 * 全局规则：教师冲突
 */
public class SameSectionOneTeacher extends TCcRSWRule {

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

        //获取节次课程表
        for (int i = 0; i < daysectioncount * weekdayscount; i++) {
            List<TCcRSw> sectionrooms = new ArrayList<>();
            for (int j = 0; j < tCcRSwIndex.getRoomSize(); j++) {
                sectionrooms.add(data.get(j * daysectioncount * weekdayscount + i));
            }

            //每个节次列表中计算重复课程出现的次数
            Map<String, Integer> map = new HashMap<String, Integer>();
            map = TeacherCntOneList(sectionrooms);
            for (Map.Entry<String, Integer> entry : map.entrySet()) {
                //教师重复一次计算一次
                if (entry.getValue() > 1) cnt = cnt + (entry.getValue() - 1);
            }
        }

        return punishValue * cnt;
    }

    //统计一个节次中教师出现的次数
    public Map<String, Integer> TeacherCntOneList(List<TCcRSw> data) {
        Map<String, Integer> map = new HashMap<String, Integer>();//新建一个map集合，用来保存重复的次数
        for (TCcRSw obj : data) {
            if (obj.getTecoId() != 0) {
                String dbTeacherId = tCcRSwIndex.getTeacerCourseByteacherCourse(obj.getTecoId()).getDbTeacherId();
                if (map.containsKey(dbTeacherId)) {//判断是否已经有该数值，如有，则将次数加1
                    map.put(dbTeacherId, map.get(dbTeacherId).intValue() + 1);
                } else {
                    map.put(dbTeacherId, 1);
                }
            }
        }
        return map;
    }
}
