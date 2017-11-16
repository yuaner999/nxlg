package com.controllers;


import com.nxlg.CourseArrangeTask;
import org.json.JSONObject;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * Created by NEUNB_Lisy on 2017/6/8.
 */
public class CourseArrangementStatusController implements Controller {

    DataSource dataSource;

    @Override
    public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {

        int status = readCourseArrangeTaskStatus();

        JSONObject result = new JSONObject();
        result.put("status",status);
        httpServletResponse.getWriter().write(result.toString());

        return null;
    }

    private int readCourseArrangeTaskStatus() {
        ResultSet result;
        Connection con = null;
        try {
            con = dataSource.getConnection();
            PreparedStatement stat = con.prepareStatement("SELECT wordbook.wordbookValue FROM wordbook WHERE wordbook.wordbookKey='排课状态'");
            result = stat.executeQuery();
            ResultSetMetaData meta = result.getMetaData();       //获取元数据

            while (result.next()){
                for(int i=1;i<=meta.getColumnCount();i++){
                    String colname = meta.getColumnLabel(i);
                    Object value = result.getObject(colname);
                }
            }
            con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}
