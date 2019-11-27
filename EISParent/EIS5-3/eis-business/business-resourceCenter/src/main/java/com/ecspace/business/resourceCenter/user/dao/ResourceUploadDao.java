package com.ecspace.business.resourceCenter.user.dao;

import com.ecspace.business.resourceCenter.user.service.entity.ResUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

public interface ResourceUploadDao {

    /**
     * 条件查询全部
     * @param map
     * @return
     */
    List<ResUpload> list(Map<String ,Object> map);

    /**
     * 增加记录
     * @param resUpload
     * @return
     */
    int add(ResUpload resUpload);

    /**
     * 删除记录
     * @param map
     * @return
     */
    int delete(Map<String, Object> map);

    /**
     * 批量删除
     * @param list
     * @return
     */
    int deleteAll(List<ResUpload> list);

    /**
     * 更新通过用户Id
     * @param userId
     * @return
     */
    int updateByUserId(String userId);
}
