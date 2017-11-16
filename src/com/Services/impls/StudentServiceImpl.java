package com.Services.impls;

import com.Services.interfaces.StudentService;
import com.dao.interfaces.StudentDao;
import com.model.Student;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/4/7.
 */
@Service
public class StudentServiceImpl implements StudentService {
    @Autowired
    private StudentDao studentDao;

    @Override
    @Transactional
    public int saveStudents(List<Student> list) {
        return studentDao.saveStudents(list);
    }

    @Override
    @Transactional
    public int saveUser(List<Map<String, String>> list) {
        return studentDao.saveUser(list);
    }
    @Override
    public List<String> getKeys(List<Map<String, String>> list) {
        return studentDao.getKeys(list);
    }
    @Override
    public List<String> getKey(List<Map<String, String>> list) {
        return studentDao.getKey(list);
    }
    @Override
    public List<String> getId(List<Map<String, String>> list) {
        return studentDao.getId(list);
    }
//    @Override
//    public Map<String, String> getKey(Map<String, String> map) {
//        return studentDao.getKey(map);
//    }
    @Override
    public List<String> getSchools(List<Map<String, String>> list) {
        return studentDao.getSchools(list);
    }
    @Override
    public List<String> getColleges(List<Map<String, String>> list) {
        return studentDao.getColleges(list);
    }
    @Override
    public List<String> getMajors(List<Map<String, String>> list) {
        return studentDao.getMajors(list);
    }
    @Override
    public List<String> getGrades(List<Map<String, String>> list) {
        return studentDao.getGrades(list);
    }
    @Override
    public List<String> getClasss(List<Map<String, String>> list) {
        return studentDao.getClasss(list);
    }
    @Override
    public List<String> getStudys(List<Map<String, String>> list) {
        return studentDao.getStudys(list);
    }

}
