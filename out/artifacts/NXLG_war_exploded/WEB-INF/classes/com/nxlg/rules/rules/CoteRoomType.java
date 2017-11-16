package com.nxlg.rules;

import com.nxlg.rules.rule.TCcRWRule;

import java.util.Objects;

/**
 * Created by NEU on 2017/6/3.
 * 节规则：教室类型与课程的教室类型匹配
 */
public class CoteRoomType extends TCcRWRule {

    @Override
    public double calculatePunishValue() {
        if (isOk()) return 0;
        return punishValue;
    }

    @Override
    public boolean isOk() {
        if (this.tCcRSw.getTecoId() != 0) {
            String roomType = this.tCcRSwIndex.getRoomByRoomId(this.tCcRSw.getRoomId()).getRoomType();
            String coteRoomtype = this.tCcRSwIndex.getTeacerCourseByteacherCourse(this.tCcRSw.getTecoId()).getRoomType();
            return Objects.equals(roomType, coteRoomtype);
        }
        return true;
    }
}
