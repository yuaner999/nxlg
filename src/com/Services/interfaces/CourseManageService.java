package com.Services.interfaces;


import java.util.List;
import java.util.Map;

/**
 * Created by zqy on 2017/10/11.
 */
public interface CourseManageService {
        /**
         * 批量存入数据库
         *
         * @param list
         * @return
         */
        int saveCourseManage(List<Map<String, String>> list);

        /**
         * 获取老师的所在学院
         * @param map
         * @return
         */
        List<Map<String, String>> getTeacherCollege(Map<String, String> map);

        /**
         * 查询课程代码是否有相同的
         * @param list
         * @return
         */
        List<String > getCourseCode(List<Map<String, String>> list);
        /**
         * 查询课程名称是否有相同的
         * @param list
         * @return
         */
        List<String > getCourseName(List<Map<String, String>> list);
        /**
         * 存入数据到消息表
         * @param map
         * @return
         */
        int saveMessage(Map<String, String> map);
}
