package com.Services.impls;

import com.Services.interfaces.DispensingService;
import com.dao.interfaces.DispensingDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
/**
 * Created by NEU on 2017/4/7.
 */
@Service
public class DispensingServiceImpl implements DispensingService {
    @Autowired
    private DispensingDao Dispensingdao;
    @Override
    public List<Map<String , Object>> gettotaltiaojipeople(String term) {
        return Dispensingdao.gettotaltiaojipeople(term);
    }
    @Override
    public List<Map<String , Object>> getmajorname(String tc_majorId) {
        return Dispensingdao.getmajorname(tc_majorId);
    }
    @Override
    public List<Map<String , Object>> getkaikeleft(String courseId, String term) {
        return Dispensingdao.getkaikeleft(courseId,term);
    }
    @Override
    public List<Map<String , Object>> getDispensingpeople1(String courseId, String term,String tc_id) {
        return Dispensingdao.getDispensingpeople1(courseId,term,tc_id);
    }

    @Override
    public int DispensingCourse(String tc_class,String studentId, String courseId,String term,String tc_id,String teacherName){
        return Dispensingdao.DispensingCourse(tc_class,studentId,courseId,term,tc_id,teacherName);
    }
    @Override
    public int insertmessage(String receiverId,String context){
        return Dispensingdao.insertmessage(receiverId,context);
    }
    @Override
    public int insertmessage2(String receiverId,String context){
        return Dispensingdao.insertmessage2(receiverId,context);
    }
    @Override
    public List<Map<String , Object>> getDispensingtotalpeople(String courseId, String term) {
        return Dispensingdao.getDispensingtotalpeople(courseId,term);
    }
    @Override
    public  List<Map<String , Object>> getunkaikecha(String courseId, String term){
        return Dispensingdao.getunkaikecha(courseId,term);
    }
    @Override
    public List<Map<String , Object>> gettime(String courseId, String tc_class,String term,String tc_id) {
        return Dispensingdao.gettime( courseId,tc_class,term,tc_id);
    }
    @Override
    public  List<Map<String , Object>> stutime(String studentId,String term){
        return Dispensingdao.stutime(studentId,term);
    }
    @Override
    public List<Map<String , Object>> Dispensingtotalpeople5(String term) {
        return Dispensingdao.Dispensingtotalpeople5(term);
    }
}
