package com.nxlg.rules;

import com.nxlg.rules.rule.TCcRWRule;

/**
 * 节规则：教室最小容积率
 */
public class MinRoomCapacityRateRule extends TCcRWRule {

    @Override
    public double calculatePunishValue() {
        if (isOk()) return 0;
        return this.punishValue;
    }

    @Override
    public boolean isOk() {
        if (this.tCcRSw.getTecoId() != 0) {
            int capacity = this.tCcRSwIndex.getRoomByRoomId(this.tCcRSw.getRoomId()).getRoomCapacity();
            int stunum = this.tCcRSwIndex.getTeacerCourseByteacherCourse(this.tCcRSw.getTecoId()).getDbstuNum();
            double rate = stunum * 1.0 / capacity;
//            return (rate >= this.tCcRSwIndex.getRoomByRoomId(this.tCcRSw.getRoomId()).getMinCapacityRate()) && (rate <= 1);
            return rate >= this.tCcRSwIndex.getRoomByRoomId(this.tCcRSw.getRoomId()).getMinCapacityRate();
        }
        return true;
    }
/*
    @Override
    public void loadConfigFromJson(SourceContext sourceContext) {
        StringSourceContext stringSourceContext = (StringSourceContext) sourceContext;
        JSONObject jsonObject = new JSONObject(stringSourceContext.getData());
        this.roomId = jsonObject.getInt("roomId");
    }*/
}
