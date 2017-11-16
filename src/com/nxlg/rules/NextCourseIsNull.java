package com.nxlg.rules;

import com.nxlg.rules.rule.TCcRSRule;

import java.util.Objects;

/**
 * Created by NEU on 2017/6/3.
 * 天规则：下一节课是否安排课程
 */
public class NextCourseIsNull extends TCcRSRule {

    private int courseId;

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    @Override
    public double calculatePunishValue() {
        if (isOk()) return 0;
        return punishValue;
    }

    @Override
    public boolean isOk() {
        for (int i = 0; i < data.size() - 1; i++) {
            if(data.get(i).getTecoId() ==0) continue;
            //某种课程类型的后续课程不能排课
            if (Objects.equals(tCcRSwIndex.getTeacerCourseByteacherCourse(data.get(i).getTecoId()).getDbCourseId(),courseId)){
                return Objects.equals(data.get(i+1).getTecoId(),0);
            }
        }
        return true;
    }
}
