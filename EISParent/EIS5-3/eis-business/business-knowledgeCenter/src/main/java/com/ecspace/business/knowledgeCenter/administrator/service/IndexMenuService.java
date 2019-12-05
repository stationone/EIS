package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.IndexMenu;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;

import java.util.List;

/**
 * @author zhangch
 * @date 2019/12/3 0003 下午 14:19
 */
public interface IndexMenuService {

    List<IndexMenu> listIndexMenu();

    //创建
    GlobalResult save(IndexMenu indexMenu);

    //删除
    GlobalResult delete(String indexName);
}
