package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.Log;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;

/**
 * @author zhangch
 * @date 2020/1/3 0003 下午 13:46
 */
public interface LogService {
    GlobalResult save(Log log);
}
