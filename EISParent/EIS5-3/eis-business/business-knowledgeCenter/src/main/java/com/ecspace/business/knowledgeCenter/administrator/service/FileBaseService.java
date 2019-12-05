package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.FileBase;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;

/**
 * @author zhangch
 * @date 2019/11/29 0029 下午 20:39
 */
public interface FileBaseService {
    /**
     * 文档基础属性列表
     * @return
     */
    PageData fileBaseList(Integer page, Integer size);

    /**
     * 添加/更新fileBase
     * @param fileBase
     * @return
     */
    GlobalResult saveFileBase(FileBase fileBase);

    /**
     * 删除fileBase
     * @param id
     * @return
     */
    GlobalResult deleteFileBase(String id);
}
