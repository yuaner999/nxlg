package com.dao.interfaces;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/5/23.
 */
@Repository
public interface DispensingDao {
    List<Map<String , Object>> gettotaltiaojipeople(String term);
    List<Map<String , Object>> getmajorname(String tc_majorId);
    List<Map<String , Object>>  getkaikeleft(String courseId, String term);
    List<Map<String , Object>>  getDispensingpeople1(String courseId, String term,String tc_id);
    List<Map<String , Object>>  gettime(String courseId, String tc_class,String term,String tc_id);
    List<Map<String , Object>>  stutime(String studentId,String term);
    int DispensingCourse(String tc_class,String studentId, String courseId,String term,String tc_id,String teacherName);
    int insertmessage(String receiverId,String context);
    int insertmessage2(String receiverId,String context);
    List<Map<String , Object>>  getDispensingtotalpeople(String courseId, String term);
    List<Map<String , Object>>  getunkaikecha(String courseId, String term);
    List<Map<String , Object>>  Dispensingtotalpeople5( String term);
}
