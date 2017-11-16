package com.nxlg.rulesloader;

import com.nxlg.rules.rule.IRule;
import com.nxlg.rules.ruleLoader.IRuleLoader;
import com.nxlg.rules.ruleLoader.JsonRuleLoader;
import com.nxlg.rules.ruleLoader.JsonStringSourceContext;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by NEU on 2017/6/6.
 */
public class FakeRulesLoader implements IRulesLoader {
    @Override
    public Set<IRule> loadRules() {
        Set<IRule> rulesSet = new HashSet<>();
        IRuleLoader loader = new JsonRuleLoader();
        JsonStringSourceContext jsoncontext = new JsonStringSourceContext();
//        for (int i = 1; i <= 10; i++) {
//            try{
//                jsoncontext.loadSourceFromResources("data" + i + ".json");
//                IRule rule = (IRule) loader.createObject(jsoncontext);
//                rulesSet.add(rule);
//            }catch (Exception e){
//                e.printStackTrace();
//            }
//        }
        return rulesSet;

    }
}
