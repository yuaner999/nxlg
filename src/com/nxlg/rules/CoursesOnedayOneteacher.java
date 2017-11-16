package com.nxlg.rules;

import com.nxlg.model.TCcRSw;
import com.nxlg.rules.rule.TCcRSWRule;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/6/7.
 * 全局规则：教师一天最多上几节课
 */
public class CoursesOnedayOneteacher extends TCcRSWRule {

    @Override
    public double calculatePunishValue() {
        int daysectioncount = tCcRSwIndex.getDaysectioncount();
        int weekdayscount = tCcRSwIndex.getWeekdayscount();
        int repeatCnt = 0;

        //获取天课程表
        for (int i = 0; i < weekdayscount; i++) {
            List<TCcRSw> daycourses = new ArrayList<>();
            for (int j = 0; j < tCcRSwIndex.getRoomSize(); j++) {
                for (int k = 0; k < daysectioncount; k++) {
                    daycourses.add(data.get(i * daysectioncount + j * daysectioncount * weekdayscount + k));
                }
            }
            //统计一天中教师出现的次数
            Map<String, Integer> mapTeacherCnt = new HashMap<>();
            mapTeacherCnt = TeacherCntOneList(daycourses);

            for (Map.Entry<String, Integer> entry : mapTeacherCnt.entrySet()) {
                //获取老师一天最多上的课程数
                int mostLessionCnt = tCcRSwIndex.getTeacherByDbteacherId(entry.getKey().toString());
                //教师多上一节课多计算一次
                if (entry.getValue() > mostLessionCnt) repeatCnt = repeatCnt + (entry.getValue() - mostLessionCnt);
            }
        }

        return repeatCnt * punishValue;
    }

    @Override
    public boolean isOk() {
        int daysectioncount = tCcRSwIndex.getDaysectioncount();
        int weekdayscount = tCcRSwIndex.getWeekdayscount();
        int repeatCnt = 0;

        //获取天课程表
        for (int i = 0; i < weekdayscount; i++) {
            List<TCcRSw> daycourses = new ArrayList<>();
            for (int j = 0; j < tCcRSwIndex.getRoomSize(); j++) {
                for (int k = 0; k < daysectioncount; k++) {
                    daycourses.add(data.get(i * daysectioncount + j * daysectioncount * weekdayscount + k));
                }
            }
            //统计一天中教师出现的次数
            Map<String, Integer> mapTeacherCnt = new HashMap<>();
            mapTeacherCnt = TeacherCntOneList(daycourses);

            for (Map.Entry<String, Integer> entry : mapTeacherCnt.entrySet()) {
                //获取老师一天最多上的课程数
                int mostLessionCnt = tCcRSwIndex.getTeacherByDbteacherId(entry.getKey().toString());
                //教师多上一节课多计算一次
                if (entry.getValue() > mostLessionCnt) repeatCnt = repeatCnt + (entry.getValue() - mostLessionCnt);
            }
        }

        return repeatCnt ==0;
    }

    //统计一天中教师出现的次数
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
