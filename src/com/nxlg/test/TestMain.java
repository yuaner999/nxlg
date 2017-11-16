package com.nxlg.test;

import com.nxlg.model.TCcRSw;
import com.nxlg.rules.rule.IRule;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by NEU on 2017/5/31.
 */
public class TestMain {

    public static void main(String[] args) throws IOException {
//        ApplicationContext context = new ClassPathXmlApplicationContext("config.xml");
//        IRuleFactory ruleFactory = (IRuleFactory) context.getBean("defaultrulefactory");
//        IRule rule = ruleFactory.createRule("111");
//        System.out.println(rule);

//        IRuleLoader loader = new JsonRuleLoader();
//        JsonStringSourceContext context = new JsonStringSourceContext();
//        context.loadSourceFromResources("data.json");
//        IRule rule = (IRule) loader.createObject(context);

//        System.out.println(rule);
    }

    private static double calcfitness(){
        List<IRule> rulelist = new ArrayList<>();
        double fitnessvalue = 0;

        List<TCcRSw> allTCcRSwList = new ArrayList<>();

//        //最内层循环
//        TCcRSw curtCcRSw = null;
//        for(IRule rule:rulelist){
//            if(rule instanceof TCcRSWRule){
//                TCcRSWRule tRule = (TCcRSWRule) rule;
//                tRule.setData(curtCcRSw);
//                fitnessvalue += -tRule.calculatePunishValue();
//            }
//        }

        //第一层循环最后
//        List<TCcRSw> roomTCcRSWList = new ArrayList<>();
//        for(IRule rule:rulelist){
//            if(rule instanceof TCcSWRule){
//                TCcSWRule tRule = (TCcSWRule) rule;
//                tRule.setData(roomTCcRSWList);
//                fitnessvalue += -tRule.calculatePunishValue();
//            }
//        }

        return fitnessvalue;
    }
}
