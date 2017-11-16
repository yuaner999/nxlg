package com.Services.impls;

import com.Services.interfaces.StudentPaymentService;
import com.dao.interfaces.StudentPaymentDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/5/23.
 */
@Service
public class StudentPaymentServiceImpl implements StudentPaymentService{
    @Autowired
    private StudentPaymentDao  StudentPayments;

    @Override
    @Transactional
    public int saveStudentPayments(List<Map<String, String>> list) {
        return StudentPayments.saveStudentPayments(list);
    }

    @Override
    public List<String> getKeys(List<Map<String, String>> list) {
        return StudentPayments.getKeys(list);
    }

}
