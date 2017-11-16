package com.Services.impls;

import com.Services.interfaces.CourseManageService;
import com.dao.interfaces.CourseManageDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by zqy on 2017/10/11.
 */
@Service
public class CourseManageServiceImpl implements CourseManageService {
    @Autowired
    private CourseManageDao courseManageDao;

    @Override
    @Transactional
    public int saveCourseManage(List<Map<String, String>> list) {
        return courseManageDao.saveCourseManage(list);
    }

    @Override
    public List<Map<String, String>> getTeacherCollege(Map<String, String> map) {
        return courseManageDao.getTeacherCollege(map);
    }

    @Override
    public List<String> getCourseCode(List<Map<String, String>> list) {
        return courseManageDao.getCourseCode(list);
    }

    @Override
    public List<String> getCourseName(List<Map<String, String>> list) {
        return courseManageDao.getCourseName(list);
    }

    @Override
    public int saveMessage(Map<String, String> map) {
        return courseManageDao.saveMessage(map);
    }

}
