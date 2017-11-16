package com.Services.impls;

import com.Services.interfaces.TeachingMaterialsService;
import com.dao.interfaces.TeachingMaterialsDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by ZCY on 2017/6/3.
 */
@Service
public class TeachingMaterialsServiceImpl implements TeachingMaterialsService {
    @Autowired
    private TeachingMaterialsDao teachingMaterialsDao;

    @Override
    @Transactional
    public int saveTeachingMaterials(List<Map<String, String>> list) {
        return teachingMaterialsDao.saveTeachingMaterials(list);
    }

    @Override
    public List<String> getKeys(List<Map<String, String>> list) {
        return teachingMaterialsDao.getKeys(list);
    }

}
