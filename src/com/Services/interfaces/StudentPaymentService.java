package com.Services.interfaces;

import java.util.List;
import java.util.Map;

/**
 * Created by zcy on 2017/5/23.
 */
public interface StudentPaymentService {
    /**
     * 批量存入数据库
     *
     * @param list
     * @return
     */
    int saveStudentPayments(List<Map<String, String>> list);
    /**
     * 查询批量导入的数据和数据库中的数据有重复
     * @param list
     * @return
     */
    List<String > getKeys(List<Map<String, String>> list);
}
