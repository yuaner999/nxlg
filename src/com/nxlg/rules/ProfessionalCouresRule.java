package com.nxlg.rules;

import com.nxlg.rules.rule.TCcRSWRule;

/**
 * Created by NEU on 2017/5/31.
 * 节规则：类型课程的上课时间偏好
 */
public class ProfessionalCouresRule extends TCcRSWRule {

    private int tecoId;
    private int prefertime;

    public int getTecoId() {
        return tecoId;
    }

    public void setTecoId(int tecoId) {
        this.tecoId = tecoId;
    }

    public int getPrefertime() {
        return prefertime;
    }

    public void setPrefertime(int prefertime) {
        this.prefertime = prefertime;
    }

    @Override
    public double calculatePunishValue() {
        if (isOk()) return 0;
        return this.punishValue;
    }

    @Override
    public boolean isOk() {
//        if (this.tCcRSw.getTecoId() != 0){
//            return Objects.equals(this.tCcRSw.getSectionId(), prefertime);
//        }
        return true;
    }

   /* @Override
    public void loadConfigFromJson(SourceContext sourceContext) {
        StringSourceContext stringSourceContext = (StringSourceContext) sourceContext;
        JSONObject jsonObject = new JSONObject(stringSourceContext.getData());
        this.tecoId = jsonObject.getInt("tecoId");
        this.prefertime = jsonObject.getInt("prefertime");
    }*/
}
