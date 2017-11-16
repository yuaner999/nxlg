package com.dao.interfaces;

import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/5/11.
 */
@Repository
public interface EducatePlanDao {
    /**
     * 批量存入数据库
     * @param list
     * @return
     */
    int saveEducatePlans(List<Map<String, String>> list);

    /**
     * 查询批量导入的数据和数据库中的数据有重复
     * @param list
     * @return
     */
    List<String > getKeys(List<Map<String, String>> list);
    List< Map<String ,String >> getCourse(List<Map<String, String>> list) ;



}

