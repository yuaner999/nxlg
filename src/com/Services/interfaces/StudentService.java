package com.Services.interfaces;

import com.model.Student;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/4/7.
 */
public interface StudentService {
    /**
     * 批量存入数据库
     *
     * @param list
     * @return
     *///    getStudys getClasss getGrades getMajors getColleges getSchools
    int saveStudents(List<Student> list);
    int saveUser(List<Map<String, String>> list);
    /**
     * 查询批量导入的数据和数据库中的数据有重复
     * @param list
     * @return
     */
    List<String > getKeys(List<Map<String, String>> list);
    List<String > getKey(List<Map<String, String>> list);
    List<String > getId(List<Map<String, String>> list);
//    Map<String, String> getKey(Map<String, String> map);
    /**
     * 查询批量导入的校区和数据库中的数据是否一致
     * @param list
     * @return
     */
    List<String > getSchools(List<Map<String, String>> list);
    /**
     * 查询批量导入的学院和数据库中的数据是否一致
     * @param list
     * @return
     */
    List<String > getColleges(List<Map<String, String>> list);
    /**
     * 查询批量导入的专业和数据库中的数据是否一致
     * @param list
     * @return
     */
    List<String > getMajors(List<Map<String, String>> list);
    /**
     * 查询批量导入的年级和数据库中的数据是否一致
     * @param list
     * @return
     */
    List<String > getGrades(List<Map<String, String>> list);
    /**
     * 查询批量导入的班级和数据库中的数据是否一致
     * @param list
     * @return
     */
    List<String > getClasss(List<Map<String, String>> list);
    /**
     * 查询批量导入的学习形式和数据库中的数据是否一致
     * @param list
     * @return
     */
    List<String > getStudys(List<Map<String, String>> list);
}
