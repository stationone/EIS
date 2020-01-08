package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.ReviewInfo;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;

/**
 * 审批service
 * @author zhangch
 * @date 2020/1/6 0006 下午 13:56
 */
public interface ReviewInfoService {

    GlobalResult insert(ReviewInfo reviewInfo) throws Exception;

    GlobalResult update(ReviewInfo reviewInfo);

    GlobalResult delete(String id);

    PageData reviewList(String fileId, Integer page, Integer size);
}
