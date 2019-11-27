package com.ecspace.business.resourceCenter.user.service;

import com.ecspace.business.resourceCenter.user.service.entity.ResUpload;

import java.util.List;
import java.util.Map;

public interface ResourceUploadService {
    /**
     * 条件查询全部
     * @param map
     * @return
     */
    List<ResUpload> list(Map<String ,Object> map);

    /**
     * 增加
     * @param resUpload
     * @return
     */
    boolean add(ResUpload resUpload);

    /**
     * 删除
     * @param map
     * @return
     */
    boolean delete(Map<String, Object> map);

    /**
     * 批量删除
     * @param list
     * @return
     */
    boolean deleteAll(List<ResUpload> list);

    /**
     * 更新通过用户ID
     * @param userId
     * @return
     */
    boolean updateByUserId(String userId);
}
