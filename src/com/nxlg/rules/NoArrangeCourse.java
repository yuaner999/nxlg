package com.nxlg.rules;

import com.nxlg.rules.rule.TCcRSWRule;
import com.nxlg.utils.PrjUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by NEU on 2017/6/5.
 * 全局规则：教室空余的情况下，课程未安排
 */
public class NoArrangeCourse extends TCcRSWRule {

    @Override
    public double calculatePunishValue() {
        int cnt = 0;
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        map = PrjUtils.CouseCntOneList(data);
        if (map.size() != tCcRSwIndex.getTeachercourseSize())
            cnt += tCcRSwIndex.getTeachercourseSize() - map.size();
        return punishValue * cnt;
    }

    @Override
    public boolean isOk() {
        int cnt = 0;
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        map = PrjUtils.CouseCntOneList(data);
        if (map.size() != tCcRSwIndex.getTeachercourseSize())
            cnt += tCcRSwIndex.getTeachercourseSize() - map.size();
        return cnt==0;
    }

}
