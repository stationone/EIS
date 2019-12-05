package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.Menu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;

import java.util.List;

/**
 * @author zhangch
 * @date 2019/11/12 0012 下午 20:45
 */
public interface MenuService {

    /**
     * 目录列表
     * @param pid
     * @return
     */
    List<Menu> getMenuList(String pid, String indexName);

    /**
     * 新增目录
     * @param menu
     * @return
     */
    GlobalResult insertMenu(Menu menu);

    /**
     * 编辑目录
     * @param menu
     * @return
     */
    GlobalResult updateMenu(Menu menu);

    /**
     * 删除目录, 及目录下所有文件
     * @param id
     * @return
     */
    GlobalResult delete(String id);
}
