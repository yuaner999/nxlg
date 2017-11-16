package com.Services.impls;

import com.Services.interfaces.EducatePlanService;
import com.dao.interfaces.EducatePlanDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by NEU on 2017/4/7.
 */
@Service
public class EducatePlanServiceImpl implements EducatePlanService {
    @Autowired
    private EducatePlanDao EducatePlan;

    @Override
    @Transactional
    public int saveEducatePlans(List<Map<String, String>> list) {
        return EducatePlan.saveEducatePlans(list);
    }

    @Override
    public List<String> getKeys(List<Map<String, String>> list) {
        return EducatePlan.getKeys(list);
    }
    public List<Map<String, String>> getCourse(List<Map<String, String>> list) {
        return EducatePlan.getCourse(list);
    }
}
