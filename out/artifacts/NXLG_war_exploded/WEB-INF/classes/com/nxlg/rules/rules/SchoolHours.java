package com.nxlg.rules;

import com.nxlg.rules.rule.TCcRSWRule;
import com.nxlg.utils.PrjUtils;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/**
 * Created by NEU on 2017/6/4.
 * 全局规则：周学时
 */
public class SchoolHours extends TCcRSWRule {

    @Override
    public double calculatePunishValue() {
        int repeatCnt = 0;
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        map = PrjUtils.CouseCntOneList(data);
        Iterator<Map.Entry<Integer, Integer>> entries = map.entrySet().iterator();
        while (entries.hasNext()) {
            Map.Entry<Integer, Integer> entry = entries.next();
            if (entry.getKey() != 0) {
                int weekhours = tCcRSwIndex.getTeacerCourseByteacherCourse(entry.getKey()).getWeekhours();
                //计算并比较周学时
                if (weekhours != entry.getValue() * 2)
                    //要被惩罚的课程数 = 课程重复次数 - 每周应该安排的课程数
                    repeatCnt = repeatCnt + Math.abs(entry.getValue() - (weekhours / 2));
            }
        }
        return punishValue * repeatCnt;
    }

    @Override
    public boolean isOk() {
        return true;
    }
}
