package com.ecspace.business.es.service;

import com.ecspace.business.es.pojo.entity.Ajax;
import com.ecspace.business.es.pojo.BaseField;
import com.ecspace.business.es.pojo.entity.PageData;

/**
 * 基础字段
 *
 * @author zhangch
 * @date 2019/10/30 0030 下午 20:30
 */
public interface BaseFieldService {
    /**
     * 保存基础字段
     * @param baseField
     * @return
     */
    Ajax save(BaseField baseField);

    /**
     * 查看所有字段
     * @return
     */
    PageData findAll();

    /**
     * 删除字段
     * @param id
     * @return
     */
    Ajax deleteField(String id);

    /**
     * 修改字段
     * @param baseField
     * @return
     */
    Ajax updateField(BaseField baseField);
}
