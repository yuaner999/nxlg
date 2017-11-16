package com.controllers;


import com.nxlg.CourseArrangeTask;
import com.nxlg.utils.DbUtils;
import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * Created by NEUNB_Lisy on 2017/6/8.
 */
public class CourseArrangementController implements Controller {

    CourseArrangeTask courseArrangeTask;
    ThreadPoolExecutor threadPoolExecutor;
    DataSource dataSource;

    @Override
    public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {

        ResultSet resultSet;
        Connection con = null;
        int status = 0;

        List<Map<String, Object>> rows = null;
        String sql = null;
        sql = "SELECT wordbook.wordbookValue FROM wordbook WHERE wordbook.wordbookKey='排课状态'";
        rows = DbUtils.queryList(dataSource, sql);
        if (rows.size() > 0) {
            status = Integer.parseInt(String.valueOf(rows.get(0).get("wordbookValue")));
        }

        if (status == 0 || status == 3|| status == 4) {
            threadPoolExecutor.execute(new Runnable() {
                @Override
                public void run() {
                    writeCourseArrangeTaskStatus(2,0);
                    int taskStat = courseArrangeTask.execTask(dataSource);
                    if(taskStat == -101) writeCourseArrangeTaskStatus(4,-101);
                    else if(taskStat == -102) writeCourseArrangeTaskStatus(4,-102);
                    else if(taskStat == -103) writeCourseArrangeTaskStatus(4,-103);
                    else if(taskStat == -104) writeCourseArrangeTaskStatus(4,-104);
                    else if(taskStat == -105) writeCourseArrangeTaskStatus(4,-105);
                    else if(taskStat == -106) writeCourseArrangeTaskStatus(4,-106);
                    else if(taskStat == -110) writeCourseArrangeTaskStatus(4,-110);
                    else writeCourseArrangeTaskStatus(3,0);
                }
            });
        } else if (status == 1 || status == 2) {
            JSONObject result = new JSONObject();
            result.put("result", false);
            httpServletResponse.getWriter().write(result.toString());
            return null;
        }

        writeCourseArrangeTaskStatus(1,0);

        //输出
        JSONObject result = new JSONObject();
        result.put("result", true);
        httpServletResponse.getWriter().write(result.toString());

        return null;
    }

    private void writeCourseArrangeTaskStatus(int status,int errorStat) {
        Connection con = null;
        try {
            con = dataSource.getConnection();
            PreparedStatement stat = con.prepareStatement("UPDATE wordbook SET wordbookValue =? WHERE wordbook.wordbookKey= '排课状态'");
            stat.setObject(1, status);
            stat.execute();
            con.commit();
            //排课错误信息
            stat = con.prepareStatement("UPDATE wordbook SET wordbookValue =? WHERE wordbook.wordbookKey= '排课错误信息'");
            stat.setObject(1, errorStat);
            stat.execute();
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
    }

    public void setCourseArrangeTask(CourseArrangeTask courseArrangeTask) {
        this.courseArrangeTask = courseArrangeTask;
    }

    public void setThreadPoolExecutor(ThreadPoolExecutor threadPoolExecutor) {
        this.threadPoolExecutor = threadPoolExecutor;
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}
