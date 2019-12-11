package com.ecspace.business.knowledgeCenter.administrator.service;

import com.alibaba.fastjson.JSONObject;
import com.ecspace.business.knowledgeCenter.administrator.pojo.FileType;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;

import java.util.List;

/**
 * @author zhangch
 * @date 2019/12/5 0005 下午 20:23
 */
public interface FileTypeService {

    GlobalResult insert(FileType fileType);

    List<FileType> listFileType();

    GlobalResult update(FileType fileType);

    GlobalResult delete(String id);

    /**
     * 类型字段列表
     * @return
     */
    PageData fileTypeDetail(String id, Integer page, Integer size);

    JSONObject getMappingInfo(String indexName);
}
