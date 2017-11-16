package com.nxlg;

import com.nxlg.algorithm.CourseArrangementAlgorithm;
import com.nxlg.dataloader.ITCcRSwLoader;
import com.nxlg.model.*;
import com.nxlg.rules.ITCcRSwIndex;
import com.nxlg.rules.TCcRSwIndex;
import com.nxlg.rules.decoder.TCcRSwChromosomListDecoder;
import com.nxlg.rules.rule.IRule;
import com.nxlg.rulesloader.IRulesLoader;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Created by NEU on 2017/6/1.
 */
public class testAlgorithm {
    public static void main(String[] args) throws IOException {
        ApplicationContext context = new ClassPathXmlApplicationContext("config.xml");
        //构建对象
        ITCcRSwLoader tCcRSwLoader = (ITCcRSwLoader) context.getBean("defaultTCcRSwLoader");
        IRulesLoader rulesLoader = (IRulesLoader) context.getBean("defaultRulesLoader");
        CourseArrangementAlgorithm courseArrangementAlgorithm = (CourseArrangementAlgorithm) context.getBean("courseArrangementAlgorithm");

        //加载课程、教师、教室数据
        Set<Course> dbCourseSet = tCcRSwLoader.loadCourse();
        Set<Teacher> dbTeacherIdSet = tCcRSwLoader.loadTeachers();
        Set<Room> dbRoomSet = tCcRSwLoader.loadRooms();
        Set<TeacherCourse> dbTeacherCourseSet = tCcRSwLoader.loadTeacherCourse();
        //加载规则
        List<IRule> ruleList = new ArrayList<>(rulesLoader.loadRules());
        //建立索引
        TCcRSwIndex tCcRSwIndex = new TCcRSwIndex();
        tCcRSwIndex.setDbTeacherIdSet(dbTeacherIdSet);
        tCcRSwIndex.setDbCourseSet(dbCourseSet);
        tCcRSwIndex.setDbRoomSet(dbRoomSet);
        tCcRSwIndex.setDbTeacherCourseSet(dbTeacherCourseSet);
        tCcRSwIndex.buildGAIndex();

        courseArrangementAlgorithm.settCcRSwIndex(tCcRSwIndex);
        courseArrangementAlgorithm.setChromosomDecoder(new TCcRSwChromosomListDecoder());
        courseArrangementAlgorithm.setRules(ruleList);

        //安排课程
        List<TCcRSw> result = courseArrangementAlgorithm.arrangeCourse();
        //转换为数据库中的真是数据
        List<DbTCcRSw> dbresult = new ArrayList<>(result.size());
        for (TCcRSw item : result) {
            dbresult.add(convertToDbObj(item,tCcRSwIndex));
        }
        List<String> result1 = new ArrayList<>();
        //输出结果
        for (int i = 0; i < dbresult.size(); i++) {
            result1.add("教室：" + dbresult.get(i).getDbRoomId() +" 星期："+ dbresult.get(i).getWeekDay()+ " 节次：" + dbresult.get(i).getSectionId() + " 课程：" + dbresult.get(i).getDbTeCoId());
        }
        System.out.println(result1);
    }

    //转变为数据库对象的数据
    private static DbTCcRSw convertToDbObj(TCcRSw tCcRSw,ITCcRSwIndex tCcRSwIndex) {
        String dbTecoId = "";
        if(tCcRSwIndex.getTeacerCourseByteacherCourse(tCcRSw.getTecoId()) == null) dbTecoId = "";
        else dbTecoId = tCcRSwIndex.getTeacerCourseByteacherCourse(tCcRSw.getTecoId()).getDbTeCoId();

        return new DbTCcRSw(
                dbTecoId,
                tCcRSwIndex.getDbClassIdByClassId(tCcRSw.getClassId()),
                tCcRSwIndex.getDbRoomIdByRoomId(tCcRSw.getRoomId()),
                tCcRSw.getSectionId(),
                tCcRSw.getWeekDay()
        );
    }

}
