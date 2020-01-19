package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.UserHouse;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;

import java.util.List;

/**
 * 用户收藏
 * @author zhangch
 * @date 2020/1/17 0017 下午 17:46
 */
public interface UserHouseService {

    /**
     * 用户收藏目录表单
     * @param id
     * @param userName
     * @return
     */
    List<UserHouse> userHouseList(String id, String userName);

    /**
     * 添加用户收藏目录
     * @param userHouse
     * @return
     */
    GlobalResult insertUserHouse(UserHouse userHouse);

    /**
     * 修改用户收藏目录
     * @param userHouse
     * @return
     */
    GlobalResult updateUserHouse(UserHouse userHouse);

    /**
     * 删除用户收藏目录
     * @param id
     * @return
     */
    GlobalResult delete(String id);
}
