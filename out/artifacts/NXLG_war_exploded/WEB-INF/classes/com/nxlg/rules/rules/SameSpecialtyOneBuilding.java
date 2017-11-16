package com.nxlg.rules;

import com.nxlg.model.TCcRSw;
import com.nxlg.rules.rule.TCcRSWRule;

import java.util.*;

/**
 * Created by NEU on 2017/6/7.
 * 全局规则：同一个专业的专业课是否安排在同一个教学楼
 */
public class SameSpecialtyOneBuilding extends TCcRSWRule {

    @Override
    public double calculatePunishValue() {
        int repeatCnt = 0;
        //获取每个专业的专业课程被安排在多少栋教学楼
        Map<String, Set<String>> mapSpecialtyBuildings = new HashMap<>();
        mapSpecialtyBuildings = SpecialtyBuildings(data);
        for (Map.Entry<String, Set<String>> entry : mapSpecialtyBuildings.entrySet()) {
            //同一专业的专业课每被分在另一栋教学楼，都要被计算一次
            if (entry.getValue().size() > 1) repeatCnt += (entry.getValue().size() - 1);
        }
        return repeatCnt * punishValue;
    }

    //统计每个专业的专业课被安排在几栋教学楼
    public Map<String, Set<String>> SpecialtyBuildings(List<TCcRSw> tCcRSwList) {
        Map<String, Set<String>> map = new HashMap<String, Set<String>>();
        for (TCcRSw tCcRSw : tCcRSwList) {
            if (tCcRSw.getTecoId() == 0) continue;
            //获取专业ID
            String specialtyId = tCcRSwIndex.getTeacerCourseByteacherCourse(tCcRSw.getTecoId()).getSpecialtyId();
            //判断该课程是否属于某专业
            if (specialtyId != "") {
                //获取教学楼Id
                String buildingId =tCcRSwIndex.getRoomByRoomId(tCcRSw.getRoomId()).getRoomBuildingId();
                Set<String> buildingIdSet = new HashSet<>();
                if (map.containsKey(specialtyId)) {
                    buildingIdSet = map.get(specialtyId);
                    buildingIdSet.add(buildingId);
                    //判断该专业的课程被分配在哪个教学楼
                    map.put(specialtyId, buildingIdSet);
                } else {
                    buildingIdSet.add(buildingId);
                    map.put(specialtyId, buildingIdSet);
                }
            }
        }
        return map;
    }
}
