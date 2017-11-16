package com.nxlg;

import java.io.IOException;

/**
 * Created by NEU on 2017/6/1.
 */
public class testAlgorithm {
    public static void main(String[] args) throws IOException {
      /*  ApplicationContext context = new ClassPathXmlApplicationContext("config.xml");
        //构建对象
        ITCcRSwLoader tCcRSwLoader = (ITCcRSwLoader) context.getBean("defaultTCcRSwLoader");
        IRulesLoader rulesLoader = (IRulesLoader) context.getBean("defaultRulesLoader");
        CourseArrangementAlgorithm courseArrangementAlgorithm = (CourseArrangementAlgorithm) context.getBean("courseArrangementAlgorithm");

//        List<DbTCcRSw> dbTCcRSws = new ArrayList<>(Collections.nCopies(9 * 6 * 5, new DbTCcRSw()));
//
//        //如果上一周课程表为空，一直向前回溯，直到有课程表或者第一周
//        dbTCcRSws.set(0, new DbTCcRSw("wm2", "1", 1, 1, 1, 0));
//        dbTCcRSws.set(4, new DbTCcRSw("wm2", "1", 1, 5, 1, 1));
//        dbTCcRSws.set(6, new DbTCcRSw("le1", "1", 2, 2, 1, 1));
//        dbTCcRSws.set(156, new DbTCcRSw("zm2", "6", 2, 2, 1, 0));
//        dbTCcRSws.set(158, new DbTCcRSw("zm3", "6", 2, 4, 1, 1));
//        dbTCcRSws.set(131, new DbTCcRSw("zm1", "5", 3, 2, 1, 0));
//        dbTCcRSws.set(146, new DbTCcRSw("zm2", "5", 6, 2, 1, 0));
//        dbTCcRSws.set(229, new DbTCcRSw("we", "8", 4, 5, 1, 0));
//        dbTCcRSws.set(230, new DbTCcRSw("we1", "8", 5, 1, 1, 0));
//        dbTCcRSws.set(66, new DbTCcRSw("zm", "3", 2, 2, 1, 1));
//        dbTCcRSws.set(240, new DbTCcRSw("ze", "9", 1, 1, 1, 1));
//        dbTCcRSws.set(260, new DbTCcRSw("ze1", "9", 5, 1, 1, 1));
//        dbTCcRSws.set(263, new DbTCcRSw("we2", "9", 5, 4, 1, 1));
//        dbTCcRSws.set(93, new DbTCcRSw("zm3", "4", 1, 4, 1, 1));
//        dbTCcRSws.set(101, new DbTCcRSw("zm1", "4", 3, 2, 1, 0));
//        dbTCcRSws.set(103, new DbTCcRSw("lm", "4", 3, 4, 1, 1));
//        dbTCcRSws.set(109, new DbTCcRSw("lm", "4", 4, 5, 1, 1));
//        dbTCcRSws.set(111, new DbTCcRSw("zm", "4", 5, 2, 1, 1));
//
//        //加载规则
//
//        DynamicRule dynamicRule = new DynamicRule();
//        dynamicRule.setLastweekdata(dbTCcRSws);
//        dynamicRule.setWeekdaysCnt(6);   //设置一周上几天课
//        dynamicRule.setDaysectionsCnt(5);   //设置一天几节课
//        dynamicRule.setPunishValue(1000000);

        List<IRule> ruleList = new ArrayList<>(rulesLoader.loadRules());
//        ruleList.add(dynamicRule);

        *//**开始排课*//*
        List<TCcRSw> tCcRSwResult = new ArrayList<>();
        //教学起始周
        int schoolweekstart = 1;
        int schoolweeekend = 1;
        //循环遍历教学周
        for (int i = schoolweekstart; i <= schoolweeekend; i++) {
            //加载当前教学周的课程、教师、教室数据
            Set<TeacherCourse> dbTeacherCourseSet = tCcRSwLoader.loadTeacherCourse(i);     *//**加载在当前教学周开课的课程*//*
            if (dbTeacherCourseSet.size() == 0) continue;        //本周开课的课程数为0，不需要排课
          //  Set<Course> dbCourseSet = tCcRSwLoader.loadCourse();
            Set<Teacher> dbTeacherIdSet = tCcRSwLoader.loadTeachers();
            Set<Room> dbRoomSet = tCcRSwLoader.loadRooms();

            //建立索引
            TCcRSwIndex tCcRSwIndex = new TCcRSwIndex();
            tCcRSwIndex.setDbTeacherCourseSet(dbTeacherCourseSet);
            tCcRSwIndex.setDbTeacherIdSet(dbTeacherIdSet);
       //     tCcRSwIndex.setDbCourseSet(dbCourseSet);
            tCcRSwIndex.setDbRoomSet(dbRoomSet);
            tCcRSwIndex.buildIndex();

//            dynamicRule.settCcRSwIndex(tCcRSwIndex);

            courseArrangementAlgorithm.settCcRSwIndex(tCcRSwIndex);
            courseArrangementAlgorithm.setChromosomDecoder(new TCcRSwChromosomListDecoder());
            courseArrangementAlgorithm.setRules(ruleList);

            tCcRSwResult = courseArrangementAlgorithm.arrangeCourse();
            //结果验证输出
            List<RuleResult> r = BestFinalUtils.checkResult(5, 6, ruleList, tCcRSwIndex, tCcRSwResult);
            System.out.println(r);
            //转为数据库格式数据
            List<DbTCcRSw> dbresult = PrjUtils.convertToDbTCcRSwData(tCcRSwResult, tCcRSwIndex, i);
//            dynamicRule.setLastweekdata(dbresult);

//            List<String> result = new ArrayList<>();
//            //输出结果
//            for (int k = 0; k < dbresult.size(); k++) {
//                result.add("教室：" + dbresult.get(k).getDbRoomId() + " 星期：" + dbresult.get(k).getWeekDay() + " 节次：" + dbresult.get(k).getSectionId() + " 课程：" + dbresult.get(k).getDbTeCoId());
//            }
//            System.out.println(result);*/
        }

    }

