package com.nxlg.rulesloader;

import com.nxlg.rules.rule.IRule;

import java.util.Set;

/**
 * Created by NEU on 2017/6/6.
 */
public interface IRulesLoader {

    Set<IRule> loadRules();

}
