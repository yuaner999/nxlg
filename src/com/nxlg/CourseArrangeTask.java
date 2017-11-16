package com.nxlg;

import com.common.DLog;
import com.nxlg.algorithm.CourseArrangementAlgorithm;
import com.nxlg.dataloader.ITCcRSwLoader;
import com.nxlg.model.*;
import com.nxlg.rules.DynamicRule;
import com.nxlg.rules.TCcRSwIndex;
import com.nxlg.rules.decoder.TCcRSwChromosomListDecoder;
import com.nxlg.rules.rule.IRule;
import com.nxlg.rulesloader.DbJsonRulesLoader;
import com.nxlg.utils.BestFinalUtils;
import com.nxlg.utils.DbUtils;
import com.nxlg.utils.PrjUtils;

import javax.sql.DataSource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by NEUNB_Lisy on 2017/6/8.
 */
public class CourseArrangeTask {

    private ITCcRSwLoader tCcRSwLoader;
    private DbJsonRulesLoader rulesLoader;
    private CourseArrangementAlgorithm courseArrangementAlgorithm;
    private TCcRSwIndex tCcRSwIndex = new TCcRSwIndex();

    public int execTask(DataSource dataSource) {
        try {

            //清空上次排课结果
            DbUtils.clearCourses(dataSource);

            int roomSize = tCcRSwIndex.getRoomSize();
            List<Map<String, Object>> rows = null;
            String sql = null;
            sql = "select * from arrangecourse where is_now='1'";
            rows = DbUtils.queryList(dataSource, sql);
            String semesterId = null;
            String semester = null;
            if (rows.size() > 0) {
                semesterId = String.valueOf(rows.get(0).get("acId"));
                semester = String.valueOf(rows.get(0).get("semester"));
            }
            if (semester == null || semesterId == null) return -105;    // //错误信息提示:未设置当前学期，请先设置

//        String semesterId = "fb910ec9-985f-11e7-a287-408d5ce8eb96";   //学期Id
            int weekdasCnt = Integer.parseInt(rows.get(0).get("days").toString());      //每周上课天数
            if (weekdasCnt == 0) return -102;       //错误信息提示：未设置每周上课天数，请先设置
            int daysectionsCnt = Integer.parseInt(rows.get(0).get("lessonsMorning").toString()) + Integer.parseInt(rows.get(0).get("lessonAfternoon").toString()) + Integer.parseInt(rows.get(0).get("lessonNight").toString());     //每天上课节数
            if (daysectionsCnt == 0) return -103;    //错误信息提示:未设置每天上课节数，请先设置
            //教学起始周
            int schoolweekstart = Integer.parseInt(rows.get(0).get("startWeek").toString());
            int schoolweeekend = Integer.parseInt(rows.get(0).get("endWeek").toString());
            if (schoolweeekend == 0 || schoolweekstart == 0) return -104;    //错误信息提示:未设置教学起始周，请先设置

            tCcRSwLoader.loadSetData(semesterId, weekdasCnt, daysectionsCnt, schoolweekstart, schoolweeekend);
            int punishValue = 10000000;    //动态规则惩罚值
            if (punishValue == 0) return -106;    //错误信息提示:未设置动态规则惩罚值，请先设置

            tCcRSwIndex.setDaysectioncount(daysectionsCnt);
            tCcRSwIndex.setWeekdayscount(weekdasCnt);

            //  Set<Course> dbCourseSet = tCcRSwLoader.loadCourse();
            Set<Teacher> dbTeacherIdSet = tCcRSwLoader.loadTeachers();
            Set<Room> dbRoomSet = tCcRSwLoader.loadRooms();
            tCcRSwIndex.setDbTeacherIdSet(dbTeacherIdSet);
            //     tCcRSwIndex.setDbCourseSet(dbCourseSet);
            tCcRSwIndex.setDbRoomSet(dbRoomSet);
            tCcRSwIndex.buildIndex();
            List<IRule> ruleList = new ArrayList<>(rulesLoader.loadRules());


            /**开始排课*/ //循环遍历教学周
            for (int weekindex = schoolweekstart; weekindex <= schoolweeekend; weekindex++) {
                //加载当前教学周的课程、教师、教室数据
                Set<TeacherCourse> dbTeacherCourseSet = tCcRSwLoader.loadTeacherCourse(weekindex, semester);     /**加载在当前教学周开课的课程*/
                if (dbTeacherCourseSet.size() == 0) continue;        //本周开课的课程数为0，不需要排课
                //建立索引
                tCcRSwIndex.setDbTeacherCourseSet(dbTeacherCourseSet);
                tCcRSwIndex.buildTeachCourseIndex();

                if(roomSize * weekdasCnt * daysectionsCnt < dbTeacherCourseSet.size()) return -101; //错误信息提示：资源不足

                //加载课程表
                List<DbTCcRSw> dbTCcRSws = tCcRSwLoader.loadArrangeCourse(semesterId, tCcRSwIndex, weekdasCnt, daysectionsCnt);
                //加载规则
                DynamicRule dynamicRule = new DynamicRule();
                dynamicRule.setLastweekdata(dbTCcRSws);
                dynamicRule.setWeekdaysCnt(weekdasCnt);   //设置一周上几天课
                dynamicRule.setDaysectionsCnt(daysectionsCnt);   //设置一天几节课
                dynamicRule.setPunishValue(punishValue);
                dynamicRule.settCcRSwIndex(tCcRSwIndex);

                ruleList.add(dynamicRule);

                courseArrangementAlgorithm.settCcRSwIndex(tCcRSwIndex);
                courseArrangementAlgorithm.setChromosomDecoder(new TCcRSwChromosomListDecoder());
                courseArrangementAlgorithm.setRules(ruleList);
                courseArrangementAlgorithm.setDbTCcRSws(dbTCcRSws);    //设置课程表
                courseArrangementAlgorithm.setCurweek(weekindex);
                courseArrangementAlgorithm.setDaySectionCount(daysectionsCnt);
                courseArrangementAlgorithm.setWeekdaycount(weekdasCnt);

                List<TCcRSw> tCcRSwResult = courseArrangementAlgorithm.arrangeCourse();
                if (tCcRSwResult == null) return -101;             //错误信息提示：资源不足
                //结果验证输出
                List<RuleResult> r = BestFinalUtils.checkResult(daysectionsCnt, weekdasCnt, ruleList, tCcRSwIndex, tCcRSwResult);
                System.out.println(r);
                //转为数据库格式数据
                List<DbTCcRSw> dbresult = PrjUtils.convertToDbTCcRSwData(tCcRSwResult, tCcRSwIndex, weekindex);
                dynamicRule.setLastweekdata(dbresult);
                //将结果存入数据库中
                DbUtils.insertArrangeCourse(dataSource, dbresult, semesterId);

          /*  //输出结果
            List<String> result = new ArrayList<>();
            for (int k = 0; k < dbresult.size(); k++) {
                result.add("教室：" + dbresult.get(k).getDbRoomId() + " 星期：" + dbresult.get(k).getWeekDay() + " 节次：" + dbresult.get(k).getSectionId() + " 课程：" + dbresult.get(k).getDbTeCoId());
            }
            System.out.println(result);*/
            }
        } catch (Exception ex) {
            DLog.w(ex.getMessage());
            return -110;
        }
        return 3;
    }

    public void settCcRSwLoader(ITCcRSwLoader tCcRSwLoader) {
        this.tCcRSwLoader = tCcRSwLoader;
    }

    public void setRulesLoader(DbJsonRulesLoader rulesLoader) {
        this.rulesLoader = rulesLoader;
    }

    public void setCourseArrangementAlgorithm(CourseArrangementAlgorithm courseArrangementAlgorithm) {
        this.courseArrangementAlgorithm = courseArrangementAlgorithm;
    }

    public void setDataSource(com.zaxxer.hikari.HikariDataSource dataSource) {
    }
}
