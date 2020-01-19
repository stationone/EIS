package com.ecspace.business.knowledgeCenter.administrator.service;

import com.ecspace.business.knowledgeCenter.administrator.pojo.Log;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.GlobalResult;
import com.ecspace.business.knowledgeCenter.administrator.pojo.entity.PageData;

import java.text.ParseException;

/**
 * @author zhangch
 * @date 2020/1/3 0003 下午 13:46
 */
public interface LogService {
    GlobalResult deleteLog(String id);

    GlobalResult deleteAll();

    GlobalResult save(Log log);

    PageData logList(Integer page, Integer size);

    PageData logList(Integer page, Integer rows, String search, String startTime, String endTime, String sort, String order, String status, String date, Integer dateOrUser) throws ParseException;
}
