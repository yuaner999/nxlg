package com.nxlg.rules;

import com.nxlg.rules.rule.TCcRSRule;
import com.nxlg.utils.PrjUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by NEU on 2017/6/3.
 * 天规则：同一天重复课程
 */
public class SameCourseOneday extends TCcRSRule {


    @Override
    public double calculatePunishValue() {
        int repeatCnt = 0;
        Map<Integer, Integer> map = new HashMap<Integer, Integer>();
        map = PrjUtils.CouseCntOneList(data);
        for (Map.Entry<Integer, Integer> entry : map.entrySet()) {
            //课程重复一次计算一次
            if (entry.getValue() > 1 && entry.getKey() != 0) repeatCnt = repeatCnt + (entry.getValue() - 1);
        }
        return punishValue * repeatCnt;
    }

    @Override
    public boolean isOk() {
        return false;
    }
}