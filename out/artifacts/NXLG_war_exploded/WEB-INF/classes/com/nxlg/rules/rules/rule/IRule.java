package com.nxlg.rules.rule;

import com.nxlg.rules.ITCcRSwIndex;

public interface IRule {

    ITCcRSwIndex getTCcRSwIndex();

    void settCcRSwIndex(ITCcRSwIndex tCcRSwIndex);

    double getPunishValue();

    void setPunishValue(double value);

    double calculatePunishValue();

    boolean isOk();

/*    void loadConfigFromJson(SourceContext sourceContext);*/
}
