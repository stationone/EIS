package com.ecspace.business.es.dao;

import com.ecspace.business.es.pojo.BaseField;

import java.util.List;

/**
 * @author zhangch
 * @date 2019/10/30 0030 下午 19:31
 */
public interface BaseFieldDao {
    /**
     * 保存基础字段
     * @param baseField
     */
    int save(BaseField baseField);

    /**
     * 查询所有
     * @return
     */
    List<BaseField> findAll();

    /**
     * 删除基础字段
     * @param id
     * @return
     */
    int deleteField(int id);

    /**
     * 修改字段
     * @param baseField
     * @return
     */
    int updateField(BaseField baseField);
}
