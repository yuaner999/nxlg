package com.nxlg.utils;

import com.nxlg.model.RuleResult;
import com.nxlg.model.TCcRSw;
import com.nxlg.rules.ITCcRSwIndex;
import com.nxlg.rules.rule.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/6/9.
 */
public class BestFinalUtils {

    private static void addCount(Map<IRule,Integer> rulecountmap, Map<IRule,Double> rulepunishmap, IRule rule, double calcpunishvalue){
        if(!rulecountmap.containsKey(rule)) rulecountmap.put(rule,0);
        if(!rulepunishmap.containsKey(rule)) rulepunishmap.put(rule,0.0);
        rulecountmap.put(rule,rulecountmap.get(rule)+1);
        rulepunishmap.put(rule,rulepunishmap.get(rule)+calcpunishvalue);
    }

    public static List<RuleResult> checkResult(int daysectioncount, int weekdayscount, List<IRule> rulelist, ITCcRSwIndex tCcRSwIndex, List<TCcRSw> tCcRSwsList){

        Map<IRule,Integer> rulecountmap = new HashMap<>();
        Map<IRule,Double> rulepunishmap = new HashMap<>();

        int roomCnt = tCcRSwIndex.getRoomSize();
        //染色体解码

        //节规则—每个教室每节
        for (TCcRSw curtCcRSw : tCcRSwsList) {
            for (IRule rule : rulelist) {
                if (rule instanceof TCcRWRule) {
                    TCcRWRule tRule = (TCcRWRule) rule;
                    tRule.setData(curtCcRSw);
                    tRule.settCcRSwIndex(tCcRSwIndex);
                    if(!tRule.isOk())
                        addCount(rulecountmap,rulepunishmap,rule,tRule.calculatePunishValue());
                }
            }
        }
        //天规则—每个教室每天
        for (int dayIndex = 0; dayIndex < roomCnt * weekdayscount; dayIndex++) {
            int index = 0;
            for (IRule rule : rulelist) {
                if (rule instanceof TCcRSRule) {
                    TCcRSRule tRule = (TCcRSRule) rule;
                    tRule.setData(PrjUtils.divideChromosome(tCcRSwsList, index, daysectioncount));
                    tRule.settCcRSwIndex(tCcRSwIndex);
                    if(!tRule.isOk())
                        addCount(rulecountmap,rulepunishmap,rule,tRule.calculatePunishValue());
                }
            }
            index += daysectioncount;
        }

        //教室规则—每个教室
        for (int roomIndex = 0; roomIndex < roomCnt; roomIndex++) {
            int index = 0;
            for (IRule rule : rulelist) {
                if (rule instanceof TCcSWRule) {
                    TCcSWRule tRule = (TCcSWRule) rule;
                    tRule.setData(PrjUtils.divideChromosome(tCcRSwsList, index, daysectioncount * weekdayscount));
                    tRule.settCcRSwIndex(tCcRSwIndex);
                    if(!tRule.isOk())
                        addCount(rulecountmap,rulepunishmap,rule,tRule.calculatePunishValue());

                }
            }
            index += daysectioncount * weekdayscount;
        }

        //全局考虑的规则
        for (IRule rule : rulelist) {
            if (rule instanceof TCcRSWRule) {
                TCcRSWRule tRule = (TCcRSWRule) rule;
                tRule.setData(tCcRSwsList);
                tRule.settCcRSwIndex(tCcRSwIndex);
                if(!tRule.isOk())
                    addCount(rulecountmap,rulepunishmap,rule,tRule.calculatePunishValue());

            }
        }

        List<RuleResult> result = new ArrayList<>();
        for(Map.Entry<IRule,Integer> entry:rulecountmap.entrySet()){
            IRule rule = entry.getKey();
            Integer count = entry.getValue();
            double punishvalue = rule.getPunishValue();
            double calcpunishvalue = rulepunishmap.get(rule);
            result.add(new RuleResult(rule.getClass().getName(),count,punishvalue,calcpunishvalue));
        }
        return  result;

    }

}
