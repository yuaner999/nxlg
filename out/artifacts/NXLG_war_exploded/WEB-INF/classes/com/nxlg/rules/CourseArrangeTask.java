package com.nxlg;

import com.nxlg.algorithm.CourseArrangementAlgorithm;
import com.nxlg.dataloader.ITCcRSwLoader;
import com.nxlg.model.*;
import com.nxlg.rules.ITCcRSwIndex;
import com.nxlg.rules.TCcRSwIndex;
import com.nxlg.rules.decoder.TCcRSwChromosomListDecoder;
import com.nxlg.rules.rule.IRule;
import com.nxlg.rulesloader.DbJsonRulesLoader;
import com.nxlg.utils.DbUtils;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static javax.swing.UIManager.get;

/**
 * Created by NEUNB_Lisy on 2017/6/8.
 */
public class CourseArrangeTask {

    private ITCcRSwLoader tCcRSwLoader;
    private DbJsonRulesLoader rulesLoader;
    private CourseArrangementAlgorithm courseArrangementAlgorithm;

    public void execTask(DataSource dataSource){


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

        /*Lisy加入数据库*/
        Connection con = null;
        try{
            con = dataSource.getConnection();
        }catch (SQLException e){
            e.printStackTrace();
        }

        try {
            PreparedStatement statement = null;
            PreparedStatement truncate=con.prepareStatement("TRUNCATE TABLE `arrangelesson`");
            truncate.execute();
            for (int i = 0; i < dbresult.size(); i++) {

                List<Map<String, Object>> rows = null;
                String sql=null;

                String acId=null;
                sql="SELECT arrangecourse.acId FROM arrangecourse WHERE arrangecourse.is_now=1";
                rows = DbUtils.queryList(dataSource, sql);
                if (rows.size()>0){
                    acId=String.valueOf(rows.get(0).get("acId"));
                }

                String classroomname = null;
                sql="SELECT classroom.classroomName FROM classroom WHERE classroom.classroomId=?";
                String[] conditionClassroom = new String[1];
                conditionClassroom[0]=String.valueOf(dbresult.get(i).getDbRoomId());
                rows=DbUtils.queryListByCondition(dataSource,sql,conditionClassroom);
                if (rows.size()>0){
                    classroomname=String.valueOf(rows.get(0).get("classroomName"));
                }

                String courseId = null;
                sql="SELECT teachtask.tc_courseid FROM teachtask WHERE teachtask.tc_id=?";
                String[] conditionCourse=new String[1];
                conditionCourse[0]=dbresult.get(i).getDbTeCoId();
                rows=DbUtils.queryListByCondition(dataSource,sql,conditionCourse);
                if (rows.size()>0){
                    courseId=String.valueOf(rows.get(0).get("tc_courseid"));
                }

//                String sql = "INSERT INTO `arrangelesson` (`al_Id`,`al_timeweek`,`al_timepitch`,`acId`,`courseId`,`classroomId`,`classroomName`,`tc_id`) VALUE ( '"+i+"','"+dbresult.get(i).getWeekDay()+"','"+dbresult.get(i).getSectionId()+"','"+acId+"','"+courseId+"','"+dbresult.get(i).getDbRoomId()+"','"+classroomname+"','"+dbresult.get(i).getDbTeCoId()+"')";
                String sqlInsert = "INSERT INTO `arrangelesson` (`al_Id`,`al_timeweek`,`al_timepitch`,`acId`,`courseId`,`classroomId`,`classroomName`,`tc_id`) VALUE (UUID(),?,?,?,?,?,?,?)";
                //System.out.println(sql);
                statement = con.prepareStatement(sqlInsert);
                statement.setObject(1,dbresult.get(i).getWeekDay());
                statement.setObject(2,dbresult.get(i).getSectionId());
                statement.setObject(3,acId);
                statement.setObject(4,courseId);
                statement.setObject(5,dbresult.get(i).getDbRoomId());
                statement.setObject(6,classroomname);
                statement.setObject(7,dbresult.get(i).getDbTeCoId());
                statement.execute();
            }
            con.commit();
            con.close();
        } catch (SQLException e) {
            if (con != null) {
                try {
                    if (!con.isClosed()) con.close();
                } catch (Exception eee) {
                    eee.printStackTrace();
                }
            }
            e.printStackTrace();
        }
        /*Lisy结束*/

        //输出结果
        /*for (int i = 0; i < dbresult.size(); i++) {
            result1.add("教室：" + dbresult.get(i).getDbRoomId() +" 星期："+ dbresult.get(i).getWeekDay()+ " 节次：" + dbresult.get(i).getSectionId() + " 课程：" + dbresult.get(i).getDbTeCoId());
        }
        System.out.println(result1);*/

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
