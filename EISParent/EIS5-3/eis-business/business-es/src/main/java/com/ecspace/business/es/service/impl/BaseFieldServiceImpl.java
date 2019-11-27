package com.ecspace.business.es.service.impl;

import com.ecspace.business.es.dao.BaseFieldDao;
import com.ecspace.business.es.pojo.entity.Ajax;
import com.ecspace.business.es.pojo.BaseField;
import com.ecspace.business.es.pojo.entity.PageData;
import com.ecspace.business.es.service.BaseFieldService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author zhangch
 * @date 2019/10/30 0030 下午 20:32
 */
@Transactional
@Service
public class BaseFieldServiceImpl implements BaseFieldService {

    @Autowired
    private BaseFieldDao baseFieldDao;

    @Override
    public Ajax save(BaseField baseField) {
        int i = baseFieldDao.save(baseField);
        if (i == 1) {
            return new Ajax("操作成功", true);
        }

        return new Ajax("操作失败", false);
    }

    @Override
    public PageData findAll() {
        List<BaseField> baseFieldList = baseFieldDao.findAll();

        return new PageData(baseFieldList);
    }

    @Override
    public Ajax deleteField(String id) {
        if (StringUtils.isBlank(id)) {
            return new Ajax("参数异常", false);
        }
        try {
            int fid = Integer.parseInt(id);
            int i = baseFieldDao.deleteField(fid);
            if (i == 1) {
                return new Ajax("删除成功", true);
            } else {
                return new Ajax("失败", false);
            }
        } catch (NumberFormatException e) {
            return new Ajax("失败", false);
        }
    }

    @Override
    public Ajax updateField(BaseField baseField) {
        try {
            int i = baseFieldDao.updateField(baseField);
            if (i == 1) {
                return new Ajax("操作成功", true);
            } else {
                return new Ajax("失败", false);
            }
        } catch (NumberFormatException e) {
            return new Ajax("失败", false);
        }
    }
}
