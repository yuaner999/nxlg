package com.Services.interfaces;

import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/5/23.
 */
public interface DispensingService {

    /**
     * 这是同意调剂的开课未满课程(总共要调剂的人数)
     * @param term
     * @return
     */
    List<Map<String , Object>> gettotaltiaojipeople(String term);
    List<Map<String , Object>> getmajorname(String tc_majorId);
    /**
     * 这是1内已开课程班级及其剩余人数
     * @param courseId
     * @param term
     * @return
     */
    List<Map<String , Object>>  getkaikeleft(String courseId, String term);
    /**
     * 第i个班的人要调到2.内的班级
     * @param courseId
     * @param term
     * @param tc_id
     * @return
     */
    List<Map<String , Object>>  getDispensingpeople1(String courseId, String term,String tc_id);
    /**
     * 查找这个课这个班的开课时间
     * @param courseId
     * @param tc_class
     * @param tc_id
     * @param term
     * @return
     */
    List<Map<String , Object>>  gettime(String courseId, String tc_class,String term,String tc_id);
    /**
     * 查找这个课这个班的开课时间
     * @param studentId
     * @param term
     * @return
     */
    List<Map<String , Object>>  stutime(String studentId,String term);
    /**
     * 调剂课程
     * @param studentId,courseId,term
     * @return
     */
    int DispensingCourse(String tc_class,String studentId, String courseId,String term,String tc_id,String teacherName);
    /**
     * 通知
     * @param receiverId
     * @return
     */
    int insertmessage(String receiverId,String context);
    /**
     * 通知2
     * @param receiverId
     * @return
     */
    int insertmessage2(String receiverId,String context);
    /**
     * 查一下调剂后还剩多少人 0人说明这个课程全部调剂完成 选下一个课程继续；否则继续在已开课的班级中填人
     * @param courseId
     * @param term
     * @return
     */
    List<Map<String , Object>>  getDispensingtotalpeople(String courseId, String term);
    /**
     * 继续填未达到开课人数的这门课班级
     * @param courseId
     * @param term
     * @return
     */
    List<Map<String , Object>>  getunkaikecha(String courseId, String term);
    /**
     *
     * @param term
     * @return
     */
    List<Map<String , Object>>  Dispensingtotalpeople5( String term);

}