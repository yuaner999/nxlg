package com.nxlg.rules;

import com.nxlg.rules.rule.TCcRWRule;

/**
 * 节规则：某课程在第几节上
 */
public class CouresSectionRule extends TCcRWRule {

    @Override
    public double calculatePunishValue() {
        if (isOk()) return 0;
        return this.punishValue;
    }

    @Override
    public boolean isOk() {
        if (this.tCcRSw.getTecoId() != 0) {
            String sections = tCcRSwIndex.getTeacerCourseByteacherCourse(this.tCcRSw.getTecoId()).getSection();
            return (sections.indexOf(this.tCcRSw.getSectionId()) != -1);
        }
        return true;
    }

   /* @Override
    public void loadConfigFromJson(SourceContext sourceContext) {
        StringSourceContext stringSourceContext = (StringSourceContext) sourceContext;
        JSONObject jsonObject = new JSONObject(stringSourceContext.getData());
        this.tecoId = jsonObject.getInt("tecoId");
        this.section = jsonObject.getInt("section");
    }*/
}
